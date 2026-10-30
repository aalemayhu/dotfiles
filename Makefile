# Set up or update this Mac or Linux machine from the repo. See README.md.

install:
	./bootstrap.sh

link:
	./bootstrap.sh link

check:
	./bootstrap.sh check
	brew bundle check --file=Brewfile --no-upgrade --verbose

# Copy settings Claude Code changed (/config, plugins, ...) back into the repo
claude-save:
	bin/claude-settings save

# Upgrade everything: Homebrew, mise runtimes, Neovim and its plugins, Claude Code
update:
	brew update
	brew upgrade
	brew cleanup
	mise upgrade
	bash bin/install_neovim.sh
	nvim --headless "+Lazy! sync" +qa
	claude update

# Refresh the Brewfile from what is installed now (npm/cargo CLIs live in mise;
# App Store apps stay out, they need an Apple ID sign-in)
dump:
	{ sed -n '1,3p' Brewfile; brew bundle dump --file=- | grep -vE '^(npm|cargo|mas) '; } > Brewfile.new
	@echo "Wrote Brewfile.new; merge it by hand, Brewfile keeps its 'if OS.mac?' block"

.PHONY: install link check claude-save update dump
