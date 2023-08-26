#!/bin/bash
# 
# feature：auto post a new article for my blog
# auther： xiaoyou
# date: 2022-07-31
#
# 思路：
# 指定文章名
# 指定作者
# 指定发布时间
# 定文章类别
# 指定文章标签
# 指定要发布文章的源文件路径
# 自动生成对应的含日期的标题/对应blog文件头/放入指定发布地址/执行服务打开浏览器看效果/自动执行git推送远端

echo "hello"

colorbegin="\033[32m"
colorend="\033[1m"

TITLE="指定文章标题"
AUTER="xiaoyouPrince"
DATE="指定发布时间"
CATEGORIES="指定文章类别"
TAGS="指定文章标签"
FILEPATH="指定文章源文件路径"

ERRORCODE=1

echo "${colorbegin}输入要发布文章名（会自动标记指定日期，便于日后文章添加时间排序）:${colorend}"
read Input
if [[ -n $Input ]]; then
	TITLE=$Input
else
	echo "未输入文章标题，流程结束"
	exit $ERRORCODE
fi

echo "${colorbegin}输入要发布文章作者（默认xiaoyouPrince）:${colorend}"
read Input
if [[ -n $Input ]]; then
	AUTER=$Input
fi

echo "${colorbegin}输入要发布文章时间（格式：yyyy-MM-dd HH-mm-ss, 默认当前时间）:${colorend}"
read Input
if [[ -n $Input ]]; then
	DATE=$Input
else
	DATE=`date "+%Y-%m-%d %H:%M:%S"`
fi

echo "${colorbegin}指定文章类别(格式[TOP_CATEGORIE SUB_CATEGORIE]):${colorend}"
read Input
if [[ -n $Input ]]; then
	CATEGORIES=$Input
else
	CATEGORIES=""
fi

echo "${colorbegin}指定文章标签(小写字母空格分开):${colorend}"
read Input
if [[ -n $Input ]]; then
	TAGS=$Input
else
	TAGS=""
fi

echo "${colorbegin}指定文章文件绝对路径(为避免出错，可以直接拖拽进来):${colorend}"
read Input
if [[ -e $Input ]]; then
	FILEPATH=$Input
else
	echo "指定的源文件地址不存在,流程结束"
	exit $ERRORCODE
fi


cd /Users/quxiaoyou/Documents/github/xiaoyouPrince.github.io/_posts
TITLEDATE=`date "+%Y-%m-%d"`
POST="${TITLEDATE}-${TITLE}.md"
touch $POST

echo "---" >> $POST
echo "title: $TITLE"  >> $POST
echo "auther: $AUTER" >> $POST
echo "date: $DATE +0800" >> $POST
echo "categories: $CATEGORIES" >> $POST
echo "tags: $TAGS" >> $POST
echo "layout: post" >> $POST
echo "---" >> $POST
echo "" >> $POST

cat $FILEPATH >> $POST
cat $POST

cd ..
bundle exec jekyll serve
open http://127.0.0.1:4000/



exit 0
