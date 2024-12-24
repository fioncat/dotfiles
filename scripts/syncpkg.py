#!/usr/bin/env python3

import subprocess
import json
import platform
import os
import sys


def run_command(cmd, capture_output=False):
    try:
        if capture_output:
            output = subprocess.check_output(["bash", "-c", cmd],
                                             stderr=subprocess.STDOUT,
                                             universal_newlines=True)
            return {line for line in output.splitlines() if line.strip()}
        else:
            subprocess.check_call(["bash", "-c", cmd])
    except subprocess.CalledProcessError as e:
        print(f"Command failed with exit code {e.returncode}")
        print(e.output)
        sys.exit(1)


def load_config():
    system = platform.system().lower()
    home = os.path.expanduser("~")

    if system == "linux":
        # Check if it's Arch Linux by checking /etc/os-release
        try:
            with open("/etc/os-release") as f:
                if "arch" in f.read().lower():
                    json_path = os.path.join(
                        home, "dotfiles/packages/archlinux.json")
                else:
                    print("Error: Only Arch Linux is supported on Linux")
                    sys.exit(1)
        except FileNotFoundError:
            print("Error: Could not determine Linux distribution")
            sys.exit(1)
    elif system == "darwin":
        json_path = os.path.join(home, "dotfiles/packages/macos.json")
    else:
        print(f"Error: Unsupported system: {system}")
        sys.exit(1)

    try:
        with open(json_path) as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"Error: Package list not found at {json_path}")
        sys.exit(1)
    except json.JSONDecodeError:
        print(f"Error: Invalid JSON file at {json_path}")
        sys.exit(1)


def get_installed_packages(config):
    packages = set()
    for cmd in config["list"]:
        cmd_packages = run_command(cmd, capture_output=True)
        if cmd_packages is None:
            continue
        packages.update(cmd_packages)
    return packages


if __name__ == "__main__":
    config = load_config()

    if "list" not in config:
        print("Error: list is missing or empty in config")
        sys.exit(1)
    if "install" not in config:
        print("Error: install is missing in config")
        sys.exit(1)
    if "packages" not in config:
        print("Error: packages is missing in config")
        sys.exit(1)

    install_cmds = config["install"]
    print("Searching for installed packages...")
    pkgs = get_installed_packages(config)
    expect_pkgs = set(config["packages"])
    uninstalled = {}
    for expect_pkg in expect_pkgs:
        pkg_type = ""
        pkg_name = expect_pkg
        if ":" in expect_pkg:
            pkg_type, pkg_name = expect_pkg.split(":", 1)
        if pkg_type == "":
            pkg_type = "default"
        if pkg_name in pkgs:
            continue

        if pkg_type not in install_cmds:
            print(
                f"Error: No install command found for package type {pkg_type}")
            sys.exit(1)

        if pkg_type not in uninstalled:
            uninstalled[pkg_type] = [pkg_name]
            continue

        uninstalled[pkg_type].append(pkg_name)

    if not uninstalled:
        print("All packages are already installed")
        sys.exit(0)

    for cmd_name, pkgs in uninstalled.items():
        print(f"Installing {', '.join(pkgs)}...")
        cmd = install_cmds[cmd_name]
        cmd = cmd.replace("%pkg", " ".join(pkgs))
        run_command(cmd)

    print("All packages installed successfully")
