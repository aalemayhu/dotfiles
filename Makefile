project=scanf/config-files

install:
	bin/run.bash

install-desktop: install
	bin/setup-desktop.bash

docker-deploy: docker push_hub
	echo "Pushed to docker"
docker:
	docker build -t ${project} .

push_hub:
	docker push ${project}
