# PROTOTYPE - NOT FOR PRODUCTION
# Dựng và xuất sprite của game Trong trên Windows.
#   1) Mỗi art/maps/<id>.txt -> assets/sprites/<id>.aseprite   (bỏ qua bằng -SkipMaps khi đã vẽ tay trong Aseprite)
#   2) Mỗi assets/sprites/<id>.aseprite -> <id>.png + <id>.json
#   3) Gộp mọi JSON thành assets/sprites/sprites.js để mở game bằng file:// vẫn đọc được
# Chạy trong PowerShell, ở thư mục prototypes/trong:   .\art\export.ps1    (hoặc thêm -Aseprite "C:\...\Aseprite.exe")
# [CHƯA CHẠY THỬ: viết ở máy cloud không có Windows/Aseprite.]
param([string]$Aseprite = "", [switch]$SkipMaps)
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$maps = Join-Path $root "art\maps"
$dir = Join-Path $root "assets\sprites"
New-Item -ItemType Directory -Force -Path $dir | Out-Null

if (-not $Aseprite) {
  $cands = @("aseprite", "$env:ProgramFiles\Aseprite\Aseprite.exe",
    "${env:ProgramFiles(x86)}\Steam\steamapps\common\Aseprite\Aseprite.exe",
    "$env:ProgramFiles\Steam\steamapps\common\Aseprite\Aseprite.exe")
  foreach ($c in $cands) { $cmd = Get-Command $c -ErrorAction SilentlyContinue; if ($cmd) { $Aseprite = $cmd.Source; break } }
}
if (-not $Aseprite) { throw "Khong tim thay Aseprite. Chay lai voi -Aseprite 'C:\duong\dan\Aseprite.exe'" }
Write-Host "aseprite: $Aseprite"

if (-not $SkipMaps) {
  Get-ChildItem $maps -Filter *.txt -ErrorAction SilentlyContinue | ForEach-Object {
    $out = Join-Path $dir ($_.BaseName + ".aseprite")
    & $Aseprite -b --script-param "in=$($_.FullName)" --script-param "out=$out" --script (Join-Path $root "art\pixelmap.lua")
    if ($LASTEXITCODE -ne 0) { throw "pixelmap loi o $($_.Name)" }
  }
}

$js = @("// PROTOTYPE - NOT FOR PRODUCTION", "// Sinh tu dong boi art/export.ps1 tu assets/sprites/*.aseprite. Dung sua tay.", "window.SPRITES = window.SPRITES || {};")
Get-ChildItem $dir -Filter *.aseprite | ForEach-Object {
  $id = $_.BaseName
  $png = Join-Path $dir "$id.png"; $json = Join-Path $dir "$id.json"
  & $Aseprite -b $_.FullName --sheet $png --data $json --format json-array --list-tags --sheet-type horizontal
  if ($LASTEXITCODE -ne 0) { throw "Aseprite loi khi xuat $id" }
  $js += "window.SPRITES['$id'] = " + (Get-Content $json -Raw) + ";"
  Write-Host "exported $id"
}
[System.IO.File]::WriteAllText((Join-Path $dir "sprites.js"), ($js -join "`n"), (New-Object System.Text.UTF8Encoding $false))
Write-Host "wrote assets/sprites/sprites.js"
