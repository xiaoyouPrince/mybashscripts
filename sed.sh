#!/bin/bash


# 将三列数据封装成一个json数据
sed -i "" 's/*/\"id\":\"*\"' cityArry





#➜  ~ sh -x sed.sh
#+ key='$a$'
#+ new='-new value-'
#+ sed -i _bak 's/$a$/bbbbb/g' 3.txt
#+ cat 3.txt
#$a$


# ------ 特殊字符替换
# key='\$a\$'
# new="-new value-"

# # sed -i "_bak" 's/\$a\$/bbbbb/g' 3.txt

# sed -i "_bak" "s/$key/bbbbb/g" 3.txt

# cat 3.txt


# --------- 判断字符串相等 判断字符串使用 单中括号
# str1=http://xiaoyouprince.com/
# str2=liuting
# if [ "$str1" = "$str2" ]
# then echo equal
# else echo not equal
# fi


# ------------ 截取字符串，从后面截取
# https://www.cnblogs.com/fengbohello/p/5954895.html
# str="http://www.fengbohello.xin3e.com/blog/shell-truncating-string"
# echo "string : [${str}]"

# #分割符为'/'
# substr=${str##*/}
# echo "substr : [${substr}]"

# ------------ sed 在字符串首尾添加引号
# str=nihao
# str=`echo $str | sed "s/$/\"/;s/^/\"/;"`

# echo $str


# 判断是否有 jq 命令
# type jq > /tmp/null
# if [[ $? -ne 0 ]]; then
# 	brew install jq
# fi

# 字符串拼接
# http://c.biancheng.net/view/1114.html

# name="Shell"
# url="http://c.biancheng.net/shell/"

# str1=$name$url  #中间不能有空格
# str2="$name $url"  #如果被双引号包围，那么中间可以有空格
# str3=$name": "$url  #中间可以出现别的字符串
# str4="$name: $url"  #这样写也可以
# str5="${name}Script: ${url}index.html"  #这个时候需要给变量名加上大括号


# 移除所有内容
# 移除所有废弃文件
# rm `ls | grep _bak`
# rm `ls | grep TEMP_`
# rm `ls | grep .js$`

# D_Files="WeexConfig ALIAS KEYS PAGES PageLength PRELOAD_URL_FILE"
# for i in $D_Files; do
# 	rm $i
# done


# for - in 处理批量文件
# Files=`ls | grep .js$`
# for name in $Files; do
# 	echo $name
# done


## 校验参数
# if [[ $1 == Android ]]; then
# 	echo "执行安卓"
# else
# 	echo 执行iOS
# fi

## 检查多个参数
# function checkParams(){
# 	if [[ -z $1 ]]; then
# 		echo -e "\033[32m Usage: $0 release|debug \033[1m"
# 		exit 1
# 	fi

# 	if [[ $1 == release ]]; then
# 		URL=https://fe-api.zhaopin.com/manifest/mobile/b-mobile-config?platform=24
# 		URL_Inner=rd.zhaopin.com/weex
# 	elif [[ $1 == debug  ]]; then
# 		URL=https://fe-api-pre.zhaopin.com/manifest/mobile/b-mobile-config?platform=24
# 		URL_Inner=rd-pre.zhaopin.com/weex
# 	else
# 		echo -e "\033[32m Usage: $0 release|debug \033[1m"
# 		exit 1
# 	fi

# 	if [[ $2 == Android ]]; then
# 		URL=`echo $URL | sed 's/platform=24/platform=100/g'`
# 	fi

# 	echo $URL
# }
# checkParams

#!/bin/bash
# author: xiaoyou.qu
# 2021-01-19


# function showError(){
# 	if [[ "$1" ]]; then
# 		echo "\033[32m 异常终止,原因: $1 \033[0m"
# 	else
# 		echo "\033[32m 异常终止，请检查入参 \033[1m"
# 	fi
# 	echo --------------------------------------
# 	echo "\033[32m Usage: $0 <release/debug> [Android]\033[1m"
# 	echo --------------------------------------
# 	echo "\033[32m 请确认参数输入正确！ \033[1m"
# 	echo "实例："
# 	echo "sh $0 release 		=> release地址，iOS平台"
# 	echo "sh $0 debug 			=> debug地址，iOS平台"
# 	echo "sh $0 release Android => release地址，Android平台"
# 	echo "sh $0 debug Android 	=> debug地址，Android平台"
# 	exit $ERRORCODE
# }

# function start(){

# 	echo "\033[32m 开始执行 weexlist.sh \033[1m"
# 	sh weexlist.sh $1 $2
# 	if [[ $? -ne 0 ]]; then
# 		showError weexlist.sh脚本出错
# 	fi

# 	echo "\033[32m 开始执行 realm.js \033[1m"
# 	node realm.js
# 	if [[ $? -ne 0 ]]; then
# 		showError realm.js脚本出错
# 	fi

# 	# 执行安卓脚本，无需后续操作
# 	if [[ $2 == Android ]]; then
# 	    echo "\033[32m 生成缓存数据和realm数据完成，脚本结束 \033[1m"
# 	    exit 0
# 	fi

# 	echo "\033[32m 开始执行 podupdate.sh \033[1m"
# 	sh podupdate.sh
# 	if [[ $? -ne 0 ]]; then
# 		showError podupdate.sh脚本出错
# 	fi

# 	echo "\033[32m $0 执行成功 - success \033[1m"
# }


# if [[ $1 ]]; then
# 	start $1 $2
# else
# 	showError
# fi


# 清理缓存垃圾？


# 打印所有 pod repo list
# SSS=`pod repo list | grep URL |  sed "s/- URL:  //g" | paste -sd "," -`
# echo $SSS


# 合并所有输出到一行
# FILES="bapp-account-improve.weex.194f6e.js bapp-certification-explain.weex.65e1f2.js bapp-certification-mode.weex.6d1ad2.js bapp-communication-deliver.weex.ef644e.js bapp-company-certification-info.weex.b353ec.js bapp-company-certification.weex.28116c.js bapp-cooperate-invite-bymail.weex.cc3097.js bapp-home.weex.504b01.js bapp-im-home.weex.84bb2a.js bapp-mine.weex.8333bb.js bapp-new-home.weex.a3fa5d.js bapp-user-name.weex.ae70fb.js bind-mobile.weex.d0302b.js certification-progress.weex.426721.js certification-progress.weex.5f5cd2.js email-auth.weex.849337.js login.weex.493f97.js login.weex.b590e8.js org-name.weex.fadb03.js own-city.weex.1e870f.js personal-verify-result.weex.6a3478.js pwd-bind-mobile.weex.18bed9.js pwd-login.weex.4fe477.js quick-reply.weex.e0ccea.js real-name-verify.weex.66b251.js switch-org.weex.601627.js zhibo-b-index.weex.60b31f.js zhibo-b-index.weex.900e30.js zhibo-b-index.weex.b7322b.js zhibo-b-index.weex.bbb4c6.js"
# OLDFILES=`ls | paste -sd " " -`
# for name in $OLDFILES; do
# 	echo "$name ------"
# done

# 发现一个问题: 直接复制命令在终端执行会打印一行。在脚本中执行才能正常打印for循环的内容
# DIR="/Users/quxiaoyou/Desktop/Car/car_images_WAGKH"
# OLDFILES=`ls $DIR | grep .bundle | paste -sd " " -`
# for name in $OLDFILES; do
# 	# echo "$name ------"
# 	mv $DIR/$name $DIR/${name%%.bundle}
# done


