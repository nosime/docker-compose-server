# Docker Compose Management Script for Windows PowerShell
# Usage: .\manage.ps1 [command] [service]

param(
    [Parameter(Position=0)]
    [string]$Command,
    
    [Parameter(Position=1)]
    [string]$Service
)

$Services = @("cloudflared", "openwebui", "portainer", "excalidraw", "affine", "docmost", "watchtower")

function Show-Help {
    Write-Host "Docker Compose Management Script" -ForegroundColor Green
    Write-Host "Usage: .\manage.ps1 [command] [service]" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Commands:" -ForegroundColor Cyan
    Write-Host "  start-all     Start all services"
    Write-Host "  stop-all      Stop all services"
    Write-Host "  restart-all   Restart all services"
    Write-Host "  start         Start specific service"
    Write-Host "  stop          Stop specific service"
    Write-Host "  restart       Restart specific service"
    Write-Host "  logs          Show logs for specific service"
    Write-Host "  status        Show status of all services"
    Write-Host "  update        Update specific service"
    Write-Host "  update-all    Update all services"
    Write-Host ""
    Write-Host "Services: $($Services -join ', ')" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Yellow
    Write-Host "  .\manage.ps1 start-all"
    Write-Host "  .\manage.ps1 start affine"
    Write-Host "  .\manage.ps1 logs openwebui"
    Write-Host "  .\manage.ps1 update-all"
}

function Start-AllServices {
    Write-Host "Starting all services..." -ForegroundColor Green
    docker-compose -f docker-compose.main.yml up -d
}

function Stop-AllServices {
    Write-Host "Stopping all services..." -ForegroundColor Yellow
    docker-compose -f docker-compose.main.yml down
}

function Restart-AllServices {
    Write-Host "Restarting all services..." -ForegroundColor Blue
    docker-compose -f docker-compose.main.yml restart
}

function Start-Service {
    param([string]$ServiceName)
    
    if ($Services -contains $ServiceName) {
        Write-Host "Starting $ServiceName..." -ForegroundColor Green
        Set-Location $ServiceName
        docker-compose up -d
        Set-Location ..
    } else {
        Write-Host "Service $ServiceName not found!" -ForegroundColor Red
        Write-Host "Available services: $($Services -join ', ')" -ForegroundColor Magenta
        exit 1
    }
}

function Stop-Service {
    param([string]$ServiceName)
    
    if ($Services -contains $ServiceName) {
        Write-Host "Stopping $ServiceName..." -ForegroundColor Yellow
        Set-Location $ServiceName
        docker-compose down
        Set-Location ..
    } else {
        Write-Host "Service $ServiceName not found!" -ForegroundColor Red
        Write-Host "Available services: $($Services -join ', ')" -ForegroundColor Magenta
        exit 1
    }
}

function Restart-Service {
    param([string]$ServiceName)
    
    if ($Services -contains $ServiceName) {
        Write-Host "Restarting $ServiceName..." -ForegroundColor Blue
        Set-Location $ServiceName
        docker-compose restart
        Set-Location ..
    } else {
        Write-Host "Service $ServiceName not found!" -ForegroundColor Red
        Write-Host "Available services: $($Services -join ', ')" -ForegroundColor Magenta
        exit 1
    }
}

function Show-Logs {
    param([string]$ServiceName)
    
    if ($Services -contains $ServiceName) {
        Write-Host "Showing logs for $ServiceName..." -ForegroundColor Cyan
        Set-Location $ServiceName
        docker-compose logs -f
        Set-Location ..
    } else {
        Write-Host "Service $ServiceName not found!" -ForegroundColor Red
        Write-Host "Available services: $($Services -join ', ')" -ForegroundColor Magenta
        exit 1
    }
}

function Show-Status {
    Write-Host "Docker containers status:" -ForegroundColor Cyan
    docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
}

function Update-Service {
    param([string]$ServiceName)
    
    if ($Services -contains $ServiceName) {
        Write-Host "Updating $ServiceName..." -ForegroundColor Green
        Set-Location $ServiceName
        docker-compose pull
        docker-compose up -d
        Set-Location ..
    } else {
        Write-Host "Service $ServiceName not found!" -ForegroundColor Red
        Write-Host "Available services: $($Services -join ', ')" -ForegroundColor Magenta
        exit 1
    }
}

function Update-AllServices {
    Write-Host "Updating all services..." -ForegroundColor Green
    foreach ($ServiceName in $Services) {
        Write-Host "Updating $ServiceName..." -ForegroundColor Yellow
        Set-Location $ServiceName
        docker-compose pull
        docker-compose up -d
        Set-Location ..
    }
}

# Main script logic
switch ($Command) {
    "start-all" {
        Start-AllServices
    }
    "stop-all" {
        Stop-AllServices
    }
    "restart-all" {
        Restart-AllServices
    }
    "start" {
        if ([string]::IsNullOrEmpty($Service)) {
            Write-Host "Please specify a service name" -ForegroundColor Red
            Show-Help
            exit 1
        }
        Start-Service $Service
    }
    "stop" {
        if ([string]::IsNullOrEmpty($Service)) {
            Write-Host "Please specify a service name" -ForegroundColor Red
            Show-Help
            exit 1
        }
        Stop-Service $Service
    }
    "restart" {
        if ([string]::IsNullOrEmpty($Service)) {
            Write-Host "Please specify a service name" -ForegroundColor Red
            Show-Help
            exit 1
        }
        Restart-Service $Service
    }
    "logs" {
        if ([string]::IsNullOrEmpty($Service)) {
            Write-Host "Please specify a service name" -ForegroundColor Red
            Show-Help
            exit 1
        }
        Show-Logs $Service
    }
    "status" {
        Show-Status
    }
    "update" {
        if ([string]::IsNullOrEmpty($Service)) {
            Write-Host "Please specify a service name" -ForegroundColor Red
            Show-Help
            exit 1
        }
        Update-Service $Service
    }
    "update-all" {
        Update-AllServices
    }
    { $_ -in @("help", "--help", "-h", "") } {
        Show-Help
    }
    default {
        Write-Host "Unknown command: $Command" -ForegroundColor Red
        Show-Help
        exit 1
    }
}
