project=scanf/config-files

all:
	bin/run.bash

run: all

desktop: run
	bin/setup-desktop.bash
copy:
	bin/copy_files.rb

docker:
	docker build -t ${project} .
docker_deploy: docker docker_push
	echo "Pushed to docker"
docker-run: docker
	docker run -t -i ${project} /bin/bash
docker-push:
	docker push ${project}

.PHONY: all
