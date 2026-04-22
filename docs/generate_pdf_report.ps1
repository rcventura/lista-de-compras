param(
  [string]$InputPath = "docs\analise_sistema_bloc.md",
  [string]$OutputPath = "docs\analise_sistema_bloc.pdf"
)

if (!(Test-Path -LiteralPath $InputPath)) {
  throw "Input file not found: $InputPath"
}

$raw = Get-Content -LiteralPath $InputPath -Raw
$raw = $raw -replace "`r`n", "`n"
$raw = $raw -replace "`r", "`n"

$plainLines = foreach ($line in ($raw -split "`n")) {
  $current = $line.TrimEnd()
  $current = $current -replace '^#{1,6}\s*', ''
  $current = $current -replace '^\-\s+', '- '
  $current
}

function Wrap-Line {
  param(
    [string]$Text,
    [int]$Width = 92
  )

  if ([string]::IsNullOrWhiteSpace($Text)) {
    return @("")
  }

  $words = $Text -split '\s+'
  $buffer = New-Object System.Collections.Generic.List[string]
  $current = ""

  foreach ($word in $words) {
    if ($current.Length -eq 0) {
      $current = $word
      continue
    }

    if (($current.Length + 1 + $word.Length) -le $Width) {
      $current = "$current $word"
    } else {
      $buffer.Add($current)
      $current = $word
    }
  }

  if ($current.Length -gt 0) {
    $buffer.Add($current)
  }

  return $buffer
}

$wrappedLines = New-Object System.Collections.Generic.List[string]
foreach ($line in $plainLines) {
  foreach ($wrapped in (Wrap-Line -Text $line -Width 92)) {
    $wrappedLines.Add($wrapped)
  }
}

$linesPerPage = 46
$pages = New-Object System.Collections.Generic.List[object]
for ($i = 0; $i -lt $wrappedLines.Count; $i += $linesPerPage) {
  $count = [Math]::Min($linesPerPage, $wrappedLines.Count - $i)
  $pages.Add($wrappedLines.GetRange($i, $count))
}

function Escape-PdfText {
  param([string]$Text)
  $value = $Text -replace '\\', '\\'
  $value = $value -replace '\(', '\('
  $value = $value -replace '\)', '\)'
  return $value
}

$objects = New-Object System.Collections.Generic.List[string]

$objects.Add("<< /Type /Catalog /Pages 2 0 R >>")

$kids = for ($p = 0; $p -lt $pages.Count; $p++) {
  "{0} 0 R" -f (3 + $p * 2)
}
$kidsText = [string]::Join(" ", $kids)
$objects.Add("<< /Type /Pages /Count $($pages.Count) /Kids [$kidsText] >>")

$fontObjectId = 3 + $pages.Count * 2

for ($pageIndex = 0; $pageIndex -lt $pages.Count; $pageIndex++) {
  $pageObjectId = 3 + $pageIndex * 2
  $contentObjectId = $pageObjectId + 1

  $contentLines = New-Object System.Collections.Generic.List[string]
  $contentLines.Add("BT")
  $contentLines.Add("/F1 10 Tf")
  $contentLines.Add("50 790 Td")
  $contentLines.Add("14 TL")

  foreach ($line in $pages[$pageIndex]) {
    $escaped = Escape-PdfText $line
    $contentLines.Add("($escaped) Tj")
    $contentLines.Add("T*")
  }

  $footer = "Pagina {0} de {1}" -f ($pageIndex + 1), $pages.Count
  $contentLines.Add("T*")
  $contentLines.Add("( $footer ) Tj")
  $contentLines.Add("ET")

  $streamContent = [string]::Join("`n", $contentLines)
  $streamLength = [System.Text.Encoding]::ASCII.GetByteCount($streamContent)

  $objects.Add("<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Resources << /Font << /F1 $fontObjectId 0 R >> >> /Contents $contentObjectId 0 R >>")
  $objects.Add("<< /Length $streamLength >>`nstream`n$streamContent`nendstream")
}

$objects.Add("<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>")

$builder = New-Object System.Text.StringBuilder
[void]$builder.Append("%PDF-1.4`n")

$offsets = New-Object System.Collections.Generic.List[int]
for ($index = 0; $index -lt $objects.Count; $index++) {
  $offsets.Add([System.Text.Encoding]::ASCII.GetByteCount($builder.ToString()))
  [void]$builder.Append(("{0} 0 obj`n{1}`nendobj`n" -f ($index + 1), $objects[$index]))
}

$xrefOffset = [System.Text.Encoding]::ASCII.GetByteCount($builder.ToString())
[void]$builder.Append("xref`n")
[void]$builder.Append(("0 {0}`n" -f ($objects.Count + 1)))
[void]$builder.Append("0000000000 65535 f `n")
foreach ($offset in $offsets) {
  [void]$builder.Append(("{0:0000000000} 00000 n `n" -f $offset))
}

[void]$builder.Append("trailer`n")
[void]$builder.Append(("<< /Size {0} /Root 1 0 R >>`n" -f ($objects.Count + 1)))
[void]$builder.Append("startxref`n")
[void]$builder.Append("$xrefOffset`n")
[void]$builder.Append("%%EOF")

$directory = Split-Path -Parent $OutputPath
if ($directory -and !(Test-Path -LiteralPath $directory)) {
  New-Item -ItemType Directory -Path $directory | Out-Null
}

$baseDirectory = if ($directory) { $directory } else { "." }
$resolvedBaseDirectory = (Resolve-Path -LiteralPath $baseDirectory).Path
$finalOutputPath = Join-Path $resolvedBaseDirectory (Split-Path -Leaf $OutputPath)

[System.IO.File]::WriteAllBytes(
  $finalOutputPath,
  [System.Text.Encoding]::ASCII.GetBytes($builder.ToString())
)

Write-Output "PDF generated at $OutputPath"
