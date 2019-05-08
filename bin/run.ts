#!/usr/bin/env deno run --allow-read --allow-write

(async function() {
  const home = Deno.env().HOME;
  let dirname = import.meta.url
    .substring(0, import.meta.url.lastIndexOf("/"))
    .replace("file:/", "");
  await Deno.run({ args: ["ruby", `${dirname}/install_packages.rb`] }).status();
  await Deno.run({
    args: ["ruby", `${dirname}/create_directories.rb`]
  }).status();
  await Deno.run({ args: ["ruby", `${dirname}/create_or_update.rb`] }).status();
  await Deno.run({ args: ["ruby", `${dirname}/copy_files.rb`] }).status();

  await Deno.symlink(`${home}/.vim/.vimrc`, `${home}/.vimrc`);

  await Deno.run({ args: ["vim", "+PluginInstall", "+qa!"] }).status();
  await Deno.run({
    args: ["ssh-keygen", "-t", "ed25519", "C", "a@alemayhu.com"]
  }).status();
})();
