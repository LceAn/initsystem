# initsystem

Linux initialization script for installing Zsh, Oh My Zsh, and a small set of plugins across common package managers.

[中文说明](README_CN.md)

## Supported systems

The script detects `apt`, `dnf`, `yum`, `pacman`, `zypper`, or `apk`. It requires either root or a working `sudo` command and an HTTPS connection to GitHub or the configured Gitee fallback.

## Usage

Review the script before running commands with elevated privileges.

```bash
git clone https://github.com/LceAn/initsystem.git
cd initsystem
chmod +x init_system.sh
./init_system.sh help
./init_system.sh install
```

Use `--manual` to choose a mirror interactively. The Aliyun, Tencent, and USTC choices still use the Gitee copy of the Oh My Zsh installer because those mirrors do not host that installer.

## Safe uninstall boundary

Version 1.1 records files it manages under `${XDG_STATE_HOME:-$HOME/.local/state}/initsystem`:

- Existing `.zshrc` is backed up before installation.
- A newly created `.zshrc` is marked as script-created.
- `.oh-my-zsh` is deleted only when this version recorded its installation.
- Without a state record, uninstall preserves existing `.oh-my-zsh` and `.zshrc`.

```bash
./init_system.sh uninstall
```

Installations made by older versions have no state record and therefore require manual cleanup. This conservative behavior avoids deleting unrelated user configuration.

## Security behavior

- The Oh My Zsh installer is downloaded to a temporary file over HTTPS with TLS 1.2+, then executed with `RUNZSH=no`, `CHSH=no`, and `KEEP_ZSHRC=yes`.
- The script does not automatically change the login shell.
- Logs are written under `log/` and ignored by Git.
- Package installation and remote scripts still execute privileged or third-party code; review URLs and changes before use.

## Validation

```bash
bash -n init_system.sh tests/test_uninstall.sh
shellcheck init_system.sh tests/test_uninstall.sh
bash tests/test_uninstall.sh
```

The automated test uses a temporary home directory and verifies both managed restoration and preservation of unmanaged files.

## License

[MIT](LICENSE)

<!-- repo-readme-standard:v1 -->
## Repository maintenance

- Type: privileged Linux setup script
- Status: maintained
- Visibility: public
- Cadence: review installers, package managers, and uninstall boundaries monthly
- Related repositories: no directly mergeable duplicate found
- Boundary: archive, deletion, history rewrite, or force-push requires separate approval
