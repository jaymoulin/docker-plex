VERSION ?= 1.21.0.3711
CACHE ?= --no-cache=1
FULLVERSION ?= 1.21.0.3711
archs ?= amd64 armhf arm64v8 aarch64
PMS_URL ?=

.PHONY: all build publish latest
all: build publish latest
qemu-aarch64-static:
	cp /usr/bin/qemu-aarch64-static .
build: qemu-aarch64-static
	docker images | grep  "jaymoulin\/plex\s.*" | awk '{print $$1":"$$2}' | xargs docker rmi || true
	$(foreach arch,$(archs), \
		cat Dockerfile.builder > Dockerfile; \
		cat docker/$(arch)/Dockerfile.template >> Dockerfile; \
		cat Dockerfile.common >> Dockerfile; \
		docker build -t jaymoulin/plex:${VERSION}-$(arch) --build-arg PMS_URL=${PMS_URL} --build-arg ARCH=$(arch) --build-arg VERSION=${VERSION}-$(arch) ${CACHE} .;\
		docker run --rm --privileged multiarch/qemu-user-static:register --reset; \
	)
publish:
	docker push jaymoulin/plex
	cat manifest.yml | sed "s/\$$VERSION/${VERSION}/g" > manifest.yaml
	cat manifest.yaml | sed "s/\$$FULLVERSION/${FULLVERSION}/g" > manifest2.yaml
	mv manifest2.yaml manifest.yaml
	manifest-tool push from-spec manifest.yaml
latest:
	FULLVERSION=latest VERSION=${VERSION} make publish
.trc:
	@cat .trc.template | sed "s/\$$TWITTER_CONSUMER_KEY/${TWITTER_CONSUMER_KEY}/g" > .trc
	@cat .trc | sed "s/\$$TWITTER_CONSUMER_SECRET/${TWITTER_CONSUMER_SECRET}/g" > .trc2
	@mv .trc2 .trc
	@cat .trc | sed "s/\$$TWITTER_TOKEN/${TWITTER_TOKEN}/g" > .trc2
	@cat .trc2 | sed "s/\$$TWITTER_SECRET/${TWITTER_SECRET}/g" > .trc
	@rm .trc2
tweet: .trc
	docker run --rm -v ${PWD}/.trc:/root/.trc jaymoulin/twitter-cli update "Version ${VERSION} available of @plex @docker container for @Raspberry_Pi. Just pull jaymoulin/plex. You can support me on https://patreon.com/jaymoulin | https://buymeacoff.ee/jaymoulin | https://paypal.me/jaymoulin"
