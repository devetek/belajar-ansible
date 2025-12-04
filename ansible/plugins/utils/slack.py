import json
import os

from ansible.module_utils.urls import open_url

try:
    import prettytable

    HAS_PRETTYTABLE = True
except ImportError:
    HAS_PRETTYTABLE = False


class InitSlack:
    def __init__(self):
        self.name = True
        self.disabled = False

        if not HAS_PRETTYTABLE:
            self.disabled = True

        self.webhook_url = os.getenv("SLACK_WEBHOOK_URL")
        self.channel = os.getenv("SLACK_CHANNEL", "#dpanel")
        self.username = os.getenv("SLACK_USERNAME", "dPanel")

        if self.webhook_url is None:
            self.disabled = True

    def build_msg(self, attachments):
        # check if type is not dict
        if not isinstance(attachments, dict):
            return {}

        msg = {
            "blocks": [
                {
                    "type": "header",
                    "text": {
                        "type": "plain_text",
                        "text": attachments["dpanel_system_title"],
                        "emoji": True,
                    },
                },
                {
                    "type": "context",
                    "elements": [
                        {
                            "type": "image",
                            "image_url": attachments["dpanel_system_actor_avatar"],
                            "alt_text": attachments["dpanel_system_actor_fullname"],
                        },
                        {"type": "mrkdwn", "text": "*{}* <{}>.".format(attachments["dpanel_system_actor_fullname"], attachments["dpanel_system_actor_email"])},
                    ],
                },
                {"type": "divider"},
                {
                    "type": "rich_text",
                    "elements": [
                        {
                            "type": "rich_text_section",
                            "elements": [{"type": "text", "text": "Command:\n"}],
                        },
                        {
                            "type": "rich_text_preformatted",
                            "border": 0,
                            "elements": [
                                {
                                    "type": "text",
                                    "text": attachments["dpanel_system_ansible_command"],
                                }
                            ],
                        },
                    ],
                },
            ]
        }

        return msg

    def send_msg(self, attachments):
        if self.disabled:
            return

        data = json.dumps(self.build_msg(attachments))
        try:
            response = open_url(self.webhook_url, data=data)
            return response.read()
        except Exception as e:
            print("Could not submit message to Slack: %s" % str(e))
