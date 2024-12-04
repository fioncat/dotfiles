DOCKER_CMD:=$(if $(DOCKER_CMD),$(DOCKER_CMD),docker)
DOCKER_BUCKET:=$(if $(DOCKER_BUCKET),$(DOCKER_BUCKET),fioncat)
DOCKER_BASE_IMAGE:=$(if $(DOCKER_BASE_IMAGE),$(DOCKER_BASE_IMAGE),archlinux:latest)

.PHONY: build
build:
	$(DOCKER_CMD) build --build-arg BASE_IMAGE=$(DOCKER_BASE_IMAGE) -t $(DOCKER_BUCKET)/dev:archlinux .
