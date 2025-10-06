#!/bin/bash

# Script de despliegue automático para Flutter Web App (Frontend)
# Uso: ./deploy-frontend.sh

echo "🚀 Iniciando despliegue de Flutter Frontend..."

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Variables
CONTAINER_NAME="flutter-frontend"
IMAGE_NAME="app-flutter-frontend:latest"
PORT=3000
DOCKERFILE="Dockerfile.frontend"

# Función para verificar si Docker está instalado
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}❌ Docker no está instalado${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Docker encontrado${NC}"
}

# Función para detener contenedor anterior
stop_old_container() {
    if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
        echo -e "${YELLOW}⏹️  Deteniendo contenedor anterior...${NC}"
        docker stop $CONTAINER_NAME
        docker rm $CONTAINER_NAME
        echo -e "${GREEN}✅ Contenedor anterior eliminado${NC}"
    fi
}

# Función para eliminar imagen anterior
remove_old_image() {
    if [ "$(docker images -q $IMAGE_NAME)" ]; then
        echo -e "${YELLOW}🗑️  Eliminando imagen anterior...${NC}"
        docker rmi $IMAGE_NAME
        echo -e "${GREEN}✅ Imagen anterior eliminada${NC}"
    fi
}

# Función para construir imagen
build_image() {
    echo -e "${YELLOW}🔨 Construyendo imagen Docker...${NC}"
    if docker build -f $DOCKERFILE -t $IMAGE_NAME .; then
        echo -e "${GREEN}✅ Imagen construida exitosamente${NC}"
    else
        echo -e "${RED}❌ Error al construir la imagen${NC}"
        exit 1
    fi
}

# Función para ejecutar contenedor
run_container() {
    echo -e "${YELLOW}▶️  Ejecutando contenedor...${NC}"
    if docker run -d -p $PORT:80 --name $CONTAINER_NAME $IMAGE_NAME; then
        echo -e "${GREEN}✅ Contenedor ejecutándose en puerto $PORT${NC}"
    else
        echo -e "${RED}❌ Error al ejecutar el contenedor${NC}"
        exit 1
    fi
}

# Función para verificar estado
check_status() {
    echo -e "${YELLOW}🔍 Verificando estado...${NC}"
    if docker ps | grep -q $CONTAINER_NAME; then
        echo -e "${GREEN}✅ Aplicación corriendo correctamente${NC}"
        echo -e "${GREEN}🌐 Accede en: http://$(hostname -I | awk '{print $1}'):$PORT${NC}"
    else
        echo -e "${RED}❌ El contenedor no está corriendo${NC}"
        echo -e "${YELLOW}Ver logs con: docker logs $CONTAINER_NAME${NC}"
    fi
}

# Ejecutar funciones
check_docker
stop_old_container
remove_old_image
build_image
run_container
check_status

echo -e "${GREEN}🎉 Despliegue completado${NC}"
