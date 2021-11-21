all: help

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}'

/tmp/ansible-galaxy-roles:
	mkdir -p /tmp/ansible-galaxy-roles
	ansible-galaxy collection install -r ./dev-machine/galaxy-roles-req.yml -p /tmp/ansible-galaxy-roles

machine: /tmp/ansible-galaxy-roles ## setup or update the base dev machine
	cd dev-machine && \
	ANSIBLE_ROLES_PATH=./roles:/tmp/ansible-galaxy-roles ansible-playbook \
		--connection=local \
		--inventory=127.0.0.1, \
		--become --ask-become-pass \
		machine.yml
