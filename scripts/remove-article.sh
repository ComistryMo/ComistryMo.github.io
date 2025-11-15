#!/bin/bash
# 删除博客文章

set -e

echo ""
echo "🗑️  删除文章"
echo "═══════════════════════════════════════"
echo ""

# 列出现有分类和文章
echo "现有文章："
blog_dir="src/content/blog"
categories=()
i=1

if [ -d "$blog_dir" ]; then
    for dir in "$blog_dir"/*/ "$blog_dir"/*/*/ "$blog_dir"/*/*/*/; do
        if [ -d "$dir" ] && [ "$(basename "$dir")" != "images" ]; then
            if ls "$dir"*.mdx >/dev/null 2>&1; then
                rel_path="${dir#$blog_dir/}"
                rel_path="${rel_path%/}"
                if [ -n "$rel_path" ]; then
                    echo ""
                    echo "📁 $rel_path"
                    for file in "$dir"*.mdx; do
                        if [ -f "$file" ]; then
                            basename=$(basename "$file" .mdx)
                            echo "   • $basename"
                        fi
                    done
                    categories+=("$rel_path")
                    ((i++))
                fi
            fi
        fi
    done
fi

echo ""

# 询问文章名称
read -p "要删除的文章名称: " name
if [ -z "$name" ]; then
    echo "❌ 文章名称不能为空"
    exit 1
fi

# 选择分类
echo ""
echo "选择文章所在分类："
i=1
for cat in "${categories[@]}"; do
    echo "  $i. $cat"
    ((i++))
done
echo ""

read -p "选择分类（输入数字）: " choice
idx=$((choice - 1))

if [ $idx -lt 0 ] || [ $idx -ge ${#categories[@]} ]; then
    echo "❌ 无效的选择"
    exit 1
fi

category="${categories[$idx]}"

# 构建路径
article_dir="src/content/blog/$category"
article_path="$article_dir/$name.mdx"
images_dir="$article_dir/images"

# 检查文章是否存在
if [ ! -f "$article_path" ]; then
    echo "❌ 错误：文章不存在 $article_path"
    exit 1
fi

# 查找相关图片
echo ""
echo "📄 找到文章："
echo "   $article_path"

related_images=()
if [ -d "$images_dir" ]; then
    for img in "$images_dir/${name}"*; do
        if [ -f "$img" ]; then
            related_images+=("$img")
        fi
    done
fi

if [ ${#related_images[@]} -gt 0 ]; then
    echo ""
    echo "🖼️  找到相关图片 (${#related_images[@]} 个)："
    for img in "${related_images[@]}"; do
        size=$(du -h "$img" | cut -f1)
        echo "   - $(basename "$img") ($size)"
    done
fi

# 确认删除
echo ""
echo "⚠️  警告：此操作将删除以下内容："
echo "   ✓ 文章文件：$article_path"
if [ ${#related_images[@]} -gt 0 ]; then
    echo "   ✓ 相关图片：${#related_images[@]} 个文件"
fi
echo ""

read -p "确认删除吗？(y/N): " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo ""
    echo "❌ 操作已取消"
    exit 0
fi

# 删除文章
rm -f "$article_path"
echo ""
echo "✅ 已删除文章：$article_path"

# 删除相关图片
deleted_count=0
for img in "${related_images[@]}"; do
    rm -f "$img"
    echo "✅ 已删除图片：$(basename "$img")"
    ((deleted_count++))
done

echo ""
echo "🎉 删除完成！"
echo ""
echo "📊 删除统计："
echo "   文章：1 个"
if [ $deleted_count -gt 0 ]; then
    echo "   图片：$deleted_count 个"
fi
echo ""
