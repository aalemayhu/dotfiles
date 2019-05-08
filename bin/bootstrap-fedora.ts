#!/usr/bin/env deno run --allow-read --allow-write

(async function() {
  const repo = "https://github.com/scanf/dotfiles/";
  const dst = "/tmp/dotfiles";

  await Deno.run({
    args: ["sudo", "dnf", "install", "-y", "git", "ruby", "make"]
  }).status();
  await Deno.run({
    args: ["sudo", "dnf", "'C Development Tools and Libraries'"]
  }).status();
  await Deno.run({ args: ["git", "clone", repo, dst] }).status();
  await Deno.run({ args: ["make", "-C", dst] }).status();
})();
