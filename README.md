# 🐳 Docker Compose Server Stack

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/Docker-20.10+-blue.svg)](https://www.docker.com/)
[![Docker Compose](https://img.shields.io/badge/Docker%20Compose-2.0+-blue.svg)](https://docs.docker.com/compose/)

Modern containerized server stack with modular architecture, Docker Compose Profiles, and centralized environment management. Ready for production deployment with zero-configuration setup.

## 🚀 Quick Start

```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/docker-compose-server.git
cd docker-compose-server

# Setup environment
cp .env.example .env
# Edit .env with your values

# Create network and start all services
docker network create cloudflare_network
docker compose --profile all up -d
```

## 🏗️ Architecture

### Modular Structure
```
docker-compose-server/
├── 📄 docker-compose.yml          # Main compose with profiles & includes
├── 📄 .env / .env.example          # Global environment management
├── 📁 services/                   # Individual service configurations
│   ├── cloudflared/               # Cloudflare Tunnel (secure access)
│   ├── watchtower/               # Auto-update containers
│   ├── portainer/                # Docker management UI
│   ├── openwebui/                # AI chat interface
│   ├── excalidraw/               # Collaborative drawing
│   ├── affine/                   # Productivity suite (Notion alternative)
│   └── docmost/                  # Documentation platform
├── 📁 data/                      # Persistent data storage
└── 📁 shared/                    # Shared configurations
```

### Global Environment Design
- **Centralized configuration** in `.env` for common settings
- **Service-specific overrides** in `services/{name}/.env`
- **Secure secrets management** with `.gitignore` protection
- **Easy domain and email configuration** across all services

## 🎯 Services Overview

| Service | Purpose | Ports | Profile | External URL |
|---------|---------|-------|---------|--------------|
| **Cloudflared** | Secure tunnel proxy | - | `cloudflared` | All services |
| **Watchtower** | Auto-update containers | - | `watchtower` | - |
| **Portainer** | Docker management | `9443`, `8000` | `portainer` | `docker.domain.com` |
| **OpenWebUI** | AI chat interface | `3000` | `openwebui` | `ai.domain.com` |
| **Excalidraw** | Drawing & diagrams | `3001` | `excalidraw` | `draw.domain.com` |
| **AFFiNE** | Knowledge management | `3010` | `affine` | `affine.domain.com` |
| **Docmost** | Team documentation | `3009` | `docmost` | `docmost.domain.com` |

## ⚡ Docker Profiles Usage

### Start All Services
```bash
docker compose --profile all up -d
```

### Start Individual Services
```bash
# Infrastructure
docker compose --profile cloudflared up -d
docker compose --profile watchtower up -d

# Management
docker compose --profile portainer up -d

# Applications
docker compose --profile openwebui up -d
docker compose --profile excalidraw up -d
docker compose --profile affine up -d
docker compose --profile docmost up -d
```

### Start Service Groups
```bash
# Core infrastructure + Management
docker compose --profile cloudflared --profile portainer --profile watchtower up -d

# AI & Productivity stack
docker compose --profile openwebui --profile affine --profile excalidraw up -d

# Documentation stack
docker compose --profile docmost --profile excalidraw up -d
```

## 🔧 Configuration

### Global Environment Variables (`.env`)

```bash
# ===== PROJECT CONFIGURATION =====
TZ=Asia/Ho_Chi_Minh
COMPOSE_PROJECT_NAME=nosime_stack

# ===== CLOUDFLARE TUNNEL =====
CLOUDFLARE_TOKEN=your_cloudflare_tunnel_token

# ===== DOMAIN CONFIGURATION =====
BASE_DOMAIN=your-domain.com
AFFINE_DOMAIN=https://affine.your-domain.com
DOCMOST_DOMAIN=https://docmost.your-domain.com
OPENWEBUI_DOMAIN=https://ai.your-domain.com
EXCALIDRAW_DOMAIN=https://draw.your-domain.com
PORTAINER_DOMAIN=https://docker.your-domain.com

# ===== SHARED EMAIL CONFIGURATION =====
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_SECURE=true
MAIL_USER=your_email@gmail.com
MAIL_PASS=your_gmail_app_password
MAIL_FROM_ADDRESS=noreply@your-domain.com
MAIL_FROM_NAME=Your Service Name

# ===== DATABASE PASSWORDS =====
AFFINE_POSTGRES_PASSWORD=strong_random_password
DOCMOST_POSTGRES_PASSWORD=strong_random_password

# ===== APPLICATION SECRETS =====
OPENWEBUI_SECRET_KEY=your_openwebui_secret
AFFINE_SECRET_KEY=your_affine_secret
DOCMOST_SECRET_KEY=your_docmost_secret
DOCMOST_NEXTAUTH_SECRET=your_nextauth_secret
```

### Service-Specific Configuration

Each service can override global settings in `services/{name}/.env`:

```bash
# Example: services/affine/.env
POSTGRES_USER=affine
POSTGRES_DB=affine
DATABASE_URL=postgresql://affine:${AFFINE_POSTGRES_PASSWORD}@affine_postgres:5432/affine
AFFINE_SERVER_EXTERNAL_URL=${AFFINE_DOMAIN}
```

## 📋 Management Commands

### Service Management
```bash
# Start services
docker compose --profile SERVICE_NAME up -d

# Stop services
docker compose --profile SERVICE_NAME down

# Restart services
docker compose --profile SERVICE_NAME restart

# View logs
docker compose --profile SERVICE_NAME logs -f

# Check status
docker compose --profile all ps
```

### Maintenance
```bash
# Update images
docker compose --profile all pull

# Restart after update
docker compose --profile all up -d

# Clean unused resources
docker system prune -f
docker volume prune -f
```

### Configuration Validation
```bash
# Validate compose syntax
docker compose config

# Validate specific profile
docker compose --profile affine config

# Check environment variable resolution
docker compose --profile all config | grep -A5 environment
```

## 🔒 Security Features

### Network Security
- **Isolated network**: All services in dedicated `cloudflare_network`
- **Local binding**: Services bind to `127.0.0.1` only
- **Cloudflare Tunnel**: Secure external access without port exposure
- **No direct internet exposure** of application ports

### Environment Security
- **Centralized secrets** in protected `.env` file
- **Strong password generation** for databases
- **App-specific secret keys** for each service
- **Email configuration isolation** with shared SMTP settings

### Data Protection
- **Persistent volumes** with proper mount points
- **Backup-friendly structure** in `data/` directory
- **Database health checks** ensuring data integrity
- **Automated container updates** via Watchtower

## 📦 Backup & Restore

### Complete Backup
```bash
# Stop all services
docker compose --profile all down

# Create timestamped backup
tar -czf backup_$(date +%Y%m%d_%H%M%S).tar.gz data/

# Restart services
docker compose --profile all up -d
```

### Service-Specific Backup
```bash
# AFFiNE backup
docker compose --profile affine down
tar -czf affine_backup_$(date +%Y%m%d).tar.gz data/affine/
docker compose --profile affine up -d

# Docmost backup
docker compose --profile docmost down
tar -czf docmost_backup_$(date +%Y%m%d).tar.gz data/docmost/
docker compose --profile docmost up -d
```

### Database Backup
```bash
# AFFiNE database export
docker exec affine_postgres pg_dump -U affine -d affine > affine_db_backup.sql

# Docmost database export  
docker exec docmost_postgres pg_dump -U docmost -d docmost > docmost_db_backup.sql
```

### Restore Process
```bash
# Stop services
docker compose --profile all down

# Restore data
tar -xzf backup_20241201_143022.tar.gz

# Fix permissions (Linux/Mac)
sudo chown -R 1000:1000 data/

# Start services
docker compose --profile all up -d
```

## 🔍 Monitoring & Troubleshooting

### Health Checks
```bash
# Check running containers
docker ps

# View resource usage
docker stats

# Check service health
docker compose --profile all ps

# Service-specific health
docker inspect affine_postgres --format='{{.State.Health.Status}}'
```

### Log Analysis
```bash
# All services logs
docker compose --profile all logs -f

# Specific service logs
docker compose --profile affine logs -f

# Error filtering
docker compose --profile all logs | grep -i error

# Recent logs only
docker compose --profile all logs --tail=100 -f
```

### Common Issues

#### Network Issues
```bash
# Recreate network
docker network rm cloudflare_network
docker network create cloudflare_network

# Check network connectivity
docker exec openwebui ping affine_postgres
```

#### Permission Issues (Linux/Mac)
```bash
# Fix data directory permissions
sudo chown -R 1000:1000 data/
sudo chmod -R 755 data/

# Check current permissions
ls -la data/
```

#### Database Issues
```bash
# Check database status
docker compose --profile affine logs affine_postgres
docker compose --profile docmost logs docmost_postgres

# Reset database (⚠️ WILL DELETE DATA)
docker compose --profile affine down
rm -rf data/affine/postgres/*
docker compose --profile affine up -d
```

#### Service Won't Start
```bash
# Check specific service logs
docker compose --profile SERVICE_NAME logs

# Validate configuration
docker compose --profile SERVICE_NAME config

# Check port conflicts
netstat -tlnp | grep :3000
```

## 🚀 Advanced Usage

### Custom Service Addition

1. **Create service directory**
```bash
mkdir -p services/new-service
mkdir -p data/new-service
```

2. **Create docker-compose.yml**
```yaml
version: '3.8'

services:
  new-service:
    image: nginx:latest
    container_name: new_service
    restart: unless-stopped
    networks:
      - cloudflare_network
    ports:
      - "127.0.0.1:8080:80"
    volumes:
      - ../../data/new-service:/usr/share/nginx/html
    env_file:
      - ../../.env      # Global env
      - .env            # Service env
    profiles:
      - all
      - new-service

networks:
  cloudflare_network:
    external: true
```

3. **Add to main compose**
```yaml
# Add to docker-compose.yml include section
include:
  - ./services/new-service/docker-compose.yml
```

### Environment Overrides

Create environment-specific configurations:

```bash
# Development override
docker-compose.dev.yml

# Production override  
docker-compose.prod.yml

# Usage
docker compose -f docker-compose.yml -f docker-compose.prod.yml --profile all up -d
```

### Scaling Services

```bash
# Scale non-database services
docker compose --profile openwebui up -d --scale openwebui=2

# Scale with load balancer
docker compose --profile all up -d --scale excalidraw=3
```

## 📚 Service Documentation

### AFFiNE (Productivity Suite)
- **Purpose**: All-in-one workspace (Notion alternative)
- **Features**: Notes, whiteboards, databases
- **Access**: `http://localhost:3010`
- **Data**: `data/affine/`

### Docmost (Documentation Platform)
- **Purpose**: Team documentation and knowledge base
- **Features**: Wiki, collaborative editing
- **Access**: `http://localhost:3009`
- **Data**: `data/docmost/`

### OpenWebUI (AI Interface)
- **Purpose**: Chat interface for AI models
- **Features**: Multiple model support, conversation history
- **Access**: `http://localhost:3000`
- **Data**: `data/openwebui/`

### Excalidraw (Drawing Tool)
- **Purpose**: Collaborative whiteboarding
- **Features**: Real-time collaboration, export options
- **Access**: `http://localhost:3001`
- **Data**: `data/excalidraw/`

### Portainer (Docker Management)
- **Purpose**: Docker container management UI
- **Features**: Container, image, volume management
- **Access**: `https://localhost:9443`
- **Data**: `data/portainer/`

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

### Development Setup
```bash
# Clone for development
git clone https://github.com/YOUR_USERNAME/docker-compose-server.git
cd docker-compose-server

# Create development environment
cp .env.example .env.dev
# Edit .env.dev with development values

# Start development stack
docker compose --env-file .env.dev --profile all up -d
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Docker](https://www.docker.com/) for containerization platform
- [Docker Compose](https://docs.docker.com/compose/) for multi-container orchestration
- [Cloudflare](https://www.cloudflare.com/) for secure tunnel technology
- [AFFiNE](https://affine.pro/) for productivity suite
- [Docmost](https://docmost.com/) for documentation platform
- [OpenWebUI](https://openwebui.com/) for AI interface
- [Excalidraw](https://excalidraw.com/) for drawing tool
- [Portainer](https://www.portainer.io/) for Docker management
- [Watchtower](https://containrrr.dev/watchtower/) for automated updates

## 📞 Support

If you encounter any issues or have questions:

1. Check the [troubleshooting section](#-monitoring--troubleshooting)
2. Review service logs: `docker compose --profile SERVICE_NAME logs`
3. Validate configuration: `docker compose config`
4. Create an issue on GitHub with:
   - System information (OS, Docker version)
   - Error logs
   - Steps to reproduce

---

**⭐ Star this repository if it helped you build your containerized infrastructure!**

**🔄 Keep your services updated with automated Watchtower updates!**

**🛡️ Stay secure with Cloudflare Tunnel protection!**