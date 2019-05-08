#!/usr/bin/env deno run --allow-read --allow-write

import { existsSync } from "https://deno.land/std/fs/mod.ts";

(async function() {
  const home = Deno.env().HOME;
  let dirname = import.meta.url
    .substring(0, import.meta.url.lastIndexOf("/"))
    .replace("file:/", "");
  await Deno.run({ args: ["ruby", `${dirname}/install_packages.rb`] }).status();
  await Deno.run({
    args: ["ruby", `${dirname}/create_directories.rb`]
  }).status();
  await Deno.run({ args: ["ruby", `${dirname}/clone_or_update.rb`] }).status();
  await Deno.run({ args: ["ruby", `${dirname}/copy_files.rb`] }).status();

  const vimrc = `${home}/.vimrc`;
  if (!existsSync(vimrc)) {
    await Deno.symlink(`${home}/.vim/.vimrc`, vimrc);
  }

  await Deno.run({ args: ["vim", "+PluginInstall", "+qa!"] }).status();
  await Deno.run({
    args: ["ssh-keygen", "-t", "ed25519", "-C", "a@alemayhu.com"]
  }).status();
})();
