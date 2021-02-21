export DOCKER_USER=pay64k
export DOCKER_CLI_EXPERIMENTAL=enabled
export MIX_ENV=prod

release:
	mix deps.get
	npm install --prefix ./assets
	npm run deploy --prefix ./assets
	mix release pi_dash

.PHONY: docker
docker: 
	docker buildx build  --platform linux/arm64 --push . -t "${DOCKER_USER}/pi_dash:arm64"
	docker buildx imagetools inspect "${DOCKER_USER}/pi_dash:arm64"
	docker inspect --format "{{.Architecture}}" "${DOCKER_USER}/pi_dash:arm64"

.PHONY: run_docker
run_docker:
	docker run -it --rm "${DOCKER_USER}/pi_dash:arm64"

.PHONY: configure
configure:
	docker version
	docker run --rm --privileged multiarch/qemu-user-static --reset -p yes