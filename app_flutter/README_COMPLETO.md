# App Flutter — Sistema de Gestión Médica

Este documento es la documentación técnica y de referencia del proyecto. Contiene todo lo necesario para entender la arquitectura, las pantallas implementadas, los modelos de datos, los endpoints del API, cómo ejecutar y probar la app, y qué queda por hacer.

Tabla de contenido
- 1. Resumen ejecutivo
- 2. Comandos rápidos
- 3. Estado del proyecto (detalle por pantalla y archivo)
- 4. Estructura del proyecto
- 5. Modelos de datos (esquemas)
- 6. API — endpoints, payloads y respuestas de ejemplo
- 7. Arquitectura y flujo (diagrama ASCII)
- 8. Configuración / Entornos
- 9. Tests, lint y CI sugerido
- 10. Checklist de verificación y roadmap
- 11. Problemas comunes y debugging
- 12. Contribuir, issues y licencias

---

## 1. Resumen ejecutivo

Aplicación móvil en Flutter para gestionar pacientes, médicos y citas médicas. UI principal implementada, flujos básicos (crear/ver/borrar) presentes. Muchas peticiones a la API están simuladas para permitir desarrollo UI sin dependencia total del backend. Falta integración completa del token en cabeceras, validaciones, gestión avanzada de citas y notificaciones.

Estado breve:

| Área                     | Estado                     | Descripción                                              |
|--------------------------|----------------------------|----------------------------------------------------------|
| UI (pantallas principales) | ✅ Implementadas (básico) | Pantallas principales creadas con navegación básica      |
| Providers / Estado       | ✅ Parcial (ChangeNotifier) | Estado manejado con providers, actualizaciones dinámicas |
| ApiService (cliente HTTP)| ⚠️ Parcial / simulada      | Cliente HTTP con simulaciones para desarrollo            |
| Autenticación (login)    | ✅ Login + secure storage (token) | Login funcional con almacenamiento seguro               |
| Validaciones de formulario| ⚠️ Parcial                | Validaciones básicas, faltan reglas completas            |
| Tests                    | ⚠️ Mínimos / no completos  | Pruebas unitarias pendientes de ampliación               |

Diagrama de estado general:

```
Estado Actual del Proyecto
├── UI: ✅ Básico
├── Estado: ✅ Parcial
├── API: ⚠️ Simulado
├── Auth: ✅ Completo
├── Validaciones: ⚠️ Parcial
└── Tests: ⚠️ Mínimos
```

---

## 2. Comandos rápidos

Abre una terminal en la carpeta del proyecto y ejecuta:

```bat
REM Instala dependencias
flutter pub get

REM Corre la app en el emulador/dispositivo conectado
flutter run

REM Corre la app en el navegador
flutter run -d web-server

REM Corre tests (cuando haya tests implementados)
flutter test

REM Corre analyzer
flutter analyze
```

Recomendación: usa un canal estable de Flutter y abre un emulador Android/iOS o un dispositivo físico.

---

## 3. Estado del proyecto (detalle por pantalla y archivo)

Tabla que relaciona pantallas con archivos y estado actual. Marca `Simulado` si usa datos de prueba en lugar del API en el código.

| Pantalla               | Archivo (sugerido)               | Estado                     | Notas                                | Simulado |
|------------------------|----------------------------------|----------------------------|--------------------------------------|----------|
| Home                  | `lib/screens/home_page.dart`    | ✅ Implementada            | Navegación central                   | No       |
| Lista Pacientes       | `lib/screens/patients_page.dart`| ✅ Implementada            | Soporta borrado; puede usar simulación| Sí/No*   |
| Crear Paciente        | `lib/screens/create_patient_page.dart` | ⚠️ Implementada (parcial) | Validación de campos básica; falta reglas completas | No |
| Detalle Paciente      | `lib/screens/patient_details_page.dart` | ✅ Implementada | Muestra datos básicos | No |
| Lista Médicos         | `lib/screens/doctors_page.dart` | ✅ Implementada | Refresco con `setState`/provider | Sí |
| Crear Médico          | `lib/screens/create_doctor_page.dart` | ⚠️ Parcial | Formulario básico | Sí |
| Lista Citas           | `lib/screens/appointments_page.dart` | ⚠️ Parcial | Presentación básica | Sí |
| Crear Cita            | `lib/screens/create_appointment_page.dart` | ✅ Implementada | Selección fecha/hora; simulación de creación | Sí |
| Login                 | `lib/screens/login_page.dart` | ✅ Implementada | Guarda token en `flutter_secure_storage` | No |

Notas: revisa cada archivo para comentarios de `TODO` y `SIMULATED` que indican qué partes están pendientes.

Diagrama de pantallas y navegación:

```
HomePage
├── PatientsPage ──► CreatePatientPage
│   └── PatientDetailsPage
├── DoctorsPage ──► CreateDoctorPage
├── AppointmentsPage ──► CreateAppointmentPage
└── LoginPage (si no autenticado)
```

---

Notas: revisa cada archivo para comentarios de `TODO` y `SIMULATED` que indican qué partes están pendientes.

---

## 4. Estructura del proyecto (archivo/propósito)

Tabla resumida de carpetas y archivos relevantes (rutas relativas desde la raíz del proyecto):

| Ruta                          | Propósito                          | Estado                     |
|-------------------------------|-------------------------------------|----------------------------|
| `lib/main.dart`               | Punto de entrada, rutas y configuración inicial | ✅ Implementado |
| `lib/screens/home_page.dart`  | Pantalla principal de navegación   | ✅ Implementada            |
| `lib/screens/patients_page.dart` | Lista de pacientes               | ✅ Implementada            |
| `lib/screens/create_patient_page.dart` | Formulario crear paciente | ⚠️ Parcial |
| `lib/screens/patient_details_page.dart` | Detalles de paciente      | ✅ Implementada |
| `lib/screens/doctors_page.dart` | Lista de médicos                 | ✅ Implementada |
| `lib/screens/create_doctor_page.dart` | Formulario crear médico    | ⚠️ Parcial |
| `lib/screens/appointments_page.dart` | Lista de citas             | ⚠️ Parcial |
| `lib/screens/create_appointment_page.dart` | Formulario crear cita   | ✅ Implementada |
| `lib/screens/login_page.dart` | Pantalla de login                 | ✅ Implementada |
| `lib/models/patient.dart`     | Modelo de datos para pacientes     | ✅ Implementado |
| `lib/models/doctor.dart`      | Modelo de datos para médicos       | ⚠️ Pendiente |
| `lib/models/appointment.dart` | Modelo de datos para citas         | ⚠️ Pendiente |
| `lib/models/auth_response.dart` | Modelo de respuesta de autenticación | ✅ Implementado |
| `lib/providers/patient_provider.dart` | Provider para estado de pacientes | ✅ Implementado |
| `lib/services/api_service.dart` | Cliente HTTP centralizado         | ⚠️ Parcial |
| `lib/services/auth_service.dart` | Servicio de autenticación        | ⚠️ Parcial |
| `lib/widgets/`                | Widgets reutilizables              | ⚠️ Pendiente |
| `test/`                       | Pruebas unitarias/widget           | ⚠️ Mínimas |

Si alguna ruta no existe exactamente, usa el nombre como referencia y localiza el archivo real en el proyecto.

Diagrama de estructura de carpetas:

```
lib/
├── main.dart
├── screens/
│   ├── home_page.dart
│   ├── patients_page.dart
│   ├── create_patient_page.dart
│   ├── patient_details_page.dart
│   ├── doctors_page.dart
│   ├── create_doctor_page.dart
│   ├── appointments_page.dart
│   ├── create_appointment_page.dart
│   └── login_page.dart
├── models/
│   ├── patient.dart
│   ├── doctor.dart
│   ├── appointment.dart
│   └── auth_response.dart
├── providers/
│   └── patient_provider.dart
├── services/
│   ├── api_service.dart
│   └── auth_service.dart
└── widgets/
    └── (pendiente)
```

---

## 5. Modelos de datos (esquemas)

Modelos principales con campos esperados (ajusta según tu backend):

Pacientes (Patient)

| Campo       | Tipo             | Requerido | Descripción                  | Ejemplo               |
|-------------|------------------|-----------|------------------------------|-----------------------|
| id          | int / String     | sí        | Identificador único          | 101                   |
| name        | string           | sí        | Nombre                       | "Juan"               |
| lastName    | string           | no        | Apellido                     | "Perez"              |
| dni         | string           | no        | Documento de identidad       | "12345678"           |
| phone       | string           | no        | Teléfono                     | "+541112345678"      |
| email       | string           | no        | Correo electrónico           | "juan@example.com"   |
| birthDate   | string (ISO)     | no        | Fecha de nacimiento          | "1980-01-01"         |

Doctor (Doctor)

| Campo       | Tipo             | Requerido | Descripción                  | Ejemplo               |
|-------------|------------------|-----------|------------------------------|-----------------------|
| id          | int / String     | sí        | Identificador                | 201                   |
| name        | string           | sí        | Nombre                       | "Dr. Smith"          |
| specialty   | string           | no        | Especialidad                 | "Cardiology"         |
| phone       | string           | no        | Teléfono                     | "+541112345678"      |

Cita (Appointment)

| Campo       | Tipo             | Requerido | Descripción                  | Ejemplo               |
|-------------|------------------|-----------|------------------------------|-----------------------|
| id          | int / String     | sí        | Identificador                | 301                   |
| patientId   | int / String     | sí        | FK -> Patient                | 1                     |
| doctorId    | int / String     | sí        | FK -> Doctor                 | 1                     |
| startAt     | string (ISO)     | sí        | Fecha/hora inicio            | "2023-10-01T10:00:00Z" |
| endAt       | string (ISO)     | no        | Fecha/hora fin               | "2023-10-01T11:00:00Z" |
| status      | string           | sí        | pending, confirmed, cancelled, completed | "pending" |

AuthResponse

| Campo | Tipo | Descripción | Ejemplo |
|---|---|---|---|
| token | string | JWT o token bearer | "jwt_token_here" |
| user | object | Información del usuario autenticado (id, nombre, rol) | { "id": 1, "name": "Admin", "role": "admin" }

Diagrama de relaciones de modelos:

```
Patient ────┐
           │
           ├── Appointment ─── Doctor
           │
AuthResponse ─── User
```

---

---

## 6. API — endpoints, payloads y ejemplos

Base URL: configura `baseUrl` en `lib/services/api_service.dart`.

Endpoints resumidos (tabla detallada):

| Método | Endpoint                  | Requiere Auth | Request Body (ejemplo)                                                                 | Response (ejemplo)                                                                 | Estado en App             |
|--------|---------------------------|---------------|---------------------------------------------------------------------------------------|------------------------------------------------------------------------------------|---------------------------|
| GET    | `/api/v1/patients`        | Sí            | —                                                                                     | `200: [{ "id": 1, "name": "Juan", ... }]`                                      | ✅ Implementado (simulado) |
| POST   | `/api/v1/patients`        | Sí            | `{ "name": "Juan", "lastName": "Perez", "dni": "12345678", "phone": "+541112345678", "email": "juan@example.com", "birthDate": "1980-01-01" }` | `201: { "id": 101, ... }`                                                        | ✅ Implementado (simulado) |
| DELETE | `/api/v1/patients/{id}`   | Sí            | —                                                                                     | `204: No Content`                                                                  | ✅ Implementado (simulado) |
| GET    | `/api/v1/doctors`         | Sí            | —                                                                                     | `200: [{ "id": 1, "name": "Dr. Smith", "specialty": "Cardiology" }]`       | ✅ Implementado (simulado) |
| POST   | `/api/v1/doctors`         | Sí            | `{ "name": "Dr. Smith", "specialty": "Cardiology", "phone": "+541112345678" }` | `201: { "id": 201, ... }`                                                        | ⚠️ Parcial (simulado)      |
| GET    | `/api/v1/appointments`    | Sí            | —                                                                                     | `200: [{ "id": 1, "patientId": 1, "doctorId": 1, "startAt": "2023-10-01T10:00:00Z", "status": "pending" }]` | ⚠️ Parcial (simulado)      |
| POST   | `/api/v1/appointments`    | Sí            | `{ "patientId": 1, "doctorId": 1, "startAt": "2023-10-01T10:00:00Z", "endAt": "2023-10-01T11:00:00Z" }`       | `201: { "id": 301, ... }`                                                        | ✅ Implementado (simulado) |
| POST   | `/api/v1/auth/login`      | No            | `{ "username": "demo", "password": "secret" }`                                 | `200: { "token": "jwt_token_here", "user": { "id": 1, "name": "Admin", "role": "admin" } }` | ✅ Implementado            |
```
*Dependiente de cada endpoint; en la app planeada la mayoría de llamadas requiere token.

Diagrama de flujo API:

```
Cliente App ──► ApiService ──► Backend API
     │                │
     │                ├── Headers (Authorization: Bearer <token>)
     │                └── Body (JSON)
     │
     └── Respuesta ◄── Parse JSON ◄── HTTP Response
```

---

*Dependiente de cada endpoint; en la app planeada la mayoría de llamadas requiere token.

Ejemplo POST crear paciente (curl):

```bash
curl -X POST "https://api.tuservidor.com/api/v1/patients" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{"name":"Juan","lastName":"Perez","dni":"12345678","phone":"+541112345678","email":"juan@example.com","birthDate":"1980-01-01"}'
```

Ejemplo respuesta (201):

```json
{
  "id": 101,
  "name": "Juan",
  "lastName": "Perez",
  "dni": "12345678",
  "phone": "+541112345678",
  "email": "juan@example.com",
  "birthDate": "1980-01-01"
}
```

---

---

## 7. Arquitectura y flujo (diagrama ASCII)

Diagrama simplificado del flujo de la app y cómo interactúa con servicios:

```
┌─────────────┐     ┌─────────────────────┐
│   Usuario   │ ──► │   UI / Screens      │
│             │     │ (Home, Patients,    │
│             │     │  Create, Details)   │
└─────────────┘     └─────────────────────┘
                       │
                       ▼
               ┌─────────────────────┐
               │ Providers / State   │
               │ (ChangeNotifier)    │
               └─────────────────────┘
                       │
                       ▼
               ┌─────────────────────┐     ┌─────────────────────┐
               │ ApiService /        │ ◄──►│ Secure Storage      │
               │ AuthService         │     │ (Token)             │
               │ (HTTP requests)     │     └─────────────────────┘
               └─────────────────────┘
                       │
                       ▼
               ┌─────────────────────┐
               │   Backend API       │
               │ (Endpoints REST)    │
               └─────────────────────┘
```

Descripción: Las pantallas llaman a los providers para actualizar estado; los providers orquestan llamadas a `ApiService` que añade headers (incluido token desde `flutter_secure_storage`) y parsea respuestas. Las flechas indican flujo de datos.

---

---

## 8. Configuración / Entornos

Recomendación: mantener la `baseUrl` configurable mediante un archivo o constantes.

Ejemplo sencillo: crea `lib/config.dart` con:

```dart
class Config {
  static const String baseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'https://api.tuservidor.com/api/v1');
}
```

Y para correr en emulador apuntando a `10.0.2.2`:

```bat
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api/v1
```

Guardado seguro de tokens: `flutter_secure_storage` (ya integrado). No guardes tokens en texto plano ni en `SharedPreferences` para producción.

---

---

## 9. Tests, lint y CI sugerido

- Añadir `flutter_lints` en `pubspec.yaml` para reglas básicas.
- Añadir pruebas unitarias para `models` y `providers` en `test/`.
- CI (GitHub Actions) sugerido: pipeline que ejecute `flutter analyze` y `flutter test` en cada PR.

Ejemplo sencillo de job en GitHub Actions (concepto):

```yaml
name: Flutter CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: 'stable'
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test --coverage
```

---

## 10. Checklist de verificación y roadmap (priorizado)

Prioridad alta (sprints inmediatos)

1. Integrar token en `ApiService` para todas las llamadas protegidas — Est: 1 día
2. Validaciones de formularios (crear/editar pacientes, citas, médicos) y feedback de errores — Est: 2 días
3. Convertir simulaciones en llamadas reales al API y manejar errores/timeout — Est: 2-3 días

Prioridad media

4. Gestión avanzada de citas: confirmar/cancelar/reprogramar/complete — Est: 3 días
5. Notificaciones (correo o push): recordatorios de cita — Est: 4 días

Prioridad baja

6. Dashboard con métricas y filtros — Est: 5-8 días
7. Tests end-to-end y CI/CD configurado — Est: 3 días

Checklist de verificación manual (smoke test):

- [ ] ✅ Login y almacenamiento de token (verificar en `flutter_secure_storage`)
- [ ] ✅ Crear paciente y ver en lista (verificar actualización en `PatientsPage`)
- [ ] ✅ Borrar paciente (verificar eliminación y refresco)
- [ ] ✅ Crear cita y ver en lista (verificar en `AppointmentsPage`)
- [ ] ✅ Crear médico y ver en lista (verificar en `DoctorsPage`)
- [ ] ⚠️ Validar formulario (probar campos vacíos o inválidos)
- [ ] ⚠️ Manejo de errores (probar desconexión de red)

---

## 11. Problemas comunes y debugging

- Error: "Connection refused" al llamar al backend desde emulador Android
  - Solución: usar `http://10.0.2.2:<puerto>` como `baseUrl` para el emulador Android.
- Error: token no se envía
  - Solución: revisar que `ApiService` lea el token desde `flutter_secure_storage` antes de la petición y que `Authorization` se incluya en `headers`.
- Respuesta 500 del backend
  - Solución: revisar payload, usar herramientas como Postman o curl para reproducir la petición; confirmar esquema esperado.

---

## 12. Contribuir, issues y licencias

Guía rápida de contribución

1. Fork del repo
2. Crear rama: `feature/<descripcion>` o `fix/<descripcion>`
3. Ejecutar `flutter analyze` y `flutter test`
4. Crear PR con descripción clara y screenshots si aplica

Plantillas recomendadas (puedo generarlas): `CONTRIBUTING.md`, `ISSUE_TEMPLATE.md`, `PULL_REQUEST_TEMPLATE.md`.

Licencia: MIT (ver `LICENSE`).

---

Extras que puedo agregar ahora si quieres:

- Ejemplos de payloads y respuestas para cada endpoint más detallados.
- `CONTRIBUTING.md` y plantillas de issue/PR.
- Un archivo `lib/config.dart` con manejo de entornos y ejemplo de uso en `ApiService`.
- Un `docs/` con diagramas (si quieres imágenes, puedo crear `docs/assets/diagram.png` y sugerir contenido).

Dime cuál de las opciones extras quieres que implemente ahora y lo añado (por ejemplo: generar `CONTRIBUTING.md` y `lib/config.dart`).