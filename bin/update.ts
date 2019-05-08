#!/usr/bin/env deno run --allow-read
import { exists } from "https://deno.land/std/fs/mod.ts";

(async () => {
  const isFedora = await exists("/etc/fedora-release");
  if (isFedora) {
    const commands = ["update", "upgrade", "autoremove"];
    for (const cmd of commands) {
      await Deno.run({ args: ["dnf", "-y", cmd] }).status();
    }
    await Deno.run({ args: ["dnf", "-y", "clean", "packages"] }).status();
    Deno.exit(0);
  }

  const isDebian = await exists("/etc/debian-release");
  let hasAptGet = isDebian;

  if (!isDebian) {
    try {
      await Deno.run({ args: ["sudo", "apt-get", "--version", ">", "/dev/null"] }).status();
      hasAptGet = true;
    } catch (error) {}
  }

  if (isDebian || hasAptGet) {
    await Deno.run({ args: ["sudo", "apt-get", "update"] }).status();
    await Deno.run({ args: ["sudo", "apt-get", "upgrade", "-y"] }).status();
    await Deno.run({ args: ["sudo", "apt-get", "upgrade", "-y"] }).status();
    await Deno.run({ args: ["sudo", "apt-get", "autoclean"] }).status();
    await Deno.run({ args: ["sudo", "apt-get", "autoremove"] }).status();
    Deno.exit(0);
  }

  console.error("fatal: unsupported system");
  Deno.exit(1);
})()