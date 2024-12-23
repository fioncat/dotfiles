DOCKER_CMD:=$(if $(DOCKER_CMD),$(DOCKER_CMD),docker)
DOCKER_BUCKET:=$(if $(DOCKER_BUCKET),$(DOCKER_BUCKET),fioncat)

ARCHLINUX_BASE_IMAGE:=$(if $(BASE_IMAGE),$(BASE_IMAGE),archlinux:latest)
UBUNTU_BASE_IMAGE:=$(if $(BASE_IMAGE),$(BASE_IMAGE),ubuntu:22.04)

.PHONY: archlinux
archlinux:
	$(DOCKER_CMD) build --build-arg BASE_IMAGE=$(ARCHLINUX_BASE_IMAGE) -t $(DOCKER_BUCKET)/dev:archlinux .

.PHONY: ubuntu
ubuntu:
	$(DOCKER_CMD) build --build-arg BASE_IMAGE=$(UBUNTU_BASE_IMAGE) -t $(DOCKER_BUCKET)/dev:ubuntu .
