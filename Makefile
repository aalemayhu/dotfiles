project=scanf/config-files

all:
	bin/run.bash

desktop: install
	bin/setup-desktop.bash

docker-deploy: docker push_hub
	echo "Pushed to docker"
docker:
	docker build -t ${project} .

push_hub:
	docker push ${project}
