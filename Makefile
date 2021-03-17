export base_image_rpi4=docker.io/arm64v8/alpine:3.13.2

export DOCKER_USER=pay64k
export DOCKER_CLI_EXPERIMENTAL=enabled
export MIX_ENV=prod

release:
	mix deps.get
	npm install --prefix ./assets
	npm run deploy --prefix ./assets
	mix release pi_dash

install:
	rm -rf ~/pi_dash || true
	mkdir -p ~/pi_dash
	mkdir -p ~/pi_dash/log/
	cp _build/prod/pi_dash-0.1.1.tar.gz ~/pi_dash
	cd ~/pi_dash && \
	tar -xvf pi_dash-0.1.1.tar.gz

.PHONY: test_mode
test_mode:
	MIX_ENV=dev TEST_MODE=true iex -S mix phx.server

.PHONY: docker_rpi4
docker_rpi4:
	docker buildx build --build-arg base_image=${base_image_rpi4} --platform linux/arm64 --push . -t "docker.io/${DOCKER_USER}/pi_dash:arm64v8"
	# docker buildx imagetools inspect "docker.io/${DOCKER_USER}/pi_dash:arm64v8"
	# docker inspect --format "{{.Architecture}}" "docker.io/${DOCKER_USER}/pi_dash:arm64v8"
	# extract release
	docker create --name boii "docker.io/${DOCKER_USER}/pi_dash:arm64v8"
	docker cp boii:/app/pi_dash-0.1.0.tar.gz .
	docker rm boii
	mv pi_dash-0.1.0.tar.gz pi_dash-0.1.0-arm64v8.tar.gz

.PHONY: configure
configure:
	docker version
	docker run --rm --privileged multiarch/qemu-user-static --reset -p yes