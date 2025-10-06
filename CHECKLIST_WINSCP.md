# 📦 Checklist de Archivos para WinSCP

## ✅ SUBIR estos archivos/carpetas:

```
app_flutter/
├── 📄 Dockerfile.frontend           ⭐ ESENCIAL (renombrado para no conflictuar con API)
├── 📄 .dockerignore                 ⭐ ESENCIAL
├── 📄 pubspec.yaml                  ⭐ ESENCIAL
├── 📄 pubspec.lock                  ⭐ ESENCIAL
├── 📄 deploy-frontend.sh            🚀 Script automático (renombrado)
├── 📄 INSTRUCCIONES_DESPLIEGUE.md   📖 Guía
├── 📁 lib/                          ⭐ TODO el código fuente
│   ├── main.dart
│   ├── models/
│   ├── providers/
│   ├── screens/
│   ├── services/
│   └── theme/
├── 📁 web/                          ⭐ Archivos web
│   ├── index.html
│   ├── manifest.json
│   └── icons/
└── 📁 android/                      ⚠️ Opcional (solo si necesitas Android)
    └── app/
```

## ❌ NO SUBIR (ocupa espacio innecesario):

```
❌ build/              (se genera al compilar)
❌ .dart_tool/         (cache local)
❌ .idea/              (configuración IDE)
❌ .vscode/            (configuración VS Code)
❌ test/               (tests unitarios)
❌ windows/            (solo Windows)
❌ linux/              (solo Linux desktop)
❌ macos/              (solo macOS)
❌ ios/                (solo iOS - opcional)
```

---

## 🎯 Ruta recomendada en el servidor:

```bash
/home/usuario/apps/app_flutter/
```

O para producción:
```bash
/var/www/app_flutter/
```

---

## 🚀 PASOS RÁPIDOS:

### 1. Conectar WinSCP al servidor
- Host: tu-servidor.com
- Usuario: tu_usuario
- Puerto: 22 (SSH)

### 2. Crear carpeta en servidor
```bash
mkdir -p /home/usuario/apps/app_flutter
```

### 3. Subir archivos
- Arrastra toda la carpeta `app_flutter` desde Windows
- WinSCP transferirá solo los archivos necesarios (gracias a .dockerignore)

### 4. Conectar con PuTTY y ejecutar
```bash
cd /home/usuario/apps/app_flutter
chmod +x deploy-frontend.sh
./deploy-frontend.sh
```

---

## ⚡ Opción Manual (sin script):

```bash
cd /home/usuario/apps/app_flutter
docker build -f Dockerfile.frontend -t app-flutter-frontend:latest .
docker run -d -p 3000:80 --name flutter-frontend app-flutter-frontend:latest
```

**Nota:** Puerto 3000 para el frontend (tu API está en otro puerto)

---

## 📊 Tamaño aproximado de transferencia:

- **Con .dockerignore**: ~500 KB - 2 MB ✅
- **Sin .dockerignore**: ~100-200 MB ❌

Por eso es importante incluir el archivo `.dockerignore`

---

## 🔐 Permisos importantes:

Después de subir, ejecuta en PuTTY:
```bash
chmod +x deploy-frontend.sh
chmod 644 Dockerfile.frontend
chmod 644 .dockerignore
```
