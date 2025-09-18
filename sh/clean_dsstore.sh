#!/bin/bash
#
# feature: 清理当前仓库下并全局忽略 .DS_Store 文件
# author:  xiaoyou.qu
# date:    2025-09-18

# -------------------------------------------------------
# 函数：打印错误并退出
# -------------------------------------------------------
abort() {
    echo "❌ 错误: $1"
    echo ""
    echo "使用说明:"
    echo "  1. 请在 Git 仓库的根目录执行此脚本"
    echo "  2. 确保当前目录存在 .git 文件夹"
    echo "  3. 运行方式:"
    echo "       ./clean_dsstore.sh"
    exit 1
}

# -------------------------------------------------------
# 校验是否为 Git 仓库根目录
# -------------------------------------------------------
if [ ! -d ".git" ]; then
    abort "当前目录不是 Git 仓库根目录"
fi

echo "🧹 开始清理当前仓库的 .DS_Store ..."

# 删除仓库里的所有 .DS_Store 文件
find . -name '.DS_Store' -print -delete

# 确保 .gitignore 文件存在，并写入忽略规则
if [ ! -f .gitignore ]; then
    touch .gitignore
fi

# 如果 .gitignore 里没有 .DS_Store，则追加
if ! grep -q "^\.DS_Store$" .gitignore; then
    echo ".DS_Store" >> .gitignore
    echo "✅ 已在 .gitignore 添加 .DS_Store"
fi

# 从 Git 索引中移除 .DS_Store
git rm -r --cached .DS_Store 2>/dev/null

# 提交变更
git add .gitignore
git commit -m "chore: remove .DS_Store and update .gitignore"

echo "✅ 当前仓库已清理完成"

# -------------------------------------------------------
# 全局忽略配置
# -------------------------------------------------------
echo "⚙️  配置全局 .DS_Store 忽略..."

GLOBAL_GITIGNORE="$HOME/.gitignore_global"

# 如果全局配置文件不存在，就创建
if [ ! -f "$GLOBAL_GITIGNORE" ]; then
    touch "$GLOBAL_GITIGNORE"
fi

# 确保全局配置文件里有 .DS_Store
if ! grep -q "^\.DS_Store$" "$GLOBAL_GITIGNORE"; then
    echo ".DS_Store" >> "$GLOBAL_GITIGNORE"
    echo "✅ 已在 $GLOBAL_GITIGNORE 添加 .DS_Store"
fi

# 设置 git 全局忽略配置
git config --global core.excludesfile "$GLOBAL_GITIGNORE"

echo "🎉 全局 .DS_Store 忽略配置完成"
