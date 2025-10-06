import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/patient.dart';
import '../models/appointment.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión');
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.delete(url);
  }

  Future<List<Patient>> fetchPatients() async {
    try {
      final response = await get('/api/v1/patients');
      if (response is List) {
        return response.map((json) => Patient.fromJson(json)).toList();
      } else {
        throw Exception('La respuesta de pacientes no es una lista');
      }
    } catch (e) {
      throw Exception('Error al obtener pacientes: $e');
    }
  }

  // ========== APPOINTMENT ENDPOINTS ==========

  /// GET /api/v1/appointments - Listar todas las citas
  Future<List<Appointment>> fetchAppointments() async {
    try {
      final response = await get('/api/v1/appointments');
      if (response is List) {
        return response.map((json) => Appointment.fromJson(json)).toList();
      } else {
        throw Exception('La respuesta de citas no es una lista');
      }
    } catch (e) {
      throw Exception('Error al obtener citas: $e');
    }
  }

  /// POST /api/v1/appointments - Crear cita
  Future<Appointment> createAppointment({
    required int doctorId,
    required int patientId,
    required String startAt,
    String? notes,
  }) async {
    try {
      final data = {
        'doctorId': doctorId,
        'patientId': patientId,
        'startAt': startAt,
        'notes': notes ?? '',
      };
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/appointments'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Appointment.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al crear cita: $e');
    }
  }

  /// GET /api/v1/appointments/{id} - Obtener cita por id
  Future<Appointment> getAppointmentById(int id) async {
    try {
      final response = await get('/api/v1/appointments/$id');
      return Appointment.fromJson(response);
    } catch (e) {
      throw Exception('Error al obtener cita: $e');
    }
  }

  /// POST /api/v1/appointments/{id}/reschedule - Reprogramar cita
  Future<Appointment> rescheduleAppointment(int id, String startAt) async {
    try {
      final data = {'startAt': startAt};
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/appointments/$id/reschedule'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return Appointment.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al reprogramar cita: $e');
    }
  }

  /// POST /api/v1/appointments/{id}/confirm - Confirmar cita
  Future<Appointment> confirmAppointment(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/appointments/$id/confirm'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return Appointment.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al confirmar cita: $e');
    }
  }

  /// POST /api/v1/appointments/{id}/complete - Completar cita
  Future<Appointment> completeAppointment(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/appointments/$id/complete'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return Appointment.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al completar cita: $e');
    }
  }

  /// POST /api/v1/appointments/{id}/cancel - Cancelar cita
  Future<void> cancelAppointment(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/appointments/$id/cancel'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode != 200) {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al cancelar cita: $e');
    }
  }

  /// DELETE /api/v1/appointments/{id} - Eliminar cita
  Future<void> deleteAppointment(int id) async {
    try {
      final response = await delete('/api/v1/appointments/$id');
      if (response.statusCode != 200) {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al eliminar cita: $e');
    }
  }

  /// GET /api/v1/appointments/patient/{patientId} - Listar citas de un paciente (historial)
  Future<List<Appointment>> fetchAppointmentsByPatient(int patientId) async {
    try {
      final response = await get('/api/v1/appointments/patient/$patientId');
      if (response is List) {
        return response.map((json) => Appointment.fromJson(json)).toList();
      } else {
        throw Exception('La respuesta de citas no es una lista');
      }
    } catch (e) {
      throw Exception('Error al obtener citas del paciente: $e');
    }
  }

  /// GET /api/v1/appointments/doctor/{doctorId} - Listar citas de un doctor entre fechas
  Future<List<Appointment>> fetchAppointmentsByDoctor(
    int doctorId, {
    String? from,
    String? to,
  }) async {
    try {
      String endpoint = '/api/v1/appointments/doctor/$doctorId';
      List<String> queryParams = [];
      
      if (from != null) queryParams.add('from=$from');
      if (to != null) queryParams.add('to=$to');
      
      if (queryParams.isNotEmpty) {
        endpoint += '?${queryParams.join('&')}';
      }

      final response = await get(endpoint);
      if (response is List) {
        return response.map((json) => Appointment.fromJson(json)).toList();
      } else {
        throw Exception('La respuesta de citas no es una lista');
      }
    } catch (e) {
      throw Exception('Error al obtener citas del doctor: $e');
    }
  }
}

final apiService = ApiService(baseUrl: 'http://ec2-3-21-127-81.us-east-2.compute.amazonaws.com:8085');