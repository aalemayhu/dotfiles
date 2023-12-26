project=scanf/config-files
PATH :=${HOME}/.local/bin:${PATH}

all:
	ruby bin/run.rb
	if [ ! -d "${HOME}/.cargo" ]; then ${MAKE} install_rust; fi
	if [ ! -d "${HOME}/.nvm" ]; then ${MAKE} install_node; fi

install_rust:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

install_wasmtime:
	curl https://wasmtime.dev/install.sh -sSf | bash

install_node:
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

run: all

desktop: run
	bin/setup-desktop.bash
copy:
	ruby bin/copy_files.rb

fmt:
	rubocop --fix-layout bin/*.rb

docker:
	docker build -t ${project} .
docker_deploy: docker docker_push
	echo "Pushed to docker"
docker_run: docker
	docker run -t -i ${project} /bin/bash
docker_push:
	docker push ${project}

.PHONY: all
