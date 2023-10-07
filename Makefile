REPO=cwbak
NAME=psqlc
APPNAME=$(REPO)/$(NAME)
VERSION=$(shell cat ./version)
LATEST=latest

AMD64=amd64
ARM64=arm64
PLATFORM_AMD64:=linux/$(AMD64)
PLATFORM_ARM64:=linux/$(ARM64)

APPNAME_AMD64:=$(APPNAME)-$(AMD64)
APPNAME_ARM64:=$(APPNAME)-$(ARM64)


.PHONY: version all

all: build tag manifest publish

# build
build: build-amd64 build-arm64 manifest

build-amd64:
	@echo "> Build AMD64 image"
	@docker build -t $(APPNAME_AMD64):$(VERSION) --platform $(PLATFORM_AMD64) .

build-arm64:
	@echo "> Build ARM64 image"
	@docker build -t $(APPNAME_ARM64):$(VERSION) --platform $(PLATFORM_ARM64) .



# tag
tag: tag-amd64 tag-arm64

tag-amd64:
	docker tag $(APPNAME_AMD64):$(VERSION) $(APPNAME_AMD64):$(LATEST)

tag-arm64:
	docker tag $(APPNAME_ARM64):$(VERSION) $(APPNAME_ARM64):$(LATEST)



# manifest
manifest: manifest-version manifest-latest


manifest-version:
	docker manifest create --amend $(APPNAME):$(VERSION) \
		$(APPNAME_AMD64):$(VERSION) \
		$(APPNAME_ARM64):$(VERSION)
manifest-latest:
	docker manifest create --amend $(APPNAME):$(LATEST) \
		$(APPNAME_AMD64):$(LATEST) \
		$(APPNAME_ARM64):$(LATEST)

# publish
publish: publish-amd64 publish-arm64 publish-manifest

publish-amd64:
	docker push $(APPNAME_AMD64):$(VERSION)
	docker push $(APPNAME_AMD64):$(LATEST)

publish-arm64:
	docker push $(APPNAME_ARM64):$(VERSION)
	docker push $(APPNAME_ARM64):$(LATEST)

publish-manifest:
	docker manifest push $(APPNAME):$(VERSION)
	docker manifest push $(APPNAME):$(LATEST)

# version
version:
	@echo $(VERSION)
