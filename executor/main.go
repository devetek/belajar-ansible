package main

import (
	"context"
	"fmt"
	"os"

	"github.com/apenella/go-ansible/v2/pkg/execute"
	"github.com/apenella/go-ansible/v2/pkg/execute/configuration"
	"github.com/apenella/go-ansible/v2/pkg/execute/result/transformer"
	"github.com/apenella/go-ansible/v2/pkg/playbook"
	errors "github.com/apenella/go-common-utils/error"
	"github.com/spf13/cobra"
)

var inventory string
var connectionLocal bool
var user string
var key string
var playbookFiles []string
var tags []string
var extravars []string

func init() {
	rootCmd.Flags().StringVarP(&inventory, "inventory", "i", "", "Specify ansible playbook inventory")
	rootCmd.Flags().BoolVarP(&connectionLocal, "connection-local", "L", false, "Run playbook using local connection")
	rootCmd.Flags().StringVarP(&user, "user", "u", "", "User to executute playbook")
	rootCmd.Flags().StringVarP(&key, "key", "k", "", "SSH key to execute playbook")
	rootCmd.Flags().StringSliceVarP(&playbookFiles, "playbook", "p", []string{}, "Playbook(s) to run")
	rootCmd.Flags().StringSliceVarP(&tags, "tags", "t", []string{}, "Tag(s) to be executed")
	rootCmd.Flags().StringSliceVarP(&extravars, "extra-var", "e", []string{}, "Set extra variables from file to use during the playbook execution.")
}

var rootCmd = &cobra.Command{
	Use:   "ansible-executor",
	Short: "ansible-executor",
	Long: `ansible-executor is an example which show how to use go-ansible library from cobra cli
	
 Run the example:
go run main.go -L -i /ansible/inventory/{task-id}.json -p site.yml -e @/ansible/variables/{task-id}.json
go run main.go -i /ansible/inventory/{task-id}.json -p site.yml -e @/ansible/variables/{task-id}.json -t "role-a,role-b" -u root -k @/ansible/keys/{task-id}.json
`,
	RunE: commandHandler,
}

func commandHandler(cmd *cobra.Command, args []string) error {
	if len(playbookFiles) < 1 {
		return errors.New("(ansible-handler)", "To run ansible-playbook playbook file path must be specified")
	}

	if len(inventory) < 1 {
		return errors.New("(ansible-handler)", "To run ansible-playbook an inventory must be specified")
	}

	if user == "" {
		return errors.New("(ansible-handler)", "To run ansible-playbook user must be specified")
	}

	if key == "" {
		return errors.New("(ansible-handler)", "To run ansible-playbook key must be specified")
	}

	ansiblePlaybookOptions := &playbook.AnsiblePlaybookOptions{
		Inventory:     inventory,
		ExtraVarsFile: extravars,
		BecomeMethod:  "sudo",
		AskBecomePass: false,
		Become:        true,
		AskPass:       false,
		User:          user,
		PrivateKey:    key,
	}

	if connectionLocal {
		ansiblePlaybookOptions.Connection = "local"
	}

	playbookCmd := playbook.NewAnsiblePlaybookCmd(
		playbook.WithPlaybooks(playbookFiles...),
		playbook.WithPlaybookOptions(ansiblePlaybookOptions),
	)

	playbookCmdString := playbookCmd.String()

	ansiblePlaybookOptions.ExtraVars = map[string]interface{}{
		"dpanel_system_title":           "Setup Machine ID #1",
		"dpanel_system_actor_avatar":    "https://ik.imagekit.io/terpusat/tr:h-300,w-300/assets/v1_0_0/logo/terpusat_YecCfAziS.png?ik-sdk-version=react-1.1.0",
		"dpanel_system_actor_fullname":  "dPanel Executor",
		"dpanel_system_actor_username":  "dpanel",
		"dpanel_system_actor_email":     "info@devetek.com",
		"dpanel_system_ansible_command": playbookCmdString,
	}

	exec := configuration.NewAnsibleWithConfigurationSettingsExecute(
		execute.NewDefaultExecute(
			execute.WithCmd(playbookCmd),
			execute.WithCmdRunDir("/ansible"),
			execute.WithErrorEnrich(playbook.NewAnsiblePlaybookErrorEnrich()),
			execute.WithEnvVars(map[string]string{
				"ANSIBLE_HOST_KEY_CHECKING":               "false",
				"ANSIBLE_FORCE_COLOR":                     "true",
				"ANSIBLE_ROLES_PATH":                      "/ansible/roles",
				"ANSIBLE_DPANEL_PLUGINS":                  "/ansible/plugins/utils",
				"ANSIBLE_CALLBACK_PLUGINS":                "/ansible/plugins/callback",
				"ANSIBLE_STDOUT_CALLBACK":                 "dpanel",
				"ANSIBLE_SHELL_ALLOW_WORLD_READABLE_TEMP": "true",
			}),
			execute.WithTransformers(
				transformer.Prepend("(ansible-handler)"),
			),
		),
		configuration.WithAnsibleForceColor(),
	)

	err := exec.Execute(context.TODO())
	if err != nil {
		panic(err)
	}

	return nil
}

func main() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
