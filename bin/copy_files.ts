#!/usr/bin/env deno run --allow-read --allow-write --allow-env

import { isDarwin } from "./distro.ts";

export async function copyFiles() {
  const home = Deno.dir("home");
  let dirname = import.meta.url
    .substring(0, import.meta.url.lastIndexOf("/"))
    .replace("file:/", "");
  const configDir = `${dirname}/..`;

  // Shell
  Deno.copyFileSync(`${configDir}/shell/aliases`, `${home}/.shell/.aliases`);
  Deno.copyFileSync(`${configDir}/shell/bashrc`, `${home}/.bashrc`);
  Deno.copyFileSync(`${configDir}/shell/env`, `${home}/.shell/.env`);
  Deno.copyFileSync(`${configDir}/shell/funcs`, `${home}/.shell/.funcs`);
  Deno.copyFileSync(`${configDir}/shell/tmux.conf`, `${home}/.tmux.conf`);
  Deno.copyFileSync(`${configDir}/shell/zshrc`, `${home}/.zshrc`);

  const darwin = await isDarwin();
  if (darwin) {
    Deno.copyFileSync(
      `${configDir}/term/bash_profile`,
      `${home}/.bash_profile`
    );
  }

  // Misc
  Deno.copyFileSync(`${configDir}/gnupg/gpg.conf`, `${home}/.gnupg/gpg.conf`);
  Deno.copyFileSync(`${configDir}/ssh/config`, `${home}/.ssh/config`);
  Deno.chmodSync(`${home}/.ssh/config`, 0o600);

  // Git
  Deno.copyFileSync(
    `${configDir}/git/git-completion.bash`,
    `${home}/.git-completion.bash`
  );
  Deno.copyFileSync(`${configDir}/git/gitconfig`, `${home}/.gitconfig`);
}

if (import.meta.main) {
  copyFiles();
}
