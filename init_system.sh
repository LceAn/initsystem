#!/usr/bin/env bash

# 定义资源
OH_MY_ZSH_INSTALL_SCRIPT=(
  "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
  "https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh"
)

Zsh_plugins=("zsh-users/zsh-autosuggestions" "zsh-users/zsh-completions" "zsh-users/zsh-syntax-highlighting" "zsh-users/zsh-history-substring-search" "MichaelAquilina/zsh-you-should-use")
log_file="./log/init_system_log_$(date +"%Y%m%d_%H%M%S").log"

# 创建日志文件
mkdir -p ./log
exec > >(tee -a "$log_file") 2>&1

# 定义颜色
yellow=$(tput setaf 3)
white=$(tput setaf 7)
green=$(tput setaf 2)
blue=$(tput setaf 4)
red=$(tput setaf 1)
end=$(tput sgr0)
version='v0.0.2'

# 初始化信息输出
start(){
  echo "${yellow}"
  echo " _       _ _                   _                 "
  echo "(_)_ __ (_) |_   ___ _   _ ___| |_ ___ _ __ ___  "
  echo "| | '_ \| | __| / __| | | / __| __/ _ \ '_ \` _ \ ${white}{${red}$version #dev${white}}"
  echo "| | | | | | |_  \__ \ |_| \__ \ ||  __/ | | | | |${blue}"
  echo "|_|_| |_|_|\__|_|___/\__, |___/\__\___|_| |_| |_|${white}内部版本，请勿泄露"
  echo "                     |___/                      "
  echo "${red}initSystem 正在开发中，请每次使用前更新!${end}"
}

showSystemInfo() {
  echo "${yellow}当前用户：$(whoami)${end}"
  echo "${yellow}当前时区时间：$(date)${end}"

  # 尝试从 /etc/os-release 获取系统版本信息
  if [ -f "/etc/os-release" ]; then
    echo "${yellow}系统版本信息：$(grep PRETTY_NAME /etc/os-release | cut -d\" -f2)${end}"
  else
    echo "${red}无法获取系统版本信息。${end}"
  fi
}

# 使用 GitHub 的一个轻量级资源来测试连接是否可以访问国际网络
checkNetwork() {
  if curl -Is https://github.com/robots.txt | head -n 1 | grep -q 200; then
    echo "当前机器属于境外服务器，已使用 GitHub。"
    OH_MY_ZSH_INSTALL="${OH_MY_ZSH_INSTALL_SCRIPT[0]}"
  else
    echo "当前机器属于国内服务器，已切换 Gitee 源。"
    OH_MY_ZSH_INSTALL="${OH_MY_ZSH_INSTALL_SCRIPT[1]}"
  fi
}

#根据系统版本选择不同的包管理器
installPackage() {
  local package_name=$1
  if command -v apt &> /dev/null; then
    sudo apt update && sudo apt install -y "$package_name"
  elif command -v yum &> /dev/null; then
    sudo yum install -y "$package_name"
  elif command -v dnf &> /dev/null; then
    sudo dnf install -y "$package_name"
  else
    echo "${red}不支持的包管理器。无法安装：${package_name}${end}"
  fi
}

# 更新并安装必要的实用程序
update(){
  echo "${blue}检查并安装必要的工具：sudo, curl, wget, git...${end}"
  for util in sudo curl wget git; do
    if ! command -v $util &> /dev/null; then
      echo "${yellow}正在安装：${util}...${end}"
      installPackage $util
    else
      echo "${green}${util} 已经安装。${end}"
    fi
  done
}

# 检测并跳过已安装的 Oh My Zsh
Oh_my_zsh_install(){
  if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "${green}Oh My Zsh 已安装，跳过安装步骤。${end}"
  else
    echo "${blue}正在安装 Oh My Zsh...${end}"
    # 确保使用正确的变量名称
    curl -fsSL "$OH_MY_ZSH_INSTALL" | sudo -u "${SUDO_USER:-$USER}" bash > /dev/null
    echo "${green}Oh My Zsh 安装完成。${end}"
  fi
}

 # 检查 Oh My Zsh 是否已安装，以及当前 shell 是否为 zsh
SetupZsh() {

  if [ "$omz_dir_exists" = 1 ] || grep -q "${SUDO_USER:-$USER}.*zsh$" /etc/passwd; then
    echo "Oh My Zsh 已安装，或默认 shell 已经是 zsh。"
    return
  fi
  
  echo "您希望将默认 shell 更改为 zsh 吗？[Y/n]"
  read -r opt
  case $opt in
    [Yy]|"")
      if zsh=$(command -v zsh); then
        echo "更改默认登录 shell 为 $zsh..."
        if sudo -k chsh -s "$zsh" "${SUDO_USER:-$USER}"; then
          echo "成功更改登录 shell 到 $zsh。请退出并重新登录或使用 'exec zsh' 来立即切换到 zsh。"
        else
          echo "更改默认 shell 失败。您可能需要手动更改。"
        fi
      else
        echo "找不到 zsh 可执行文件。"
        exit 1
      fi
      ;;
    [Nn])
      echo "修改默认 shell 被跳过。"
      ;;
    *)
      echo "无效选择。修改默认 shell 被跳过。"
      ;;
  esac
}


# 定义并安装 Zsh 插件
Zsh_Plugins() {
  installed_plugins=0
  zsh_dir=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/
  for plugin in "${Zsh_plugins[@]}"; do
    plugin_dir="$zsh_dir$(basename ${plugin})"
    if [ ! -d "$plugin_dir" ]; then
      sudo git clone --progress --depth=1 "https://github.com/${plugin}.git" "$plugin_dir"
      echo "${blue}已安装${plugin_dir}插件.${end}"
      ((installed_plugins++))
    else
      echo "${yellow}插件 $(basename ${plugin}) 已存在，跳过。${end}"
    fi
  done
  echo "${green}ZSH插件安装完成。已安装插件总数：${installed_plugins}。${end}"
}

# 修改 .zshrc 文件
ModifyZshRC() {
  if [ -f ~/.zshrc ]; then
    if ! grep -qi "Custom lines start" ~/.zshrc; then
      sed -i '/^plugins=/c\plugins=(git z sudo tmux screen zsh-autosuggestions you-should-use zsh-completions zsh-history-substring-search zsh-syntax-highlighting)' ~/.zshrc
    fi
  fi
}

# 主函数
main() {
# 检查是否以 root 权限运行
if [ "$EUID" -ne 0 ]; then
  echo "检测到非 root 权限运行，尝试以 sudo 权限重新运行脚本。"
  exec sudo bash "$0" "$@"
  exit $?
fi

  start
  echo "<<<<<<<<<<<检测系统信息中>>>>>>>>>>"
  sleep 1
  showSystemInfo
  echo "<<<<<<<<<<<检测网络环境中>>>>>>>>>>"
  sleep 1
  checkNetwork
  echo "<<<<<<<<<<<检测必备软件中>>>>>>>>>>"
  sleep 1
  update
  echo "<<<<<<<<<<<尝试安装ZSH中>>>>>>>>>>"
  sleep 1
  Oh_my_zsh_install
  SetupZsh
  echo "<<<<<<<<<<<安装ZSH插件中>>>>>>>>>>"
  sleep 1
  Zsh_Plugins
  echo "<<<<<<<<<<<刷新ZSH配置中>>>>>>>>>>"
  sleep 1
  ModifyZshRC
  echo "<<<<<<<<<<<脚本运行完成！>>>>>>>>>>"
}

main
