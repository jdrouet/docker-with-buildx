ci-install-buildx:
	sudo rm -rf /var/lib/apt/lists/*
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu ${shell lsb_release -cs} edge"
	sudo apt-get update
	sudo apt-get -y -o Dpkg::Options::="--force-confnew" install docker-ce
	docker run --rm --privileged tonistiigi/binfmt:latest --install all
	mkdir -vp ~/.docker/cli-plugins/
	curl --silent -L "https://github.com/docker/buildx/releases/download/v0.4.2/buildx-v0.4.2.linux-amd64" > ~/.docker/cli-plugins/docker-buildx
	chmod a+x ~/.docker/cli-plugins/docker-buildx
	docker buildx install
	docker buildx create --use

ci-build:
	docker buildx build ${EXTRA_ARGS} \
		--platform linux/amd64,linux/i386,linux/arm64,linux/arm/v7 \
		--build-arg BUILDX_VERSION=${BUILDX_VERSION} \
		--build-arg DOCKER_VERSION=${DOCKER_VERSION} \
		--tag jdrouet/docker-with-buildx:${DOCKER_VERSION}-${BUILDX_VERSION} .