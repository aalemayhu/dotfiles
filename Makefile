project=scanf/config-files

docker-deploy: docker push_hub
	echo "Pushed to docker"
docker:
	docker build -t ${project} .

push_hub:
	docker push ${project}

install:
	bin/run.bash

install-desktop: install
	bin/setup-desktop.bash
