[![Build Status](https://travis-ci.org/scanf/dotfiles.svg?branch=master)](https://travis-ci.org/scanf/dotfiles)

This repository contains the ⚙️ configurations files I use both on Linux and
macOS...

Use this at your own risk and don't expect any support from me if you break
your default setup.

## Installing

```sh
curl -fsSL https://deno.land/x/install/install.sh | sh
git clone https://github.com/scanf/dotfiles ~/src/github.com/scanf/dotfiles
cd ~/src/github.com/scanf/dotfiles
~/.deno/bin/deno run --allow-write \
--allow-read \
--allow-run \
 --allow-env \
 bin/bootstrap.ts
```
