# Roadmap

> Last updated: 2026-08-30. 中文版计划请参考下方说明。

## Short term

- Migration helper for installs made before 1.1 (no state record): a `--adopt` mode that registers existing `.zshrc`/`.oh-my-zsh` into the state store instead of requiring manual cleanup.
- Extend shellcheck coverage to the full script in CI, not only distro detection paths.

## Mid term

- More mirrors: validate Aliyun/Tencent/USTC paths for the Oh My Zsh installer itself, reducing reliance on the Gitee copy.
- Optional non-interactive mode for cloud-init/user-data usage (`--yes` with explicit component list).

## Long term / ideas

- Optional extra components (starship, fzf, zsh-autosuggestions) behind explicit flags, keeping the default install minimal.

---

## 中文说明（计划摘要）

- 短期：为 1.1 之前安装的环境提供 `--adopt` 迁移登记；CI 全量 shellcheck。
- 中期：镜像源优化，减少对 Gitee 备用安装器的依赖；提供面向 cloud-init 的非交互模式。
- 长期：可选组件（starship、fzf、zsh 插件），默认保持最小安装。
