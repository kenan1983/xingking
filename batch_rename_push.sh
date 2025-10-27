#!/bin/bash
# 一键批量改名并推送 GitHub（支持中文、空格文件夹名）
# 自动处理未暂存改动
# 使用方法：Git Bash 双击或运行

# ================= 配置 =================
# 只需修改这里的数组即可
OLD_FOLDERS=("04+ipv6-ssl-证书申请" "3K大神EDtunnel是一个基于 Cloudflare Workers 和 Pages 的代理工具" "03+vps一键脚本-Github")
NEW_FOLDERS=("003+ipv6-ssl-证书申请" "0063K大神EDtunnel是一个基于 Cloudflare Workers 和 Pages 的代理工具" "007+vps一键脚本-Github")
# ========================================

# 切换到脚本所在目录（仓库根目录）
cd "$(dirname "$0")"

# 检查是否 Git 仓库
if [ ! -d ".git" ]; then
    echo "❌ 当前目录不是 Git 仓库！"
    read -n1 -r -p "按任意键退出..."
    exit 1
fi

# 自动检测默认分支
BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/origin/||')
[ -z "$BRANCH" ] && BRANCH="master"
echo "📂 当前仓库分支: $BRANCH"

# 检查未暂存改动
if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "⚠️ 检测到本地未暂存改动，自动提交临时保存"
    git add -A
    git commit -m "Temp commit before pull"
fi

# 拉取远程最新代码
echo "🚀 正在同步远程仓库..."
git pull --rebase origin "$BRANCH"
if [ $? -ne 0 ]; then
    echo "❌ 拉取失败，请检查网络或冲突。"
    read -n1 -r -p "按任意键退出..."
    exit 1
fi

# 批量重命名
for i in "${!OLD_FOLDERS[@]}"; do
    OLD="${OLD_FOLDERS[$i]}"
    NEW="${NEW_FOLDERS[$i]}"

    if [ ! -d "$OLD" ]; then
        echo "⚠️ 找不到原文件夹: '$OLD'，跳过"
        continue
    fi

    echo "🧩 正在重命名: '$OLD' → '$NEW'"
    mv "$OLD" "$NEW"
    if [ $? -ne 0 ]; then
        echo "❌ 改名失败: '$OLD'"
    fi
done

# 提交改动
git add -A
git commit -m "Batch rename folders" || echo "⚠️ 没有改动需要提交"

# 推送到远程
echo "⏫ 推送到远程..."
git push origin "$BRANCH"
if [ $? -ne 0 ]; then
    echo "❌ 推送失败，请检查连接或凭证。"
    read -n1 -r -p "按任意键退出..."
    exit 1
fi

echo "✅ 批量改名完成！"
read -n1 -r -p "按任意键退出..."
