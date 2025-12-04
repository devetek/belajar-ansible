'''
Publish task status to dpanel, to update state of the task in dpanel UI.
'''

import os
import json
import uuid
from ansible.module_utils.urls import open_url


available_status = ["pending", "progress", "success", "failed", "canceled", "skipped", "unknown"]

class InitDnocs:
    def __init__(self):
        self.url = None
        self.token = None
        
        # set data from environment variables
        self.url = os.getenv("DPANEL_PUBLISHER_URL", "http://localhost:9000/api/v1/ansible/callback")
        self.token = os.getenv("DPANEL_PUBLISHER_TOKEN", str(uuid.uuid4()))
    
    def publish(self, data):
        status = "progress"
        stdout = ""
        stderr = ""
        if "result" in data and data["result"] is not None:
            if hasattr(data["result"], "_result"):
                if "stdout" in data["result"]._result:
                    stdout = data["result"]._result["stdout"]
                if "stderr" in data["result"]._result:
                    stderr = data["result"]._result["stderr"]
            
            # get task name, file and host name
            task_name = data["result"]._task.get_name()
            host_name = data["result"]._host.get_name()
            task_file = data["result"]._task.get_path()
            
            if data.get("success", "unknown") == True:
                status = "success"
            else:
                status = "failed"
        
        data = json.dumps(self.__build_message(
            status,
            task_name,
            host_name,
            task_file,
            stdout=stdout,
            stderr=stderr
        )).encode('utf-8')

        try:
            response = open_url(
                self.url,
                data=data,
                headers={
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'Authorization': 'Bearer %s' % self.token
                }, 
                method='POST',
                timeout=10
            )
            return response.read()
        except Exception as e:
            print("Could not submit message to dPanel: %s" % str(e))
    
    # build dPanel payload
    def __build_message(self, status, task, host, file, stdout="", stderr=""):
        return {
            "status": status,
            "task": task,
            "host": host,
            "file": file,
            "stdout": stdout,
            "stderr": stderr,
            "iac_type": "ansible",
        }