VERSION ?= 1.14.0
CACHE ?= --no-cache=1
FULLVERSION ?= 1.14.0
archs ?= amd64 arm32v6 arm64v8 aarch64

.PHONY: all build publish latest
all: build publish latest
build: 
	$(foreach arch,$(archs), \
		a=$$(echo $(arch) | awk -F"arm" '{print $$2}'); \
		if [ $(arch) = aarch64 ]; then a=arm; fi; \
		cat Dockerfile.builder > Dockerfile; \
		if [ "$$a" = "" ]; then \
			cat Dockerfile.amd | sed "s/FROM alpine/FROM $(arch)\/alpine/g" >> Dockerfile; \
			cat Dockerfile.common >> Dockerfile; \
			docker build -t jaymoulin/plex:${VERSION}-$(arch) --build-arg ARM=0 --build-arg VERSION=${VERSION} ${CACHE} .;\
		else \
			cat Dockerfile.arm >> Dockerfile; \
			cat Dockerfile.common >> Dockerfile; \
			docker run --rm --privileged multiarch/qemu-user-static:register --reset; \
			docker build -t jaymoulin/rpi-plex:${VERSION}-$(arch) --build-arg VERSION=${VERSION} ${CACHE} .;\
		fi; \
	)
publish:
	docker push jaymoulin/plex
	docker push jaymoulin/rpi-plex
	cat manifest.yml | sed "s/\$$VERSION/${VERSION}/g" > manifest.yaml
	cat manifest.yaml | sed "s/\$$FULLVERSION/${FULLVERSION}/g" > manifest2.yaml
	mv manifest2.yaml manifest.yaml
	manifest-tool push from-spec manifest.yaml
	cat manifest.rpi.yml | sed "s/\$$VERSION/${VERSION}/g" > manifest.yaml
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
	docker run -ti --rm -v ${PWD}/.trc:/root/.trc jaymoulin/twitter-cli update "Version ${VERSION} available of @plex @docker container for @Raspberry_Pi. Just pull jaymoulin/plex"
