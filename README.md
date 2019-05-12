[![Build Status](https://travis-ci.org/scanf/dotfiles.svg?branch=master)](https://travis-ci.org/scanf/dotfiles)

This repository contains the configurations files I use both on Linux and
macOS.

Use this at your own risk and don't expect any support from me if you break
your default setup.

## Debian

```sh
curl -fsSL https://deno.land/x/install/install.sh | sh -s v0.5.0
~/.deno/bin/deno run --allow-write \
--allow-read \
--allow-run \
 --allow-env \
 https://raw.githubusercontent.com/scanf/dotfiles/master/bin/bootstrap.ts
```