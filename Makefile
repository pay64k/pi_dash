export base_image_rpi_b_plus=docker.io/arm32v6/alpine:3.13.2
export base_image_rpi4=docker.io/arm64v8/alpine:3.13.2

export DOCKER_USER=pay64k
export DOCKER_CLI_EXPERIMENTAL=enabled
export MIX_ENV=prod

release:
	mix deps.get
	npm install --prefix ./assets
	npm run deploy --prefix ./assets
	mix release pi_dash

.PHONY: docker_rpi4
docker_rpi4:
	docker buildx build --build-arg base_image=${base_image_rpi4} --platform linux/arm64 --push . -t "docker.io/${DOCKER_USER}/pi_dash:arm64v8"
	docker buildx imagetools inspect "docker.io/${DOCKER_USER}/pi_dash:arm64v8"
	docker inspect --format "{{.Architecture}}" "docker.io/${DOCKER_USER}/pi_dash:arm64v8"

.PHONY: docker_rpi_b_plus
docker_rpi_b_plus:
	docker buildx build --build-arg base_image=${base_image_rpi_b_plus} --platform linux/arm64 --push . -t "docker.io/${DOCKER_USER}/pi_dash:arm32v6"
	docker buildx imagetools inspect "docker.io/${DOCKER_USER}/pi_dash:arm32v6"
	docker inspect --format "{{.Architecture}}" "docker.io/${DOCKER_USER}/pi_dash:arm32v6"

.PHONY: run_docker
run_docker:
	docker run -it --rm "${DOCKER_USER}/pi_dash:arm64"

.PHONY: configure
configure:
	docker version
	docker run --rm --privileged multiarch/qemu-user-static --reset -p yes