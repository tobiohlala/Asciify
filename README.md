# Asciify

[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/Asciify.svg)](https://www.powershellgallery.com/packages/Asciify)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/cc2d46b1198e4484909af81fe17b3283)](https://www.codacy.com/app/off-world/Asciify?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=off-world/Asciify&amp;utm_campaign=Badge_Grade)

Convert Images to ASCII Pictures

<p float="left">
  <img src="https://i.imgur.com/E0psv5j.jpg" width="200" />
  <img src="https://i.imgur.com/MjvEsYi.png" />
</p>

## Description

Convert any image to ASCII picture by representing each pixels grayscale value as an ASCII character.
The higher the grayscale value the more space the corresponding ASCII character fills. Before being
processed the image will be cropped in memory to fit the consoles width or height.

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
