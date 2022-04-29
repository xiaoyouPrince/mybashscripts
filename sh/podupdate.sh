#!/bin/bash
# auther: xiaoyou.qu
# date: 2021-01-14

ERRORCODE=1
REPO_ADDRESS="项目git地址"
REPO_NAME="要推送的REPO名称"
TAG="手动指定版本号，默认检测上次版本，版本号自动加1"
MESSAGE="手动指定git提交message，默认为tag号"

function showError(){
	if [[ "$1" ]]; then
		echo "\033[32m 异常终止,原因: $1 \033[0m"
	else
		echo "\033[32m 异常终止，请检查入参 \033[1m"
	fi
	echo --------------------------------------
	echo "\033[32m Usage: $0 <repo_address> <repo_name> [tag=<your_tag>] [message=<your_commit_message>]\033[1m"
	echo --------------------------------------
	echo "\033[32m 请确认参数输入正确！ \033[1m"
	echo "实例："
	echo "sh $0 https://github.com/xiaoyouPrince/DataStructure.git DataStructure"
	exit $ERRORCODE
}

function checkArgs(){
	if [[ -z $2 ]]; then
		showError 非法入参
	else
		REPO_ADDRESS=$1
		REPO_NAME=$2
		TAG=${3##tag=}
		MESSAGE=${4##message=}
	fi
}

function gitClone(){
	git clone $REPO_ADDRESS
	if [[ $? -eq 0 ]]; then
		DIR=${REPO_ADDRESS##*/}
		DIR=${DIR%.*}

		if [[ -d $DIR ]]; then
			cd $DIR
		else
			showError 仓库地址不正确
		fi
	else
		showError 仓库地址不正确
	fi
}

function updateSpecVersion(){
	# 假设只有一个 podspec 文件
	RepoSpecName=`ls | grep .podspec`
	OriginRepoVersion=`grep -Eo "[a-zA-Z]+\.version.*=.*" ${RepoSpecName} | cut -d "=" -f2 | grep -Eo "[a-zA-Z.0-9]+"`
	OldVersionP1=${OriginRepoVersion%.*}
	OldVersionP2=${OriginRepoVersion##*.}
	OldVersionP2Update=$((OldVersionP2+1))
	NewRepoVersion="$OldVersionP1.$OldVersionP2Update"
	echo $NewRepoVersion

	VersionLineNumber=`grep -nE 's.version.*=' ${RepoSpecName} | cut -d : -f1`
	sed -i "" "${VersionLineNumber}s/${OriginRepoVersion}/${NewRepoVersion}/g" ${RepoSpecName}
	cat ${RepoSpecName}
}

function gitOperation(){

	NEWTAG=""
	NEWMESSAGE=""
	if [[ -z $TAG ]]; then
		NEWTAG=$NewRepoVersion
	else
		NEWTAG=$TAG
	fi
	if [[ -z $MESSAGE ]]; then
		NEWMESSAGE=$NewRepoVersion
	else
		NEWMESSAGE=$MESSAGE
	fi

	# git opreation
	git stash
	git pull origin $(git rev-parse --abbrev-ref HEAD) --tags
	git stash pop
	git add .
	git commit -am "${NEWMESSAGE}"
	git tag ${NEWTAG}
	git push origin $(git rev-parse --abbrev-ref HEAD) --tags
}

function podOperation(){
	# get sources
	SOURCES=`pod repo list | grep URL |  sed "s/- URL:  //g" | paste -sd "," -`
	echo "--------sources--------"
	echo
	echo $SOURCES
	echo
	echo "--------sources--------"


	pod lib lint --use-libraries --use-modular-headers --allow-warnings --sources=$SOURCES --skip-import-validation
	if [[ $? == 0 ]]; then
		echo "------------pod lint 完成--------------"
		echo "------------开始执行 pod push--------------"
		pod repo push $REPO_NAME --use-libraries --use-modular-headers  --allow-warnings  --sources=$SOURCES --skip-import-validation
	else
		echo "------------pod lint 出错--------------"
		echo "------------终止运行--------------"
		exit 1
	fi
}


checkArgs $@
gitClone
updateSpecVersion
gitOperation
podOperation
exit 0



