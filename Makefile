project=scanf/config-files

all:
	bin/run.bash

desktop: install
	bin/setup-desktop.bash

docker:
	docker build -t ${project} .
docker-deploy: docker push_hub
	echo "Pushed to docker"
docker-run: docker
	docker run -t -i scanf/config-files /bin/bash
push_hub:
	docker push ${project}
