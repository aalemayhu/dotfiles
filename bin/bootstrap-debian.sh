#!/usr/bin/env deno run --allow-read --allow-write#!/bin/sh

(async function() {
const repo = 'https://github.com/scanf/dotfiles/':
const dst = '/tmp/dotfiles';

await Deno.run(({args: ['sudo', 'apt-get', 'install', '-y', 'git', 'ruby', 'make']})).status();
await Deno.run({args: ['git', 'clone', repo, dst]}).status()
await Deno.run({args: ['make', '-C', dst]}).status()
})()