# Docker Compose Server Setup

Cấu trúc thư mục đã được tách riêng cho từng ứng dụng để dễ quản lý và bảo trì.

## Cấu trúc thư mục

```
docker-compose-server/
├── affine/                 # AFFiNE workspace với PostgreSQL & Redis
│   └── docker-compose.yml
├── cloudflared/           # Cloudflare Tunnel
│   └── docker-compose.yml
├── docmost/               # Docmost documentation với PostgreSQL & Redis
│   └── docker-compose.yml
├── excalidraw/            # Excalidraw diagram tool
│   └── docker-compose.yml
├── openwebui/             # OpenWebUI interface
│   └── docker-compose.yml
├── portainer/             # Portainer Docker management
│   └── docker-compose.yml
├── watchtower/            # Watchtower auto-update
│   └── docker-compose.yml
├── opt/                   # Data volumes và persistent storage
│   ├── affine/
│   │   ├── config/
│   │   └── storage/
│   ├── docmost/
│   │   ├── data/
│   │   └── uploads/
│   ├── excalidraw/
│   │   └── drawings/
│   └── openwebui/
│       └── data/
├── docker-compose.yml     # File compose gốc (có thể giữ lại)
├── docker-compose.main.yml # File compose tổng để start tất cả
└── README.md
```

## Cách sử dụng

### 1. Chạy tất cả services cùng lúc

```bash
docker-compose -f docker-compose.main.yml up -d
```

### 2. Chạy từng service riêng biệt

#### Cloudflared (Chạy đầu tiên để tạo network)

```bash
cd cloudflared
docker-compose up -d
```

#### OpenWebUI

```bash
cd openwebui
docker-compose up -d
```

#### Portainer

```bash
cd portainer
docker-compose up -d
```

#### Excalidraw

```bash
cd excalidraw
docker-compose up -d
```

#### AFFiNE (bao gồm PostgreSQL, Redis, Migration và Main Server)

```bash
cd affine
docker-compose up -d
```

#### Docmost (bao gồm PostgreSQL, Redis và Main Server)

```bash
cd docmost
docker-compose up -d
```

#### Watchtower

```bash
cd watchtower
docker-compose up -d
```

### 3. Quản lý services

#### Xem logs của một service cụ thể

```bash
cd <service-folder>
docker-compose logs -f
```

#### Stop một service

```bash
cd <service-folder>
docker-compose down
```

#### Update một service

```bash
cd <service-folder>
docker-compose pull
docker-compose up -d
```

### 4. Quản lý volumes và data

Tất cả dữ liệu persistent được lưu trong thư mục `opt/`:

- `opt/openwebui/data/` - Dữ liệu OpenWebUI
- `opt/excalidraw/drawings/` - Drawings của Excalidraw
- `opt/affine/storage/` và `opt/affine/config/` - Dữ liệu AFFiNE
- `opt/docmost/data/` và `opt/docmost/uploads/` - Dữ liệu Docmost

## URLs truy cập

- OpenWebUI: http://localhost:3000 hoặc https://openwebui.nosime.org
- Portainer: https://localhost:9443 hoặc https://portainer.nosime.org
- Excalidraw: http://localhost:3001 hoặc https://excalidraw.nosime.org
- AFFiNE: http://localhost:3010 hoặc https://affine.nosime.org
- Docmost: http://localhost:3009 hoặc https://docmost.nosime.org

## Lưu ý

1. **Network**: Tất cả services sử dụng network `cloudflare_network`. Cloudflared tạo network này, các service khác kết nối vào network external.

2. **Dependencies**: Các service database (PostgreSQL, Redis) phải healthy trước khi main application start.

3. **Volumes**: Host volumes được mount từ thư mục `opt/` để dễ backup và quản lý.

4. **Security**: Tất cả services chỉ bind vào 127.0.0.1, chỉ truy cập được qua Cloudflare tunnel.

5. **Watchtower**: Tự động update containers hàng ngày lúc 86400 giây (24h).
