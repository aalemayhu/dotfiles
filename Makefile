project=scanf/config-files
elixir_repo_path=~/src/github.com/elixir-lang/elixir
PATH :=${HOME}/.local/bin:${PATH}

# Detect OS for conditional targets
UNAME_S := $(shell uname -s 2>/dev/null || echo "Windows")

all:
	ruby bin/run.rb
ifeq ($(UNAME_S),Windows)
	@echo "Windows setup complete. Use Git Bash for best experience."
else
	if [ ! -d "${HOME}/.cargo" ]; then ${MAKE} install_rust; fi
	if [ ! -d "${HOME}/.nvm" ]; then ${MAKE} install_node; fi
endif

windows:
	@echo "Running Windows setup..."
	ruby bin/run.rb
	@echo "Setup complete! Use Git Bash for the best experience."

install_elixir:
	mkdir -pv ${elixir_repo_path}
	ls ${elixir_repo_path} || git clone https://github.com/elixir-lang/elixir.git ${elixir_repo_path}
	cd ${elixir_repo_path}
	make -C ${elixir_repo_path} clean compile

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
