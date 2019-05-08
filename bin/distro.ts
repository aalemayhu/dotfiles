import { exists } from "https://deno.land/std/fs/mod.ts";

export async function isFedora() {
  return exists("/usr/bin/dnf");
}

export async function isDebian() {
  return exists("/usr/bin/apt-get");
}
