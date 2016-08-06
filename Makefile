project=scanf/config-files

docker:
	docker build -t ${project} .

push_hub:
	docker push ${project}
