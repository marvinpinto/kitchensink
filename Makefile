all: help

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}'

/tmp/ansible-galaxy-roles:
	mkdir -p /tmp/ansible-galaxy-roles
	ansible-galaxy collection install -r ./dev-machine/galaxy-roles-req.yml -p /tmp/ansible-galaxy-roles

machine: /tmp/ansible-galaxy-roles ## setup or update the base dev machine
	@echo "Setting up dev machine..."
	@cd dev-machine && \
	ANSIBLE_ROLES_PATH=./roles:/tmp/ansible-galaxy-roles \
	GALAXY_COLLECTIONS_PATH_WARNING=False \
	ansible-playbook \
		--connection=local \
		--inventory=127.0.0.1, \
		--become --ask-become-pass \
		machine.yml
	@echo "Setting up dev machine: complete"

op-init: ## initialize the 1password CLI
	@echo "Initializing 1password CLI..."
	@rm -rf "${HOME}/.openv-cfg-dir"
	@mkdir -p "${HOME}/.openv-cfg-dir"
	@chmod 0700 "${HOME}/.openv-cfg-dir" 
	@OP_CONFIG_DIR=${HOME}/.openv-cfg-dir && \
		read -p "1password email address: " op_email && \
		token=$$(op account add --address my.1password.ca --email "$$op_email" --signin --raw --config "$$OP_CONFIG_DIR") && \
		echo "$$token" > "${HOME}/.openv-session" && \
		echo "************************************" && \
		echo "export OP_CONFIG_DIR=$$OP_CONFIG_DIR" && \
		echo "export OP_SESSION_my=$$token" && \
		echo "************************************"
	@echo "Initializing 1password CLI: complete"

chezmoi-init: ## initialize the chezmoi dotfile management system on the dev machine
	@echo "Initializing dotfiles..."
	@mkdir -p ${HOME}/projects
	@chezmoi init "marvinpinto/kitchensink" --source=${HOME}/projects/kitchensink --apply
	@echo "Initializing dotfiles: complete"
