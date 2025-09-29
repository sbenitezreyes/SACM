# 🚀 **SACM - Sistema de Agendamiento de Citas Médicas**

```
               ███████╗  █████╗   ██████╗ ███╗   ███╗
               ██╔════╝ ██╔══██╗ ██╔════╝ ████╗ ████║
               ███████╗ ███████║ ██║      ██╔████╔██║
               ╚════██║ ██╔══██║ ██║      ██║╚██╔╝██║
               ███████║ ██║  ██║ ╚██████╗ ██║ ╚═╝ ██║
               ╚══════╝ ╚═╝  ╚═╝  ╚═════╝ ╚═╝     ╚═╝
    
           ╔═════════════════════════════════════╗
           ║        Sistema de Agendamiento      ║
           ║           de Citas Médicas          ║
           ╚═════════════════════════════════════╝
```

> *🏥 Un sistema robusto y eficiente para gestionar citas médicas, desarrollado con Spring Boot y PostgreSQL. 💻*

---

## 📋 **Descripción del Proyecto**

**SACM** es una plataforma integral diseñada para facilitar el agendamiento y gestión de citas médicas. Permite a pacientes y médicos interactuar de manera fluida, asegurando una experiencia óptima en la administración de consultas. El sistema incluye funcionalidades avanzadas como validaciones de horarios, notificaciones y una API RESTful completa.

### 🎯 **Objetivos Principales**

```
┌─────────────────────────────────────────────────────────────┐
│ ✅ Simplificar el proceso de agendamiento de citas          │
│ ✅ Garantizar la integridad de los datos                    │
│ ✅ Evitar conflictos de horarios automáticamente            │
│ ✅ Proporcionar una interfaz intuitiva para usuarios        │
│ ✅ Ofrecer una API extensible para integraciones futuras    │
└─────────────────────────────────────────────────────┘
```

## 🔗 **Integraciones Externas**

El sistema está preparado para integraciones con servicios externos mediante interfaces modulares:

### 📧 **Notificaciones**
- **Interfaz:** `NotificationsClient`
- **Funcionalidades:** Envío de correos para creación y cancelación de citas
- **Estado:** Implementación dummy actual, lista para integración con proveedores como SendGrid o AWS SES

### 💳 **Pagos**
- **Interfaz:** `PaymentsClient`
- **Funcionalidades:** Creación de pagos y procesamiento de reembolsos
- **Estado:** Implementación dummy actual, preparada para pasarelas como Stripe o PayPal

---

## 🛠️ **Stack Tecnológico**
```

---

## ✨ **Características Principales**

| Característica         | Descripción                                                                 |
|------------------------|-----------------------------------------------------------------------------|
| Gestión de Pacientes   | Crear, actualizar, listar y eliminar pacientes con validaciones completas   |
| Gestión de Médicos     | Administrar perfiles de médicos con especialidades                          |
| Agendamiento de Citas  | Crear, reprogramar, confirmar y cancelar citas con validaciones de conflictos |
| Validaciones Avanzadas | Verificación de horarios, solapamientos y datos obligatorios                |
| Notificaciones         | Integración para envío de correos electrónicos (en desarrollo)              |
| Integración de Pagos   | Procesamiento de pagos y reembolsos para citas (en desarrollo)              |
| API RESTful            | Documentada con Swagger/OpenAPI para fácil integración                      |
| Base de Datos          | PostgreSQL con migraciones automáticas via Flyway                           |
| Monitoreo              | Endpoints de Actuator para salud y métricas                                 |
| Pruebas                | Cobertura de pruebas unitarias y de integración                             |

## 🔧 **Funcionalidades Detalladas**

### PACIENTES
- Registro con nombre completo
- Documento de identidad único
- Email con validación
- Operaciones CRUD completas

### MÉDICOS
- Perfil con nombre completo
- Especialidad médica
- Gestión de disponibilidad

### CITAS
- Estados: Solicitada | Confirmada | Cancelada | Completada
- Pagos: Pendiente | Pagado | Reembolsado
- Validación anti-conflictos
- Historial completo por paciente/médico
```

---

## 🛠️ **Stack Tecnológico**

<div align="center">

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   🔧 BACKEND    │    │   🗄️ DATABASE   │    │   📋 TOOLS      │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ Spring Boot 3.5.5│    │ PostgreSQL 17.6 │    │ Gradle Build    │
│ Java 21         │    │ HikariCP Pool   │    │ Flyway Migrations│
│ Hibernate/JPA   │    │ ACID Compliant  │    │ Swagger/OpenAPI │
│ Lombok          │    │ Full-Text Search│    │ GitHub Actions  │
│ JavaMailSender  │    │ Backup Support  │    │ SonarCloud      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

</div>

### 📦 **Dependencias Principales**

```yaml
🔹 Core Framework:
  - Spring Boot Starter Web
  - Spring Boot Starter Data JPA
  - Spring Boot Starter Validation
  - Spring Boot Starter Actuator

🔹 Database & Migrations:
  - PostgreSQL Driver
  - Flyway Core + PostgreSQL Support
  - HikariCP Connection Pool

🔹 Documentation & Testing:
  - SpringDoc OpenAPI
  - JUnit 5 + Spring Boot Test
  - Lombok Annotations

🔹 CI/CD & Quality:
  - GitHub Actions
  - SonarQube Integration
  - Gradle Build System
```

---

## � **Instalación y Configuración**

### 📋 **Prerrequisitos**

```
┌─────────────────────────────────────────────┐
│  ☑️  Java 21 JDK o superior                │
│  ☑️  PostgreSQL 17.6+ instalado            │
│  ☑️  Git para clonar el repositorio        │
│  ☑️  Terminal/CMD con permisos              │
└─────────────────────────────────────────────┘
```

### ⚡ **Instalación Rápida**

```bash
# 1️⃣ Clonar el repositorio
git clone https://github.com/sbenitezreyes/SACM.git
cd SACM

# 2️⃣ Configurar PostgreSQL
createdb sacmbd
# Usuario: postgres | Contraseña: admin

# 3️⃣ Ejecutar migraciones
./gradlew flywayMigrate

# 4️⃣ Construir el proyecto  
./gradlew build

# 5️⃣ Ejecutar la aplicación
./gradlew bootRun
```

### 🔧 **Configuración Avanzada**

<details>
<summary>📁 <strong>Archivo application.properties</strong></summary>

```properties
# === CONFIGURACIÓN DE BASE DE DATOS ===
spring.datasource.url=jdbc:postgresql://localhost:5432/sacmbd
spring.datasource.username=postgres
spring.datasource.password=admin

# === CONFIGURACIÓN JPA ===
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true

# === CONFIGURACIÓN FLYWAY ===
spring.flyway.enabled=true
spring.flyway.locations=classpath:db/migration

# === CONFIGURACIÓN SWAGGER ===
springdoc.api-docs.enabled=true
springdoc.swagger-ui.enabled=true
```

</details>

### 🌐 **URLs de Acceso**

### Aplicación Principal
- [http://localhost:8080](http://localhost:8080)

### Documentación API (Swagger)
- [http://localhost:8080/swagger-ui/index.html](http://localhost:8080/swagger-ui/index.html)

---

## 🛠️ **Guía de Uso del Sistema**

### 🎮 **Ejemplos Prácticos con cURL**

<details>
<summary>👨‍⚕️ <strong>Gestión de Pacientes</strong></summary>

```bash
# 🔹 Crear un Paciente
curl -X POST http://localhost:8080/api/v1/patients \
  -H "Content-Type: application/json" \
  -d '{
    "fullName": "Juan Carlos Pérez",
    "documentId": "12345678",
    "email": "juan.perez@example.com"
  }'

# 🔹 Listar todos los Pacientes
curl -X GET http://localhost:8080/api/v1/patients

# Obtener Paciente por ID
curl -X GET http://localhost:8080/api/v1/patients/1

# 🔹 Actualizar Paciente
curl -X PUT http://localhost:8080/api/v1/patients/1 \
  -H "Content-Type: application/json" \
  -d '{
    "fullName": "Juan Carlos Pérez Actualizado",
    "email": "juan.nuevo@example.com"
  }'
```

</details>

<details>
<summary>👨‍⚕️ <strong>Gestión de Médicos</strong></summary>

```bash
# 🔹 Crear un Médico
curl -X POST http://localhost:8080/api/v1/doctors \
  -H "Content-Type: application/json" \
  -d '{
    "fullName": "Dra. Ana María López",
    "specialty": "Cardiología"
  }'

# 🔹 Listar todos los Médicos
curl -X GET http://localhost:8080/api/v1/doctors

# 🔹 Obtener Médico por ID
curl -X GET http://localhost:8080/api/v1/doctors/1
```

</details>

<details>
<summary>📅 <strong>Gestión de Citas</strong></summary>

```bash
# 🔹 Agendar una Cita
curl -X POST http://localhost:8080/api/v1/appointments \
  -H "Content-Type: application/json" \
  -d '{
    "doctorId": 1,
    "patientId": 1,
    "startAt": "2025-09-15T10:00:00",
    "endAt": "2025-09-15T11:00:00",
    "notes": "Consulta de rutina"
  }'

# 🔹 Confirmar Cita
curl -X POST http://localhost:8080/api/v1/appointments/1/confirm

# 🔹 Reprogramar Cita
curl -X POST http://localhost:8080/api/v1/appointments/1/reschedule \
  -H "Content-Type: application/json" \
  -d '{
    "startAt": "2025-09-16T14:00:00",
    "endAt": "2025-09-16T15:00:00"
  }'

# 🔹 Listar Citas por Médico
curl -X GET "http://localhost:8080/api/v1/appointments/doctor/1?from=2025-09-01T00:00:00&to=2025-09-30T23:59:59"
```

</details>

### 🖥️ **Interfaz de Usuario**

```
┌─────────────────────────────────────────────────────┐
│  📊 SWAGGER UI - Interfaz Interactiva              │
│  ➤ Probar endpoints en tiempo real                 │
│  ➤ Ver documentación completa de la API            │
│  ➤ Validar requests y responses                     │
│                                                     │
│  🔮 FUTURO: Interfaz Web React/Vue                 │
│  ➤ Dashboard para administradores                   │
│  ➤ Portal para pacientes                           │
│  ➤ Panel para médicos                              │
└─────────────────────────────────────────────────────┘
```

---

## 📚 **Documentación Completa de la API**

### 🌐 **Arquitectura de Endpoints**

```
┌─────────────────────────────────────────────────────────┐
│                    🏗️ API STRUCTURE                    │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  📁 /api/v1/patients     👥 Gestión de Pacientes       │
│  📁 /api/v1/doctors      👨‍⚕️ Gestión de Médicos        │
│  📁 /api/v1/appointments 📅 Gestión de Citas           │
│  📁 /actuator           📊 Monitoreo y Salud           │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### 👥 **Endpoints de Pacientes**

| Método | Endpoint | Descripción | Ejemplo |
|--------|----------|-------------|---------|
| `POST` | `/api/v1/patients` | ➕ Crear paciente | `{"fullName":"Juan", "email":"juan@email.com"}` |
| `GET` | `/api/v1/patients` | 📋 Listar todos los pacientes | N/A |
| `GET` | `/api/v1/patients/{id}` | 🔍 Obtener paciente específico | `/patients/1` |
| `PUT` | `/api/v1/patients/{id}` | ✏️ Actualizar paciente | `/patients/1` + datos |
| `DELETE` | `/api/v1/patients/{id}` | 🗑️ Eliminar paciente | `/patients/1` |

### 👨‍⚕️ **Endpoints de Médicos**

| Método | Endpoint | Descripción | Ejemplo |
|--------|----------|-------------|---------|
| `POST` | `/api/v1/doctors` | ➕ Crear médico | `{"fullName":"Dr. Ana", "specialty":"Cardiología"}` |
| `GET` | `/api/v1/doctors` | 📋 Listar todos los médicos | N/A |
| `GET` | `/api/v1/doctors/{id}` | 🔍 Obtener médico específico | `/doctors/1` |
| `PUT` | `/api/v1/doctors/{id}` | ✏️ Actualizar médico | `/doctors/1` + datos |
| `DELETE` | `/api/v1/doctors/{id}` | 🗑️ Eliminar médico | `/doctors/1` |

### 📅 **Endpoints de Citas**

| Método | Endpoint | Descripción | Estados |
|--------|----------|-------------|---------|
| `POST` | `/api/v1/appointments` | ➕ Crear cita | `REQUESTED` → `CONFIRMED` |
| `GET` | `/api/v1/appointments/{id}` | 🔍 Obtener cita | Ver detalles completos |
| `POST` | `/api/v1/appointments/{id}/cancel` | ❌ Cancelar cita | `ANY` → `CANCELLED` |
| `POST` | `/api/v1/appointments/{id}/reschedule` | 🔄 Reprogramar cita | Cambiar horarios |
| `POST` | `/api/v1/appointments/{id}/confirm` | ✅ Confirmar cita | `REQUESTED` → `CONFIRMED` |
| `POST` | `/api/v1/appointments/{id}/complete` | ✔️ Completar cita | `CONFIRMED` → `COMPLETED` |
| `GET` | `/api/v1/appointments/doctor/{doctorId}` | 📋 Citas por médico | Con filtros de fecha |
| `GET` | `/api/v1/appointments/patient/{patientId}` | 📋 Historial de paciente | Ordenado por fecha |
| `DELETE` | `/api/v1/appointments/{id}` | 🗑️ Eliminar cita | Solo si no está completada |

### 🗂️ **Modelos de Datos**

<details>
<summary>👤 <strong>Patient Model</strong></summary>

```json
{
  "id": 1,
  "fullName": "Juan Carlos Pérez",
  "documentId": "12345678",
  "email": "juan@example.com"
}
```

**Validaciones:**
- `fullName`: Obligatorio, no vacío
- `documentId`: Único en el sistema  
- `email`: Formato válido y obligatorio

</details>

<details>
<summary>👨‍⚕️ <strong>Doctor Model</strong></summary>

```json
{
  "id": 1,
  "fullName": "Dra. Ana María López",
  "specialty": "Cardiología"
}
```

**Validaciones:**
- `fullName`: Obligatorio, no vacío
- `specialty`: Obligatorio, especialidad médica

</details>

<details>
<summary>📅 <strong>Appointment Model</strong></summary>

```json
{
  "id": 1,
  "doctorId": 1,
  "patientId": 1,
  "startAt": "2025-09-15T10:00:00",
  "endAt": "2025-09-15T11:00:00",
  "status": "CONFIRMED",
  "paymentStatus": "PENDING",
  "notes": "Consulta de rutina"
}
```

**Estados Disponibles:**
- `status`: `REQUESTED`, `CONFIRMED`, `CANCELLED`, `COMPLETED`
- `paymentStatus`: `PENDING`, `PAID`, `REFUNDED`

</details>

---

## 🧪 **Testing y Calidad de Código**

### 🔬 **Ejecutar Pruebas**

```bash
# 🎯 Ejecutar todas las pruebas
./gradlew test

# 📊 Generar reporte de cobertura
./gradlew jacocoTestReport

# 🔍 Análisis de calidad con SonarQube
./gradlew sonarqube
```

### 📈 **Métricas de Calidad**

```
┌─────────────────────────────────────────────────────┐
│  📊 COBERTURA DE CÓDIGO                            │
│  ├── Pruebas Unitarias: ✅ Servicios y Validadores │
│  ├── Pruebas Integración: ✅ Controladores         │
│  └── Análisis Estático: ✅ SonarCloud              │
│                                                    │
│  🔍 ANÁLISIS DE CÓDIGO                             │
│  ├── Bugs: 0 🐛                                    │
│  ├── Vulnerabilidades: 0 🔒                        │
│  ├── Code Smells: Mínimos 🌿                       │
│  └── Duplicación: < 3% 📋                          │
└─────────────────────────────────────────────────────┘
```

## 🐳 **Despliegue**

### 🐳 **Despliegue con Docker**

```bash

# 1️⃣ Construir la imagen
 docker build -t sacm-app .

Para detener y eliminar el contenedor:

```bash
docker rm -f sacm-app
```

---

## ☁️ **Despliegue en AWS EC2**

La aplicación y la base de datos están desplegadas en AWS:

- **Swagger UI**: [http://18.117.111.212:8080/swagger-ui/index.html](http://18.117.111.212:8080/swagger-ui/index.html)
- **Base de datos**: PostgreSQL en AWS RDS
- **Servidor**: Linux (Amazon EC2)
- **Usuario SSH**: `ec2-user`
- **IP pública**: `18.117.111.212`

### Comando para desplegar la aplicación en AWS

```bash
java -jar sacm-0.0.1-SNAPSHOT.jar
```

### 2️⃣ **Ejecutar el contenedor**

```bash
docker run -d -p 8080:8080 --name sacm-app sacm-app:latest
```

El contenedor expone el puerto `8080` para acceso a la API y Swagger.
Puedes configurar variables de entorno para la base de datos si lo necesitas.

---

## 🤝 **Contribuir al Proyecto**

### 🚀 **Flujo de Contribución**

```
1️⃣ Fork del repositorio
   ↓
2️⃣ Crear rama feature/nueva-funcionalidad
   ↓
3️⃣ Desarrollar y hacer commits
   ↓
4️⃣ Ejecutar pruebas y validaciones
   ↓
5️⃣ Push y crear Pull Request
   ↓
6️⃣ Review y merge por el equipo
```

### 📝 **Guías de Desarrollo**

<details>
<summary>💻 <strong>Estándares de Código</strong></summary>

- **Java:** Seguir convenciones de Oracle
- **Nomenclatura:** CamelCase para métodos, PascalCase para clases
- **Comentarios:** JavaDoc para métodos públicos
- **Formato:** 4 espacios de indentación
- **Líneas:** Máximo 120 caracteres por línea

</details>

<details>
<summary>🧪 <strong>Estándares de Testing</strong></summary>

- **Cobertura mínima:** 80% para servicios
- **Naming:** `should_ReturnExpected_When_ValidInput()`
- **Mocking:** Usar Mockito para dependencias
- **Assertions:** Preferir AssertJ sobre JUnit básico

</details>

<details>
<summary>📝 <strong>Convenciones de Commits</strong></summary>

```
feat: nueva funcionalidad
fix: corrección de bug
docs: actualización de documentación
style: cambios de formato
refactor: refactorización sin cambio funcional
test: agregar o modificar pruebas
chore: tareas de mantenimiento
```

</details>

---

## 📄 **Licencia y Legal**

```
┌─────────────────────────────────────────────────────┐
│  📜 LICENCIA MIT                                    │
│  ├── ✅ Uso comercial permitido                     │
│  ├── ✅ Modificación permitida                      │
│  ├── ✅ Distribución permitida                      │
│  ├── ✅ Uso privado permitido                       │
│  └── ⚠️ Sin garantías incluidas                     │
└─────────────────────────────────────────────────────┘
```

Este proyecto está bajo la **Licencia MIT**. Ver el archivo [`LICENSE`](LICENSE) para más detalles.

---

## 📞 **Contacto y Soporte**

### 👥 **Equipo de Desarrollo**

```
┌─────────────────────────────────────────────────────────┐
│  👨‍💻 DESARROLLADOR PRINCIPAL                             │
│  ├── Nombre: [Jose/Santiago/Johan/Juan]                 │
│  ├── GitHub: @                                          │
│  ├── Email:                                             │
│  └── LinkedIn: /in/.                                    │
│                                                         │
│  🔗 ENLACES DEL PROYECTO                                │
│  ├── 📦 Repositorio: github.com/sbenitezreyes/SACM      │
│  ├── 🐛 Issues: github.com/sbenitezreyes/SACM/issues    │
│  ├── 📖 Wiki: github.com/sbenitezreyes/SACM/wiki        │
│  └── 🚀 Releases: github.com/sbenitezreyes/SACM/releases│
└─────────────────────────────────────────────────────────┘
```

### 💬 **Canales de Comunicación**

- **🐛 Reportar Bugs:** [GitHub Issues](https://github.com/sbenitezreyes/SACM/issues)
- **💡 Solicitar Features:** [GitHub Discussions](https://github.com/sbenitezreyes/SACM/discussions)
- **❓ Preguntas:** Stack Overflow con tag `sacm-medical`
- **📧 Contacto Directo:** sbenitezreyes@example.com

---

## 🔄 **Roadmap y Próximas Versiones**

### 🎯 **Version 1.1 - Q4 2025**

```
🔹 MEJORAS PLANIFICADAS:
  ├── 📧 Sistema de notificaciones por email completo
  ├── � Sistema de pagos completo
  ├── �📱 Campos adicionales en PatientRequestDTO
  ├── 🔐 Autenticación y autorización (Spring Security)
  ├── 🌐 API Gateway para microservicios
  └── 📊 Dashboard administrativo

🔹 OPTIMIZACIONES:
  ├── ⚡ Cache con Redis para consultas frecuentes
  ├── 🗃️ Optimización de consultas JPA
  ├── 📈 Métricas avanzadas con Micrometer
  └── 🔍 Logging estructurado con ELK Stack
```

### 🚀 **Version 2.0 - Q1 2026**

```
🔹 CARACTERÍSTICAS AVANZADAS:
  ├── 🏥 Multi-tenancy para múltiples clínicas
  ├── 📱 Aplicación móvil React Native
  ├── 🤖 Integración con IA para sugerencias
  ├── 💳 Pasarela de pagos integrada
  └── 📋 Historiales médicos digitales

🔹 ESCALABILIDAD:
  ├── ☁️ Migración a microservicios
  ├── 🐳 Contenerización con Docker
  ├── ☸️ Orquestación con Kubernetes
  └── 🌍 CDN para contenido estático
```

---

## 🏆 **Reconocimientos**

```
┌─────────────────────────────────────────────────────┐
│  🙏 AGRADECIMIENTOS                                 │
│  ├── Spring Boot Team - Framework excepcional       │
│  ├── PostgreSQL Community - Base de datos robusta   │
│  ├── OpenAPI Initiative - Documentación estándar    │
│  └── GitHub - Platform de desarrollo colaborativo   │
│                                                     │
│  📚 RECURSOS INSPIRACIONALES                        │
│  ├── Clean Architecture - Robert C. Martin          │
│  ├── Spring in Action - Craig Walls                 │
│  ├── Effective Java - Joshua Bloch                  │
│  └── Building Microservices - Sam Newman            │
└─────────────────────────────────────────────────────┘
```

---

<div align="center">

```
 ╔══════════════════════════════════════════════════════════╗
 ║                                                          ║
 ║         🏥 ¡Gracias por usar SACM! 🏥                   ║
 ║                                                          ║
 ║   Si encuentras algún problema, por favor reporta        ║
 ║   un issue en GitHub. ¡Tu feedback es muy valioso!       ║
 ║                                                          ║
 ║              ⭐ No olvides dar una estrella ⭐          ║
 ║                                                          ║
 ╚══════════════════════════════════════════════════════════╝
```

**Made with ❤️ by [Jose Padilla-Santiago Benitez-Johan Mejia-Juan Delgado](https://github.com/sbenitezreyes/SACM)**

</div>
