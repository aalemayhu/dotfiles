#!/usr/bin/env deno run --allow-read --allow-write
import { existsSync } from "https://deno.land/std/fs/mod.ts";

import { isDebian, isFedora } from "./distro.ts";

(async function() {
  const repo = "https://github.com/scanf/dotfiles/";
  const dst = "/tmp/dotfiles";

  if (existsSync(dst)) {
    await Deno.run({ args: ["git", "-C", dst, "pull", "origin"] }).status();
  } else {
    await Deno.run({ args: ["git", "clone", repo, dst] }).status();
  }

  if (isDebian()) {
    await Deno.run({
      args: [
        "sudo",
        "apt-get",
        "install",
        "-y",
        "git",
        "ruby",
        "make",
        "locales"
      ]
    }).status();
  } else if (isFedora()) {
    await Deno.run({
      args: ["sudo", "dnf", "install", "-y", "git", "ruby", "make"]
    }).status();
    await Deno.run({
      args: ["sudo", "dnf", "'C Development Tools and Libraries'"]
    }).status();
  } else {
    console.log("sorry unsupported system");
    Deno.exit(1);
  }

  await Deno.run({ args: ["make", "-C", dst] }).status();
})();
