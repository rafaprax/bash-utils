aa() {
	cd $LFR_HOME
	ant all
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

alias buildCeEnv="cdce; createMySqlDB; gcfdx; aa; cd modules; gw eclipse; cd -"
alias buildEeEnv="cdee; createMySqlDB lportal-ee; gcfdx; aa; cd modules; gw eclipse; cd -"
alias clearLiferayCache="rm -rf /Users/rafael/.m2/repository/com/liferay; rm -rf /Users/rafael/.liferay"
alias ce-bundles-dir="cd /Users/rafael/Liferay/bundles/"
alias ee-bundles-dir="cd /Users/rafael/Liferay/bundles-ee/"
alias cdce="cd ~/Workspace/sources/liferay-portal; setce"
alias cdee="cd ~/Workspace/sources/liferay-portal-ee; setee"

