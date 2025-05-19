# Pusat Panel
#
# Copyright (c) 2022 Devetek Tech. https://devetek.com. MIT License
# Repo: https://github.com/devetek/belajar-ansible

# Global variables
MSG_PREFIX="[belajar-ansible]"

# Required binaries
$(eval WHICH_DOCKER := $(strip $(shell which docker)))
docker_found = $(strip $(findstring docker, $(WHICH_DOCKER)))

$(eval WHICH_ANSIBLE := $(strip $(shell which ansible)))
ansible_found = $(strip $(findstring ansible, $(WHICH_ANSIBLE)))

$(eval WHICH_GAWK := $(strip $(shell which gawk)))
gawk_found = $(strip $(findstring gawk, $(WHICH_GAWK)))

################################################################################
##@ GENERIC
################################################################################

help: .bin-validator ## Show available commands
	@echo " ____       _        _                   _              _ _     _"
	@echo "| __ )  ___| | __ _ (_) __ _ _ __       / \\   _ __  ___(_) |__ | | ___"
	@echo "|  _ \\ / _ \\ |/ _\` || |/ _\` | '__|____ / _ \\ | '_ \\/ __| | '_ \\| |/ _ \\"
	@echo "| |_) |  __/ | (_| || | (_| | | |_____/ ___ \\| | | \\__ \\ | |_) | |  __/"
	@echo "|____/ \\___|_|\\__,_|/ |\\__,_|_|      /_/   \\_\\_| |_|___/_|_.__/|_|\\___|"
	@echo "                  |__/"
	@echo ""
	@echo "Copyright (c) $(shell date +"%Y") Devetek Tech. https://devetek.com."
	@echo "Repo: https://github.com/devetek/belajar-ansible"
	@echo ""
	@gawk 'function fix_value(value, str) { \
		padding=sprintf("%50s",""); \
		ret=gensub("([^ ]+)", "\\1"padding"\n ", "g", "  "value); \
		ret=gensub("(^|\n)(.{53}) *", "\\1\\2\033[0m"str"  \033[36m", "g", ret); \
		ret=substr(ret, 3, length(ret)-16-length(str)); \
		return ret; \
	} \
	BEGIN { \
		FS = ":.*##"; \
		printf "Use: make \033[36m<target>\033[0m\n"; \
	} /^\$$?\(?[a-zA-Z0-9_-]+\)?:.*?##/ { \
		printf "  \033[36m%-50s\033[0m %s\n", $$1, $$2 \
	} /^##@/ { \
		printf "\n\033[1m%s\033[0m\n", substr($$0, 5) \
	}' $(MAKEFILE_LIST)



################################################################################
##@ DEVELOPMENT
################################################################################
init: .bin-validator ## Prepare env
	@python -m venv .pyenv
	@( \
		source .pyenv/bin/activate ; \
		pip install --upgrade pip; \
		pip install -r requirements.txt --verbose; \
	)

run: .bin-validator ## Run playground
	@docker compose -f docker-compose.yml down --remove-orphans
	@docker compose -f docker-compose.yml up

ls: .bin-validator ## Show containers
	@docker compose -f docker-compose.yml ps

enter-ansible-executor: ## Enter to ansible-executor
	@echo "This command will remove your ~/.ssh/known_hosts, carefully!"
	@rm ~/.ssh/known_hosts || echo "ignore!"
	@chmod 0600 ssh-key/id_rsa_fake
	@ssh -i ssh-key/id_rsa_fake root@localhost -p 10000

enter-ansible-inventory: ## Enter to ansible-inventory
	@echo "This command will remove your ~/.ssh/known_hosts, carefully!"
	@rm ~/.ssh/known_hosts || echo "ignore!"
	@chmod 0600 ssh-key/id_rsa_fake
	@ssh -i ssh-key/id_rsa_fake root@localhost -p 10001

log: .bin-validator ## Show containers log
	@docker-compose -f docker-compose.yml logs -f

down: .bin-validator ## Shutdown playground
	@docker compose -f docker-compose.yml down --remove-orphans


# Hidden target, for contributors only
git-clean:
	@git branch | grep -v "main" | xargs git branch -D

.bin-validator: ## validate required binaries exist
# exit status code 126 - Command invoked cannot execute
ifneq ($(docker_found),docker)
	@echo "$(MSG_PREFIX) Install docker https://docs.docker.com/engine/install/"
	@exit 126
endif

ifneq ($(gawk_found),gawk)
	@echo "$(MSG_PREFIX) Install gawk for macOS https://formulae.brew.sh/formula/gawk"
	@echo "$(MSG_PREFIX) Install gawk for Ubuntu https://howtoinstall.co/en/gawk"
	@exit 126
endif

ifneq ($(ansible_found),ansible)
	@echo "$(MSG_PREFIX) Install ansible official https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html"
	@echo "$(MSG_PREFIX) Install ansible for MacOS https://formulae.brew.sh/formula/ansible"
	@exit 126
endif

# extend your make here!
include .docker/docker.Mk
include ansible/ansible.Mak
