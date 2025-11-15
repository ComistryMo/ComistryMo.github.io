#!/bin/bash
# 列出所有博客文章

echo ""
echo "📚 博客文章列表"
echo "═══════════════════════════════════════"
echo ""

blog_dir="src/content/blog"
total_articles=0

if [ ! -d "$blog_dir" ]; then
    echo "❌ 博客目录不存在：$blog_dir"
    exit 1
fi

# 遍历所有分类目录
for dir in "$blog_dir"/*/ "$blog_dir"/*/*/ "$blog_dir"/*/*/*/; do
    if [ -d "$dir" ] && [ "$(basename "$dir")" != "images" ]; then
        # 检查是否有mdx文件
        if ls "$dir"*.mdx >/dev/null 2>&1; then
            rel_path="${dir#$blog_dir/}"
            rel_path="${rel_path%/}"
            if [ -n "$rel_path" ]; then
                article_count=$(ls -1 "$dir"*.mdx 2>/dev/null | wc -l)
                
                echo ""
                echo "📁 $rel_path"
                echo "   共 $article_count 篇文章"
                echo ""
                
                # 列出所有文章
                for file in "$dir"*.mdx; do
                    if [ -f "$file" ]; then
                        name=$(basename "$file" .mdx)
                        size=$(du -h "$file" | cut -f1)
                        modified=$(date -r "$file" "+%Y-%m-%d %H:%M" 2>/dev/null || stat -c %y "$file" 2>/dev/null | cut -d' ' -f1,2 | cut -d':' -f1,2)
                        
                        echo "   📄 $name"
                        echo "      大小：$size | 修改：$modified"
                        
                        ((total_articles++))
                    fi
                done
            fi
        fi
    fi
done

echo ""
echo "═══════════════════════════════════════"
echo "共 $total_articles 篇文章"
echo ""
