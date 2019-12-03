#!/usr/bin/env deno run --allow-read --allow-write
import { existsSync } from "https://deno.land/std/fs/mod.ts";

class Repository {
  local: string;
  remote: string;
  constructor(local: string, remote: string) {
    this.local = local;
    this.remote = remote;
  }
}

async function cloneOrUpdate(mappings) {
  const jobs = [];
  for (const repo of mappings) {
    const foundRepo = existsSync(repo.local);
    if (!foundRepo) {
      jobs.push(
        Deno.run({
          args: [
            "git",
            "clone",
            repo.remote,
            repo.local,
            "--recurse-submodules"
          ]
        })
      );
    } else if (!existsSync(`${repo.local}/.git`)) {
      console.log(
        "error",
        `directory exists at ${repo.local} but is not a git directory`
      );
    } else {
      jobs.push(
        Deno.run({
          args: ["git", "-C", repo.local, "pull", "--recurse-submodules"]
        })
      );
    }
  }
  // Wait for all the jobs to finish
  for (const job of jobs) {
    await job.status();
  }
}

export async function syncRepositories() {
  const home = Deno.env().HOME;
  const src = `${home}/src/github.com`;

  const mappings = [
    new Repository(
      `${src}/VundleVim/Vundle.vim`,
      "https://github.com/VundleVim/Vundle.vim.git"
    ),
    new Repository(
      `${src}/scanf/dotfiles`,
      "https://github.com/scanf/dotfiles"
    ),
    new Repository(`${src}/scanf/xcd.rb`, "https://github.com/scanf/xcd.rb"),
    new Repository(`${home}/.vim`, "https://github.com/scanf/.vim"),
    new Repository(
      `${src}/ggreer/the_silver_searcher`,
      "https://github.com/ggreer/the_silver_searcher"
    ),
    new Repository(
      `${home}/.mutt`,
      "https://github.com/scanf/.mutt"
    ),
    new Repository(
      `${home}/.oh-my-zsh/custom/plugins/zsh-nvm`,
      "https://github.com/lukechilds/zsh-nvm"
    ),
    new Repository(
      `${home}/.oh-my-zsh/custom/themes/spaceship-prompt`,
      "https://github.com/denysdovhan/spaceship-prompt.git",
    ),
    new Repository(
      `${home}/.oh-my-zsh/custom/plugins/yarn-completion`,
      "https://github.com/buonomo/yarn-completion"
    ),
    new Repository(
      `${src}/golang/go`,
      "https://github.com/golang/go"
    )
  ];

  await cloneOrUpdate(mappings);
}

if (import.meta.main) {
  syncRepositories();
}
