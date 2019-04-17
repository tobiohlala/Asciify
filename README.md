# Asciify

[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/Asciify.svg)](https://www.powershellgallery.com/packages/Asciify)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/cc2d46b1198e4484909af81fe17b3283)](https://www.codacy.com/app/off-world/Asciify?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=off-world/Asciify&amp;utm_campaign=Badge_Grade)

Convert Images to ASCII Pictures

![preview](https://i.imgur.com/hVBnXGo.png)

## Description

Convert any image to ASCII picture by representing each pixels grayscale value as an ASCII character. The higher the grayscale value resp. the lighter the pixel the more space the corresponding ASCII character fills on the screen therefore reassembling the image well on dark console backgrounds with light font colors. On light console backgrounds with dark font colors use the `-Invert` switch to adjust. Before being processed the image will be resized in memory to make the resulting ASCII picture fit the console's width later on. To fit the console's height instead use the `-FitConsoleHeight` switch. Otherwise, if you don't want the resulting ASCII picture's dimensions determined by the script automatically at all you can specify a custom width and height using the `-Width` and `-Height` parameters. This can be useful when exporting ASCII pictures of custom sizes into textfiles, e.g (_Note:_ `i2a` is an Alias for `Convert-ImageToAscii`):
```PowerShell
gci .\bobby-fischer.jpg | i2a -Width 160 -Height 80 -Resolution Mid -Invert > .\bobby-fischer.txt
```
**Note:** `-Width` and `-Height` _must_ be specified manually when running the Cmdlet from PowerShell hosts not reporting its console dimensions like PowerShell ISE.

Furthermore, the Cmdlet supports three different resolutions regarding the resulting ASCII picture. These are `Low`, `Mid` and `High` and can be specified by the `-Resolution` parameter. On higher resolutions the resulting ASCII picture will be made up with more ASCII characters yielding a more fine-grained picture. Depending on the image a higher resolution sometimes may tend to look better especially when using smaller font sizes or bigger dimensions.

## Installation

Install from [PowerShell Gallery](https://www.powershellgallery.com/packages/Asciify)

```Powershell
Install-Module -Name Asciify
```

## Usage

```Powershell
Import-Module Asciify

Convert-ImageToAscii .\bobby-fischer.jpg
```

## Examples

```Powershell
Get-Help Convert-ImageToAscii -Examples
```
