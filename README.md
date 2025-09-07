# Docker Compose Server Stack

Modern containerized server stack với Docker Compose, Profiles và Global Environment management.

## 🏗️ Kiến trúc

```
project-root/
├── docker-compose.yml          # Main compose với profiles
├── .env                        # Global environment variables
├── .env.example               # Template cho .env
├── services/                  # Service configurations
│   ├── cloudflared/           # Cloudflare Tunnel
│   ├── watchtower/           # Auto-update containers  
│   ├── portainer/            # Docker management UI
│   ├── openwebui/            # AI chat interface
│   ├── excalidraw/           # Drawing tool
│   ├── affine/               # Productivity suite (Notion alternative)
│   └── docmost/              # Documentation platform
├── data/                     # Persistent data storage
└── shared/                   # Shared configurations
```

## �� Services

| Service | Purpose | URL | Profile |
|---------|---------|-----|---------|
| **Cloudflared** | Secure tunnel | - | `cloudflared` |
| **Watchtower** | Auto-update containers | - | `watchtower` |
| **Portainer** | Docker management | `:9443` | `portainer` |
| **OpenWebUI** | AI chat interface | `:3000` | `openwebui` |
| **Excalidraw** | Drawing tool | `:3001` | `excalidraw` |
| **AFFiNE** | Productivity suite | `:3010` | `affine` |
| **Docmost** | Documentation | `:3009` | `docmost` |

## ⚡ Quick Start

### 1. Clone và Setup
```bash
git clone <repo-url>
cd docker-compose-server

# Copy environment template
cp .env.example .env

# Edit với thông tin thực tế của bạn
nano .env
```

### 2. Tạo Network
```bash
docker network create cloudflare_network
```

### 3. Start Services

```bash
# Tất cả services
docker compose --profile all up -d

# Chỉ một service
docker compose --profile cloudflared up -d
docker compose --profile openwebui up -d

# Nhiều services
docker compose --profile cloudflared --profile portainer --profile openwebui up -d
```

## 🎯 Profiles

| Profile | Services | Use Case |
|---------|----------|----------|
| `all` | Tất cả services | Production deployment |
| `cloudflared` | Cloudflare Tunnel | Secure access |
| `watchtower` | Auto-updater | Maintenance |
| `portainer` | Docker UI | Management |
| `openwebui` | AI interface | AI workloads |
| `excalidraw` | Drawing tool | Diagrams |
| `affine` | Productivity stack | Knowledge management |
| `docmost` | Documentation stack | Team docs |

## 📋 Management Commands

### Service Management
```bash
# Start specific services
docker compose --profile affine up -d
docker compose --profile openwebui up -d

# Stop services  
docker compose --profile affine down
docker compose --profile all down

# View logs
docker compose --profile affine logs -f
docker compose --profile openwebui logs -f

# Check status
docker compose --profile all ps
```

### Maintenance
```bash
# Pull latest images
docker compose --profile all pull

# Restart services
docker compose --profile all restart

# Clean up
docker system prune -f
docker volume prune -f
```

## 🔧 Configuration

### Global Environment Variables
File `.env` chứa cấu hình chung cho tất cả services:

```bash
# Project
TZ=Asia/Ho_Chi_Minh
COMPOSE_PROJECT_NAME=your_project

# Cloudflare
CLOUDFLARE_TOKEN=your_token

# Domains
AFFINE_DOMAIN=https://affine.your-domain.com
DOCMOST_DOMAIN=https://docmost.your-domain.com

# Email (shared)
MAIL_HOST=smtp.gmail.com
MAIL_USER=your_email@gmail.com
MAIL_PASS=your_app_password

# Database passwords
AFFINE_POSTGRES_PASSWORD=strong_password
DOCMOST_POSTGRES_PASSWORD=strong_password
```

### Service-Specific Configuration
Mỗi service có file `.env` riêng trong thư mục `services/{service_name}/`:

- **Global env** (priority thấp): `../../.env`  
- **Service env** (override): `.env`

## 📊 Monitoring

### Health Checks
```bash
# Check running containers
docker ps

# View resource usage
docker stats

# Check logs
docker compose logs -f [service_name]
```

### Service URLs (Local)
- Portainer: http://localhost:9443
- OpenWebUI: http://localhost:3000  
- Excalidraw: http://localhost:3001
- AFFiNE: http://localhost:3010
- Docmost: http://localhost:3009

## �� Security

### Environment Protection
- File `.env` chứa thông tin nhạy cảm → **KHÔNG commit**
- Sử dụng `.env.example` làm template
- Passwords và tokens được centralized

### Network Security
- Tất cả services trong `cloudflare_network`
- External access qua Cloudflare Tunnel
- Local binding: `127.0.0.1` only

## 🛠️ Development

### Adding New Service
1. Tạo thư mục `services/new-service/`
2. Tạo `docker-compose.yml` với profiles
3. Tạo `.env` với config đặc biệt
4. Thêm vào main `docker-compose.yml`
5. Cập nhật global `.env` nếu cần

### Example Service Template
```yaml
version: '3.8'

services:
  new-service:
    image: nginx:latest
    container_name: new_service
    restart: unless-stopped
    networks:
      - cloudflare_network
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

## 📦 Backup & Restore

### Backup Data
```bash
# Backup tất cả data
tar -czf backup_$(date +%Y%m%d).tar.gz data/

# Backup specific service
tar -czf affine_backup_$(date +%Y%m%d).tar.gz data/affine/
```

### Restore Data
```bash
# Stop services
docker compose --profile all down

# Restore data
tar -xzf backup_20241201.tar.gz

# Start services
docker compose --profile all up -d
```

## 🐛 Troubleshooting

### Common Issues

**Network errors:**
```bash
docker network create cloudflare_network
```

**Permission errors:**
```bash
sudo chown -R 1000:1000 data/
```

**Config validation:**
```bash
docker compose config
```

**Service won't start:**
```bash
docker compose --profile service_name logs
```

## 📚 References

- [Docker Compose](https://docs.docker.com/compose/)
- [Docker Profiles](https://docs.docker.com/compose/profiles/)
- [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/)

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

**⚠️ Important:** Luôn backup data trước khi update hoặc thay đổi cấu hình!
