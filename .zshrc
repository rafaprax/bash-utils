# Path to your oh-my-zsh installation.
export ZSH=/Users/rafael/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(osx z)

# User configuration
# Disable tabs sharing history

unsetopt inc_append_history
unsetopt share_history

export ANTLR4="/usr/local/lib/antlr-4.3-complete.jar"
export ANT_OPTS="-Xms4096m -Xmx4096m"
export ANT_HOME=/Users/rafael/Workspace/tools/apache-ant-1.10.1
export CLASSPATH=".:/usr/local/lib/antlr-4.7.1-complete.jar:$CLASSPATH"
export EDITO="sublime -w"
export LIFERAY_DEPLOY_DIR=/Users/rafael/Liferay/bundles/liferay-portal
export GRADLE_COMMAND=gradlew
export GRADLE_HOME="/Users/rafael/Workspace/tools/gradle-3.3"
export GRADLE_OPTS="-Xms512m -Xmx2048m"
#export GRADLE_OPTS="-Xms512m -Xmx2048m -Drepository.url=http://192.168.109.41:8082/nexus/content/groups/public"
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_181.jdk/Contents/Home
export LFR_HOME=/Users/rafael/Workspace/sources/liferay-portal
export MAVEN_OPTS="-Xms6048m -Xmx6048m"
export MYSQL_HOME=/usr/local/mysql
export ORIGINAL_PATH=$PATH

export PATH=$ORIGINAL_PATH:$ANT_HOME/bin:$JAVA_HOME/bin:$LFR_HOME:$MYSQL_HOME/bin

#export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/rafael/Workspace/tools/apache-ant-1.9.4/bin:/Library/Java/JavaVirtualMachines/jdk1.7.0_75.jdk/Contents/Home/bin:/Users/rafael/Workspace/sources/liferay-portal:/usr/local/mysql/bin"

# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

PROMPT='${ret_status}%{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)$(hg_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'

#FUNCTIONS

function git_prompt_info() {
 ref=$(git symbolic-ref HEAD 2> /dev/null) || return 1
 echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$(git_prompt_ahead)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

createMySqlDB() {
	MYSQL=$(which mysql)
	MUSER="root"
	DBNAME=""
	DUMP_FILE=""
	
	#RESOLVE PARAMETERS

	if [ "$#" -eq 0 ]; then
		DBNAME="lportal"
	elif [ "$#" -eq 1 ] && [ ! -z "$1" ] && [ -f "$1" ]; then
		filename=$(basename "$1")
		DBNAME="${filename%.*}"
		DUMP_FILE=$1
	elif [ "$#" -eq 1 ] && [ ! -z "$1" ]; then
		DBNAME=$1
	elif [ "$#" -eq 2 ] && [ -f "$1" ]; then
		DBNAME=$2
		DUMP_FILE=$1
	elif [ "$#" -eq 2 ] && [ -f "$2" ]; then
		DBNAME=$1
		DUMP_FILE=$2
	fi
	
	if [ ! -z "$DBNAME" ]; then	
		#DROP DATABASE

		dropMySqlDB  $DBNAME

		#CREATE DATABASE

		$MYSQL -u $MUSER -e "CREATE SCHEMA \`$DBNAME\` DEFAULT CHARACTER SET utf8"

		echo "database $DBNAME was created successfully"
	fi

	if [ ! -z "$DUMP_FILE" ]; then
		#IMPORT FROM FILE
		$MYSQL -u $MUSER $DBNAME < $DUMP_FILE

		echo "'$PWD/$DUMP_FILE' was imported in $DBNAME database"
	fi
}

dropMySqlDB() {
	MYSQL=$(which mysql)
	MUSER="root"
	
	for DBNAME in "$@"
	do
	    $MYSQL -u $MUSER -e "drop database IF EXISTS \`$DBNAME\`"
	done
}

copyMySqlDB() {
	MYSQL=$(which mysql)
	MYSQLADMIN=$(which mysqladmin)
	MYSQLDUMP=$(which mysqldump)	

	createMySqlDB $2

	MYSQLDUMP -u root -v $1 | MYSQL -u root -D $2

	echo "'$2' was created based on $1 database"
}

fetchSubRepoPR() {
	git checkout master
	git pull upstream master
	git fetch upstream pull/$1/head:repo-pr-$1
	git checkout repo-pr-$1
	git rebase master
}

elasticQ() {
	curl -X GET 'http://localhost:9200/_search?pretty=true' -H 'content-type: application/json' -d $1
}

setce(){
	export LFR_HOME=/Users/rafael/Workspace/sources/liferay-portal
	export GRADLE_COMMAND=gradlew
	setcedeploy
	reloadPATH
}

setee(){
	export LFR_HOME=/Users/rafael/Workspace/sources/liferay-portal-ee
	export GRADLE_COMMAND=gradlew
	seteedeploy
	reloadPATH
}

setcedeploy(){
        export LIFERAY_DEPLOY_DIR=/Users/rafael/Liferay/bundles/liferay-portal
}

seteedeploy(){
	export LIFERAY_DEPLOY_DIR=/Users/rafael/Liferay/bundles-ee/7.0.x
}

setExternalGradle(){
	export GRADLE_COMMAND=gradle
	export PATH=$ORIGINAL_PATH:$ANT_HOME/bin:$JAVA_HOME/bin:$GRADLE_HOME/bin:$MYSQL_HOME/bin
}

reloadPATH() {
	export PATH=$ORIGINAL_PATH:$ANT_HOME/bin:$JAVA_HOME/bin:$LFR_HOME:$MYSQL_HOME/bin
}

java-7() {
	export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_75.jdk/Contents/Home

	reloadPATH
}

java-8() {
	export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_101.jdk/Contents/Home

	reloadPATH
}

pag() {
	ps aux | grep $1 
}

gw() {
	$GRADLE_COMMAND $1 $2 $3 $4 $5 $6 $7 $8
}

gcd() {
	gw -Dbuild.exclude.dirs="dynamic-data-mapping-test,dynamic-data-mapping-test-util,dynamic-data-lists-test"  clean deploy
}

aa() {
	cd $LFR_HOME
	ant all
}

wip() {
	git add .
	git commit -m "WIP"
}

# ALIAS

alias antlr4='java -Xmx500M -cp "/usr/local/lib/antlr-4.7.1-complete.jar:$CLASSPATH" org.antlr.v4.Tool'
alias grun='java org.antlr.v4.gui.TestRig'
alias gfs="gw formatSource"

alias clCEenv="cdce; createMySqlDB; gcfdx; ant all; cd modules; gw eclipse; cd -"
alias clEEenv="cdee; createMySqlDB lportal-ee; gcfdx; ant all; cd modules; gw eclipse; cd -"

alias gcfdx="git clean -dfx -e build.rafael.properties -e app.server.rafael.properties -e portal-ext.properties -e release.rafael.properties -e portal-test-ext.properties -e .project -e .classpath"

alias cllc="rm -rf /Users/rafael/.m2/repository/com/liferay; rm -rf /Users/rafael/.liferay"

alias bce="cd /Users/rafael/Liferay/bundles/"
alias bee="cd /Users/rafael/Liferay/bundles-ee/"

alias cdce="cd ~/Workspace/sources/liferay-portal; setce"
alias cdee="cd ~/Workspace/sources/liferay-portal-ee; setee"

alias s-pr="fetchSubRepoPR"

alias tomcat="sh /Users/rafael/Liferay/bundles/liferay-portal/tomcat-9.0.10/bin/catalina.sh run"
alias tomcat-ee="sh /Users/rafael/Liferay/bundles-ee/7.1.x/tomcat-9.0.10/bin/catalina.sh run"
