#!/usr/bin/env deno run --allow-read --allow-write --allow-env --allow-net
import { existsSync, readFileStrSync } from "https://deno.land/std/fs/mod.ts";
import { isDarwin, isDebian, isFedora } from "./distro.ts";

export async function installPackages() {
  const sudoPath = "/usr/bin/sudo";

  if (!existsSync(sudoPath)) {
    console.log(`error expected ${sudoPath} to exist. unsupported system`);
    Deno.exit(1);
  }

  let dirname = import.meta.url
    .substring(0, import.meta.url.lastIndexOf("/"))
    .replace("file:/", "");
  const configDir = `${dirname}/..`;

  const darwin = await isDarwin();
  if (darwin) {
    const packagesFile = readFileStrSync(`${configDir}/packages/macOS`);
    const packages = packagesFile.split("\n").join(" ");
    await Deno.run({ args: ["brew", "install"].concat(packages) }).status();
  } else if (isDebian()) {
    const pm = isDebian() ? "apt-get" : "dnf";
    await Deno.run({ args: ["sudo", pm, "update", "-y"] }).status();

    const packagesFilePath = isDebian() ? "packages/Debian" : "packages/Fedora";
    const packages = readFileStrSync(`${configDir}/${packagesFilePath}`)
      .split("\n")
      .join(" ");

    await Deno.run({
      args: ["sudo", pm, "install", "-y"].concat(packages)
    }).status();
    await Deno.run({ args: ["sudo", pm, "autoremove"] }).status();
    await Deno.run({ args: ["sudo", pm, "autoclean"] }).status();

    await Deno.run({ args: ["sudo", "locale-gen", '"en_US.UTF-8"'] }).status();
  }
}

if (import.meta.main) {
  (async () => {
    await installPackages();
  })();
}