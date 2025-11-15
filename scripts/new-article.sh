#!/bin/bash
# 创建新博客文章

set -e

echo ""
echo "📝 创建新文章"
echo "═══════════════════════════════════════"
echo ""

# 询问文章名称
read -p "文章名称（英文，如：my-article）: " name
if [ -z "$name" ]; then
    echo "❌ 文章名称不能为空"
    exit 1
fi

# 询问标题
read -p "文章标题（中英文均可）: " title
if [ -z "$title" ]; then
    echo "❌ 文章标题不能为空"
    exit 1
fi

# 询问描述（可选）
read -p "文章描述（可选，按回车跳过）: " description
if [ -z "$description" ]; then
    description="$title"
fi

# 列出现有分类
echo ""
echo "现有分类："
blog_dir="src/content/blog"
categories=()
i=1

if [ -d "$blog_dir" ]; then
    # 使用简单的循环代替find
    for dir in "$blog_dir"/*/ "$blog_dir"/*/*/ "$blog_dir"/*/*/*/; do
        if [ -d "$dir" ] && [ "$(basename "$dir")" != "images" ]; then
            if ls "$dir"*.mdx >/dev/null 2>&1; then
                rel_path="${dir#$blog_dir/}"
                rel_path="${rel_path%/}"
                if [ -n "$rel_path" ]; then
                    categories+=("$rel_path")
                    echo "  $i. $rel_path"
                    ((i++))
                fi
            fi
        fi
    done
fi

echo "  0. 输入新分类"
echo ""

read -p "选择分类（输入数字）: " choice

if [ "$choice" = "0" ] || [ -z "$choice" ]; then
    read -p "输入分类路径（如：essay, competitive-programming）: " category
else
    idx=$((choice - 1))
    if [ $idx -ge 0 ] && [ $idx -lt ${#categories[@]} ]; then
        category="${categories[$idx]}"
    else
        echo "❌ 无效的选择"
        exit 1
    fi
fi

if [ -z "$category" ]; then
    echo "❌ 分类不能为空"
    exit 1
fi

# 询问标签
read -p "标签（逗号分隔，如：LLM,Quant，可选）: " tags

# 获取今天日期
publish_date=$(date +%Y-%m-%d)

# 构建路径
article_dir="src/content/blog/$category"
article_path="$article_dir/$name.mdx"
images_dir="$article_dir/images"

# 检查文章是否已存在
if [ -f "$article_path" ]; then
    echo "❌ 错误：文章已存在 $article_path"
    exit 1
fi

# 创建目录
mkdir -p "$article_dir"
mkdir -p "$images_dir"

# 生成标签格式
if [ -n "$tags" ]; then
    IFS=',' read -ra tag_array <<< "$tags"
    formatted_tags=""
    for tag in "${tag_array[@]}"; do
        tag=$(echo "$tag" | xargs)  # trim
        if [ -n "$formatted_tags" ]; then
            formatted_tags="$formatted_tags, \"$tag\""
        else
            formatted_tags="\"$tag\""
        fi
    done
    tags_line="tags: [$formatted_tags]"
else
    tags_line=""
fi

# 生成文章内容
cat > "$article_path" << EOF
---
title: "$title"
description: "$description"
image: "../../blog_post.jpg"
publishDate: "$publish_date"
${tags_line}
---

# $title

## 简介

在这里写文章的简介...

## 主要内容

### 章节 1

你的内容...

### 章节 2

你的内容...

## 代码示例

\`\`\`python
# 示例代码
def example():
    print("Hello, World!")
\`\`\`

## 总结

总结文章的要点...

## 参考资料

- [参考链接1](https://example.com)
- [参考链接2](https://example.com)
EOF

echo ""
echo "🎉 文章创建成功！"
echo ""
echo "📄 文章位置："
echo "   $article_path"
echo ""
echo "📝 文章信息："
echo "   标题：$title"
echo "   分类：$category"
echo "   日期：$publish_date"
echo ""
echo "🖼️  图片目录："
echo "   $images_dir"
echo ""
echo "🚀 下一步："
echo "   1. 编辑文章：code $article_path"
echo "   2. 添加封面图到：$images_dir"
echo "   3. 启动开发服务器：npm run dev"
echo ""
