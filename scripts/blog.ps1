#!/usr/bin/env pwsh
<#
.SYNOPSIS
    博客管理工具 - 统一入口

.DESCRIPTION
    提供博客文章创建、删除、列表等功能的统一命令行工具

.PARAMETER Action
    操作类型：new, remove, list

.EXAMPLE
    .\scripts\blog.ps1 new
    .\scripts\blog.ps1 remove
    .\scripts\blog.ps1 list
#>

param(
    [Parameter(Position=0, HelpMessage="操作类型：new, remove, list, help")]
    [ValidateSet("new", "remove", "list", "help")]
    [string]$Action = "help"
)

$scriptDir = $PSScriptRoot

function Show-Help {
    Write-Host ""
    Write-Host "📝 博客管理工具" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "用法：" -ForegroundColor Yellow
    Write-Host "  .\scripts\blog.ps1 <action>" -ForegroundColor White
    Write-Host ""
    Write-Host "可用操作：" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  new       创建新文章" -ForegroundColor Green
    Write-Host "            示例：.\scripts\blog.ps1 new" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  remove    删除文章" -ForegroundColor Red
    Write-Host "            示例：.\scripts\blog.ps1 remove" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  list      列出所有文章" -ForegroundColor Cyan
    Write-Host "            示例：.\scripts\blog.ps1 list" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  help      显示此帮助信息" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "详细文档：" -ForegroundColor Yellow
    Write-Host "  .\scripts\README.md" -ForegroundColor White
    Write-Host ""
}

function Get-ExistingCategories {
    $blogDir = "src\content\blog"
    
    if (-not (Test-Path $blogDir)) {
        return @()
    }
    
    $categories = @()
    Get-ChildItem -Path $blogDir -Directory -Recurse | Where-Object { 
        $_.FullName -notmatch "images$" -and 
        (Get-ChildItem -Path $_.FullName -Filter "*.mdx" -File -ErrorAction SilentlyContinue).Count -gt 0
    } | ForEach-Object {
        $relPath = $_.FullName.Replace("$PWD\$blogDir\", "").Replace("\", "/")
        $categories += $relPath
    }
    
    return $categories | Sort-Object
}

function New-Article {
    Write-Host ""
    Write-Host "📝 创建新文章" -ForegroundColor Green
    Write-Host "═══════════════════════════════════════" -ForegroundColor Green
    Write-Host ""
    
    # 询问文章名称
    $name = Read-Host "文章名称（英文，如：my-article）"
    if ([string]::IsNullOrWhiteSpace($name)) {
        Write-Host "❌ 文章名称不能为空" -ForegroundColor Red
        return
    }
    
    # 询问标题
    $title = Read-Host "文章标题（中英文均可）"
    if ([string]::IsNullOrWhiteSpace($title)) {
        Write-Host "❌ 文章标题不能为空" -ForegroundColor Red
        return
    }
    
    # 询问描述（可选）
    $description = Read-Host "文章描述（可选，按回车跳过）"
    
    # 获取现有分类
    $existingCategories = Get-ExistingCategories
    
    # 询问分类
    Write-Host ""
    Write-Host "分类选项：" -ForegroundColor Cyan
    
    if ($existingCategories.Count -gt 0) {
        Write-Host "  现有分类：" -ForegroundColor Yellow
        for ($i = 0; $i -lt $existingCategories.Count; $i++) {
            Write-Host "    $($i + 1). $($existingCategories[$i])" -ForegroundColor White
        }
        Write-Host "    0. 输入新分类" -ForegroundColor White
        Write-Host ""
        $categoryChoice = Read-Host "选择分类（输入数字）"
        
        if ($categoryChoice -eq "0" -or [string]::IsNullOrWhiteSpace($categoryChoice)) {
            $category = Read-Host "输入分类路径（如：essay, competitive-programming, llms/training）"
        } else {
            $idx = [int]$categoryChoice - 1
            if ($idx -ge 0 -and $idx -lt $existingCategories.Count) {
                $category = $existingCategories[$idx]
            } else {
                Write-Host "❌ 无效的选择" -ForegroundColor Red
                return
            }
        }
    } else {
        Write-Host "  暂无现有分类，请创建新分类" -ForegroundColor Yellow
        Write-Host ""
        $category = Read-Host "输入分类路径（如：essay, competitive-programming, llms/quantization）"
    }
    
    if ([string]::IsNullOrWhiteSpace($category)) {
        Write-Host "❌ 分类不能为空" -ForegroundColor Red
        return
    }
    
    # 询问标签
    $tags = Read-Host "标签（逗号分隔，如：LLM,Quant,Python，可选）"
    
    # 构建参数
    $params = @{
        Name = $name
        Title = $title
        Category = $category
    }
    
    if (-not [string]::IsNullOrWhiteSpace($description)) {
        $params.Description = $description
    }
    
    if (-not [string]::IsNullOrWhiteSpace($tags)) {
        $params.Tags = $tags
    }
    
    # 调用创建脚本
    & "$scriptDir\new-article.ps1" @params
}

function Remove-Article {
    Write-Host ""
    Write-Host "🗑️  删除文章" -ForegroundColor Red
    Write-Host "═══════════════════════════════════════" -ForegroundColor Red
    Write-Host ""
    
    # 先列出文章
    List-Articles -Compact
    Write-Host ""
    
    # 询问文章名称
    $name = Read-Host "要删除的文章名称"
    if ([string]::IsNullOrWhiteSpace($name)) {
        Write-Host "❌ 文章名称不能为空" -ForegroundColor Red
        return
    }
    
    # 获取现有分类
    $existingCategories = Get-ExistingCategories
    
    if ($existingCategories.Count -eq 0) {
        Write-Host "❌ 未找到任何分类" -ForegroundColor Red
        return
    }
    
    # 询问分类
    Write-Host ""
    Write-Host "选择文章所在分类：" -ForegroundColor Cyan
    for ($i = 0; $i -lt $existingCategories.Count; $i++) {
        Write-Host "  $($i + 1). $($existingCategories[$i])" -ForegroundColor White
    }
    Write-Host ""
    $categoryChoice = Read-Host "选择分类（输入数字）"
    
    $idx = [int]$categoryChoice - 1
    if ($idx -lt 0 -or $idx -ge $existingCategories.Count) {
        Write-Host "❌ 无效的选择" -ForegroundColor Red
        return
    }
    
    $category = $existingCategories[$idx]
    
    # 调用删除脚本
    & "$scriptDir\remove-article.ps1" -Name $name -Category $category
}

function List-Articles {
    param([switch]$Compact)
    
    if (-not $Compact) {
        Write-Host ""
        Write-Host "📚 博客文章列表" -ForegroundColor Cyan
        Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
        Write-Host ""
    }
    
    $blogDir = "src\content\blog"
    
    if (-not (Test-Path $blogDir)) {
        Write-Host "❌ 博客目录不存在：$blogDir" -ForegroundColor Red
        return
    }
    
    $categories = Get-ChildItem -Path $blogDir -Directory -Recurse | Where-Object { 
        $_.FullName -notmatch "images$" 
    }
    
    $totalArticles = 0
    $categoriesWithArticles = @()
    
    foreach ($cat in $categories) {
        $articles = Get-ChildItem -Path $cat.FullName -Filter "*.mdx" -File
        
        if ($articles.Count -gt 0) {
            $relPath = $cat.FullName.Replace("$PWD\$blogDir\", "").Replace("\", "/")
            $categoriesWithArticles += @{
                Path = $relPath
                Articles = $articles
            }
            $totalArticles += $articles.Count
        }
    }
    
    if ($categoriesWithArticles.Count -eq 0) {
        Write-Host "暂无文章" -ForegroundColor Gray
        return
    }
    
    foreach ($catInfo in $categoriesWithArticles) {
        if (-not $Compact) {
            Write-Host ""
            Write-Host "📁 $($catInfo.Path)" -ForegroundColor Yellow
            Write-Host "   共 $($catInfo.Articles.Count) 篇文章" -ForegroundColor Gray
            Write-Host ""
        } else {
            Write-Host "📁 $($catInfo.Path)" -ForegroundColor Yellow
        }
        
        foreach ($article in $catInfo.Articles) {
            $name = $article.BaseName
            $size = [math]::Round($article.Length / 1KB, 1)
            $modified = $article.LastWriteTime.ToString("yyyy-MM-dd HH:mm")
            
            if ($Compact) {
                Write-Host "   • $name" -ForegroundColor White
            } else {
                Write-Host "   📄 $name" -ForegroundColor White
                Write-Host "      大小：$size KB | 修改：$modified" -ForegroundColor Gray
            }
        }
    }
    
    if (-not $Compact) {
        Write-Host ""
        Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
        Write-Host "共 $totalArticles 篇文章" -ForegroundColor Cyan
        Write-Host ""
    }
}

# 主逻辑
switch ($Action) {
    "new" {
        New-Article
    }
    "remove" {
        Remove-Article
    }
    "list" {
        List-Articles
    }
    "help" {
        Show-Help
    }
}
