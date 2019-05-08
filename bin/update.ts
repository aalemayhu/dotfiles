#!/usr/bin/env deno run --allow-read
import { isDebian, isFedora } from "./distro.ts";

(async () => {
  let fedora = await isFedora();
  if (fedora) {
    const commands = ["update", "upgrade", "autoremove"];
    for (const cmd of commands) {
      await Deno.run({ args: ["dnf", "-y", cmd] }).status();
    }
    await Deno.run({ args: ["dnf", "-y", "clean", "packages"] }).status();
    Deno.exit(0);
  }

  let debian = await isDebian();
  if (debian) {
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