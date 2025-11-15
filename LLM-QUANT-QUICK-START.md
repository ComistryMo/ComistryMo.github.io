# LLM/Quant 博客快速参考卡片

> **快速开始指南** - 5分钟上手  
> **详细文档**: 查看 [LLM-QUANT-BLOG-GUIDE.md](./LLM-QUANT-BLOG-GUIDE.md)

---

## 📂 文件位置

```
📁 src/content/blog/LLM/Quant/
├── 📁 images/                    # 图片文件夹
├── 📄 template.mdx               # 文章模板
├── 📄 getting-started.mdx        # 示例文章
└── 📄 你的文章.mdx               # 在这里创建新文章
```

---

## ⚡ 创建文章三步走

### 1️⃣ 复制模板
```bash
cd src/content/blog/LLM/Quant/
cp template.mdx my-article-name.mdx
```

### 2️⃣ 修改 Frontmatter
```yaml
---
title: "你的文章标题"
description: "文章简短描述（用于SEO）"
image: "./images/cover.png"
publishDate: "2025-11-15"
tags: ["LLM", "Quant"]
---
```

### 3️⃣ 开始写作
使用 Markdown/MDX 语法编写内容！

---

## 🖼️ 图片使用

### 方式一：相对路径（推荐）✨
```yaml
# Frontmatter 封面图
image: "./images/my-cover.png"
```
```markdown
# 内容中的图片
![说明](./images/figure1.png)
```

### 方式二：Public 目录
```yaml
# Frontmatter 封面图
image: "/images/blog/LLM/Quant/my-cover.png"
```
```markdown
# 内容中的图片
![说明](/images/blog/LLM/Quant/figure1.png)
```

**图片规范**：
- 封面：1200x630px，< 500KB
- 内容图：800-1200px宽，< 300KB

---

## 🏷️ 推荐标签

```yaml
# LLM相关
tags: ["LLM", "GPT", "Transformer", "RAG", "Fine-tuning"]

# Quant相关
tags: ["Quant", "量化交易", "算法交易", "回测", "因子分析"]

# 技术栈
tags: ["Python", "PyTorch", "Pandas", "机器学习"]

# 组合使用（推荐2-6个）
tags: ["LLM", "Quant", "Python", "量化交易"]
```

---

## 💻 常用 Markdown

````markdown
## 标题
### 子标题

**粗体** *斜体* `代码`

- 无序列表
1. 有序列表

[链接](https://example.com)
![图片](./images/pic.png)

> 引用文字

```python
# 代码块
print("Hello World")
```

| 表格 | 示例 |
|------|------|
| 数据 | 值   |
````

---

## 🎬 嵌入媒体

```jsx
import YouTube from '../../../components/YouTube.astro';
import Spotify from '../../../components/Spotify.astro';
import Twitter from '../../../components/Twitter.astro';

<YouTube id="视频ID" />
<Spotify url="https://open.spotify.com/..." />
<Twitter url="https://x.com/user/status/..." />
```

---

## 🚀 本地预览

```bash
# 启动开发服务器
npm run dev

# 访问
http://localhost:4321/blog
```

---

## ✅ 发布检查清单

- [ ] 标题和描述准确
- [ ] 封面图显示正常（1200x630px）
- [ ] 所有图片都能加载
- [ ] 代码块语法高亮正常
- [ ] 标签合理（2-6个）
- [ ] 日期格式正确（YYYY-MM-DD）
- [ ] 在手机上显示正常
- [ ] 内外链接有效

---

## 🔧 构建和部署

```bash
# 构建生产版本
npm run build

# 预览生产版本
npm run preview

# 提交代码
git add .
git commit -m "Add new blog post"
git push
```

---

## 📚 更多帮助

| 文档 | 说明 |
|------|------|
| `LLM-QUANT-BLOG-GUIDE.md` | 📖 完整使用指南 |
| `src/content/blog/LLM/Quant/template.mdx` | 📄 文章模板 |
| `src/content/blog/LLM/Quant/getting-started.mdx` | 📝 示例文章 |

---

## 🐛 常见问题

**Q: 图片不显示？**  
A: 检查路径 `./images/xxx.png` 或 `/images/blog/LLM/Quant/xxx.png`

**Q: 构建失败？**  
A: 检查日期格式必须是 `"2025-11-15"` 带引号

**Q: 封面图变形？**  
A: 使用 1200x630px (1.91:1) 比例

**Q: 如何添加数学公式？**  
A: 需要安装 `remark-math` 和 `rehype-katex` 插件

---

## 📞 联系方式

- GitHub: [@ComistryMo](https://github.com/ComistryMo/)
- Email: comistrymo@gmail.com

---

**快速开始，立即创作！** 🚀

详细说明请查看 [完整指南](./LLM-QUANT-BLOG-GUIDE.md)
