#!/usr/bin/env pwsh
<#
.SYNOPSIS
    删除博客文章及相关资源

.DESCRIPTION
    删除指定的博客文章及其相关图片资源

.PARAMETER Name
    文章文件名（不含扩展名），例如：my-article

.PARAMETER Category
    文章分类路径，默认为 "llms/quantization"

.PARAMETER Force
    强制删除，不显示确认提示

.PARAMETER KeepImages
    保留图片文件，只删除文章

.EXAMPLE
    .\scripts\remove-article.ps1 -Name "my-article"
    
.EXAMPLE
    .\scripts\remove-article.ps1 -Name "my-article" -Force

.EXAMPLE
    .\scripts\remove-article.ps1 -Name "my-article" -Category "llms/training"

.EXAMPLE
    .\scripts\remove-article.ps1 -Name "my-article" -KeepImages
#>

param(
    [Parameter(Mandatory=$true, HelpMessage="文章文件名（不含扩展名）")]
    [string]$Name,
    
    [Parameter(Mandatory=$true, HelpMessage="分类路径，如：llms/quantization, essay, competitive-programming")]
    [string]$Category,
    
    [Parameter(Mandatory=$false, HelpMessage="强制删除，不显示确认")]
    [switch]$Force,
    
    [Parameter(Mandatory=$false, HelpMessage="保留图片文件")]
    [switch]$KeepImages
)

# 构建文章路径
$articleDir = "src\content\blog\$Category"
$articlePath = "$articleDir\$Name.mdx"
$imagesDir = "$articleDir\images"

# 检查文章是否存在
if (-not (Test-Path $articlePath)) {
    Write-Host "❌ 错误：文章不存在 $articlePath" -ForegroundColor Red
    Write-Host ""
    Write-Host "💡 提示：" -ForegroundColor Yellow
    Write-Host "   检查文章名称和分类是否正确" -ForegroundColor White
    Write-Host "   当前查找路径：$articlePath" -ForegroundColor White
    
    # 列出该分类下的所有文章
    if (Test-Path $articleDir) {
        $existingArticles = Get-ChildItem -Path $articleDir -Filter "*.mdx" | Select-Object -ExpandProperty BaseName
        if ($existingArticles.Count -gt 0) {
            Write-Host ""
            Write-Host "📄 该分类下的文章列表：" -ForegroundColor Cyan
            $existingArticles | ForEach-Object { Write-Host "   - $_" -ForegroundColor White }
        }
    }
    
    exit 1
}

# 显示文章信息
Write-Host ""
Write-Host "📄 找到文章：" -ForegroundColor Cyan
Write-Host "   路径：$articlePath" -ForegroundColor White

# 读取文章内容以显示标题
try {
    $content = Get-Content -Path $articlePath -Raw
    if ($content -match 'title:\s*"([^"]+)"') {
        Write-Host "   标题：$($matches[1])" -ForegroundColor White
    }
} catch {
    # 忽略读取错误
}

# 查找相关图片
$relatedImages = @()
if (Test-Path $imagesDir) {
    $relatedImages = Get-ChildItem -Path $imagesDir -Filter "$Name*" -File
    if ($relatedImages.Count -gt 0) {
        Write-Host ""
        Write-Host "🖼️  找到相关图片 ($($relatedImages.Count) 个)：" -ForegroundColor Cyan
        $relatedImages | ForEach-Object { 
            Write-Host "   - $($_.Name) ($([math]::Round($_.Length/1KB, 2)) KB)" -ForegroundColor White 
        }
    }
}

# 确认删除
if (-not $Force) {
    Write-Host ""
    Write-Host "⚠️  警告：此操作将删除以下内容：" -ForegroundColor Yellow
    Write-Host "   ✓ 文章文件：$articlePath" -ForegroundColor White
    
    if ($relatedImages.Count -gt 0 -and -not $KeepImages) {
        Write-Host "   ✓ 相关图片：$($relatedImages.Count) 个文件" -ForegroundColor White
    } elseif ($KeepImages) {
        Write-Host "   ✗ 图片文件：将保留" -ForegroundColor Green
    }
    
    Write-Host ""
    $confirmation = Read-Host "确认删除吗？(y/N)"
    
    if ($confirmation -ne 'y' -and $confirmation -ne 'Y') {
        Write-Host ""
        Write-Host "❌ 操作已取消" -ForegroundColor Yellow
        exit 0
    }
}

# 删除文章
try {
    Remove-Item -Path $articlePath -Force
    Write-Host ""
    Write-Host "✅ 已删除文章：$articlePath" -ForegroundColor Green
    
    $deletedCount = 0
    
    # 删除相关图片
    if ($relatedImages.Count -gt 0 -and -not $KeepImages) {
        foreach ($image in $relatedImages) {
            try {
                Remove-Item -Path $image.FullName -Force
                Write-Host "✅ 已删除图片：$($image.Name)" -ForegroundColor Green
                $deletedCount++
            } catch {
                Write-Host "⚠️  删除图片失败：$($image.Name) - $($_.Exception.Message)" -ForegroundColor Yellow
            }
        }
    }
    
    Write-Host ""
    Write-Host "🎉 删除完成！" -ForegroundColor Green
    Write-Host ""
    Write-Host "📊 删除统计：" -ForegroundColor Cyan
    Write-Host "   文章：1 个" -ForegroundColor White
    if (-not $KeepImages -and $relatedImages.Count -gt 0) {
        Write-Host "   图片：$deletedCount / $($relatedImages.Count) 个" -ForegroundColor White
    }
    Write-Host ""
    
    # 提示清理缓存
    if (Test-Path ".astro") {
        Write-Host "💡 提示：如需立即生效，请重启开发服务器" -ForegroundColor Yellow
        Write-Host "   或运行：npm run dev" -ForegroundColor White
        Write-Host ""
    }
    
} catch {
    Write-Host ""
    Write-Host "❌ 删除失败：$($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
