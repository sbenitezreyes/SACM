# Documentación de Implementaciones en Flutter

Este archivo detalla las implementaciones realizadas en la aplicación Flutter, incluyendo las pantallas, las interacciones con la API y las tecnologías utilizadas.

## Pantallas Implementadas

### 1. HomePage
- **Descripción**: Pantalla principal con botones para navegar a las diferentes secciones.
- **Interacciones**: Navegación a `PatientsPage`, `AppointmentsPage`, `DoctorsPage`.

### 2. PatientsPage
- **Descripción**: Muestra una lista de pacientes.
- **Interacciones con la API**:
  - **Endpoint**: `GET /api/v1/patients`
  - **Uso**: Recupera la lista de pacientes.
- **Tecnologías**: `FutureBuilder`, `ListView`.

### 3. CreatePatientPage
- **Descripción**: Formulario para crear un nuevo paciente.
- **Interacciones con la API**:
  - **Endpoint**: `POST /api/v1/patients`
  - **Uso**: Envía datos para crear un paciente.
- **Tecnologías**: `TextFormField`, `http`.

### 4. PatientDetailsPage
- **Descripción**: Muestra detalles de un paciente específico.
- **Interacciones con la API**:
  - **Endpoint**: `GET /api/v1/patients/{id}`
  - **Uso**: Recupera detalles de un paciente.
- **Tecnologías**: `FutureBuilder`, `http`.

### 5. AppointmentsPage
- **Descripción**: Muestra una lista de citas.
- **Interacciones con la API**:
  - **Endpoint**: `GET /api/v1/appointments`
  - **Uso**: Recupera la lista de citas.
- **Tecnologías**: `FutureBuilder`, `ListView`.

### 6. CreateAppointmentPage
- **Descripción**: Formulario para crear una nueva cita.
- **Interacciones con la API**:
  - **Endpoint**: `POST /api/v1/appointments`
  - **Uso**: Envía datos para crear una cita.
- **Tecnologías**: `TextFormField`, `showDatePicker`, `showTimePicker`.

### 7. DoctorsPage
- **Descripción**: Muestra una lista de médicos.
- **Interacciones con la API**:
  - **Endpoint**: `GET /api/v1/doctors`
  - **Uso**: Recupera la lista de médicos.
- **Tecnologías**: `FutureBuilder`, `ListView`.

### 8. CreateDoctorPage
- **Descripción**: Formulario para crear un nuevo médico.
- **Interacciones con la API**:
  - **Endpoint**: `POST /api/v1/doctors`
  - **Uso**: Envía datos para crear un médico.
- **Tecnologías**: `TextFormField`, `http`.

## Tecnologías Utilizadas

### Flutter
- **Framework**: Utilizado para desarrollar la aplicación.
- **Widgets**: `ElevatedButton`, `TextFormField`, `ListView`, `FutureBuilder`.

### Dart
- **Lenguaje**: Utilizado para la lógica de la aplicación.

### Paquetes
- **http**: Para realizar solicitudes HTTP.
- **flutter_secure_storage**: Para almacenar tokens de manera segura.

## Interacciones con la API

### Autenticación
- **Endpoint**: `POST /api/v1/auth/login`
- **Uso**: Autenticar usuarios y obtener un token.

### Pacientes
- **Endpoints**:
  - `GET /api/v1/patients`: Recuperar lista de pacientes.
  - `POST /api/v1/patients`: Crear un nuevo paciente.
  - `GET /api/v1/patients/{id}`: Recuperar detalles de un paciente.

### Citas
- **Endpoints**:
  - `GET /api/v1/appointments`: Recuperar lista de citas.
  - `POST /api/v1/appointments`: Crear una nueva cita.

### Médicos
- **Endpoints**:
  - `GET /api/v1/doctors`: Recuperar lista de médicos.
  - `POST /api/v1/doctors`: Crear un nuevo médico.

## Configuración del Cliente HTTP

### Paquete recomendado
- **Paquete**: `http` o `dio`.
- **Uso**: Realizar solicitudes HTTP desde Flutter.

### Ejemplo con `http`
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

### Manejo de Errores

#### Errores comunes
- **CORS**: Verificar configuración en el backend.
- **Timeout**: Configurar tiempo de espera adecuado.

#### Ejemplo de manejo de errores
```dart
try {
  await fetchPatients();
} catch (e) {
  print('Error: $e');
}
```

## Funcionalidades de los Botones

### Botones para Crear, Editar y Eliminar
- **Crear**: Permite agregar nuevos registros (pacientes, médicos, citas).
  - **Endpoint**: `POST /api/v1/{resource}`
  - **Ejemplo**:
    ```dart
    Future<void> createResource(String resource, Map<String, dynamic> data) async {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/v1/$resource'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      if (response.statusCode == 201) {
        print('Creado exitosamente');
      } else {
        print('Error: ${response.statusCode}');
      }
    }
    ```

- **Editar**: Modifica registros existentes.
  - **Endpoint**: `PUT /api/v1/{resource}/{id}`
  - **Ejemplo**:
    ```dart
    Future<void> editResource(String resource, String id, Map<String, dynamic> data) async {
      final response = await http.put(
        Uri.parse('http://localhost:8080/api/v1/$resource/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      if (response.statusCode == 200) {
        print('Editado exitosamente');
      } else {
        print('Error: ${response.statusCode}');
      }
    }
    ```

- **Eliminar**: Borra registros existentes.
  - **Endpoint**: `DELETE /api/v1/{resource}/{id}`
  - **Ejemplo**:
    ```dart
    Future<void> deleteResource(String resource, String id) async {
      final response = await http.delete(
        Uri.parse('http://localhost:8080/api/v1/$resource/$id'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 204) {
        print('Eliminado exitosamente');
      } else {
        print('Error: ${response.statusCode}');
      }
    }
    ```