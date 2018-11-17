#overrides the PROMPT enviroment variable
PROMPT='${ret_status}%{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)$(hg_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'

#overrides the zsh git_prompt_info function

git_prompt_info() {
 ref=$(git symbolic-ref HEAD 2> /dev/null) || return 1
 echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$(git_prompt_ahead)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

#fetch a pr
g.pr() {
	git checkout master
	git pull --rebase upstream master
	git fetch upstream pull/$1/head:repo-pr-$1
	git checkout pr-$1
	git rebase master
}

#scommit working in progress
g.wip() {
	git add .
	git commit -m "WIP"
}
