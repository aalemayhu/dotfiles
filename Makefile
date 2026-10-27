# Set up or update this Mac from the repo. See README.md.

install:
	./bootstrap.sh

link:
	./bootstrap.sh link

check:
	./bootstrap.sh check
	brew bundle check --file=Brewfile --no-upgrade --verbose

# Upgrade everything: Homebrew, mise runtimes, Neovim and its plugins, Claude Code
update:
	brew update
	brew upgrade
	brew cleanup
	mise upgrade
	bash bin/install_neovim.sh
	nvim --headless "+Lazy! sync" +qa
	claude update

# Refresh the Brewfile from what is installed now (npm/cargo CLIs live in mise)
dump:
	{ sed -n '1,3p' Brewfile; brew bundle dump --file=- | grep -vE '^(npm|cargo) '; } > Brewfile.new
	mv Brewfile.new Brewfile

.PHONY: install link check update dump
