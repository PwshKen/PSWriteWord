# Paragraph InsertParagraph()
# Paragraph InsertParagraph( int index, string text, bool trackChanges )
# Paragraph InsertParagraph( Paragraph p )
# Paragraph InsertParagraph( int index, Paragraph p )
# Paragraph InsertParagraph( int index, string text, bool trackChanges, Formatting formatting )
# Paragraph InsertParagraph( string text )
# Paragraph InsertParagraph( string text, bool trackChanges )
# Paragraph InsertParagraph( string text, bool trackChanges, Formatting formatting )

function Add-WordText {
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)][Xceed.Words.NET.Container]$WordDocument,
        [parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)][Xceed.Words.NET.InsertBeforeOrAfter] $Paragraph,
        [alias ("T")] [String[]]$Text,
        [alias ("C")] [System.Drawing.Color[]]$Color = @(),
        [alias ("S")] [double[]] $FontSize = @(),
        [alias ("FontName")] [string[]] $FontFamily = @(),
        [alias ("B")] [bool[]] $Bold = @(),
        [alias ("I")] [bool[]] $Italic = @(),
        [alias ("U")] [UnderlineStyle[]] $UnderlineStyle = @(),
        [alias ('UC')] [System.Drawing.Color[]]$UnderlineColor = @(),
        [alias ("SA")] [double[]] $SpacingAfter = @(),
        [alias ("SB")] [double[]] $SpacingBefore = @(),
        [alias ("SP")] [double[]] $Spacing = @(),
        [alias ("H")] [highlight[]] $Highlight = @(),
        [alias ("CA")] [CapsStyle[]] $CapsStyle = @(),
        [alias ("ST")] [StrikeThrough[]] $StrikeThrough = @(),
        [alias ("HT")] [HeadingType[]] $HeadingType = @(),
        $PercentageScale = @(), # "Value must be one of the following: 200, 150, 100, 90, 80, 66, 50 or 33"
        $Misc = @(),
        [string[]] $Language = @(),
        $Kerning = @(), # "Value must be one of the following: 8, 9, 10, 11, 12, 14, 16, 18, 20, 22, 24, 26, 28, 36, 48 or 72"
        $Hidden = @(),
        $Position = @(), #  "Value must be in the range -1585 - 1585"
        [bool[]] $NewLine = @(),
        [switch] $KeepLinesTogether,
        [switch] $KeepWithNextParagraph,
        [single[]] $IndentationFirstLine = @(),
        [single[]] $IndentationHanging = @(),
        [Alignment[]] $Alignment = @(),
        [Direction[]] $Direction = @(),
        [bool] $Supress = $true
    )
    if ($Text.Count -eq 0) { return }

    #if ($Paragraph -eq $null) {

    #}
    $p = $WordDocument.InsertParagraph()
    if ($Paragraph -ne $null) {
        $p = $Paragraph.InsertParagraphAfterSelf($p)
    }

    for ($i = 0; $i -lt $Text.Length; $i++) {
        if ($NewLine[$i] -ne $null -and $NewLine[$i] -eq $true) {
            if ($i -gt 0) {
                if ($Paragraph -ne $null) {
                    $p = $p.InsertParagraphAfterSelf()
                } else {
                    $p = $WordDocument.InsertParagraph()
                }
            }
            $p = $p.Append($Text[$i])
        } else {
            $p = $p.Append($Text[$i])
        }
        $p = $p | Set-WordTextColor -Color $Color[$i] -Supress $false
        $p = $p | Set-WordTextFontSize -FontSize $FontSize[$i] -Supress $false
        $p = $p | Set-WordTextFontFamily -FontFamily $FontFamily[$i] -Supress $false
        $p = $p | Set-WordTextBold -Bold $Bold[$i] -Supress $false
        $p = $p | Set-WordTextItalic -Italic $Italic[$i] -Supress $false

        if ($UnderlineStyle[$i] -ne $null) {
            $p = $p.UnderlineStyle($UnderlineStyle[$i])
        }
        if ($UnderlineColor[$i] -ne $null) {
            $p = $p.UnderlineColor($UnderlineColor[$i])
        }
        if ($SpacingAfter[$i] -ne $null) {
            $p = $p.SpacingAfter($SpacingAfter[$i])
        }
        if ($SpacingBefore[$i] -ne $null) {
            $p = $p.SpacingBefore($SpacingBefore[$i])
        }
        if ($SpacingBefore[$i] -ne $null) {
            $p = $p.SpacingBefore($SpacingBefore[$i])
        }
        if ($Spacing[$i] -ne $null) {
            $p = $p.Spacing($Spacing[$i])
        }
        if ($Highlight[$i] -ne $null) {
            $p = $p.Highlight($Highlight[$i])
        }
        if ($CapsStyle[$i] -ne $null) {
            $p = $p.CapsStyle($CapsStyle[$i])
        }
        if ($StrikeThrough[$i] -ne $null) {
            $p = $p.StrikeThrough($StrikeThrough[$i])
        }
        if ($PercentageScale[$i] -ne $null) {
            $p = $p.PercentageScale($PercentageScale[$i])
        }
        if ($Language[$i] -ne $null) {
            Write-Verbose "Add-WriteText - Setting language $($Language[$i])"
            $Culture = [System.Globalization.CultureInfo]::GetCultureInfo($Language[$i])
            $p = $p.Culture($Culture)
        }
        if ($Kerning[$i] -ne $null) {
            $p = $p.Kerning($Kerning[$i])
        }
        if ($PercentageScale[$i] -ne $null) {
            $p = $p.PercentageScale($PercentageScale[$i])
        }
        if ($Misc[$i] -ne $null) {
            $p = $p.Misc($Misc[$i])
        }
        if ($Position[$i] -ne $null) {
            $p = $p.Position($Position[$i])
        }
        if ($HeadingType[$i] -ne $null) {
            $p.StyleName = $HeadingType[$i]
        }
        if ($Alignment[$i] -ne $null) {
            $p.Alignment = $Alignment[$i]
        }
        if ($IndentationFirstLine[$i] -ne $null) {
            $p.IndentationFirstLine = $IndentationFirstLine[$i]
        }
        if ($IndentationHanging[$i] -ne $null) {
            $p.IndentationHanging = $IndentationHanging[$i]
        }
        if ($Direction[$i] -ne $null) {
            $p.Direction = $Direction[$i]
        }
    }

    if ($Supress) { return } else { return $p }
}

function Set-WordText {
    param(
        [parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)][Xceed.Words.NET.InsertBeforeOrAfter] $Paragraph,
        [alias ("C")] [nullable[System.Drawing.Color]]$Color,
        [alias ("S")] [nullable[double]] $FontSize,
        [alias ("FontName")] [string] $FontFamily,
        [alias ("B")] [nullable[bool]] $Bold,
        [alias ("I")] [nullable[bool]] $Italic,
        [alias ("U")] [UnderlineStyle[]] $UnderlineStyle = @(),
        [alias ('UC')] [System.Drawing.Color[]]$UnderlineColor = @(),
        [alias ("SA")] [double[]] $SpacingAfter = @(),
        [alias ("SB")] [double[]] $SpacingBefore = @(),
        [alias ("SP")] [double[]] $Spacing = @(),
        [alias ("H")] [highlight[]] $Highlight = @(),
        [alias ("CA")] [CapsStyle[]] $CapsStyle = @(),
        [alias ("ST")] [StrikeThrough[]] $StrikeThrough = @(),
        [alias ("HT")] [HeadingType[]] $HeadingType = @(),
        $PercentageScale = @(), # "Value must be one of the following: 200, 150, 100, 90, 80, 66, 50 or 33"
        $Misc = @(),
        [string[]] $Language = @(),
        $Kerning = @(), # "Value must be one of the following: 8, 9, 10, 11, 12, 14, 16, 18, 20, 22, 24, 26, 28, 36, 48 or 72"
        $Hidden = @(),
        $Position = @(), #  "Value must be in the range -1585 - 1585"
        [bool[]] $NewLine = @(),
        [switch] $KeepLinesTogether,
        [switch] $KeepWithNextParagraph,
        [single[]] $IndentationFirstLine = @(),
        [single[]] $IndentationHanging = @(),
        [Alignment[]] $Alignment = @(),
        [Direction[]] $Direction = @(),
        [bool] $Supress = $true
    )

    $Paragraph = $Paragraph | Set-WordTextColor -Color $Color -Supress $false
    $Paragraph = $Paragraph | Set-WordTextFontSize -FontSize $FontSize -Supress $false
    $Paragraph = $Paragraph | Set-WordTextFontFamily -FontFamily $FontFamily -Supress $false
    $Paragraph = $Paragraph | Set-WordTextBold -Bold $Bold -Supress $false
    $Paragraph = $Paragraph | Set-WordTextItalic -Italic $Italic -Supress $false
}

function Set-WordTextFontSize {
    param(
        [parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)][Xceed.Words.NET.InsertBeforeOrAfter] $Paragraph,
        [alias ("S")] [nullable[double]] $FontSize,
        [bool] $Supress = $true
    )
    if ($Paragraph -ne $null -and $FontSize -ne $null) {
        $Paragraph = $Paragraph.FontSize($FontSize)
    }
    if ($Supress) { return } else { return $Paragraph }
}

function Set-WordTextColor {
    param(
        [parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)][Xceed.Words.NET.InsertBeforeOrAfter] $Paragraph,
        [alias ("C")] [nullable[System.Drawing.Color]] $Color,
        [bool] $Supress = $true
    )
    if ($Paragraph -ne $null -and $Color -ne $null) {
        $Paragraph = $Paragraph.Color($Color)
    }
    if ($Supress) { return } else { return $Paragraph }
}

function Set-WordTextBold {
    param(
        [parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)][Xceed.Words.NET.InsertBeforeOrAfter] $Paragraph,
        [nullable[bool]] $Bold,
        [bool] $Supress = $true
    )
    if ($Paragraph -ne $null -and $Bold -ne $null -and $Bold -eq $true) {
        $Paragraph = $Paragraph.Bold()
    }
    if ($Supress) { return } else { return $Paragraph }
}

function Set-WordTextItalic {
    param(
        [parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)][Xceed.Words.NET.InsertBeforeOrAfter] $Paragraph,
        [nullable[bool]] $Italic,
        [bool] $Supress = $true
    )
    if ($Paragraph -ne $null -and $Italic -ne $null -and $Italic -eq $true) {
        $Paragraph = $Paragraph.Italic()
    }
    if ($Supress) { return } else { return $Paragraph }
}

function Set-WordTextFontFamily {
    param(
        [parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)][Xceed.Words.NET.InsertBeforeOrAfter] $Paragraph,
        [string] $FontFamily,
        [bool] $Supress = $true
    )
    if ($Paragraph -ne $null -and $FontFamily -ne $null -and $FontFamily -ne '') {
        $Paragraph = $Paragraph.Font($FontFamily)
    }
    if ($Supress) { return } else { return $Paragraph }
}