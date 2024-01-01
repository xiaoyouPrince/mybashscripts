#!/bin/bash
# author: qxy
# date: 2024年01月2日00:05:02
# feature: 删除指定路径下(当前路径下)的空文件


# 如果提供了目录作为参数，则使用该目录；否则使用当前目录
directory="${1:-.}"

# 遍历指定目录下的所有文件
for file in "$directory"/*; do
    # 检查文件是否存在且字节数为0, -s 是校验文件字节数量>0
    if [ -f "$file" ] && [ ! -s "$file" ]; then
        # 删除字节数为0的文件
        rm "$file"
        echo "Deleted empty file: $file"
    fi
done

echo "Deleted empty file in ${PWD} complete."

