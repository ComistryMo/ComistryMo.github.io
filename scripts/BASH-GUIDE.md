# Bash 脚本使用指南

## 🚀 快速开始

在 **Git Bash** 或 **WSL** 中使用这些脚本。

### 方式一：统一入口（推荐）

```bash
# 创建新文章
./scripts/blog.sh new

# 删除文章
./scripts/blog.sh remove

# 列出所有文章
./scripts/blog.sh list

# 显示帮助
./scripts/blog.sh help
```

### 方式二：直接调用

```bash
# 创建新文章
bash scripts/new-article.sh

# 删除文章
bash scripts/remove-article.sh

# 列出文章
bash scripts/list-articles.sh
```

## 📝 创建新文章示例

运行 `./scripts/blog.sh new` 后：

```
📝 创建新文章
═══════════════════════════════════════

文章名称（英文，如：my-article）: algorithm-guide
文章标题（中英文均可）: 算法入门指南
文章描述（可选，按回车跳过）: 面向初学者的算法学习路线

现有分类：
  1. competitive-programming
  2. essay
  3. llms/quantization
  0. 输入新分类

选择分类（输入数字）: 1
标签（逗号分隔，如：LLM,Quant，可选）: Algorithm,Tutorial

🎉 文章创建成功！
```

## 🗑️ 删除文章示例

运行 `./scripts/blog.sh remove` 后：

```
🗑️  删除文章
═══════════════════════════════════════

现有文章：

📁 competitive-programming
   • algorithm-guide
   • dp-tutorial

要删除的文章名称: algorithm-guide

选择文章所在分类：
  1. competitive-programming
  2. essay

选择分类（输入数字）: 1

📄 找到文章：
   src/content/blog/competitive-programming/algorithm-guide.mdx

⚠️  警告：此操作将删除以下内容：
   ✓ 文章文件：src/content/blog/competitive-programming/algorithm-guide.mdx

确认删除吗？(y/N): y

✅ 已删除文章
🎉 删除完成！
```

## 💡 使用技巧

### 1. 在 Windows 上使用

**Git Bash（推荐）：**
```bash
# 在项目根目录打开 Git Bash
./scripts/blog.sh new
```

**WSL：**
```bash
# 在 WSL 中进入项目目录
cd /mnt/d/Obsidian_repo/Obsidian_repo/comistrymo_blog
./scripts/blog.sh new
```

### 2. 给脚本添加执行权限

如果遇到权限问题：

```bash
chmod +x scripts/*.sh
```

### 3. 分类路径示例

- 单级：`essay`, `tutorial`, `competitive-programming`
- 多级：`llms/quantization`, `llms/training`, `notes/algorithm`

### 4. 标签建议

```
常用英文标签：LLM, Quant, Python, Algorithm, Tutorial, Research
常用中文标签：算法, 教程, 研究, 笔记
```

## ⚙️ 脚本文件说明

| 文件 | 功能 |
|------|------|
| `blog.sh` | 统一入口脚本 |
| `new-article.sh` | 创建新文章 |
| `remove-article.sh` | 删除文章 |
| `list-articles.sh` | 列出所有文章 |

## 🐛 故障排除

### 问题1：脚本无法执行

**错误**：`Permission denied`

**解决**：
```bash
chmod +x scripts/*.sh
```

### 问题2：找不到bash命令

**Windows用户**：
- 安装 Git for Windows（自带 Git Bash）
- 或使用 WSL (Windows Subsystem for Linux)

### 问题3：日期格式错误

Git Bash 中如果 `date -r` 不工作，脚本会自动使用 `stat` 命令。

## 📚 相关文档

- **PowerShell脚本**：`README.md`（如果PowerShell可用）
- **完整文档**：`BLOG-USAGE-GUIDE.md`
- **项目总览**：根目录 `README.md`

---

**提示**：Bash脚本比PowerShell脚本更简单、更稳定，推荐在Git Bash中使用！
