all: help

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}'

clean:
	docker image prune --force

build: clean ## build the vpn container locally
	docker buildx build \
		--no-cache \
		--platform linux/amd64 \
		--tag ghcr.io/marvinpinto/vpn:latest .
