docker:
	docker build -t scanf/config-files .

push_hub:
	docker push scanf/config-files
