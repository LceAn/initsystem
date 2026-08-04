# initsystem

面向常见 Linux 发行版的初始化脚本，用于安装 Zsh、Oh My Zsh 和一组常用插件。

[English](README.md)

## 支持范围

脚本自动检测 `apt`、`dnf`、`yum`、`pacman`、`zypper` 或 `apk`。运行环境需要 root 权限或可用的 `sudo`，并能通过 HTTPS 访问 GitHub 或 Gitee 回退源。

## 使用

高权限脚本执行前应先阅读源码。

```bash
git clone https://github.com/LceAn/initsystem.git
cd initsystem
chmod +x init_system.sh
./init_system.sh help
./init_system.sh install
```

使用 `--manual` 手动选择镜像。阿里云、腾讯云和中科大选项不托管 Oh My Zsh 安装器，因此该部分仍使用 Gitee 回退地址。

## 安全卸载边界

1.1 版本会在 `${XDG_STATE_HOME:-$HOME/.local/state}/initsystem` 记录由脚本管理的内容：

- 安装前已有 `.zshrc` 时先备份。
- 原本没有 `.zshrc` 时记录为脚本创建。
- 只有存在本版本安装记录时才删除 `.oh-my-zsh`。
- 没有状态记录时保留现有 `.oh-my-zsh` 和 `.zshrc`。

```bash
./init_system.sh uninstall
```

旧版本安装没有状态记录，需要人工清理。这个限制用于避免误删用户原有配置。

## 安全行为

- Oh My Zsh 安装器先通过 TLS 1.2+ 下载到临时文件，再以 `RUNZSH=no`、`CHSH=no`、`KEEP_ZSHRC=yes` 执行。
- 脚本不会自动修改登录 Shell。
- 日志写入 `log/`，并由 Git 忽略。
- 软件包安装和远程脚本仍会运行高权限或第三方代码，执行前必须复核来源和变更。

## 验证

```bash
bash -n init_system.sh tests/test_uninstall.sh
shellcheck init_system.sh tests/test_uninstall.sh
bash tests/test_uninstall.sh
```

自动测试使用临时 HOME，验证受管配置可恢复、无记录配置不会被删除。

## 许可证

[MIT](LICENSE)

<!-- repo-readme-standard:v1 -->
## 仓库维护信息

- 项目类型：高权限 Linux 初始化脚本
- 当前状态：维护中
- 可见性：public
- 维护节奏：每月检查安装源、包管理器和卸载边界
- 相关仓库：未发现功能相同、可直接合并的仓库
- 维护边界：归档、删除、历史重写或强制推送需单独确认
