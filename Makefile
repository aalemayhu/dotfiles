project=scanf/config-files

all: docker push_hub
	echo "Pushed to docker"
docker:
	docker build -t ${project} .

push_hub:
	docker push ${project}
