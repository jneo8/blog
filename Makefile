DATE ?= $$(date '+%Y-%m-%d %H:%M:%S %Z')
COMMIT = $$(git rev-parse --short HEAD)
COMMITMSG ?= "Auto-deploy at ${DATE} commit: ${COMMIT}"


##@ Show

show-commit-msg:  ## show COMMITMSG
	echo ${COMMITMSG}

.PHONY: show-commit-msg

##@ hugo

deploy:  ## Auto deploy to github page with times commit
	./deploy.sh "Auto-deploy at ${DATE} commit: ${COMMIT}"

.PHONY: deploy

##@ Help

.PHONY: help

help:  ## Display this help
	    @awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-0-9]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help
