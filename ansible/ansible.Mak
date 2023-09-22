################################################################################
##@ ANSIBLE
################################################################################

ansible-create-roles: .bin-validator ## Create new role ansible_role_name=<ROLE_NAME>
	@cd ansible/roles && ansible-galaxy init $(ansible_role_name)