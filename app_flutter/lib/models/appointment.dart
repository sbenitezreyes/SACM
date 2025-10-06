/// Modelo de Appointment según la API
/// Status posibles: REQUESTED, CONFIRMED, COMPLETED, CANCELLED
class Appointment {
  final int id;
  final int doctorId;
  final int patientId;
  final String startAt; // ISO 8601 format: "2025-10-06T04:36:38.494Z"
  final String status; // REQUESTED | CONFIRMED | COMPLETED | CANCELLED
  final String? notes;

  Appointment({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.startAt,
    required this.status,
    this.notes,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      doctorId: json['doctorId'] is int ? json['doctorId'] : int.tryParse(json['doctorId'].toString()) ?? 0,
      patientId: json['patientId'] is int ? json['patientId'] : int.tryParse(json['patientId'].toString()) ?? 0,
      startAt: json['startAt']?.toString() ?? '',
      status: json['status']?.toString() ?? 'REQUESTED',
      notes: json['notes']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'id': id,
      'doctorId': doctorId,
      'patientId': patientId,
      'startAt': startAt,
      'status': status,
    };
    if (notes != null) {
      data['notes'] = notes!;
    }
    return data;
  }

  /// Obtiene el color según el estado de la cita
  String getStatusColor() {
    switch (status) {
      case 'CONFIRMED':
        return '#4CAF50'; // Verde
      case 'COMPLETED':
        return '#2196F3'; // Azul
      case 'CANCELLED':
        return '#F44336'; // Rojo
      case 'REQUESTED':
      default:
        return '#FF9800'; // Naranja
    }
  }

  /// Obtiene el texto en español del estado
  String getStatusText() {
    switch (status) {
      case 'REQUESTED':
        return 'Solicitada';
      case 'CONFIRMED':
        return 'Confirmada';
      case 'COMPLETED':
        return 'Completada';
      case 'CANCELLED':
        return 'Cancelada';
      default:
        return status;
    }
  }
}