function c {
    Clear-Host
}

function l {
    Get-ChildItem
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
