.EXPORT_ALL_VARIABLES:

## Include the environment file
ifneq ("$(wildcard .env)",)
$(info $(shell tput setaf 2)Using .env$(shell tput sgr0))
include .env
export $(shell sed 's/=.*//' .env)
else
$(info $(shell tput setaf 1)File not found ".env"$(shell tput sgr0))
endif

## Default environment
_context=local

## List of running containers
_running_containers=$(if $(shell docker-compose ps -q), $(shell docker-compose ps -q),)

## Checking the environment file in the "docker" folder
#ifneq ("$(wildcard docker/.env)",)
# $(info $(shell tput setaf 2)Using docker/.env$(shell tput sgr0))
# include docker/.env
# export $(shell sed 's/=.*//' docker/.env)
#else
# $(info $(shell tput setaf 1)File not found "api/.env"$(shell tput sgr0))
#endif

## Checking the environment file in the "api" folder
#ifneq ("$(wildcard include api/.env)",)
# $(info $(shell tput setaf 2)Using api/.env$(shell tput sgr0))
# include api/.env
# export $(shell sed 's/=.*//' api/.env)
#else
# $(info $(shell tput setaf 1)File not found "api/.env"$(shell tput sgr0))
#endif

## Checking the environment file in the "web" folder
#ifneq ("$(wildcard web/.env)",)
# $(info $(shell tput setaf 2)Using web/.env$(shell tput sgr0))
# include web/.env
# export $(shell sed 's/=.*//' web/.env)
#else
# $(info $(shell tput setaf 1)File not found "web/.env"$(shell tput sgr0))
#endif

ifdef c
ifeq ($(c), $(filter $(c), prod production))
_context=production
else ifeq ($(c), $(filter $(c), loc local dev develop))
_context=local
else ifeq ($(c), $(filter $(c), stage staging test testing))
_context=staging
endif
else ifdef context
ifeq ($(context), $(filter $(context), prod production))
_context=production
else ifeq ($(context), $(filter $(context), loc local dev develop development))
_context=local
else ifeq ($(context), $(filter $(context), stage staging test testing))
_context=staging
else
_context=local
endif
endif

ifeq ($(_context), production)
_branch=master
endif
ifeq ($(_context), local)
_branch=develop
endif
ifeq ($(_context), staging)
_branch=test
endif

## Builds, (re)creates, starts, and attaches to containers for a service.
up:
ifneq ($(or $(s),$(service)),)
	docker-compose -f docker-compose.yml -f docker-compose.$(_context).yml up -d --no-deps --build $(or $(s), $(service))
else
	docker-compose -f docker-compose.yml -f docker-compose.$(_context).yml up -d --no-deps --build
endif

## Stops containers and removes containers, networks, volumes, and images created by up.
down:
	docker-compose -f docker-compose.yml -f docker-compose.$(_context).yml down

## List of running containers
list:
	docker-compose -f docker-compose.yml -f docker-compose.$(_context).yml ps

## Fetch the logs of a container
## (opt) If the variable $s or $service is specified - selects the logs by service (s=nginx or service=nginx)
## (opt) If the variable $q or $query is specified - selects the logs by the search string (q=searchMe or query=searchMe)
log:
ifneq ($(or $(s), $(service)),)
	docker-compose -f docker-compose.yml -f docker-compose.$(_context).yml logs $(or $(s), $(service))
endif
ifneq ($(or $(q), $(query)),)
	docker-compose -f docker-compose.yml -f docker-compose.$(_context).yml logs | grep $(or $(q), $(query))
endif

## Run a command in a running container
## (rqd) $s or $service - name of started service
exec:
	docker-compose -f docker-compose.yml -f docker-compose.$(_context).yml exec $(or $(s), $(service)) bash

## Remove all containers, networks, images volumes.
prune:
ifneq ($(_running_containers),)
	echo $(_running_containers)
	$(info $(shell tput setaf 5)Stop working containers $(shell tput sgr0))
	docker stop $(_running_containers)
endif
	docker system prune -af --volumes

install_dependencies:
ifeq ($(_context),local)
	cd $(WEB_SOURCE_PATH) && npm install
	cd $(API_SOURCE_PATH) && composer install
endif

# TODO: сделать автоматическое переключение ветки на мастер
init:
ifeq ($(_context),local)
	git checkout master
	cd $(API_SOURCE_PATH) && git checkout master
	cd $(WEB_SOURCE_PATH) && git checkout master
	cd ../ && git submodule update --remote
endif



#----------------------------------------------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------------------------------------------#

VV := ./version.sh
D := docker
CC := docker-compose -f docker/docker-compose.yml

# Enter your Docker Host IP (will be appended to /etc/hosts). Default is `10.0.75.1`
#DHIP=$(shell ip -4 a_ddr show docker0 | grep -Po 'inet \K[\d.]+')





#DOCKER_REPO     := $(if $(DOCKER_REPO),$(DOCKER_REPO),tc-dockerhub.telecontact.ru/)
#DOCKER_REPO_URL := "https://${DOCKER_REPO}/v2/"
#COMPOSE_FILE    := $(if $(COMPOSE_FILE),$(COMPOSE_FILE),docker-compose.yml:docker-compose.build.yml)

#branch_NAME := $(if $(branch_NAME),$(shell echo $(branch_NAME) | sed 's/\//./g'),$(shell git rev-parse --abbrev-ref HEAD | sed 's/\//./g'))
#BUILD_ID    := $(if $(BUILD_ID),$(BUILD_ID),local)

#ifeq ($(META_FILE), )
#	ifneq ("$(wildcard application/package.json)","")
#		META_FILE = application/package.json
#	endif
#endif

#ifeq ($(META_FILE), )
#	ifneq ("$(wildcard application/composer.json)","")
#		META_FILE = application/composer.json
#	endif
#endif

#COMPOSE_PROJECT_NAME           := $(if $(COMPOSE_PROJECT_NAME),$(COMPOSE_PROJECT_NAME),$(shell cat ${META_FILE} | jq --raw-output '.name'))
#DOCKER_REGISTRY_MIRROR := $(if $(DOCKER_REGISTRY_MIRROR),$(DOCKER_REGISTRY_MIRROR),tc-dockerhub.telecontact.ru/mirror/)
#DOCKER_RELEASE_REPO    := $(if $(DOCKER_RELEASE_REPO),$(DOCKER_RELEASE_REPO),tc-dockerhub.telecontact.ru/)

#PRODUCT_VERSION  := $(shell cat ${META_FILE} | jq --raw-output '.version')
#PRODUCT_REVISION := $(shell cat ${META_FILE} | jq --raw-output '.revision//""')

#ifeq ($(PRODUCT_REVISION),)
#	DESCRIBE_LONG := $(PRODUCT_VERSION)
#else
#	DESCRIBE_LONG := $(PRODUCT_VERSION)-$(PRODUCT_REVISION)
#endif

#TAG_DISCOVERY_MOD := unknown
#branch_NAME_CLASS := $(shell echo $(branch_NAME) | sed 's/release.*/release/g' | sed 's/^feature.*/feature/g')

#ifeq ($(VERSION), )
#
#	META_SHA := $(shell git log --pretty=format:'%h' -n 1)
#
#	ifeq ($(branch_NAME_CLASS), $(filter $(branch_NAME_CLASS), master HEAD release))
#
#		ifeq ($(branch_NAME_CLASS), $(filter $(branch_NAME_CLASS), master HEAD))
#
#			TAG_DISCOVERY_MOD := MASTER
#			VERSION_SHORT     := $(shell $(VV) get ci_short ${DESCRIBE_LONG})
#			VERSION_LONG      := ${VERSION_SHORT}+${branch_NAME_CLASS}.sha.${META_SHA}.build.$(BUILD_ID)
#			VERSION_BRIEF     := $(shell $(VV) get ci_brief ${DESCRIBE_LONG})
#
#		else ifeq ($(branch_NAME_CLASS), $(filter $(branch_NAME_CLASS), release))
#
#			TAG_DISCOVERY_MOD := RELEASE
#			VERSION_SHORT     := $(shell $(VV) get ci_short ${DESCRIBE_LONG})+${branch_NAME}.sha.${META_SHA}
#			VERSION_LONG      := ${VERSION_SHORT}.build.$(BUILD_ID)
#
#		endif
#
#		BUILD_INFO          := ${branch_NAME}.sha.${META_SHA}.build.$(BUILD_ID)
#
#	else
#
#		TAG_DISCOVERY_MOD   := AUTO
#
#		BUILD_INFO    := ${branch_NAME}.sha.${META_SHA}.build.$(BUILD_ID)
#		VERSION_SHORT := $(shell $(VV) get ci_long ${DESCRIBE_LONG})+${branch_NAME}.sha.${META_SHA}
#		VERSION_LONG  := ${VERSION_SHORT}.build.$(BUILD_ID)
#
#	endif
#else
#	TAG_DISCOVERY_MOD   := DISABLED
#	BUILD_INFO          := build.$(BUILD_ID)
#	VERSION_SHORT       := $(VERSION)
#	VERSION_LONG        := $(VERSION).build.$(BUILD_ID)
#endif

#VERSION_DOCKER_SHORT := $(shell echo $(VERSION_SHORT) | sed 's/\+/-/g')
#VERSION_DOCKER_BRIEF := $(shell echo $(VERSION_BRIEF) | sed 's/\+/-/g')
#VERSION_DOCKER_LONG  := $(shell echo $(VERSION_LONG)  | sed 's/\+/-/g')

#DOCKER_BUILD_TAGS =
#DOCKER_BUILD_TAGS += ${VERSION_DOCKER_LONG}

#ifneq ($(BUILD_ID),local)
#	DOCKER_BUILD_TAGS += ${VERSION_DOCKER_SHORT}
#	ifeq ($(branch_NAME), $(filter $(branch_NAME), master))
#		DOCKER_BUILD_TAGS += latest
#		DOCKER_BUILD_TAGS += ${VERSION_DOCKER_BRIEF}
#	endif
#	ifeq ($(branch_NAME_CLASS), $(filter $(branch_NAME_CLASS), release))
#		DOCKER_BUILD_TAGS += latest_release
#	endif
#	ifeq ($(branch_NAME), $(filter $(branch_NAME), develop))
#		DOCKER_BUILD_TAGS += develop
#	endif
#	ifeq ($(branch_NAME_CLASS), $(filter $(branch_NAME_CLASS), feature))
#		DOCKER_BUILD_TAGS +=  $(branch_NAME)
#	endif
#endif

all: lint build
build: prebuild build_docker_image
build_docker_image:
	env \
		VERSION=$(VERSION_DOCKER_LONG) \
		DOCKER_RELEASE_REPO=localhost/ \
		DOCKER_REGISTRY_MIRROR=$(DOCKER_REGISTRY_MIRROR) \
		$(CC) build --pull --no-cache

	for DOCKER_BUILD_TAG in $(DOCKER_BUILD_TAGS) ; \
	do \
		env \
		VERSION=$$DOCKER_BUILD_TAG \
		$(CC) build; \
	done

prebuild:
	@prebuild_services_list=`VERSION=$(VERSION_DOCKER_LONG) \
		DOCKER_RELEASE_REPO=localhost/ \
		DOCKER_REGISTRY_MIRROR=$(DOCKER_REGISTRY_MIRROR) \
		$(CC) config --services | grep -E '^prebuild_'`; \
	if [ ! -z $$prebuild_services_list ]; then \
		echo $$prebuild_services_list; \
		for prebuild_service in $$prebuild_services_list ; \
		do \
			echo ${prebuild_service}; \
			env \
			VERSION=$(VERSION_DOCKER_LONG) \
			DOCKER_RELEASE_REPO=localhost/ \
			DOCKER_REGISTRY_MIRROR=$(DOCKER_REGISTRY_MIRROR) \
			${CC} run --rm $$prebuild_service; \
		done \
	else \
		echo "prebuild_services_list empty" ; \
	fi

lint: print_docker_compose_config

	jq --version
	# COMPOSE_PROJECT_NAME = ${COMPOSE_PROJECT_NAME}
	# branch_NAME  = ${branch_NAME}

	# branch_NAME_CLASS   = ${branch_NAME_CLASS}
	# DESCRIBE_LONG       = ${DESCRIBE_LONG}
	# DOCKER_RELEASE_REPO = ${DOCKER_RELEASE_REPO}
	# DOCKER_REGISTRY_MIRROR = ${DOCKER_REGISTRY_MIRROR}
	# TAG_DISCOVERY_MOD   = ${TAG_DISCOVERY_MOD}

	# BUILD_INFO = ${BUILD_INFO}
	# META_SHA   = ${META_SHA}

	# VERSION_SHORT = ${VERSION_SHORT}
	# VERSION_LONG  = ${VERSION_LONG}

	# VERSION_DOCKER_SHORT = ${VERSION_DOCKER_SHORT}
	# VERSION_DOCKER_LONG  = ${VERSION_DOCKER_LONG}
	# VERSION_DOCKER_BRIEF = ${VERSION_DOCKER_BRIEF}

	# DOCKER_BUILD_TAGS = ${DOCKER_BUILD_TAGS}
	# DOCKER_BUILD_TAG:
	for DOCKER_BUILD_TAG in $(DOCKER_BUILD_TAGS) ; do echo "  - $$DOCKER_BUILD_TAG"; done
	#
	# ======================================
	#
	$(VV) validate $(VERSION_SHORT)
	$(VV) validate $(VERSION_LONG)

print_docker_compose_config:
	env \
		VERSION=$(VERSION_DOCKER_SHORT) \
		DOCKER_RELEASE_REPO=localhost/ \
		DOCKER_REGISTRY_MIRROR=$(DOCKER_REGISTRY_MIRROR) \
		$(CC) config

run:
	env \
		VERSION=$(VERSION_DOCKER_SHORT) \
		$(CC) up -d

#stop:
#	env \
#		VERSION=$(VERSION_DOCKER_SHORT) \
#		$(CC) stop

clean:
	env \
		VERSION=$(VERSION_DOCKER_LONG) \
		DOCKER_RELEASE_REPO=localhost/ \
		DOCKER_REGISTRY_MIRROR=$(DOCKER_REGISTRY_MIRROR) \
		$(CC) down --rmi all

	for DOCKER_BUILD_TAG in $(DOCKER_BUILD_TAGS) ; \
	do \
		env \
			VERSION=$$DOCKER_BUILD_TAG \
			$(CC) down --rmi all ;\
	done

release: release_docker_image

release_docker_image:
	for DOCKER_BUILD_TAG in $(DOCKER_BUILD_TAGS) ; \
	do \
		env \
		VERSION=$$DOCKER_BUILD_TAG \
		$(CC) push; \
	done








app: up

export CONTEXT = $(_context)
export BRANCH = $(_branch)
export DOCKER_HOST_IP = $(DHIP)
