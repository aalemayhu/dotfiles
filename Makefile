project=scanf/config-files

all:
	curl -fsSL https://deno.land/x/install/install.sh | sh
	~/.deno/bin/deno run --allow-write --allow-read --allow-run --allow-env bin/run.ts

run: all

desktop: run
	bin/setup-desktop.bash
copy:
	bin/copy_files.rb

docker:
	docker build -t ${project} .
docker_deploy: docker docker_push
	echo "Pushed to docker"
docker_run: docker
	docker run -t -i ${project} /bin/bash
docker_push:
	docker push ${project}

.PHONY: all
