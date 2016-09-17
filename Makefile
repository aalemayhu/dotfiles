project=scanf/config-files

all:
	bin/run.bash

desktop: install
	bin/setup-desktop.bash

docker:
	docker build -t ${project} .

docker-deploy: docker push_hub
	echo "Pushed to docker"

push_hub:
	docker push ${project}
