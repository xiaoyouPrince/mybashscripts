#!/bin/bash

ERRORCODE=1
REPO_ADDRESS="项目地址"
REPO_NAME="要推送的REPO名称"

function showError(){
	if [[ "$1" ]]; then
		echo "\033[32m 异常终止,原因: $1 \033[0m"
	else
		echo "\033[32m 异常终止，请检查入参 \033[1m"
	fi
	echo --------------------------------------
	echo "\033[32m Usage: $0 <repo_address> <repo_name>\033[1m"
	echo --------------------------------------
	echo "\033[32m 请确认参数输入正确！ \033[1m"
	echo "实例："
	echo "sh pod_update.sh https://github.com/xiaoyouPrince/DataStructure.git DataStructure"
	exit $ERRORCODE
}

if [[ -z $2 ]]; then
	showError 非法入参
else
	REPO_ADDRESS=$1
	REPO_NAME=$2
fi

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

# get sources
SSS=`pod repo list | grep URL`
SSS=`echo $SSS | sed "s/- URL://g"`
SSS=`echo $SSS | sed "s/ //g"`
SSS=`echo $SSS | sed "s/\.git/\.git,/g"`
SSS=`echo $SSS | sed "s#cocoapods.org/#cocoapods.org/,#g"`
SSS=`echo $SSS | sed s'/.$//'`

pod lib lint --use-libraries --use-modular-headers --allow-warnings --sources=$SSS --verbose --skip-import-validation

pod repo push $REPO_NAME ZLMainComponent.podspec --use-libraries --use-modular-headers  --allow-warnings  --sources=$SSS  --verbose --skip-import-validation

