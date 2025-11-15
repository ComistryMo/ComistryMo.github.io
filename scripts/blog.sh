#!/bin/bash
# 博客管理工具 - 统一入口

show_help() {
    echo ""
    echo "📝 博客管理工具"
    echo "═══════════════════════════════════════"
    echo ""
    echo "用法："
    echo "  ./scripts/blog.sh <action>"
    echo ""
    echo "可用操作："
    echo ""
    echo "  new       创建新文章"
    echo "            示例：./scripts/blog.sh new"
    echo ""
    echo "  remove    删除文章"
    echo "            示例：./scripts/blog.sh remove"
    echo ""
    echo "  list      列出所有文章"
    echo "            示例：./scripts/blog.sh list"
    echo ""
    echo "  organize  整理文章图片（处理粘贴的外部路径）"
    echo "            示例：./scripts/blog.sh organize <文章路径>"
    echo ""
    echo "  help      显示此帮助信息"
    echo ""
    echo "详细文档："
    echo "  ./scripts/README.md"
    echo ""
}

# 获取脚本所在目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 主逻辑
case "$1" in
    new)
        bash "$SCRIPT_DIR/new-article.sh"
        ;;
    remove)
        bash "$SCRIPT_DIR/remove-article.sh"
        ;;
    list)
        bash "$SCRIPT_DIR/list-articles.sh"
        ;;
    organize)
        if [ -z "$2" ]; then
            echo "❌ 错误: 请指定文章路径"
            echo "示例: ./scripts/blog.sh organize src/content/blog/llms/quantization/my-article.mdx"
            exit 1
        fi
        bash "$SCRIPT_DIR/organize-images.sh" "$2"
        ;;
    help|"")
        show_help
        ;;
    *)
        echo "❌ 未知操作: $1"
        show_help
        exit 1
        ;;
esac
