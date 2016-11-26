project=scanf/config-files

all:
	bin/run.bash

run: all

desktop: install
	bin/setup-desktop.bash

docker:
	docker build -t ${project} .
docker_deploy: docker docker_push
	echo "Pushed to docker"
docker_run: docker
	docker run -t -i scanf/config-files /bin/bash
docker_push:
	docker push ${project}
