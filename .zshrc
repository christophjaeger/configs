setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_no_store
setopt hist_reduce_blanks
setopt share_history

HISTFILE=${HOME}/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

alias configs="git --git-dir=${HOME}/.configs.git --work-tree=${HOME}"

for cmd in br ci co cp st; do
	alias g${cmd}="git ${cmd}"
done

autoload -U compinit && compinit
# context: ":completion:function:completer:command:argument:tag"
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''
