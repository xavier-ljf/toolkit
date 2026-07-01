try {
    # Update PSReadLine: Install-Module PSReadLine -Force
    Import-Module PSReadLine
    # Turn on tab completion
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
    # Turn on history search
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    # Turn on command suggestion
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle InlineView
} catch {
    # Ignore environments that do not support PSReadLine.
}

function c {
    Clear-Host
}

function l {
    Get-ChildItem
}

function o {
    explorer .
}

function proxy-on {
    param([string]$Proxy = "http://127.0.0.1:7897")
    $env:HTTP_PROXY = $Proxy
    $env:HTTPS_PROXY = $Proxy
    Write-Host "Proxy ON: $Proxy" -ForegroundColor Green
}

function proxy-off {
    Remove-Item Env:HTTP_PROXY, Env:HTTPS_PROXY -ErrorAction SilentlyContinue
    Write-Host "Proxy OFF" -ForegroundColor Yellow
}
