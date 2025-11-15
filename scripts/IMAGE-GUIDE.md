# 图片整理使用指南 📸

## 🎯 功能说明

自动整理文章中粘贴的外部图片路径，将图片复制到正确位置并更新引用。

## 🚀 使用方法

### 步骤 1: 正常编辑文章

像平时一样粘贴图片的绝对路径到文章中：

```markdown
---
title: "我的文章"
description: "描述"
image: "d:\downloads\cover.jpg"
---

# 我的文章

这是一张图片：
![示例图](d:\downloads\screenshot.png)
```

### 步骤 2: 运行整理脚本

**Bash (Git Bash/WSL)：**
```bash
bash scripts/blog.sh organize src/content/blog/llms/quantization/qwen3vl-30b-a3b-quant.mdx
```

**PowerShell：**
```powershell
.\scripts\organize-images.ps1 -ArticlePath "src\content\blog\llms\quantization\qwen3vl-30b-a3b-quant.mdx"
```

### 步骤 3: 自动完成

脚本会：
1. 扫描文章中的所有图片路径
2. 识别外部绝对路径
3. 复制图片到 `images/` 目录
4. 自动重命名（cover.jpg, figure1.png, figure2.png...）
5. 更新文章中的引用

**整理后的文章：**
```markdown
---
title: "我的文章"
description: "描述"
image: "./images/cover.jpg"
---

# 我的文章

这是一张图片：
![示例图](./images/figure1.png)
```

## 📝 实际示例

### 示例 1: 整理刚创建的文章

```bash
# 1. 创建文章
bash scripts/blog.sh new

# 2. 编辑文章，粘贴图片路径
# 3. 整理图片
bash scripts/blog.sh organize src/content/blog/llms/quantization/qwen3vl-30b-a3b-quant.mdx
```

**输出：**
```
🖼️  整理文章图片
═══════════════════════════════════════
📄 文章: src/content/blog/llms/quantization/qwen3vl-30b-a3b-quant.mdx

🔍 扫描图片引用...

📌 封面图（frontmatter）：
   原路径: d:\downloads\cover.jpg
   ✅ 已复制到: src/content/blog/llms/quantization/images/cover.jpg
   新引用: ./images/cover.jpg

📌 图片 1：
   原路径: d:\downloads\screenshot1.png
   ✅ 已复制到: src/content/blog/llms/quantization/images/figure1.png
   新引用: ./images/figure1.png

📌 图片 2：
   原路径: d:\downloads\diagram.png
   ✅ 已复制到: src/content/blog/llms/quantization/images/figure2.png
   新引用: ./images/figure2.png

═══════════════════════════════════════
✅ 完成！共处理 3 张图片

📁 图片目录: src/content/blog/llms/quantization/images
📄 文章已更新: src/content/blog/llms/quantization/qwen3vl-30b-a3b-quant.mdx
```

## 💡 工作流程建议

### 方案 1: 先写再整理（推荐）

```bash
# 1. 创建文章
bash scripts/blog.sh new

# 2. 编辑文章
code src/content/blog/llms/quantization/my-article.mdx

# 3. 直接粘贴图片的完整路径（从资源管理器复制）
#    image: "d:\xwechat_files\...\image.jpg"
#    ![图片](d:\downloads\screenshot.png)

# 4. 保存文章

# 5. 运行整理脚本
bash scripts/blog.sh organize src/content/blog/llms/quantization/my-article.mdx

# 6. 完成！图片已自动整理
```

### 方案 2: 手动复制图片

如果你更喜欢手动控制：

```bash
# 1. 手动复制图片到images目录
cp ~/Downloads/my-image.jpg src/content/blog/llms/quantization/images/

# 2. 在文章中使用相对路径
#    ![图片](./images/my-image.jpg)
```

## 🔍 支持的图片格式

- **Frontmatter封面图：** `image: "路径"`
- **Markdown图片：** `![描述](路径)`
- **支持的路径类型：**
  - ✅ Windows绝对路径: `d:\folder\image.jpg`
  - ✅ Windows路径（斜杠）: `d:/folder/image.jpg`
  - ✅ Linux/Mac绝对路径: `/home/user/image.jpg`
  - ❌ 相对路径（不会处理）: `./images/image.jpg`
  - ❌ URL（不会处理）: `https://example.com/image.jpg`

## 📋 命名规则

脚本会自动重命名图片：

| 图片类型 | 命名规则 | 示例 |
|---------|---------|------|
| 封面图 | `cover.扩展名` | `cover.jpg`, `cover.png` |
| 内容图片 | `figure序号.扩展名` | `figure1.png`, `figure2.jpg` |

## ⚠️ 注意事项

1. **备份原文章**：脚本会直接修改文章文件
2. **检查结果**：运行后检查图片是否正确复制和引用
3. **图片重复**：如果多次运行，会覆盖同名图片
4. **仅处理绝对路径**：相对路径和URL不会被处理

## 🛠️ 故障排除

### 问题 1: 图片没有被处理

**原因：** 路径可能是相对路径或URL

**解决：** 确保粘贴的是完整的绝对路径

### 问题 2: 中文路径问题

**原因：** 编码问题

**解决：** 
- 使用 PowerShell 版本: `.\scripts\organize-images.ps1`
- 或确保文件保存为 UTF-8 编码

### 问题 3: 图片显示不正常

**原因：** 路径格式问题

**解决：** 检查生成的路径是否使用了 `./images/` 格式

## 🎓 高级用法

### 批量处理多篇文章

```bash
# 处理某个分类下所有文章
for file in src/content/blog/llms/quantization/*.mdx; do
    bash scripts/organize-images.sh "$file"
done
```

### 与Git配合使用

```bash
# 整理后提交
bash scripts/blog.sh organize src/content/blog/my-article.mdx
git add src/content/blog/
git commit -m "Add article with images"
```

## 📚 相关文档

- **创建文章：** `BASH-GUIDE.md`
- **完整指南：** `README.md`

---

**提示：** 这个功能大大简化了图片管理流程，不用手动复制和重命名图片了！✨
