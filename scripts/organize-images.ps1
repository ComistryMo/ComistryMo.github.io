#!/usr/bin/env pwsh
<#
.SYNOPSIS
    整理文章中的图片 - 自动将外部图片复制到正确位置并更新引用

.PARAMETER ArticlePath
    文章路径

.EXAMPLE
    .\scripts\organize-images.ps1 -ArticlePath "src\content\blog\llms\quantization\my-article.mdx"
#>

param(
    [Parameter(Mandatory=$true, HelpMessage="文章路径")]
    [string]$ArticlePath
)

if (-not (Test-Path $ArticlePath)) {
    Write-Host "❌ 文章不存在: $ArticlePath" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🖼️  整理文章图片" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host "📄 文章: $ArticlePath" -ForegroundColor White
Write-Host ""

# 获取文章所在目录和文章名
$articleDir = Split-Path -Parent $ArticlePath
$articleName = [System.IO.Path]::GetFileNameWithoutExtension($ArticlePath)
$imagesDir = Join-Path $articleDir "images"

# 创建images目录
if (-not (Test-Path $imagesDir)) {
    New-Item -ItemType Directory -Path $imagesDir -Force | Out-Null
}

# 读取文章内容
$content = Get-Content -Path $ArticlePath -Raw -Encoding UTF8
$newContent = $content

$imageCount = 0
$copiedCount = 0

Write-Host "🔍 扫描图片引用..." -ForegroundColor Cyan
Write-Host ""

# 处理frontmatter中的image字段
if ($content -match '(?m)^image:\s*["\x27]?([^"\x27\r\n]+)["\x27]?') {
    $imageValue = $matches[1].Trim()
    
    # 检查是否是外部绝对路径
    if ([System.IO.Path]::IsPathRooted($imageValue) -and (Test-Path $imageValue)) {
        Write-Host "📌 封面图（frontmatter）：" -ForegroundColor Yellow
        Write-Host "   原路径: $imageValue" -ForegroundColor Gray
        
        # 获取文件扩展名
        $ext = [System.IO.Path]::GetExtension($imageValue)
        $newName = "cover$ext"
        $newPath = Join-Path $imagesDir $newName
        
        # 复制文件
        Copy-Item -Path $imageValue -Destination $newPath -Force
        
        Write-Host "   ✅ 已复制到: $newPath" -ForegroundColor Green
        Write-Host "   新引用: ./images/$newName" -ForegroundColor Green
        
        # 更新引用
        $escapedOld = [regex]::Escape($imageValue).Replace('\', '\\')
        $newContent = $newContent -replace "(?m)^image:\s*[`"']?$escapedOld[`"']?", "image: `"./images/$newName`""
        
        $copiedCount++
        Write-Host ""
    }
}

# 处理Markdown图片引用 ![](...)
$pattern = '!\[([^\]]*)\]\(([^\)]+)\)'
$matches = [regex]::Matches($content, $pattern)

foreach ($match in $matches) {
    $imgPath = $match.Groups[2].Value.Trim()
    
    # 检查是否是外部绝对路径
    if ([System.IO.Path]::IsPathRooted($imgPath) -and (Test-Path $imgPath)) {
        $imageCount++
        Write-Host "📌 图片 $imageCount：" -ForegroundColor Yellow
        Write-Host "   原路径: $imgPath" -ForegroundColor Gray
        
        # 生成新文件名
        $ext = [System.IO.Path]::GetExtension($imgPath)
        $newName = "figure$imageCount$ext"
        $newPath = Join-Path $imagesDir $newName
        
        # 复制文件
        Copy-Item -Path $imgPath -Destination $newPath -Force
        
        Write-Host "   ✅ 已复制到: $newPath" -ForegroundColor Green
        Write-Host "   新引用: ./images/$newName" -ForegroundColor Green
        
        # 更新引用
        $escapedOld = [regex]::Escape($imgPath).Replace('\', '\\')
        $newContent = $newContent -replace [regex]::Escape($imgPath), "./images/$newName"
        
        $copiedCount++
        Write-Host ""
    }
}

# 如果有修改，更新原文件
if ($copiedCount -gt 0) {
    $newContent | Set-Content -Path $ArticlePath -Encoding UTF8 -NoNewline
    
    Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "✅ 完成！共处理 $copiedCount 张图片" -ForegroundColor Green
    Write-Host ""
    Write-Host "📁 图片目录: $imagesDir" -ForegroundColor White
    Write-Host "📄 文章已更新: $ArticlePath" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "ℹ️  未找到需要整理的外部图片" -ForegroundColor Gray
    Write-Host ""
}
