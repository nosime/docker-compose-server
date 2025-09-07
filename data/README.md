# Data Directory Structure

This directory contains persistent data for all Docker services. Each service has its own subdirectory to store application data, databases, and configuration files.

## 📁 Directory Structure

```
data/
├── openwebui/          # OpenWebUI application data
├── portainer/          # Portainer management data  
├── excalidraw/         # Excalidraw drawing tool data
│   ├── data/           # Application data
│   └── drawings/       # User drawings
├── affine/             # AFFiNE productivity suite
│   ├── storage/        # File storage
│   ├── config/         # Configuration files
│   ├── postgres/       # PostgreSQL database
│   └── redis/          # Redis cache
└── docmost/            # Docmost documentation platform
    ├── data/           # Application data
    ├── uploads/        # File uploads
    ├── postgres/       # PostgreSQL database
    └── redis/          # Redis cache
```

## �� Important Notes

- **Backup**: Always backup this directory before major updates
- **Permissions**: May need proper ownership (1000:1000) on Linux
- **Size**: Can grow large with user data and databases
- **Git**: Only `.gitkeep` files are tracked, actual data is ignored

## 📦 Backup Commands

```bash
# Backup all data
tar -czf backup_$(date +%Y%m%d).tar.gz data/

# Backup specific service
tar -czf affine_backup_$(date +%Y%m%d).tar.gz data/affine/
tar -czf docmost_backup_$(date +%Y%m%d).tar.gz data/docmost/
```

## 🔧 Restore Commands

```bash
# Stop all services first
docker compose --profile all down

# Restore data
tar -xzf backup_20241201.tar.gz

# Fix permissions (Linux/Mac)
sudo chown -R 1000:1000 data/

# Start services
docker compose --profile all up -d
```

## 🚨 Troubleshooting

### Permission Issues (Linux/Mac)
```bash
sudo chown -R 1000:1000 data/
sudo chmod -R 755 data/
```

### Disk Space Issues
```bash
# Check disk usage
du -sh data/*

# Clean old container data if needed
docker system prune -f
docker volume prune -f
```

### Database Issues
```bash
# Check database logs
docker compose --profile affine logs affine_postgres
docker compose --profile docmost logs docmost_postgres

# Reset database (⚠️ WILL DELETE ALL DATA)
rm -rf data/affine/postgres/*
rm -rf data/docmost/postgres/*
```
