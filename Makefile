# This Makefile automates possible operations of this project.
#
# Images and description on Docker Hub will be automatically rebuilt on
# pushes to `master` branch of this repo and on updates of parent image.
#
# Note! Docker Hub `post_push` hook must be always up-to-date with default
# values of current Makefile. To update it just use:
#	make post-push-hook
#
# It's still possible to build, tag and push images manually. Just use:
#	make release


IMAGE_NAME := flexconstructor/gotools
VERSION ?= 1.11.5-r1
TAGS ?= 1.11.5-r1,1.11.5,1.11,1,latest


comma := ,
eq = $(if $(or $(1),$(2)),$(and $(findstring $(1),$(2)),\
                                $(findstring $(2),$(1))),1)


MAINLINE_BRANCH := master
CURRENT_BRANCH := $(shell git branch | grep \* | cut -d ' ' -f2)




###########
# Aliases #
###########

squash: git.squash



# Build Docker image.
#
# Usage:
#	make image [VERSION=<image-version>] [no-cache=(no|yes)]

image:
	docker build --network=host --force-rm \
		$(if $(call eq,$(no-cache),yes),--no-cache --pull,) \
		-t $(IMAGE_NAME):$(VERSION) .



# Tag Docker image with given tags.
#
# Usage:
#	make tags [VERSION=<image-version>]
#	          [TAGS=<docker-tag-1>[,<docker-tag-2>...]]

tags:
	$(foreach tag, $(subst $(comma), ,$(TAGS)),\
		$(call docker.tag.do,$(VERSION),$(tag)))
define tags.do
	$(eval from := $(strip $(1)))
	$(eval to := $(strip $(2)))
	docker tag $(IMAGE_NAME):$(from) $(IMAGE_NAME):$(to)
endef



# Manually push Docker images to Docker Hub.
#
# Usage:
#	make push [TAGS=<docker-tag-1>[,<docker-tag-2>...]]

push:
	$(foreach tag, $(subst $(comma), ,$(TAGS)),\
		$(call docker.push.do, $(tag)))
define push.do
	$(eval tag := $(strip $(1)))
	docker push $(IMAGE_NAME):$(tag)
endef



# Make manual release of Docker images to Docker Hub.
#
# Usage:
#	make release [VERSION=<image-version>] [no-cache=(no|yes)]
#	             [TAGS=<docker-tag-1>[,<docker-tag-2>...]]

release: | image tags push



# Create `post_push` Docker Hub hook.
#
# When Docker Hub triggers automated build all the tags defined in `post_push`
# hook will be assigned to built image. It allows to link the same image with
# different tags, and not to build identical image for each tag separately.
# See details:
# http://windsock.io/automated-docker-image-builds-with-multiple-tags
#
# Usage:
#	make post-push-hook [TAGS=<docker-tag-1>[,<docker-tag-2>...]]

post-push-hook:
	@mkdir -p hooks/
	docker run --rm -v "$(PWD)/post_push.tmpl.php":/post_push.php:ro \
		php:alpine php -f /post_push.php -- \
			--image_tags='$(TAGS)' \
		> hooks/post_push



# Test Docker image with goss tool.
#
# Manual:
#	https://github.com/aelsabbahy/goss/blob/master/docs/manual.md#usage
#
# Usage:
#	make test [VERSION=<image-version>]

test-container-name ?= goss-test

test:

	docker run --name $(test-container-name) aelsabbahy/goss goss
	docker run --rm -it --volumes-from  $(test-container-name) -v $(PWD)/goss.yml:/goss/goss.yml:ro  $(IMAGE_NAME):$(VERSION)  /goss/goss --gossfile=/goss/goss.yml validate --format=tap
	docker stop $(test-container-name)
	docker rm $(test-container-name)


################
# Git commands #
################

# Squash changes of the current Git branch onto another Git branch.
#
# WARNING: You must merge `onto` branch in the current branch before squash!
#
# Usage:
#	make git.squash [onto=(<mainline-git-branch>|<git-branch>)]
#	                [del=(no|yes)]
#	                [upstream=(origin|<git-remote>)]

onto ?= $(MAINLINE_BRANCH)
upstream ?= origin

git.squash:
ifeq ($(CURRENT_BRANCH),$(onto))
	echo "--> Current branch is '$(onto)' already" && false
endif
	git checkout $(onto)
	git branch -m $(CURRENT_BRANCH) orig-$(CURRENT_BRANCH)
	git checkout -b $(CURRENT_BRANCH)
	git branch --set-upstream-to $(upstream)/$(CURRENT_BRANCH)
	git merge --squash orig-$(CURRENT_BRANCH)
ifeq ($(del),yes)
	git branch -d orig-$(CURRENT_BRANCH)
endif

.PHONY: image tags push release post-push-hook test
