# Asciify

Convert Images to ASCII Pictures

<p float="left">
  <img src="https://i.imgur.com/E0psv5j.jpg" width="200" />
  <img src="https://i.imgur.com/cnRw6DO.png" width="230" /> 
  <img src="https://i.imgur.com/eZXcEb4.png" width="235" />
</p>

## Description

Convert any image to ASCII picture by representing each pixels grayscale value as an ASCII character.
The higher the grayscale value the more space the corresponding ASCII character fills. Before being
processed the image will be cropped in memory to fit the consoles width or height.

## Installation

Install from [PowerShell Gallery](https://www.powershellgallery.com/packages/Asciify/1.0)

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
