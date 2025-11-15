#!/bin/bash
# 整理文章中的图片 - 自动将外部图片复制到正确位置并更新引用

set -e

if [ -z "$1" ]; then
    echo "用法: bash scripts/organize-images.sh <文章路径>"
    echo "示例: bash scripts/organize-images.sh src/content/blog/llms/quantization/my-article.mdx"
    exit 1
fi

article_path="$1"

if [ ! -f "$article_path" ]; then
    echo "❌ 文章不存在: $article_path"
    exit 1
fi

echo ""
echo "🖼️  整理文章图片"
echo "═══════════════════════════════════════"
echo "📄 文章: $article_path"
echo ""

# 获取文章所在目录和文章名
article_dir=$(dirname "$article_path")
article_name=$(basename "$article_path" .mdx)
images_dir="$article_dir/images"

# 创建images目录
mkdir -p "$images_dir"

# 读取文章内容
content=$(cat "$article_path")

# 临时文件
temp_file=$(mktemp)
cp "$article_path" "$temp_file"

image_count=0
copied_count=0

echo "🔍 扫描图片引用..."
echo ""

# 处理frontmatter中的image字段
if echo "$content" | grep -q '^image:'; then
    image_line=$(echo "$content" | grep '^image:' | head -1)
    # 移除 image: 前缀和可能的引号，trim空格
    image_value=$(echo "$image_line" | sed 's/^image:\s*//;s/^["'\'']\(.*\)["'\'']$/\1/' | xargs)
    
    echo "🔍 检测到frontmatter图片: $image_value"
    
    # 检查是否是外部绝对路径（Windows路径或Linux绝对路径）
    if [[ "$image_value" =~ ^[a-zA-Z]:\\ ]] || [[ "$image_value" =~ ^[a-zA-Z]:/ ]] || [[ "$image_value" =~ ^/ ]]; then
        # 转换Windows路径分隔符
        image_value_unix=$(echo "$image_value" | sed 's/\\/\//g')
        
        echo "   检查文件是否存在..."
        
        if [ -f "$image_value_unix" ] || [ -f "$image_value" ]; then
            echo "   ✅ 文件存在"
            echo "📌 封面图（frontmatter）："
            echo "   原路径: $image_value"
            
            # 获取文件扩展名
            ext="${image_value##*.}"
            new_name="cover.${ext}"
            new_path="$images_dir/$new_name"
            
            # 复制文件
            if [ -f "$image_value_unix" ]; then
                cp "$image_value_unix" "$new_path"
            else
                cp "$image_value" "$new_path"
            fi
            
            echo "   ✅ 已复制到: $new_path"
            echo "   新引用: ./images/$new_name"
            
            # 更新文章中的引用
            sed -i "s|^image:.*|image: \"./images/$new_name\"|" "$temp_file"
            
            ((copied_count++))
            echo ""
        else
            echo "   ⚠️  文件不存在（可能已被删除）"
            echo ""
        fi
    fi
fi

# 处理图片引用
# 定义正则表达式模式
markdown_pattern='!\[.*\]\(([^)]+)\)'
obsidian_pattern='!\[\[([^\]]+)\]\]'
path_pattern='([a-zA-Z]:[/\\][^[:space:]]+\.(jpg|jpeg|png|gif|webp|svg|bmp|JPG|JPEG|PNG|GIF|WEBP|SVG|BMP))'

while IFS= read -r line; do
    img_path=""
    format_type=""
    
    # 1. 标准Markdown格式 ![](...)
    if [[ "$line" =~ $markdown_pattern ]]; then
        img_path="${BASH_REMATCH[1]}"
        format_type="markdown"
    # 2. Obsidian格式 ![[...]]
    elif [[ "$line" =~ $obsidian_pattern ]]; then
        img_path="${BASH_REMATCH[1]}"
        format_type="obsidian"
    # 3. 纯Windows路径（以盘符开头，包含\或/）
    elif [[ "$line" =~ $path_pattern ]]; then
        img_path="${BASH_REMATCH[1]}"
        format_type="plain"
    fi
    
    if [ -n "$img_path" ]; then
        # 转换Windows路径
        img_path_unix=$(echo "$img_path" | sed 's/\\/\//g')
        img_path=$(echo "$img_path" | xargs)  # trim
        img_path_unix=$(echo "$img_path_unix" | xargs)
        
        # 检查是否是外部绝对路径
        if [[ "$img_path" =~ ^[a-zA-Z]:\\ ]] || [[ "$img_path" =~ ^[a-zA-Z]:/ ]] || [[ "$img_path" =~ ^/ ]]; then
            echo "🔍 检测到图片路径 ($format_type): $img_path"
            if [ -f "$img_path_unix" ] || [ -f "$img_path" ]; then
                ((image_count++))
                echo "   ✅ 文件存在"
                echo "📌 图片 $image_count ($format_type)："
                echo "   原路径: $img_path"
                
                # 生成新文件名
                ext="${img_path##*.}"
                new_name="figure${image_count}.${ext}"
                new_path="$images_dir/$new_name"
                
                # 复制文件
                if [ -f "$img_path_unix" ]; then
                    cp "$img_path_unix" "$new_path"
                else
                    cp "$img_path" "$new_path"
                fi
                
                echo "   ✅ 已复制到: $new_path"
                echo "   新引用: ./images/$new_name"
                
                # 根据格式更新引用
                if [ "$format_type" = "obsidian" ]; then
                    # Obsidian格式转换为标准Markdown
                    # 转义原路径中的特殊字符
                    escaped_obsidian=$(echo "$img_path" | sed 's/[\/&\.\[]/\\&/g')
                    new_ref="![图片](./images/$new_name)"
                    sed -i "s|!\[\[${escaped_obsidian}\]\]|${new_ref}|g" "$temp_file"
                elif [ "$format_type" = "plain" ]; then
                    # 纯路径，转为Markdown格式
                    escaped_old=$(echo "$img_path" | sed 's/[\/&\:\\]/\\&/g')
                    new_ref="![图片](./images/$new_name)"
                    sed -i "s|${escaped_old}|${new_ref}|g" "$temp_file"
                else
                    # 标准Markdown，只替换路径部分
                    escaped_old=$(echo "$img_path" | sed 's/[\/&\:\\]/\\&/g')
                    sed -i "s|${escaped_old}|./images/$new_name|g" "$temp_file"
                fi
                
                ((copied_count++))
                echo ""
            else
                echo "   ⚠️  文件不存在（可能已被删除或路径错误）"
                echo ""
            fi
        fi
    fi
done < "$article_path"

# 如果有修改，更新原文件
if [ $copied_count -gt 0 ]; then
    mv "$temp_file" "$article_path"
    echo "═══════════════════════════════════════"
    echo "✅ 完成！共处理 $copied_count 张图片"
    echo ""
    echo "📁 图片目录: $images_dir"
    echo "📄 文章已更新: $article_path"
    echo ""
else
    rm "$temp_file"
    echo "ℹ️  未找到需要整理的外部图片"
    echo ""
fi
