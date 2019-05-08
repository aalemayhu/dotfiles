#!/usr/bin/env deno run --allow-read
import { isDebian, isFedora } from "./distro.ts";

(async () => {
  if (isDebian()) {
    await Deno.run({ args: ["sudo", "apt-get", "update"] }).status();
    await Deno.run({ args: ["sudo", "apt-get", "upgrade", "-y"] }).status();
    await Deno.run({ args: ["sudo", "apt-get", "upgrade", "-y"] }).status();
    await Deno.run({ args: ["sudo", "apt-get", "autoclean"] }).status();
    await Deno.run({ args: ["sudo", "apt-get", "autoremove"] }).status();
    Deno.exit(0);
  } else if (isFedora()) {
    const commands = ["update", "upgrade", "autoremove"];
    for (const cmd of commands) {
      await Deno.run({ args: ["dnf", "-y", cmd] }).status();
    }
    await Deno.run({ args: ["dnf", "-y", "clean", "packages"] }).status();
    Deno.exit(0);
  }
  console.error("fatal: unsupported system");
  Deno.exit(1);
})();
