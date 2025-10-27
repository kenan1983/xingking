#!/bin/bash
# 一键改名并推送到 GitHub（支持中文和空格）
# 双击或在 Git Bash 中运行即可

# ========== 配置 ==========
OLD_FOLDER="02+worker-各个大神代码"
NEW_FOLDER="002+worker-各个大神代码"

# ========== 脚本开始 ==========
# 切换到脚本所在目录（仓库根目录）
cd "$(dirname "$0")"

# 检查是否是 Git 仓库
if [ ! -d ".git" ]; then
    echo "❌ 当前目录不是 Git 仓库！"
    read -n1 -r -p "按任意键退出..."
    exit 1
fi

# 自动检测默认分支
BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/origin/||')
if [ -z "$BRANCH" ]; then
    BRANCH="master" # 默认 fallback
fi
echo "📂 当前仓库分支: $BRANCH"

# 拉取远程最新代码
echo "🚀 正在同步远程仓库..."
git pull --rebase origin "$BRANCH"
if [ $? -ne 0 ]; then
    echo "❌ 拉取失败，请检查网络或冲突。"
    read -n1 -r -p "按任意键退出..."
    exit 1
fi

# 确认旧文件夹存在
if [ ! -d "$OLD_FOLDER" ]; then
    echo "❌ 找不到原文件夹：'$OLD_FOLDER'"
    read -n1 -r -p "按任意键退出..."
    exit 1
fi

# 使用 mv 重命名（防止 git mv 中文路径错误）
mv "$OLD_FOLDER" "$NEW_FOLDER"
if [ $? -ne 0 ]; then
    echo "❌ 改名失败！"
    read -n1 -r -p "按任意键退出..."
    exit 1
fi

# git add 所有改动
git add -A

# 提交改动
git commit -m "Rename folder '$OLD_FOLDER' → '$NEW_FOLDER'" || echo "⚠️ 没有改动需要提交"

# 推送到远程
echo "⏫ 推送到远程..."
git push origin "$BRANCH"
if [ $? -ne 0 ]; then
    echo "❌ 推送失败，请检查网络或凭证。"
    read -n1 -r -p "按任意键退出..."
    exit 1
fi

echo "✅ 成功完成！"
read -n1 -r -p "按任意键退出..."
