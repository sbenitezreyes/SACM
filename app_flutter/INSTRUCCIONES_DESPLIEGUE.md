# 📋 Instrucciones para Desplegar en Servidor

## 📁 Archivos a subir por WinSCP

Sube **TODA la carpeta del proyecto** al servidor, incluyendo:

### ✅ Archivos esenciales:
- `Dockerfile` (configuración de Docker)
- `.dockerignore` (archivos a ignorar)
- `pubspec.yaml` (dependencias)
- `pubspec.lock` (versiones bloqueadas)
- Carpeta `lib/` (código fuente completo)
- Carpeta `web/` (archivos web)
- Carpeta `android/` (configuración Android - opcional si solo web)

### ❌ NO subir (ya están en .dockerignore):
- `build/`
- `.dart_tool/`
- `.idea/`
- `.vscode/`
- `test/`

---

## 🚀 Comandos en PuTTY (Servidor Linux)

### 1. Conectarse al servidor
```bash
ssh usuario@tu-servidor.com
```

### 2. Navegar a la carpeta del proyecto
```bash
cd /ruta/donde/subiste/app_flutter
```

### 3. Construir la imagen Docker
```bash
docker build -t app-flutter-web:latest .
```

### 4. Ejecutar el contenedor
```bash
docker run -d -p 80:80 --name flutter-app app-flutter-web:latest
```

**O en otro puerto (ejemplo: 8080):**
```bash
docker run -d -p 8080:80 --name flutter-app app-flutter-web:latest
```

### 5. Verificar que está corriendo
```bash
docker ps
```

### 6. Ver logs (si hay problemas)
```bash
docker logs flutter-app
```

---

## 🔄 Actualizar la aplicación

Si haces cambios y quieres actualizar:

```bash
# 1. Detener y eliminar el contenedor anterior
docker stop flutter-app
docker rm flutter-app

# 2. Eliminar la imagen anterior (opcional)
docker rmi app-flutter-web:latest

# 3. Reconstruir con los nuevos archivos
docker build -t app-flutter-web:latest .

# 4. Ejecutar de nuevo
docker run -d -p 80:80 --name flutter-app app-flutter-web:latest
```

---

## 🌐 Acceder a la aplicación

Una vez ejecutado, accede desde el navegador:
- `http://IP-DEL-SERVIDOR` (si usaste puerto 80)
- `http://IP-DEL-SERVIDOR:8080` (si usaste puerto 8080)

---

## 🛠️ Comandos útiles

```bash
# Ver contenedores corriendo
docker ps

# Detener contenedor
docker stop flutter-app

# Iniciar contenedor
docker start flutter-app

# Reiniciar contenedor
docker restart flutter-app

# Ver logs en tiempo real
docker logs -f flutter-app

# Eliminar contenedor
docker rm flutter-app

# Ver imágenes
docker images

# Limpiar todo (contenedores e imágenes no usadas)
docker system prune -a
```

---

## ⚙️ Configuración del Backend API

Recuerda que la app apunta a: `http://3.142.93.102:8085`

Si necesitas cambiar la URL del backend, edita:
`lib/services/api_service.dart` línea 5

```dart
static const String baseUrl = 'http://TU-NUEVA-IP:PUERTO';
```

---

## 📝 Notas importantes

1. El Dockerfile usa `ghcr.io/cirruslabs/flutter:stable` (Flutter estable más reciente)
2. La aplicación se sirve con Nginx en el puerto 80 del contenedor
3. El build puede tardar 5-10 minutos la primera vez
4. Requiere Docker instalado en el servidor Linux
