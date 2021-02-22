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
	docker buildx build --platform linux/arm64 --push -f Dockerfile.rpi4 . -t "docker.io/${DOCKER_USER}/pi_dash:arm64v8"
	docker buildx imagetools inspect "docker.io/${DOCKER_USER}/pi_dash:arm64v8"
	docker inspect --format "{{.Architecture}}" "docker.io/${DOCKER_USER}/pi_dash:arm64v8"

.PHONY: docker_rpi_b_plus
docker_rpi_b_plus:
	docker buildx build  --platform linux/arm64 --push -f Dockerfile.rpi_b_plus . -t "docker.io/${DOCKER_USER}/pi_dash:arm64v6l"
	docker buildx imagetools inspect "docker.io/${DOCKER_USER}/pi_dash:arm64v6l"
	docker inspect --format "{{.Architecture}}" "docker.io/${DOCKER_USER}/pi_dash:arm64v6l"

.PHONY: run_docker
run_docker:
	docker run -it --rm "${DOCKER_USER}/pi_dash:arm64"

.PHONY: configure
configure:
	docker version
	docker run --rm --privileged multiarch/qemu-user-static --reset -p yes