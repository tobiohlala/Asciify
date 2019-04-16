# Copyright 2019 Tobias Heilig
#
# Redistribution and use in source and binary forms, with or without modification, are
# permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this list
# of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list
# of conditions and the following disclaimer in the documentation and/or other materials
# provided with the distribution.
# 3. Neither the name of the copyright holder nor the names of its contributors may be used
# to endorse or promote products derived from this software without specific prior written
# permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS
# OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
# OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


Add-Type -AssemblyName System.Drawing


<#
    .SYNOPSIS
    Convert image to ascii.

    .DESCRIPTION
    Convert any image to ascii picture by representing each pixels grayscale value as an ascii character.

    .PARAMETER Path
    The path to the image to process.

    .PARAMETER Resolution
    The amount of different ascii characters the grayscale values will be assigned to.

    .PARAMETER Width
    Set the width of the output ascii picture manually.

    .PARAMETER Height
    Set the height of the output ascii picture manually.

    .PARAMETER FitConsoleHeight
    Whether the output ascii picture should fit the console height instead of width. Only applicable if
    width and height are not explicitly specified.

    .PARAMETER Invert
    Whether the output ascii picture should be inverted. Use this on light console backgrounds
    for better results.

    .INPUTS
    System.IO.FileInfo
    System.String
    System.Int32

    .OUTPUTS
    System.String

    .COMPONENT
    GDI+

    .EXAMPLE
    Convert-ImageToAscii C:\Users\Bobby\Pictures\bobby-fischer.jpg

    .EXAMPLE
    Convert-ImageToAscii -Path C:\Users\Bobby\Pictures\bobby-fischer.jpg -Resolution Mid -FitConsoleHeight

    .EXAMPLE
    Convert-ImageToAscii -Path C:\Users\Bobby\Pictures\bobby-fischer.jpg -Width 120 -Height 80 -Invert

    .EXAMPLE
    Get-ChildItem C:\Users\Bobby\Pictures\*.jpg | Convert-ImageToAscii -FitConsoleHeight
#>
function Convert-ImageToAscii
{
    [Alias('i2a')]
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0, ValueFromPipeline)]
        [ValidateScript({ $PSItem | Test-Path -PathType Leaf })]
        [ValidateScript({ $PSItem.Extension -in '.bmp', '.gif', '.jpeg', '.jpg', '.png', '.tiff' })]
        [System.IO.FileInfo]
        $Path,

        [ValidateSet('Low', 'Mid', 'High')]
        [string]
        $Resolution='Low',

        [Parameter(Mandatory, ParameterSetName="SetDimensionsManually")]
        [ValidateRange(1, [int]::MaxValue)]
        [int]
        $Width,
        
        [Parameter(Mandatory, ParameterSetName="SetDimensionsManually")]
        [ValidateRange(1, [int]::MaxValue)]
        [int]
        $Height,

        [Parameter(ParameterSetName="SetDimensionsAutomatically")]
        [switch]
        $FitConsoleHeight,

        [switch]
        $Invert
    )

    begin {
        $symbols = $(if ($Invert.IsPresent) {
            @{
                Low  = '@#+. '
                Mid  = '@%#*+:,. '
                High = '@%#omCXxt?+~;:,. '
            }
        }
        else {
            @{
                Low  = ' .+#@'
                Mid  = ' .,:+*#%@'
                High = ' .,:;~+?txXCmo#%@'
            }
        })[$Resolution]
    }

    process {
        try {
            $img = [Drawing.Image]::FromFile($(Resolve-Path -Path $Path))

            [int]$w, [int]$h = switch ($PSCmdlet.ParameterSetName) {
                SetDimensionsManually {
                    ($Width / 2), $Height
                }

                SetDimensionsAutomatically {
                    @(($Host.UI.RawUI.WindowSize.Height * ($img.Width / $img.Height))
                    ($Host.UI.RawUI.WindowSize.Height - 4))
                }

                default {
                    @(($Host.UI.RawUI.WindowSize.Width / 2 - 1)
                    ($Host.UI.RawUI.WindowSize.Width / 2 / ($img.Width / $img.Height)))
                }
            }

            $bmp = [Drawing.Bitmap]::New($w, $h)
            $bmp.SetResolution($img.HorizontalResolution, $img.VerticalResolution)

            $rec = [Drawing.Rectangle]::New(0, 0, $w, $h)
            $wrapMode = [Drawing.Imaging.ImageAttributes]::New()
            $wrapMode.SetWrapMode([Drawing.Drawing2D.WrapMode]::TileFlipXY)

            $graphics                    = [Drawing.Graphics]::FromImage($bmp)
            $graphics.CompositingMode    = [Drawing.Drawing2D.CompositingMode]::SourceCopy
            $graphics.CompositingQuality = [Drawing.Drawing2D.CompositingQuality]::HighQuality
            $graphics.InterpolationMode  = [Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
            $graphics.SmoothingMode      = [Drawing.Drawing2D.SmoothingMode]::HighQuality
            $graphics.PixelOffsetMode    = [Drawing.Drawing2D.PixelOffsetMode]::HighQuality
            $graphics.DrawImage($img, $rec, 0, 0, $img.Width, $img.Height, [Drawing.GraphicsUnit]::Pixel, $wrapMode)

            $ascii = [System.Text.StringBuilder]::New()

            foreach ($y in 0..($bmp.Height-1))
            {
                foreach ($x in 0..($bmp.Width-1))
                {
                    $p = $bmp.GetPixel($x, $y)
                    $symbol = "$($symbols[[Math]::Floor((($p.R+$p.G+$p.B)/3)/(256/$symbols.Length))])" * 2
                    [void]$ascii.Append($symbol)
                }
                [void]$ascii.Append("`n")
            }

            $ascii.ToString()

        } finally {
            $wrapMode.Dispose()
            $graphics.Dispose()
            $bmp.Dispose()
            $img.Dispose()
        }
    }
}
