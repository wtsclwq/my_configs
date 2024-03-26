# 环境变量
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN

# #### Zsh配置 #### #

# 设置历史记录文件和大小
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# 自动建议和语法高亮显示插件的配置
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10"
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

# 设置Zinit的安装目录
export ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

# 如果Zinit未安装，则自动安装Zinit
if [[ ! -f $ZINIT_HOME/zinit.zsh ]]; then
    print -P "%F{33}Zinit未安装，正在自动安装...%f"
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# 加载Zinit
source $ZINIT_HOME/zinit.zsh

# 使用Zinit加载Starship主题
zinit light starship/starship

# Starship配置文件路径
export STARSHIP_CONFIG=~/.config/starship.toml

# Zinit插件
# 异步加载，不影响shell启动速度
zinit ice wait"0" lucid
zinit load zsh-users/zsh-autosuggestions
zinit load zsh-users/zsh-syntax-highlighting

# Oh My Zsh插件
zinit snippet OMZ::plugins/common-aliases
zinit snippet OMZ::plugins/git
zinit snippet OMZ::plugins/z

# 设置别名以提高工作效率
alias ll='ls -lah'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Starship提示符初始化
eval "$(starship init zsh)"

