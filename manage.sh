#!/bin/bash

# Docker Compose Management Script
# Usage: ./manage.sh [command] [service]

SERVICES=("cloudflared" "openwebui" "portainer" "excalidraw" "affine" "docmost" "watchtower")

show_help() {
    echo "Docker Compose Management Script"
    echo "Usage: $0 [command] [service]"
    echo ""
    echo "Commands:"
    echo "  start-all     Start all services"
    echo "  stop-all      Stop all services"
    echo "  restart-all   Restart all services"
    echo "  start         Start specific service"
    echo "  stop          Stop specific service"
    echo "  restart       Restart specific service"
    echo "  logs          Show logs for specific service"
    echo "  status        Show status of all services"
    echo "  update        Update specific service"
    echo "  update-all    Update all services"
    echo ""
    echo "Services: ${SERVICES[*]}"
    echo ""
    echo "Examples:"
    echo "  $0 start-all"
    echo "  $0 start affine"
    echo "  $0 logs openwebui"
    echo "  $0 update-all"
}

start_all() {
    echo "Starting all services..."
    docker-compose -f docker-compose.main.yml up -d
}

stop_all() {
    echo "Stopping all services..."
    docker-compose -f docker-compose.main.yml down
}

restart_all() {
    echo "Restarting all services..."
    docker-compose -f docker-compose.main.yml restart
}

start_service() {
    local service=$1
    if [[ " ${SERVICES[@]} " =~ " ${service} " ]]; then
        echo "Starting $service..."
        cd $service && docker-compose up -d
        cd ..
    else
        echo "Service $service not found!"
        echo "Available services: ${SERVICES[*]}"
        exit 1
    fi
}

stop_service() {
    local service=$1
    if [[ " ${SERVICES[@]} " =~ " ${service} " ]]; then
        echo "Stopping $service..."
        cd $service && docker-compose down
        cd ..
    else
        echo "Service $service not found!"
        echo "Available services: ${SERVICES[*]}"
        exit 1
    fi
}

restart_service() {
    local service=$1
    if [[ " ${SERVICES[@]} " =~ " ${service} " ]]; then
        echo "Restarting $service..."
        cd $service && docker-compose restart
        cd ..
    else
        echo "Service $service not found!"
        echo "Available services: ${SERVICES[*]}"
        exit 1
    fi
}

show_logs() {
    local service=$1
    if [[ " ${SERVICES[@]} " =~ " ${service} " ]]; then
        echo "Showing logs for $service..."
        cd $service && docker-compose logs -f
        cd ..
    else
        echo "Service $service not found!"
        echo "Available services: ${SERVICES[*]}"
        exit 1
    fi
}

show_status() {
    echo "Docker containers status:"
    docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
}

update_service() {
    local service=$1
    if [[ " ${SERVICES[@]} " =~ " ${service} " ]]; then
        echo "Updating $service..."
        cd $service && docker-compose pull && docker-compose up -d
        cd ..
    else
        echo "Service $service not found!"
        echo "Available services: ${SERVICES[*]}"
        exit 1
    fi
}

update_all() {
    echo "Updating all services..."
    for service in "${SERVICES[@]}"; do
        echo "Updating $service..."
        cd $service && docker-compose pull && docker-compose up -d
        cd ..
    done
}

# Main script logic
case $1 in
    start-all)
        start_all
        ;;
    stop-all)
        stop_all
        ;;
    restart-all)
        restart_all
        ;;
    start)
        if [ -z "$2" ]; then
            echo "Please specify a service name"
            show_help
            exit 1
        fi
        start_service $2
        ;;
    stop)
        if [ -z "$2" ]; then
            echo "Please specify a service name"
            show_help
            exit 1
        fi
        stop_service $2
        ;;
    restart)
        if [ -z "$2" ]; then
            echo "Please specify a service name"
            show_help
            exit 1
        fi
        restart_service $2
        ;;
    logs)
        if [ -z "$2" ]; then
            echo "Please specify a service name"
            show_help
            exit 1
        fi
        show_logs $2
        ;;
    status)
        show_status
        ;;
    update)
        if [ -z "$2" ]; then
            echo "Please specify a service name"
            show_help
            exit 1
        fi
        update_service $2
        ;;
    update-all)
        update_all
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
