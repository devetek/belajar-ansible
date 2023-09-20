package main

import (
	"context"
	"log"

	"github.com/apenella/go-ansible/pkg/execute"
	"github.com/apenella/go-ansible/pkg/options"
	"github.com/apenella/go-ansible/pkg/playbook"
	"github.com/apenella/go-ansible/pkg/stdoutcallback/results"
	"github.com/devetek/belajar-ansible/utils"
)

func main() {

	// Remove known host config, ignore error
	_ = utils.RemoveKnownHost()

	// Conection configuration
	ansiblePlaybookConnectionOptions := &options.AnsibleConnectionOptions{
		Connection: "ssh",
		User:       "root",
		PrivateKey: "./id_rsa_fake",
		AskPass:    false,
	}

	// playbook configuration
	// var extraVarsFile = []string{
	// 	"@filename-if-exist",
	// 	"@anotherfilename-if-exist",
	// }
	ansiblePlaybookOptions := &playbook.AnsiblePlaybookOptions{
		Inventory: "inventory/ansible-inventory.ini",
		// ExtraVarsFile: extraVarsFile,
		Tags:          "all",
		ForceHandlers: false,
		FlushCache:    false,
		SyntaxCheck:   false,
		Verbose:       false,
	}

	// previllage configuration
	ansiblePlaybookPrivilegeEscalationOptions := &options.AnsiblePrivilegeEscalationOptions{
		BecomeMethod: "sudo",
	}

	playbook := &playbook.AnsiblePlaybookCmd{
		Playbooks:                  []string{"playbooks/hello-world.yml"},
		ConnectionOptions:          ansiblePlaybookConnectionOptions,
		PrivilegeEscalationOptions: ansiblePlaybookPrivilegeEscalationOptions,
		Options:                    ansiblePlaybookOptions,
		Exec: execute.NewDefaultExecute(
			execute.WithEnvVar("ANSIBLE_HOST_KEY_CHECKING", "false"),
			execute.WithEnvVar("ANSIBLE_FORCE_COLOR", "true"),
			execute.WithEnvVar("ANSIBLE_ROLES_PATH", "${PWD}/roles"),
			execute.WithTransformers(
				results.Prepend("lite-tools"),
			),
		),
		StdoutCallback: "json",
	}

	log.Println("[DEBUG] ANSIBLE COMMAND: ", playbook.String())

	err := playbook.Run(context.TODO())
	if err != nil {
		log.Println(err)
	}
}
