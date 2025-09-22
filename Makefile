VERSION ?= 1.42.2.10156
CACHE ?= --no-cache=1
PMS_URL ?=

.PHONY: all build publish
all: build publish
build:
	docker buildx build --platform linux/amd64,linux/arm/v7,linux/arm64/v8 ${PUSH} --build-arg PMS_URL=${PMS_URL} --build-arg VERSION=${VERSION} ${CACHE} -t jaymoulin/plex -t jaymoulin/plex:${VERSION} .
publish:
	PUSH=--push CACHE= make build

