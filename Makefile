VERSION ?= 1.10.0
CACHE ?= --no-cache=1
FULLVERSION ?= ${VERSION}
archs ?= amd64 arm32v6 arm64v8 aarch64

.PHONY: all build publish latest
all: build publish latest
qemu-aarch64-static:
	cp /usr/bin/qemu-aarch64-static .
qemu-arm-static:
	cp /usr/bin/qemu-arm-static .
build: qemu-aarch64-static qemu-arm-static
	$(foreach arch,$(archs), \
		a=$$(echo $(arch) | awk -F"arm" '{print $$2}'); \
		if [ $(arch) = aarch64 ]; then a=arm; fi; \
		cat Dockerfile.builder > Dockerfile; \
		if [ "$$a" = "" ]; then \
			cat Dockerfile.amd | sed "s/FROM alpine/FROM $(arch)\/alpine/g" >> Dockerfile; \
			cat Dockerfile.common >> Dockerfile; \
			docker build -t jaymoulin/plex:${VERSION}-$(arch) --build-arg ARM=0 ${CACHE} .;\
		else \
			cat Dockerfile.arm >> Dockerfile; \
			cat Dockerfile.common >> Dockerfile; \
			docker build -t jaymoulin/rpi-plex:${VERSION}-$(arch) ${CACHE} .;\
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
latest: build
	FULLVERSION=latest VERSION=${VERSION} make publish
