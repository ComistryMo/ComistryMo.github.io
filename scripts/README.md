# 博客管理脚本使用指南

## 📦 脚本列表

- **new-article.ps1** - 创建新文章
- **remove-article.ps1** - 删除文章及相关资源

---

## 🆕 创建新文章 (new-article.ps1)

### 基础用法

```powershell
# 最简单的用法（只需提供文章名和标题）
.\scripts\new-article.ps1 -Name "my-article" -Title "我的文章标题"
```

### 完整用法

```powershell
.\scripts\new-article.ps1 `
    -Name "llm-quant-strategy" `
    -Title "大语言模型在量化交易中的应用" `
    -Description "详细介绍如何利用LLM提升量化策略开发效率" `
    -Category "llms/quantization" `
    -Tags "LLM,Quant,Python,机器学习" `
    -Image "./images/my-cover.png"
```

### 参数说明

| 参数 | 必填 | 默认值 | 说明 |
|------|------|--------|------|
| `-Name` | ✅ | - | 文章文件名（英文，不含扩展名） |
| `-Title` | ✅ | - | 文章标题（中英文均可） |
| `-Description` | ❌ | 使用标题 | 文章描述，用于SEO |
| `-Category` | ❌ | `llms/quantization` | 分类路径 |
| `-Tags` | ❌ | `LLM,Quant` | 标签，逗号分隔 |
| `-Image` | ❌ | `../../blog_post.jpg` | 封面图路径 |

### 使用示例

#### 示例1：创建基础文章

```powershell
.\scripts\new-article.ps1 `
    -Name "my-first-article" `
    -Title "我的第一篇文章"
```

**生成的文件**：`src/content/blog/llms/quantization/my-first-article.mdx`

#### 示例2：指定详细信息

```powershell
.\scripts\new-article.ps1 `
    -Name "llm-tutorial" `
    -Title "LLM入门教程" `
    -Description "从零开始学习大语言模型" `
    -Tags "LLM,Tutorial,Python,AI"
```

#### 示例3：指定不同分类

```powershell
.\scripts\new-article.ps1 `
    -Name "model-training" `
    -Title "模型训练技巧" `
    -Category "llms/training"
```

**生成的文件**：`src/content/blog/llms/training/model-training.mdx`

#### 示例4：使用自定义封面图

```powershell
.\scripts\new-article.ps1 `
    -Name "advanced-strategy" `
    -Title "高级量化策略" `
    -Image "./images/advanced-strategy-cover.png"
```

---

## 🗑️ 删除文章 (remove-article.ps1)

### 基础用法

```powershell
# 删除文章（会提示确认）
.\scripts\remove-article.ps1 -Name "my-article"
```

### 高级用法

```powershell
# 强制删除，不显示确认
.\scripts\remove-article.ps1 -Name "my-article" -Force

# 只删除文章，保留图片
.\scripts\remove-article.ps1 -Name "my-article" -KeepImages

# 删除指定分类下的文章
.\scripts\remove-article.ps1 -Name "my-article" -Category "llms/training"
```

### 参数说明

| 参数 | 必填 | 默认值 | 说明 |
|------|------|--------|------|
| `-Name` | ✅ | - | 文章文件名（不含扩展名） |
| `-Category` | ❌ | `llms/quantization` | 分类路径 |
| `-Force` | ❌ | `false` | 强制删除，不显示确认 |
| `-KeepImages` | ❌ | `false` | 保留图片文件 |

### 使用示例

#### 示例1：安全删除（推荐）

```powershell
.\scripts\remove-article.ps1 -Name "my-article"
```

会显示：
- 文章信息
- 相关图片列表
- 确认提示

#### 示例2：快速删除

```powershell
.\scripts\remove-article.ps1 -Name "my-article" -Force
```

不显示确认，直接删除。

#### 示例3：只删除文章，保留图片

```powershell
.\scripts\remove-article.ps1 -Name "my-article" -KeepImages
```

适用于：图片被多篇文章共享的情况。

#### 示例4：删除其他分类的文章

```powershell
.\scripts\remove-article.ps1 -Name "old-tutorial" -Category "llms/training"
```

---

## 📋 完整工作流示例

### 场景1：创建和发布新文章

```powershell
# 1. 创建文章
.\scripts\new-article.ps1 `
    -Name "llm-best-practices" `
    -Title "LLM最佳实践指南" `
    -Description "总结LLM开发中的最佳实践和常见陷阱" `
    -Tags "LLM,Best-Practices,Tutorial"

# 2. 编辑文章
code src\content\blog\llms\quantization\llm-best-practices.mdx

# 3. 添加图片到
#    src\content\blog\llms\quantization\images\

# 4. 启动开发服务器预览
npm run dev

# 5. 访问 http://localhost:4321/blog/llms/quantization/llm-best-practices
```

### 场景2：删除过时文章

```powershell
# 1. 查看要删除的文章（带确认）
.\scripts\remove-article.ps1 -Name "old-article"

# 2. 确认信息后输入 'y' 删除

# 3. 重启开发服务器
npm run dev
```

### 场景3：批量操作

```powershell
# 创建一系列相关文章
$articles = @(
    @{Name="llm-intro"; Title="LLM简介"},
    @{Name="llm-training"; Title="LLM训练"},
    @{Name="llm-deployment"; Title="LLM部署"}
)

foreach ($article in $articles) {
    .\scripts\new-article.ps1 `
        -Name $article.Name `
        -Title $article.Title `
        -Tags "LLM,Tutorial"
}
```

---

## 🎯 常用分类路径

| 分类 | 路径 | 说明 |
|------|------|------|
| 量化相关 | `llms/quantization` | 模型量化、压缩 |
| 模型训练 | `llms/training` | 训练技巧、微调 |
| 模型推理 | `llms/inference` | 推理优化、部署 |
| 自定义 | `your/custom/path` | 自定义分类路径 |

---

## 💡 最佳实践

### 文章命名规范

✅ **推荐**：
- `llm-introduction.mdx`
- `quant-strategy-backtest.mdx`
- `2025-11-15-weekly-summary.mdx`

❌ **不推荐**：
- `文章1.mdx` - 避免中文
- `my article.mdx` - 避免空格
- `LLM-Introduction.mdx` - 使用小写

### 标签规范

**常用标签**：
```
LLM, GPT, Transformer, PyTorch, TensorFlow,
Quant, 量化交易, Python, Tutorial, Research,
机器学习, 深度学习, 数据分析
```

**标签原则**：
- 2-6个标签
- 混合使用中英文
- 包含技术栈标签
- 使用统一格式

### 图片管理

**命名规范**：
```
{文章名}-cover.png      # 封面图
{文章名}-fig1.png       # 第1张图
{文章名}-fig2.png       # 第2张图
{文章名}-chart.png      # 图表
{文章名}-diagram.png    # 架构图
```

**优化建议**：
- 封面图：1200x630px，< 500KB
- 内容图：适当压缩，< 300KB
- 使用 WebP 格式更佳

---

## ⚠️ 注意事项

1. **文章名称**：必须使用英文，推荐使用连字符分隔单词
2. **分类路径**：如果分类不存在，脚本会自动创建
3. **图片文件**：删除文章时，只会删除以文章名开头的图片
4. **缓存清理**：删除文章后建议重启开发服务器
5. **备份建议**：删除前建议先用 Git 提交，以便恢复

---

## 🔧 故障排除

### 问题1：脚本无法执行

**错误**：`无法加载脚本，因为在此系统上禁止运行脚本`

**解决**：
```powershell
# 临时允许脚本执行（当前会话）
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# 或永久允许（需要管理员权限）
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

### 问题2：文章创建后不显示

**可能原因**：
- 缓存问题
- Frontmatter 格式错误
- 开发服务器未重启

**解决**：
```powershell
# 清理缓存
Remove-Item -Path ".astro" -Recurse -Force

# 重启服务器
npm run dev
```

### 问题3：删除时找不到文章

**检查清单**：
1. 确认文章名称（不含 `.mdx` 扩展名）
2. 确认分类路径是否正确
3. 查看脚本输出的可用文章列表

---

## 📞 获取帮助

### 查看脚本帮助

```powershell
# 查看创建脚本帮助
Get-Help .\scripts\new-article.ps1 -Detailed

# 查看删除脚本帮助
Get-Help .\scripts\remove-article.ps1 -Detailed
```

### 相关文档

- **博客使用指南**：`BLOG-USAGE-GUIDE.md`
- **LLM/Quant专区指南**：`LLM-QUANT-BLOG-GUIDE.md`
- **模板文件**：`src/content/blog/llms/quantization/template.mdx`

---

**最后更新**：2025-11-15
