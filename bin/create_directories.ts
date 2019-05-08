#!/usr/bin/env deno run --allow-read --allow-write --allow-env

import {
  ensureDirSync,
  readFileStrSync
} from "https://deno.land/std/fs/mod.ts";

export function createDirectories(prefix: string, listFile: string) {
  const directoriesFile = readFileStrSync(listFile);
  const files = directoriesFile.split("\n").map(x => `${prefix}/${x}`);
  for (const f of files) {
    console.log(`ensuring ${f} exists`);
    ensureDirSync(f);
  }
}

if (import.meta.main) {
  createDirectories(
    `${Deno.env().HOME}/src/github.com/scanf`,
    "./DirectoriesList"
  );
}
