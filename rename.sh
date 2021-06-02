#!/bin/bash
# author: qxy
# date: 2021年03月30日15:04:02
# feature: 替换某文件夹下面的文件的名称，按统一命名规则


echo "$PWD"

Files=`ls | grep .png$`

for name in $Files; do
    echo $name
#    mv $PWD/$name $PWD/${name##*_00}

#    newName=`echo $name | sed 's/.png/@3x.png/g'`
    newName=`echo $name | sed 's/@3x//g'`
    mv $PWD/$name $PWD/$newName
done
