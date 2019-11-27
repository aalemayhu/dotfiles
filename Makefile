project=scanf/config-files

all:
	if [ ! -d "${HOME}/.deno" ]; then ${MAKE} install_deno; fi
	~/.deno/bin/deno run --allow-write --allow-read --allow-run --allow-env bin/run.ts

install_deno:
	$(shell grep curl README.md)

run: all

desktop: run
	bin/setup-desktop.bash
copy:
	deno run --allow-read --allow-write --allow-env --allow-run bin/copy_files.ts

fmt:
	deno fmt bin/*.ts

docker:
	docker build -t ${project} .
docker_deploy: docker docker_push
	echo "Pushed to docker"
docker_run: docker
	docker run -t -i ${project} /bin/bash
docker_push:
	docker push ${project}

.PHONY: all
