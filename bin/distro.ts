import { existsSync } from "https://deno.land/std/fs/mod.ts";

export function isFedora() {
  return existsSync("/usr/bin/dnf");
}

export function isDebian() {
  return existsSync("/usr/bin/apt-get");
}

export async function isDarwin() {
  const uname = await Deno.run({ cmd: ["uname"], stdout: "piped" });
  const decoder = new TextDecoder();
  const stdout = decoder.decode(await Deno.readAll(Deno.stdout));
  await uname.status();
  return stdout.trim().includes("Darwin");
}
