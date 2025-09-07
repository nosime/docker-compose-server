# copy-env-examples.ps1 - Copy all .env.example to .env files

Write-Host "Copy tất cả .env.example thành .env files..." -ForegroundColor Cyan

$services = @("cloudflared", "watchtower", "portainer", "openwebui", "excalidraw", "affine", "docmost")

foreach ($service in $services) {
    $examplePath = "services\$service\.env.example"
    $envPath = "services\$service\.env"
    
    if (Test-Path $examplePath) {
        Copy-Item $examplePath $envPath -Force
        Write-Host "✅ Copied: $envPath" -ForegroundColor Green
    } else {
        Write-Host "❌ Missing: $examplePath" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "🎯 Bước tiếp theo:" -ForegroundColor Yellow
Write-Host "1. Chỉnh sửa global .env với thông tin thực tế" -ForegroundColor White
Write-Host "2. Chỉnh sửa service .env nếu cần customize" -ForegroundColor White
Write-Host "3. docker compose config để kiểm tra" -ForegroundColor White
Write-Host "4. docker compose --profile all up -d" -ForegroundColor White
