################################################################################
##@ ANSIBLE
################################################################################
ansible-setup: .bin-validator ## Create new role ansible_role_name=<ROLE_NAME>
	@cd ansible/roles && ./scripts/setup.sh

ansible-create-roles: .bin-validator ## Create new role ansible_role_name=<ROLE_NAME>
	@cd ansible/roles && ansible-galaxy init $(ansible_role_name)

ansible-install-deps: .bin-validator ## Install dependencies from requirements.yml
	@cd ansible && ansible-galaxy install -r requirements.yml

ansible-install-deps-force: .bin-validator ## Install dependencies from requirements.yml
	@cd ansible && ansible-galaxy install -r requirements.yml --force --ignore-errors