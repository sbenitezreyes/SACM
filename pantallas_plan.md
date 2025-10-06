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