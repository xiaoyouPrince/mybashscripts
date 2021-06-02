#!/bin/bash

# auther: xiaoyouPrince
# date: 2021年03月02日16:00:30
# func: 给当前的git 仓库，设置 local user

# 使用方式: 在需要修改仓库 local user 的仓库内执行下面代码即可
# sh ~/.setGitlabUser.sh

git config --local user.name xiaoyou.qu
git config --local user.email xiaoyou.qu@zhaopin.com.cn
