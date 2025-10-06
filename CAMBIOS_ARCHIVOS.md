# 🔄 Archivos Renombrados para Convivir con API

## ✅ Cambios Realizados:

| Antes | Después | Motivo |
|-------|---------|--------|
| `Dockerfile` | `Dockerfile.frontend` | Evitar conflicto con Dockerfile del API |
| `deploy.sh` | `deploy-frontend.sh` | Distinguir del script de deploy del API |
| Contenedor: `flutter-app` | `flutter-frontend` | Nombre único para el contenedor |
| Imagen: `app-flutter-web` | `app-flutter-frontend` | Nombre único para la imagen |
| Puerto: `80` | `3000` | No conflictuar con API (puerto 8085) |

---

## 🚀 Comandos Actualizados:

### Para construir:
```bash
docker build -f Dockerfile.frontend -t app-flutter-frontend:latest .
```

### Para ejecutar:
```bash
docker run -d -p 3000:80 --name flutter-frontend app-flutter-frontend:latest
```

### Script automático:
```bash
chmod +x deploy-frontend.sh
./deploy-frontend.sh
```

---

## 🌐 Arquitectura Final:

```
Servidor Linux
├── 🔙 Backend API
│   ├── Puerto: 8085
│   ├── Contenedor: tu-api-container
│   ├── Dockerfile: (el que ya tienes)
│   └── deploy.sh: (el que ya tienes)
│
└── 🎨 Frontend Flutter
    ├── Puerto: 3000
    ├── Contenedor: flutter-frontend
    ├── Dockerfile: Dockerfile.frontend
    └── deploy: deploy-frontend.sh
```

---

## 📋 Archivos a subir por WinSCP:

```
✅ Dockerfile.frontend
✅ .dockerignore
✅ deploy-frontend.sh
✅ pubspec.yaml
✅ pubspec.lock
✅ lib/ (carpeta completa)
✅ web/ (carpeta completa)
✅ INSTRUCCIONES_DESPLIEGUE.md
✅ CHECKLIST_WINSCP.md
```

---

## 🎯 Acceso a la aplicación:

- **Frontend**: `http://tu-servidor:3000`
- **API**: `http://tu-servidor:8085` (ya existente)

---

## ✨ Ventajas de esta configuración:

1. ✅ No hay conflictos de nombres
2. ✅ Ambos servicios corren independientemente
3. ✅ Fácil actualización de cada uno por separado
4. ✅ Puertos diferentes evitan conflictos
5. ✅ Scripts con nombres descriptivos

---

## 🔍 Verificar ambos servicios:

```bash
docker ps

# Deberías ver algo como:
# CONTAINER ID   IMAGE                          PORTS                  NAMES
# abc123...      tu-api-image                   0.0.0.0:8085->8080    tu-api-container
# def456...      app-flutter-frontend:latest    0.0.0.0:3000->80      flutter-frontend
```

---

## 📝 Nota sobre CORS:

Si tienes problemas de CORS entre el frontend (puerto 3000) y el API (puerto 8085), necesitarás configurar el backend para permitir:

```
Access-Control-Allow-Origin: http://tu-servidor:3000
```

O usar un proxy inverso (Nginx/Apache) para servir ambos en el mismo dominio.
