param(
    [string]$InputHtml = "js_spectrum.html",
    [string]$OutputHtml = "js_spectrum_single.html",
    [string]$CpuScript = "Z80.js",
    [string]$RomFile = "48.rom",
    [string]$KeyboardImage = "keyboard.jpg"
)

$ErrorActionPreference = "Stop"

function Replace-Strict {
    param(
        [string]$Content,
        [string]$Search,
        [string]$Replace,
        [string]$Label
    )

    if (-not $Content.Contains($Search)) {
        throw "Could not find expected block: $Label"
    }

    return $Content.Replace($Search, $Replace)
}

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
if ([string]::IsNullOrWhiteSpace($root)) {
    $root = (Get-Location).Path
}

$inputPath = Join-Path $root $InputHtml
$cpuPath = Join-Path $root $CpuScript
$romPath = Join-Path $root $RomFile
$keyboardPath = Join-Path $root $KeyboardImage
$outputPath = Join-Path $root $OutputHtml

$html = [System.IO.File]::ReadAllText($inputPath)
$z80 = [System.IO.File]::ReadAllText($cpuPath)
$romB64 = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($romPath))
$keyboardB64 = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($keyboardPath))
$tapDir = Join-Path $root "TAPs"
$embeddedTapMap = @{}
if (Test-Path $tapDir) {
    Get-ChildItem -Path $tapDir -File -Filter *.tap | Sort-Object Name | ForEach-Object {
        $relativeTapPath = "TAPs/" + $_.Name
        $embeddedTapMap[$relativeTapPath] = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($_.FullName))
    }
}
$embeddedTapJson = if ($embeddedTapMap.Count -gt 0) { $embeddedTapMap | ConvertTo-Json -Compress } else { "{}" }

$inlineZ80 = "<script>`r`n$z80`r`n</script>"
$html = Replace-Strict -Content $html -Search '<script src="Z80.js"></script>' -Replace $inlineZ80 -Label 'external Z80 script tag'
$html = Replace-Strict -Content $html -Search 'src="keyboard.jpg"' -Replace "src=`"data:image/jpeg;base64,$keyboardB64`"" -Label 'keyboard image source'
$html = Replace-Strict -Content $html -Search 'System Halted. Load ROM to begin.' -Replace 'Initializing embedded ROM...' -Label 'default status text'
$html = Replace-Strict -Content $html -Search 'const EMBEDDED_TAP_BASE64 = {};' -Replace "const EMBEDDED_TAP_BASE64 = $embeddedTapJson;" -Label 'embedded TAP map placeholder'

$romBootstrap = @"
const EMBEDDED_ROM_BASE64 = '$romB64';

function loadRomBytes(romBytes) {
    memory.fill(0);
    const maxRomSize = 0x4000;
    const copyLen = Math.min(romBytes.length, maxRomSize);
    memory.set(romBytes.subarray(0, copyLen), 0);
    initZ80();
}

function loadEmbeddedRom() {
    try {
        loadRomBytes(decodeBase64ToBytes(EMBEDDED_ROM_BASE64));
    } catch (err) {
        log('Failed to load embedded ROM: ' + err.message, 'error');
    }
}

"@

$html = Replace-Strict -Content $html -Search 'let animationFrameId;' -Replace "let animationFrameId;`r`n`r`n$romBootstrap" -Label 'animation frame declaration'
$html = Replace-Strict -Content $html -Search "r.onload = (ev) => { new Uint8Array(ev.target.result).forEach((b, i) => memory[i] = b); initZ80(); };" -Replace "r.onload = (ev) => { loadRomBytes(new Uint8Array(ev.target.result)); };" -Label 'ROM file handler'
$html = Replace-Strict -Content $html -Search "document.getElementById('btnReset').addEventListener('click', resetSystem);" -Replace "document.getElementById('btnReset').addEventListener('click', resetSystem);`r`nloadEmbeddedRom();" -Label 'startup bootstrap'

[System.IO.File]::WriteAllText($outputPath, $html, [System.Text.UTF8Encoding]::new($false))

Write-Host "Standalone file generated: $OutputHtml"
