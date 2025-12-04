# (c) 2012-2014, Michael DeHaan <michael.dehaan@gmail.com>
# (c) 2017 Ansible Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = '''
    name: default
    type: stdout
    short_description: default Ansible screen output
    version_added: historical
    description:
        - This is the default output callback for ansible-playbook.
    extends_documentation_fragment:
      - default_callback
      - result_format_callback
    requirements:
      - set as stdout in configuration
'''


import os
import sys
import inspect
from ansible import constants as C
from ansible import context
from ansible.plugins.callback import CallbackBase
from ansible.utils.color import colorize, hostcolor
from ansible.utils.fqcn import add_internal_fqcns
from importlib.machinery import SourceFileLoader
from pathlib import Path


class CallbackModule(CallbackBase):

    '''
    This is the default callback interface, which simply prints messages
    to stdout when new callback events are received.
    '''

    CALLBACK_VERSION = 2.0
    CALLBACK_TYPE = 'stdout'
    CALLBACK_NAME = 'default'

    def __init__(self):
        self.channels = {}
        self._play = None
        self._last_task_banner = None
        self._last_task_name = None
        self._task_type_cache = {}
        super(CallbackModule, self).__init__()
        
        self.__import_plugins_utils()

    def v2_runner_on_failed(self, result, ignore_errors=False):
        host_name = result._host.get_name()
        # send status to dPanel, on task failed
        self.channels["dnocs"].publish({
            "success": False,
            "result": result,
            "error": f"Task failed on host: {host_name}",
            "callback_function": sys._getframe(0).f_code.co_name
        })

    def v2_runner_on_ok(self, result):
        # send status to dPanel, on task success
        host_name = result._host.get_name()
        # send status to dPanel, on task failed
        self.channels["dnocs"].publish({
            "success": True,
            "result": result,
            "error": None,
            "callback_function": sys._getframe(0).f_code.co_name
        })

    def v2_runner_on_skipped(self, result):
        '''
        Do nothing on skipped tasks, to prevent output cluttering.

        Copyright (c) 2025, Prakasa <prakasa@devetek.com>
        MIT License (see LICENSE file for details)
        '''
        pass

    def v2_runner_on_unreachable(self, result):
        # get host name
        host_name = result._host.get_name()
        # send status to dPanel, host not reachable
        self.channels["dnocs"].publish({
            "success": False,
            "result": result,
            "error": f"Host unreachable: {host_name}",
            "callback_function": sys._getframe(0).f_code.co_name
        })

    def v2_playbook_on_no_hosts_matched(self):
        # send status to dPanel, no hosts matched
        self.channels["dnocs"].publish({
            "success": False,
            "result": None,
            "error": "No hosts matched",
            "callback_function": sys._getframe(0).f_code.co_name
        })

    def v2_playbook_on_no_hosts_remaining(self):
        pass

    def v2_playbook_on_task_start(self, task, is_conditional):
        # do nothing on task start, to prevent output cluttering.
        pass

    def _task_start(self, task, prefix=None):
        # Cache output prefix for task if provided
        # This is needed to properly display 'RUNNING HANDLER' and similar
        # when hiding skipped/ok task results
        if prefix is not None:
            self._task_type_cache[task._uuid] = prefix

        # Preserve task name, as all vars may not be available for templating
        # when we need it later
        if self._play.strategy in add_internal_fqcns(('free', 'host_pinned')):
            # Explicitly set to None for strategy free/host_pinned to account for any cached
            # task title from a previous non-free play
            self._last_task_name = None
        else:
            self._last_task_name = task.get_name().strip()

            # Display the task banner immediately if we're not doing any filtering based on task result
            if self.get_option('display_skipped_hosts') and self.get_option('display_ok_hosts'):
                self._print_task_banner(task)

    def _print_task_banner(self, task):
        # args can be specified as no_log in several places: in the task or in
        # the argument spec.  We can check whether the task is no_log but the
        # argument spec can't be because that is only run on the target
        # machine and we haven't run it thereyet at this time.
        #
        # So we give people a config option to affect display of the args so
        # that they can secure this if they feel that their stdout is insecure
        # (shoulder surfing, logging stdout straight to a file, etc).
        args = ''
        if not task.no_log and C.DISPLAY_ARGS_TO_STDOUT:
            args = u', '.join(u'%s=%s' % a for a in task.args.items())
            args = u' %s' % args

        prefix = self._task_type_cache.get(task._uuid, 'TASK')

        # Use cached task name
        task_name = self._last_task_name
        if task_name is None:
            task_name = task.get_name().strip()

        if task.check_mode and self.get_option('check_mode_markers'):
            checkmsg = " [CHECK MODE]"
        else:
            checkmsg = ""
        self._display.banner(u"%s [%s%s]%s" % (prefix, task_name, args, checkmsg))

        if self._display.verbosity >= 2:
            self._print_task_path(task)

        self._last_task_banner = task._uuid

    def v2_playbook_on_cleanup_task_start(self, task):
        pass

    def v2_playbook_on_handler_task_start(self, task):
        pass

    def v2_runner_on_start(self, host, task):
        # do nothing on runner start, to prevent output cluttering.
        pass

    def v2_playbook_on_play_start(self, play):
        # get all extra variables
        # variable_manager = play.get_variable_manager()
        # extra_vars = variable_manager.extra_vars
        # print(extra_vars)
        pass

    def v2_on_file_diff(self, result):
        pass

    def v2_runner_item_on_ok(self, result):
        # send status to dPanel, on task success
        self.channels["dnocs"].publish({
            "success": True,
            "result": result,
            "error": None,
            "callback_function": sys._getframe(0).f_code.co_name
        })

    def v2_runner_item_on_failed(self, result):
        # send status to dPanel, on task failed
        self.channels["dnocs"].publish({
            "success": False,
            "result": result,
            "error": "Task item failed",
            "callback_function": sys._getframe(0).f_code.co_name
        })

    def v2_runner_item_on_skipped(self, result):
        '''
        Do nothing on skipped tasks, to prevent output cluttering.

        Copyright (c) 2025, Prakasa <prakasa@devetek.com>
        MIT License (see LICENSE file for details)
        '''
        pass

    def v2_playbook_on_include(self, included_file):
        # do nothing on include to prevent output cluttering.
        pass

    def v2_playbook_on_stats(self, stats):
        self._display.banner("PLAY RECAP")

        hosts = sorted(stats.processed.keys())
        for h in hosts:
            t = stats.summarize(h)

            self._display.display(
                u"%s : %s %s %s %s %s %s %s" % (
                    hostcolor(h, t),
                    colorize(u'ok', t['ok'], C.COLOR_OK),
                    colorize(u'changed', t['changed'], C.COLOR_CHANGED),
                    colorize(u'unreachable', t['unreachable'], C.COLOR_UNREACHABLE),
                    colorize(u'failed', t['failures'], C.COLOR_ERROR),
                    colorize(u'skipped', t['skipped'], C.COLOR_SKIP),
                    colorize(u'rescued', t['rescued'], C.COLOR_OK),
                    colorize(u'ignored', t['ignored'], C.COLOR_WARN),
                ),
                screen_only=True
            )

            self._display.display(
                u"%s : %s %s %s %s %s %s %s" % (
                    hostcolor(h, t, False),
                    colorize(u'ok', t['ok'], None),
                    colorize(u'changed', t['changed'], None),
                    colorize(u'unreachable', t['unreachable'], None),
                    colorize(u'failed', t['failures'], None),
                    colorize(u'skipped', t['skipped'], None),
                    colorize(u'rescued', t['rescued'], None),
                    colorize(u'ignored', t['ignored'], None),
                ),
                log_only=True
            )

        self._display.display("", screen_only=True)

        # print custom stats if required
        if stats.custom and self.get_option('show_custom_stats'):
            self._display.banner("CUSTOM STATS: ")
            # per host
            # TODO: come up with 'pretty format'
            for k in sorted(stats.custom.keys()):
                if k == '_run':
                    continue
                self._display.display('\t%s: %s' % (k, self._dump_results(stats.custom[k], indent=1).replace('\n', '')))

            # print per run custom stats
            if '_run' in stats.custom:
                self._display.display("", screen_only=True)
                self._display.display('\tRUN: %s' % self._dump_results(stats.custom['_run'], indent=1).replace('\n', ''))
            self._display.display("", screen_only=True)

        if context.CLIARGS['check'] and self.get_option('check_mode_markers'):
            self._display.banner("DRY RUN")

    def v2_playbook_on_start(self, playbook):
        # do nothing on playbook start, to prevent output cluttering.
        pass

    def v2_runner_retry(self, result):
        # do nothing on retries, to prevent output cluttering.
        pass

    def v2_runner_on_async_poll(self, result):
        # currently do nothing on async polls, to prevent output cluttering.
        # dPanel not support polling status yet
        '''
        Run on async poll event triggered when task contains async directive. For example:
        - name: Long running task
          command: /bin/sleep 45
          async: 1000
          poll: 0
          register: long_running_task
        
        - name: Poll for async result
          async_status: jid={{ long_running_task.ansible_job_id }}
          register: job_result
          until: job_result.finished == 1
          retries: 30
          delay: 10
        '''
        pass

    def v2_runner_on_async_ok(self, result):
        # polling success, do nothing to prevent output cluttering.
        pass

    def v2_runner_on_async_failed(self, result):
        # polling failed, do nothing to prevent output cluttering.
        pass

    def v2_playbook_on_notify(self, handler, host):
        # if self._display.verbosity > 1:
        #     self._display.display("NOTIFIED HANDLER %s for %s" % (handler.get_name(), host), color=C.COLOR_VERBOSE, screen_only=True)
        # Do nothing on notify to prevent output cluttering.
        pass
    
    '''
    Import dynamic plugins from environment variable ANSIBLE_DPANEL_PLUGINS. To help extend functionality
    for example to send notification to slack, telegram, etc.
    Copyright (c) 2025, Prakasa <prakasa@devetek.com>
    '''
    def __import_plugins_utils(self):
        plugin_dir = os.getenv('ANSIBLE_DPANEL_PLUGINS')
        abs_path = Path(plugin_dir).resolve()

        for item in abs_path.iterdir():
                module_path = os.path.abspath(item)
                if ".py" in module_path:
                    module_name = os.path.splitext(os.path.basename(module_path))[0]
                    module = SourceFileLoader(module_name, module_path).load_module()
                    className = getattr(module, "Init"+module_name.title())
                    self.channels[module_name] = className()