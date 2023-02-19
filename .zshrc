# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/rafaelpraxedes/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git gh z zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

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

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#EXPORTS

export ANT_OPTS="-Xms4g -Xmx4g"
export BLADE_HOME=/Users/rafaelpraxedes/Library/PackageManager/bin
export EDITOR="sublime -w"
export LFR_HOME=/Users/rafaelpraxedes/Workspace/sources/liferay-portal
export LFR_DEPLOY_HOME=/Users/rafaelpraxedes/Workspace/bundles/ce
export GRADLE_OPTS="-Xms6g -Xmx6g -Dorg.gradle.daemon=false"
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_333.jdk/Contents/Home
export MAVEN_OPTS="-Xms4g -Xmx4g"
export MYSQL_HOME=/usr/local/opt/mysql@5.7
export ORIGINAL_PATH=$PATH


export PATH=$ORIGINAL_PATH:$ANT_HOME/bin:$BLADE_HOME:$JAVA_HOME/bin:$LFR_HOME:$MYSQL_HOME/bin:/Users/rafaelpraxedes/Downloads

#FUNCTIONS

ij() {
  /Users/rafaelpraxedes/Workspace/sources/liferay-intellij/intellij "$@"
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

    echo "database $DBNAME has been created successfully"
  fi

  if [ ! -z "$DUMP_FILE" ]; then
    #IMPORT FROM FILE
    $MYSQL -u $MUSER $DBNAME < $DUMP_FILE

    echo "'$PWD/$DUMP_FILE' has been imported in $DBNAME database"
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

  echo "'$2' has been created based on $1 database"
}

dumpMySqlDB() {
  MYSQLDUMP=$(which mysqldump)  

  MYSQLDUMP -u root -v $1 > $2

  echo "'$2' has been created based on $1 database"
}

fetchSubRepoPR() {
  git checkout master
  git pull upstream master
  git fetch upstream pull/$1/head:repo-pr-$1
  git checkout repo-pr-$1
  git rebase master
}

gfb() {
  git fetch git@github.com:$1/liferay-portal.git $2:$2
}

setce(){
  export LFR_HOME=/Users/rafaelpraxedes/Workspace/sources/liferay-portal
  export LFR_DEPLOY_HOME=/Users/rafaelpraxedes/Workspace/bundles/ce

  reloadPATH
}

setee(){
  export LFR_HOME=/Users/rafaelpraxedes/Workspace/sources/liferay-portal-ee
  export LFR_DEPLOY_HOME=/Users/rafaelpraxedes/Workspace/bundles/ee

  reloadPATH
}

setJdk() {

  NEW_JAVA_HOME=$JAVA_HOME

  if [ "$1" -eq 8 ]; then
    NEW_JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_333.jdk/Contents/Home"
  elif [  "$1" -eq 11 ]; then
     NEW_JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-11.0.13.jdk/Contents/Home"
  elif [  "$1" -eq 17 ]; then
     NEW_JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home"
  fi

  export JAVA_HOME=$NEW_JAVA_HOME

  reloadPATH

  echo "JAVA_HOME has been set to '$JAVA_HOME'"
}

startTomcat() {
  $LFR_DEPLOY_HOME/tomcat-*/bin/catalina.sh jpda run
}

profileTomcat() {
  export JPDA_SUSPEND=y

  $LFR_DEPLOY_HOME/tomcat-*/bin/startup_with_yjp.sh
}

startWildfly() {
  $LFR_DEPLOY_HOME/wildfly-*/bin/standalone.sh --debug
}

stopServer() {
  export JPDA_SUSPEND=n
  lsof -t -i:8080 | xargs kill -9
}

clearEnv() {
  echo "step 1: Creating lportal database..."
  createMySqlDB

  echo "step 2: Cleaning hypersonic folder"
  rm -rf $LFR_DEPLOY_HOME/data/hypersonic

  echo "step 3: Cleaning OSGi state..."
  rm -rf $LFR_DEPLOY_HOME/osgi/state

  echo "step 4: Remove elasticsearch indices..."
  rm -rf $LFR_DEPLOY_HOME/data/elasticsearch*/indices

  echo "'$LFR_DEPLOY_HOME' has been cleaned"
}

reloadPATH() {
  export PATH=$ORIGINAL_PATH:$ANT_HOME/bin:$BLADE_HOME:$JAVA_HOME/bin:$LFR_HOME:$MYSQL_HOME/bin:/Users/rafaelpraxedes/Downloads
}

pag() {
  ps aux | grep $1 
}

gw() {
  gradlew $1 $2 $3 $4 $5 $6 $7 $8
}

pag() {
  ps aux | grep $1 
}

ri() {
  CURRENT_DIR=$PWD
  LPS_ID=$(git symbolic-ref --short HEAD)

  for MODULE_PATH in "$@"
  do
    cd $LFR_HOME/$MODULE_PATH

    MODULE_NAME=$(basename "$PWD")

    echo "Removing immediate from $MODULE_NAME"
    sed -i '' 's/immediate = true,//g' **/*.java(D.)
    #find . -type f -name "*.java" -exec sed -i 's/immediate = true,//g' {} +
    gw formatSource --parallel
    git add .
    git commit -m "$LPS_ID Remove immediate from $MODULE_NAME"
  done

  cd $CURRENT_DIR
}

wip() {
  git add .
  git commit -m "WIP"
}

## GH cli

pr-review() {
  gh pr checkout $2 -R $1/liferay-portal -f -b pr-$1-$2
  gh pr comment $2 -R $1/liferay-portal --body "Just started reviewing :)"
}

pr-review-core() {
  pr-review liferay-core-infra
}

pr-list() {
  gh pr list -R liferay-core-infra/liferay-portal
}

pr() {
  gh pr create --repo liferay-core-infra/liferay-portal -B master -b "" -t "$(git log -1 --pretty=%B)"
}

gpush() {

  LPS_ID=$(git symbolic-ref --short HEAD)

  git push -f origin ${LPS_ID}

}

#ALIASES

alias gitclean="git clean -dfx -e build.rafaelpraxedes.properties -e gradle-ext.properties -e build-ext.properties -e app.server.rafaelpraxedes.properties -e portal-ext.properties -e system-ext.properties -e test.rafaelpraxedes.properties -e working.dir.rafaelpraxedes.properties -e .project -e .classpath -e *.iml"
alias gu="git fetch upstream && git pull && git push"
alias aa="ant setup-profile-dxp && ant all && ij"
alias aace="ant setup-profile-portal && ant all"
alias gsyncrb="git pull --rebase --no-tags upstream master && git push origin master"
alias gwd="gw deploy --parallel"
alias gwc="gw clean --parallel"
alias gwcd="gw clean deploy --parallel"
alias gwf="gw formatSource --parallel"
alias gwfcd="gw formatSource clean deploy --parallel"
alias gww="gw deployFast -at"

alias cllc="rm -rf /Users/rafaelpraxedes/.m2/repository/com/liferay; rm -rf /Users/rafaelpraxedes/.liferay"

alias bce="cd ~/Workspace/bundles/ce"
alias bee="cd ~/Workspace/bundles/ee/"

alias cdce="cd ~/Workspace/sources/liferay-portal; setce"
alias cdee="cd ~/Workspace/sources/liferay-portal-ee; setee"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
