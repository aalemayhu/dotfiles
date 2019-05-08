import { existsSync } from "https://deno.land/std/fs/mod.ts";

export function isFedora() {
  return existsSync("/usr/bin/dnf");
}

export function isDebian() {
  return existsSync("/usr/bin/apt-get");
}
