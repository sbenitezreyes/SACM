# Mejoras y Cambios Propuestos

## **1. Mejoras en el Modelo `PatientRequestDTO`**
### **Campos Adicionales:**
Se propone agregar los siguientes campos al modelo `PatientRequestDTO`:
- [ ] `phoneNumber`: Número de teléfono del paciente.
- [ ] `address`: Dirección del paciente.
- [ ] `dateOfBirth`: Fecha de nacimiento del paciente.
- [ ] `gender`: Género del paciente.

### **Validaciones:**
- [ ] `phoneNumber`: Validar que sea obligatorio y tenga un formato válido.
- [ ] `address`: Validar que sea obligatorio.
- [ ] `dateOfBirth`: Validar que sea una fecha válida.
- [ ] `gender`: Validar que sea obligatorio y acepte valores predefinidos (ejemplo: `Male`, `Female`, `Other`).

---

## **2. Implementación de Notificaciones por Correo Electrónico**
### **Cambios Propuestos:**
- [ ] Configurar el servicio de correo electrónico utilizando `JavaMailSender`.
- [ ] Crear una plantilla HTML para los correos.
- [ ] Enviar notificaciones al paciente con los detalles de la cita.

### **Validaciones:**
- [ ] Verificar que el correo del paciente sea válido antes de enviar la notificación.
- [ ] Manejar errores en el envío de correos y registrar logs.

---

## **3. Revisión de Fallas y Mejoras Críticas**
### **Problemas Identificados:**
- [ ] **Validaciones insuficientes:** Algunos campos no tienen validaciones obligatorias.
- [ ] **Falta de manejo de errores:** Mejorar el manejo de excepciones en los controladores y servicios.
- [ ] **Documentación:** Actualizar la documentación de Swagger para reflejar los cambios en los modelos y endpoints.

### **Propuestas de Solución:**
- [ ] Agregar validaciones a todos los campos obligatorios.
- [ ] Implementar un sistema de manejo de errores centralizado.
- [ ] Mejorar la documentación de los endpoints en Swagger.

---

## **4. Otros Cambios Propuestos**
- [ ] **Optimización de consultas:** Revisar las consultas a la base de datos para mejorar el rendimiento.
- [ ] **Seguridad:** Implementar autenticación y autorización en los endpoints.
- [ ] **Pruebas:** Crear pruebas unitarias y de integración para los nuevos cambios.

---

## **5. Próximos Pasos**
- [ ] Revisar el impacto de los cambios en el sistema actual.
- [ ] Planificar la implementación de las mejoras en fases.
- [ ] Realizar pruebas exhaustivas antes del despliegue.

---

# **6. Funciones del Programa**

## **Controladores**
### **PatientController**
- **Descripción:** Maneja las operaciones relacionadas con los pacientes.
- **Endpoints:**
  - `POST /api/v1/patients`: Crear un nuevo paciente.
  - `GET /api/v1/patients`: Listar todos los pacientes.
  - `GET /api/v1/patients/{id}`: Obtener un paciente por ID.
  - `PUT /api/v1/patients/{id}`: Actualizar un paciente existente.
  - `DELETE /api/v1/patients/{id}`: Eliminar un paciente.

### **DoctorController**
- **Descripción:** Gestiona las operaciones relacionadas con los médicos.
- **Endpoints:**
  - `POST /api/v1/doctors`: Crear un nuevo médico.
  - `GET /api/v1/doctors`: Listar todos los médicos.
  - `GET /api/v1/doctors/{id}`: Obtener un médico por ID.
  - `PUT /api/v1/doctors/{id}`: Actualizar un médico existente.
  - `DELETE /api/v1/doctors/{id}`: Eliminar un médico.

### **AppointmentController**
- **Descripción:** Administra las citas médicas.
- **Endpoints:**
  - `POST /api/v1/appointments`: Crear una nueva cita.
  - `POST /api/v1/appointments/{id}/cancel`: Cancelar una cita.
  - `GET /api/v1/appointments/{id}`: Obtener una cita por ID.
  - `POST /api/v1/appointments/{id}/reschedule`: Reprogramar una cita.
  - `POST /api/v1/appointments/{id}/confirm`: Confirmar una cita.
  - `POST /api/v1/appointments/{id}/complete`: Completar una cita.
  - `GET /api/v1/appointments/doctor/{doctorId}`: Listar citas de un médico entre fechas.
  - `GET /api/v1/appointments/patient/{patientId}`: Listar citas de un paciente.

---

## **Servicios**
### **PatientService**
- **Descripción:** Proporciona la lógica de negocio para los pacientes.
- **Funciones:**
  - Crear, listar, obtener, actualizar y eliminar pacientes.

### **DoctorService**
- **Descripción:** Proporciona la lógica de negocio para los médicos.
- **Funciones:**
  - Crear, listar, obtener, actualizar y eliminar médicos.

### **AppointmentService**
- **Descripción:** Maneja la lógica de negocio para las citas médicas.
- **Funciones:**
  - Crear, cancelar, reprogramar, confirmar y completar citas.
  - Listar citas por médico y paciente.

### **AppointmentValidator**
- **Descripción:** Valida las reglas de negocio para las citas.
- **Funciones:**
  - Validar horarios y evitar conflictos de citas.

---

## **Repositorios**
### **PatientRepository**
- **Descripción:** Interactúa con la base de datos para las operaciones de pacientes.

### **DoctorRepository**
- **Descripción:** Interactúa con la base de datos para las operaciones de médicos.

### **AppointmentRepository**
- **Descripción:** Interactúa con la base de datos para las operaciones de citas.
- **Funciones Adicionales:**
  - Verificar conflictos de citas.
  - Listar citas por médico y paciente.

---

## **Configuraciones**
### **OpenApiConfig**
- **Descripción:** Configura Swagger/OpenAPI para la documentación de la API.
- **Detalles:**
  - Agrupa los endpoints bajo el grupo `sacm`.
  - Escanea los controladores en el paquete `co.proyecto.sacm.controller`.

### **FlywayConfig**
- **Descripción:** Configura Flyway para la gestión de migraciones de base de datos.

---

**Nota:** Este archivo se actualizará conforme se identifiquen nuevas mejoras o problemas en el proyecto.
