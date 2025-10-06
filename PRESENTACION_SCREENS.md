# 📱 Presentación de Pantallas - Sistema de Citas Médicas (SACM)

## 🚀 Tecnología Flutter

**Flutter** es el framework de Google para crear aplicaciones nativas compiladas para móvil, web y escritorio desde una sola base de código. Utiliza el lenguaje **Dart** y ofrece:

- ✅ **Desarrollo multiplataforma** (iOS, Android, Web, Desktop)
- ✅ **Hot Reload** para desarrollo rápido
- ✅ **Rendimiento nativo** 
- ✅ **UI declarativa** con widgets
- ✅ **Arquitectura reactiva**

---

## 📋 Pantallas del Sistema

### 🔐 1. Login Page (`login_page.dart`)
**Pantalla de Inicio de Sesión**

- **Propósito**: Autenticación de usuarios en el sistema
- **Características Flutter**:
  - `TextFormField` para campos de usuario y contraseña
  - `ElevatedButton` para el botón de login
  - Validación de formularios con `Form` y `GlobalKey`
  - Navegación con `Navigator.pushReplacement()`
- **Funcionalidad**: Conecta con la API para validar credenciales

### 🏠 2. Home Page (`home_page.dart`)
**Pantalla Principal del Sistema**

- **Propósito**: Dashboard central con acceso a todas las funcionalidades
- **Características Flutter**:
  - `GridView` para mostrar opciones en tarjetas
  - `Card` widgets con diseño Material Design
  - `AppBar` con título y acciones
  - `Drawer` para navegación lateral (opcional)
- **Navegación**: Dirige a pacientes, doctores y citas

### 👥 3. Patients Page (`patients_page.dart`)
**Gestión de Pacientes**

- **Propósito**: Listar, buscar y gestionar pacientes
- **Características Flutter**:
  - `ListView.builder` para lista eficiente de pacientes
  - `SearchDelegate` para búsqueda en tiempo real
  - `FloatingActionButton` para agregar nuevos pacientes
  - `RefreshIndicator` para actualizar datos
- **Funcionalidades**: Ver, editar, eliminar pacientes

### 👤 4. Patient Details Page (`patient_details_page.dart`)
**Detalles del Paciente**

- **Propósito**: Vista completa de información del paciente y su historial
- **Características Flutter**:
  - `TabBarView` con pestañas (Información, Historial de Citas)
  - `SingleTickerProviderStateMixin` para animaciones de tabs
  - `Card` widgets para organizar información
  - `IconButton` para editar información
- **Funcionalidades**: Ver datos completos, editar, ver historial de citas

### ➕ 5. Create Patient Page (`create_patient_page.dart`)
**Registro de Nuevo Paciente**

- **Propósito**: Formulario para registrar pacientes
- **Características Flutter**:
  - `Form` con validación automática
  - `TextFormField` con diferentes tipos de input
  - `validator` functions para validación de datos
  - `ScaffoldMessenger` para mostrar mensajes de éxito/error
- **Validaciones**: Email, documento de identidad, campos obligatorios

### 🩺 6. Doctors Page (`doctors_page.dart`)
**Gestión de Médicos**

- **Propósito**: Administrar información de doctores
- **Características Flutter**:
  - Lista dinámica con `ListView.builder`
  - `ListTile` para mostrar información de médicos
  - `PopupMenuButton` para acciones (ver, editar, eliminar)
  - Navegación a detalles del doctor
- **Funcionalidades**: CRUD completo de médicos

### 👨‍⚕️ 7. Doctor Details Page (`doctor_details_page.dart`)
**Detalles del Doctor**

- **Propósito**: Información completa del doctor y sus citas
- **Características Flutter**:
  - Estructura similar a Patient Details con tabs
  - `TabController` para manejo de pestañas
  - Lista de citas del doctor
  - Funcionalidad de edición con `DropdownButtonFormField`
- **Funcionalidades**: Ver especialidad, editar datos, ver agenda

### ➕ 8. Create Doctor Page (`create_doctor_page.dart`)
**Registro de Nuevo Doctor**

- **Propósito**: Formulario para registrar médicos
- **Características Flutter**:
  - `DropdownButtonFormField` para selección de especialidades
  - Validación de formularios
  - Lista predefinida de especialidades médicas
- **Validaciones**: Especialidad requerida, nombre completo

### 📅 9. Appointments Page (`appointments_page.dart`)
**Gestión de Citas Médicas**

- **Propósito**: Ver y administrar todas las citas del sistema
- **Características Flutter**:
  - `DataTable` para mostrar citas en formato tabla
  - `DatePicker` para filtros por fecha
  - Estados de citas con colores (Confirmada, Pendiente, Cancelada)
  - `Chip` widgets para mostrar estados
- **Funcionalidades**: Filtrar, ver, editar citas

### ➕ 10. Create Appointment Page (`create_appointment_page.dart`)
**Programar Nueva Cita**

- **Propósito**: Formulario para crear citas médicas
- **Características Flutter**:
  - `DatePicker` y `TimePicker` para seleccionar fecha y hora
  - `DropdownButtonFormField` para seleccionar paciente y doctor
  - `TextFormField` para notas adicionales
  - Validación de disponibilidad
- **Validaciones**: Fecha futura, doctor disponible, paciente válido

---

## 🏗️ Arquitectura Flutter Implementada

### 📁 Estructura de Carpetas
```
lib/
├── models/          # Modelos de datos (Patient, Doctor, Appointment)
├── screens/         # Pantallas de la aplicación
├── services/        # Servicios API
├── providers/       # Gestión de estado (si se usa Provider)
├── constants.dart   # Configuración de URLs y constantes
└── main.dart       # Punto de entrada de la aplicación
```

### 🔧 Patrones Flutter Utilizados

1. **StatefulWidget**: Para pantallas con estado dinámico
2. **StatelessWidget**: Para componentes sin estado
3. **FutureBuilder**: Para manejar llamadas asíncronas a la API
4. **Navigator**: Para navegación entre pantallas
5. **Form Validation**: Validación de formularios
6. **Material Design**: Siguiendo las guías de diseño de Google

### 🌐 Integración con API

- **HTTP Package**: Para comunicación con backend
- **JSON Parsing**: Serialización/deserialización de datos
- **Error Handling**: Manejo de errores de red y API
- **Loading States**: Indicadores de carga para mejor UX

### 🎨 Características de UI/UX

- **Material Design 3**: Diseño moderno y consistente
- **Responsive Design**: Adaptable a diferentes tamaños de pantalla
- **Animations**: Transiciones suaves entre pantallas
- **Dark/Light Theme**: Soporte para temas (opcional)
- **Accessibility**: Etiquetas y navegación accesible

---

## 🚀 Ventajas de Flutter en este Proyecto

1. **Desarrollo Rápido**: Hot Reload permite ver cambios instantáneamente
2. **Una Sola Codebase**: Mismo código para web, móvil y desktop
3. **Rendimiento**: Compilado a código nativo
4. **Ecosystem**: Gran cantidad de packages disponibles
5. **Google Support**: Respaldado por Google con actualizaciones constantes
6. **Material Design**: Componentes UI listos para usar

---

## 📱 Responsive Design

El sistema está optimizado para:
- **📱 Móviles**: Layout vertical, navegación por tabs
- **💻 Tablets**: Mejor aprovechamiento del espacio horizontal
- **🖥️ Web**: Interfaz completa con todas las funcionalidades

---

## 🔮 Próximas Mejoras

- [ ] **Push Notifications** para recordatorios de citas
- [ ] **Offline Support** con bases de datos locales
- [ ] **Biometric Authentication** para mayor seguridad
- [ ] **Calendar Integration** con calendarios del sistema
- [ ] **Multi-language Support** para internacionalización