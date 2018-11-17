export ANTLR4="/usr/local/lib/antlr-4.3-complete.jar"
export ANT_OPTS="-Xms4096m -Xmx4096m"
export ANT_HOME=/Users/rafael/Workspace/tools/apache-ant-1.10.1
export CLASSPATH=".:/usr/local/lib/antlr-4.7.1-complete.jar:$CLASSPATH"
export EDITOR="sublime -w"
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
