#!/bin/bash
# 只改本地文件夹名称并提交到 GitHub

# ================= 配置 =================
OLD_FOLDERS=("BPB面板搭建" "IDM激活脚本" "05+Cloudflare Snippets 搭建永久免费节点")
NEW_FOLDERS=("011+BPB面板搭建" "012+IDM激活脚本" "013+Cloudflare Snippets 搭建永久免费节点")
# ========================================

cd "$(dirname "$0")"  # 切换到脚本所在目录

# 检查是否 Git 仓库
if [ ! -d ".git" ]; then
    echo "❌ 当前目录不是 Git 仓库！"
    read -n1 -r -p "按任意键退出..."
    exit 1
fi

# 自动检测分支
BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/origin/||')
[ -z "$BRANCH" ] && BRANCH="master"
echo "📂 当前仓库分支: $BRANCH"

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
done

# 提交改动
git add -A
git commit -m "Batch rename folders" || echo "⚠️ 没有改动需要提交"

# 推送到远程（可选，如果你不想推送可以注释掉）
git push origin "$BRANCH"

echo "✅ 文件夹重命名完成！"
read -n1 -r -p "按任意键退出..."
