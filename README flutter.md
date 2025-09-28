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


# Plan para Implementar las Pantallas en Flutter

## 1. Pantallas a Implementar

### 1.1 Pantalla de Inicio (HomePage)
- [x] Mostrar un menú o navegación para acceder a las diferentes funcionalidades.
- [x] Botones o enlaces para navegar a las pantallas de "Pacientes" y "Autenticación".

### 1.2 Pantalla de Listado de Pacientes (PatientsPage)
- [x] Consumir el endpoint `GET /api/v1/patients` para mostrar una lista de pacientes.
- [x] Usar un `ListView` para mostrar los datos.
- [x] Implementar un botón para agregar un nuevo paciente (navegar a la pantalla de creación).

### 1.3 Pantalla de Creación de Pacientes (CreatePatientPage)
- [x] Formulario con campos para ingresar `name`, `age`, y `email`.
- [x] Consumir el endpoint `POST /api/v1/patients` para crear un nuevo paciente.
- [x] Validar los datos antes de enviarlos al backend.

### 1.4 Pantalla de Autenticación (LoginPage)
- [x] Formulario con campos para `username` y `password`.
- [x] Consumir el endpoint `POST /api/v1/auth/login` para autenticar al usuario.
- [x] Almacenar el token de autenticación usando `flutter_secure_storage`.

### 1.5 Pantalla de Detalles del Paciente (PatientDetailsPage)
- [x] Mostrar los detalles de un paciente seleccionado.
- [x] Consumir el endpoint `GET /api/v1/patients/{id}`.
- [x] Botón para eliminar al paciente (consumir `DELETE /api/v1/patients/{id}`).

### 1.6 Pantalla de Gestión de Citas (AppointmentsPage)
- [x] Mostrar una lista de citas médicas.
- [x] Consumir el endpoint `GET /api/v1/appointments`.
- [x] Implementar botones para crear, confirmar, cancelar y reprogramar citas.

### 1.7 Pantalla de Creación de Citas (CreateAppointmentPage)
- [x] Formulario para seleccionar paciente, médico, fecha y hora.
- [x] Consumir el endpoint `POST /api/v1/appointments` para crear una nueva cita.
- [x] Validar conflictos de horarios antes de enviar la solicitud.
- [x] Manejo de errores con mensajes de usuario.

### 1.8 Pantalla de Gestión de Médicos (DoctorsPage)
- [x] Mostrar una lista de médicos.
- [x] Consumir el endpoint `GET /api/v1/doctors`.
- [x] Implementar botones para crear, actualizar y eliminar médicos.
- [x] Manejo de errores con mensajes de usuario.

### 1.9 Pantalla de Creación de Médicos (CreateDoctorPage)
- [x] Formulario para ingresar nombre completo y especialidad.
- [x] Consumir el endpoint `POST /api/v1/doctors` para crear un nuevo médico.
- [x] Validar los datos antes de enviarlos al backend.
- [x] Manejo de errores con mensajes de usuario.

---

## 2. Funcionalidades Clave

### 2.1 Consumo de Servicios REST
- [x] Usar el paquete `http` para realizar solicitudes HTTP.
- [x] Manejar errores como timeouts y respuestas no exitosas (comentado por ahora).

### 2.2 Gestión de Estado
- [x] Usar `ChangeNotifier` para manejar el estado de la aplicación.
- [x] Actualizar las listas y vistas dinámicamente al realizar cambios.

### 2.3 Validación de Datos
- [ ] Validar los datos ingresados en los formularios antes de enviarlos al backend.
- [ ] Mostrar mensajes de error si los datos son inválidos.

### 2.4 Autenticación
- [x] Almacenar el token de autenticación de forma segura.
- [ ] Usar el token en los encabezados de las solicitudes protegidas.

### 2.5 Diseño y Usabilidad
- [ ] Usar widgets como `ListView`, `TextField`, `ElevatedButton`, y `Card` para crear una interfaz atractiva.
- [ ] Asegurar que las pantallas sean responsivas y fáciles de usar.

---

## 3. Estructura del Proyecto

### 3.1 Carpetas
- [x] **`lib/screens`**: Contendrá las pantallas (`HomePage`, `PatientsPage`, `CreatePatientPage`, `LoginPage`, `PatientDetailsPage`).
- [x] **`lib/models`**: Contendrá los modelos de datos (`Patient`, `AuthResponse`).
- [x] **`lib/services`**: Contendrá los servicios para realizar solicitudes HTTP (`ApiService`).
- [x] **`lib/providers`**: Contendrá los proveedores de estado (`PatientProvider`, `AuthProvider`).

---

## 4. Implementación

### 4.1 Crear las Pantallas
- [x] Implementar las pantallas mencionadas en la estructura del proyecto.

### 4.2 Servicios REST
- [x] Implementar los servicios REST en `lib/services/ApiService.dart` (comentado por ahora).

### 4.3 Modelos de Datos
- [x] Crear los modelos de datos en `lib/models`.

### 4.4 Gestión de Estado
- [x] Usar `ChangeNotifier` para manejar el estado en `lib/providers`.

### 4.5 Diseño de Pantallas
- [ ] Diseñar las pantallas con widgets de Flutter.

---

## Prioridad de Implementación

### Primera Pantalla: HomePage
- **Razón**: Es la pantalla principal y punto de entrada de la aplicación.
- **Objetivo**: Crear una navegación básica y estética para acceder a las demás funcionalidades.
- **Pasos**:
  1. Crear la estructura de navegación.
  2. Agregar botones para navegar a "Pacientes" y "Autenticación".
  3. Asegurar un diseño limpio y funcional.

---

## 1.10 Funcionalidades Adicionales

### 1.10.1 Gestión Avanzada de Citas
- [ ] Confirmar citas médicas (endpoint: `POST /api/v1/appointments/{id}/confirm`).
- [ ] Cancelar citas médicas (endpoint: `POST /api/v1/appointments/{id}/cancel`).
- [ ] Reprogramar citas médicas (endpoint: `POST /api/v1/appointments/{id}/reschedule`).
- [ ] Completar citas médicas (endpoint: `POST /api/v1/appointments/{id}/complete`).

### 1.10.2 Notificaciones
- [ ] Integrar el envío de correos electrónicos para notificaciones (en desarrollo).

### 1.10.3 Dashboard Administrativo
- [ ] Diseñar un dashboard para administradores, pacientes y médicos.

### 1.10.4 Seguridad y Optimización
- [ ] Usar HTTPS en producción para proteger los datos.
- [ ] Validar entradas antes de enviarlas al backend para evitar vulnerabilidades.

### 1.11 Funcionalidades Faltantes Detectadas

#### 1.11.1 Gestión Avanzada de Citas
- [ ] Confirmar citas médicas (endpoint: `POST /api/v1/appointments/{id}/confirm`).
- [ ] Cancelar citas médicas (endpoint: `POST /api/v1/appointments/{id}/cancel`).
- [ ] Reprogramar citas médicas (endpoint: `POST /api/v1/appointments/{id}/reschedule`).
- [ ] Completar citas médicas (endpoint: `POST /api/v1/appointments/{id}/complete`).
- [ ] Historial de citas por paciente y médico.

#### 1.11.2 Notificaciones
- [ ] Integrar el envío de correos electrónicos para notificaciones.

#### 1.11.3 Dashboard Administrativo
- [ ] Diseñar un dashboard para administradores, pacientes y médicos.

#### 1.11.4 Seguridad y Optimización
- [ ] Validar entradas antes de enviarlas al backend para evitar vulnerabilidades.
- [ ] Usar HTTPS en producción para proteger los datos.

#### 1.11.5 Pruebas de Conectividad
- [ ] Verificar que el backend sea accesible desde el dispositivo o emulador donde se ejecuta Flutter.
# app_flutter

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Documentación para la Integración de Flutter con el Backend

## 1. Documentar la API con Swagger
- **URL de Swagger**: [http://localhost:8080/swagger-ui/index.html](http://localhost:8080/swagger-ui/index.html)
- **Descripción**: Swagger está habilitado en el proyecto para documentar todos los endpoints disponibles. Asegúrate de que el equipo de Flutter tenga acceso a esta URL para consultar los detalles de cada endpoint.
- **Ejemplo de Endpoint**:
  - **Endpoint**: `POST /api/v1/patients`
  - **Descripción**: Crear un nuevo paciente.
  - **Cuerpo de la solicitud**:
    ```json
    {
      "name": "John Doe",
      "age": 30,
      "email": "john.doe@example.com"
    }
    ```
  - **Respuesta esperada**:
    ```json
    {
      "id": 1,
      "name": "John Doe",
      "age": 30,
      "email": "john.doe@example.com"
    }
    ```

## 2. Probar los Endpoints con Postman
- **Crear una colección de Postman**:
  - Incluye todos los endpoints del backend.
  - Proporciona ejemplos de solicitudes y respuestas.
- **Compartir la colección**:
  - Exporta la colección y compártela con el equipo de Flutter.
- **Validar los endpoints**:
  - Asegúrate de que todos los endpoints respondan correctamente antes de integrarlos con Flutter.

## 3. Configurar el archivo `application.properties` para CORS
- **Configuración eliminada**: Las propiedades `spring.web.cors.allowed-origins` y `spring.web.cors.allowed-methods` no son válidas y se manejan en la clase `WebConfig`.
- **Clase de configuración**:
  - La configuración de CORS se encuentra en `src/main/java/co/proyecto/sacm/config/WebConfig.java`.
  - Permite solicitudes desde `http://localhost:3000` (dominio de Flutter).

## 4. Asegurar la Conectividad entre Flutter y el Backend
- **Pasos**:
  1. Verifica que el backend esté corriendo y accesible desde la red.
  2. Configura reglas de firewall o seguridad si es necesario.
  3. Prueba la conectividad desde Flutter usando un cliente HTTP.

## 5. Manejar Autenticación (si es necesaria)
- **Flujo de autenticación**:
  - Documenta cómo obtener y enviar tokens de autenticación.
  - Asegúrate de que los endpoints protegidos respondan con códigos de estado adecuados (401, 403).
- **Ejemplo de autenticación con JWT**:
  - **Endpoint**: `POST /api/v1/auth/login`
  - **Cuerpo de la solicitud**:
    ```json
    {
      "username": "user",
      "password": "password"
    }
    ```
  - **Respuesta esperada**:
    ```json
    {
      "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
    }
    ```

## 6. Consideraciones Importantes para Flutter

### 6.1. Configuración del Cliente HTTP en Flutter
- **Paquete recomendado**: Usa el paquete `http` o `dio` para realizar solicitudes HTTP desde Flutter.
- **Ejemplo con `http`**:
  ```dart
  import 'package:http/http.dart' as http;
  import 'dart:convert';

  Future<void> fetchPatients() async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/v1/patients'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
    } else {
      print('Error: ${response.statusCode}');
    }
  }
  ```

### 6.2. Manejo de Errores
- **Errores comunes**:
  - `CORS`: Asegúrate de que el backend tenga CORS configurado correctamente.
  - `Timeout`: Configura un tiempo de espera adecuado en las solicitudes HTTP.
- **Ejemplo de manejo de errores**:
  ```dart
  try {
    await fetchPatients();
  } catch (e) {
    print('Error: $e');
  }
  ```

### 6.3. Variables de Entorno
- **Uso de variables de entorno**:
  - Configura las URLs del backend en un archivo separado para facilitar el cambio entre entornos (desarrollo, producción).
  - Ejemplo:
    ```dart
    const String baseUrl = 'http://localhost:8080';
    ```

### 6.4. Autenticación
- **Almacenar tokens de forma segura**:
  - Usa el paquete `flutter_secure_storage` para almacenar tokens de autenticación.
- **Ejemplo**:
  ```dart
  import 'package:flutter_secure_storage/flutter_secure_storage.dart';

  final storage = FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }
  ```

### 6.5. Pruebas de Conectividad
- **Herramientas recomendadas**:
  - Usa `Postman` o `cURL` para probar los endpoints antes de integrarlos en Flutter.
  - Verifica que el backend sea accesible desde el dispositivo o emulador donde se ejecuta Flutter.

### 6.6. Optimización de Solicitudes
- **Uso de modelos**:
  - Crea modelos en Flutter para mapear las respuestas del backend.
  - Ejemplo:
    ```dart
    class Patient {
      final int id;
      final String name;
      final int age;

      Patient({required this.id, required this.name, required this.age});

      factory Patient.fromJson(Map<String, dynamic> json) {
        return Patient(
          id: json['id'],
          name: json['name'],
          age: json['age'],
        );
      }
    }
    ```

### 6.7. Seguridad
- **HTTPS**:
  - Asegúrate de usar HTTPS en producción para proteger los datos en tránsito.
- **Validación de entradas**:
  - Valida los datos antes de enviarlos al backend para evitar errores y vulnerabilidades.

---

**Nota**: Asegúrate de mantener esta documentación actualizada a medida que se realicen cambios en el backend.

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Backend Integration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PatientListScreen(),
    );
  }
}

class PatientListScreen extends StatefulWidget {
  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  List<dynamic> patients = [];

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    final url = Uri.parse('http://10.0.2.2:8080/api/v1/patients'); // Cambia a la URL de tu backend
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        setState(() {
          patients = json.decode(response.body);
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient List'),
      ),
      body: patients.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];
                return ListTile(
                  title: Text(patient['name']),
                  subtitle: Text('Age: ${patient['age']}'),
                );
              },
            ),
    );
  }
}

Documentar la API con Swagger y compartir ejemplos.
Probar los endpoints con Postman.
Configurar el archivo application.properties para CORS.
Asegurar la conectividad entre Flutter y el backend.
Manejar autenticación si es necesaria.
