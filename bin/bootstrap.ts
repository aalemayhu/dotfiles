#!/usr/bin/env deno run --allow-read --allow-write
import { existsSync } from "https://deno.land/std/fs/mod.ts";

import { isDebian, isFedora } from "./distro.ts";

(async function () {
  const repo = "https://github.com/scanf/dotfiles/";
  const home = Deno.env.get("HOME");
  const dst = `${home}/src/github.com/scanf`;

  if (existsSync(dst)) {
    await Deno.run({ cmd: ["git", "-C", dst, "pull", "origin"] }).status();
  } else {
    await Deno.run({ cmd: ["git", "clone", repo, dst] }).status();
  }

  if (isDebian()) {
    await Deno.run({
      cmd: [
        "sudo",
        "apt-get",
        "install",
        "-y",
        "git",
        "ruby",
        "make",
        "locales",
      ],
    }).status();
  } else if (isFedora()) {
    await Deno.run({
      cmd: ["sudo", "dnf", "install", "-y", "git", "ruby", "make"],
    }).status();
    await Deno.run({
      cmd: ["sudo", "dnf", "'C Development Tools and Libraries'"],
    }).status();
  } else {
    console.log("sorry unsupported system");
    Deno.exit(1);
  }

  await Deno.run({ cmd: ["make", "-C", dst] }).status();
})();
