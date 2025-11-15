#!/usr/bin/env pwsh
<#
.SYNOPSIS
    创建新的博客文章

.DESCRIPTION
    自动创建新的博客文章，生成MDX文件和必要的目录结构

.PARAMETER Name
    文章文件名（英文，不含扩展名），例如：llm-quant-strategy

.PARAMETER Title
    文章标题（中英文均可）

.PARAMETER Description
    文章描述，用于SEO和预览

.PARAMETER Category
    文章分类路径，默认为 "llms/quantization"
    其他选项：例如 "llms/training", "llms/inference" 等

.PARAMETER Tags
    文章标签，多个标签用逗号分隔，例如："LLM,Quant,Python"

.PARAMETER Image
    封面图路径，默认使用项目占位图

.EXAMPLE
    .\scripts\new-article.ps1 -Name "my-first-article" -Title "我的第一篇文章" -Description "这是一篇测试文章"

.EXAMPLE
    .\scripts\new-article.ps1 -Name "llm-tutorial" -Title "LLM入门教程" -Description "详细的LLM使用指南" -Tags "LLM,Tutorial,Python"

.EXAMPLE
    .\scripts\new-article.ps1 -Name "quant-strategy" -Title "量化策略分析" -Category "llms/quantization" -Tags "Quant,Strategy"
#>

param(
    [Parameter(Mandatory=$true, HelpMessage="文章文件名（英文，不含扩展名）")]
    [string]$Name,
    
    [Parameter(Mandatory=$true, HelpMessage="文章标题")]
    [string]$Title,
    
    [Parameter(Mandatory=$false, HelpMessage="文章描述")]
    [string]$Description = "",
    
    [Parameter(Mandatory=$true, HelpMessage="分类路径，如：llms/quantization, essay, competitive-programming")]
    [string]$Category,
    
    [Parameter(Mandatory=$false, HelpMessage="标签，用逗号分隔")]
    [string]$Tags = "",
    
    [Parameter(Mandatory=$false, HelpMessage="封面图路径")]
    [string]$Image = "../../blog_post.jpg"
)

# 获取今天的日期
$publishDate = Get-Date -Format "yyyy-MM-dd"

# 处理标签
if ([string]::IsNullOrWhiteSpace($Tags)) {
    $tagsFormatted = ""
} else {
    $tagsArray = $Tags -split ',' | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object { "`"$($_.Trim())`"" }
    $tagsFormatted = $tagsArray -join ', '
}

# 如果没有提供描述，使用标题
if ([string]::IsNullOrWhiteSpace($Description)) {
    $Description = $Title
}

# 构建文章路径
$articleDir = "src\content\blog\$Category"
$articlePath = "$articleDir\$Name.mdx"
$imagesDir = "$articleDir\images"

# 检查文章是否已存在
if (Test-Path $articlePath) {
    Write-Host "❌ 错误：文章已存在 $articlePath" -ForegroundColor Red
    exit 1
}

# 确保目录存在
if (-not (Test-Path $articleDir)) {
    New-Item -ItemType Directory -Path $articleDir -Force | Out-Null
    Write-Host "✅ 创建目录：$articleDir" -ForegroundColor Green
}

# 确保 images 目录存在
if (-not (Test-Path $imagesDir)) {
    New-Item -ItemType Directory -Path $imagesDir -Force | Out-Null
    Write-Host "✅ 创建图片目录：$imagesDir" -ForegroundColor Green
}

# 生成文章内容
$tagsLine = if ([string]::IsNullOrWhiteSpace($tagsFormatted)) { "" } else { "tags: [$tagsFormatted]" }
$content = @"
---
title: "$Title"
description: "$Description"
image: "$Image"
publishDate: "$publishDate"
$(if ($tagsLine) { $tagsLine })
---

# $Title

## 简介

在这里写文章的简介...

## 主要内容

### 章节 1

你的内容...

### 章节 2

你的内容...

## 代码示例

``````python
# 示例代码
def example():
    print("Hello, World!")
``````

## 总结

总结文章的要点...

## 参考资料

- [参考链接1](https://example.com)
- [参考链接2](https://example.com)
"@

# 写入文件
try {
    $content | Out-File -FilePath $articlePath -Encoding UTF8 -NoNewline
    Write-Host ""
    Write-Host "🎉 文章创建成功！" -ForegroundColor Green
    Write-Host ""
    Write-Host "📄 文章位置：" -ForegroundColor Cyan
    Write-Host "   $articlePath" -ForegroundColor White
    Write-Host ""
    Write-Host "📝 文章信息：" -ForegroundColor Cyan
    Write-Host "   标题：$Title" -ForegroundColor White
    Write-Host "   分类：$Category" -ForegroundColor White
    Write-Host "   标签：$Tags" -ForegroundColor White
    Write-Host "   日期：$publishDate" -ForegroundColor White
    Write-Host ""
    Write-Host "🖼️  图片目录：" -ForegroundColor Cyan
    Write-Host "   $imagesDir" -ForegroundColor White
    Write-Host ""
    Write-Host "🚀 下一步：" -ForegroundColor Yellow
    Write-Host "   1. 编辑文章：code $articlePath" -ForegroundColor White
    Write-Host "   2. 添加封面图到：$imagesDir" -ForegroundColor White
    Write-Host "   3. 启动开发服务器：npm run dev" -ForegroundColor White
    Write-Host "   4. 访问：http://localhost:4321/blog/$($Category.Replace('\', '/'))/$Name" -ForegroundColor White
    Write-Host ""
} catch {
    Write-Host "❌ 创建文章失败：$($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
