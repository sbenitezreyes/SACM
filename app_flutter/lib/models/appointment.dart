class Appointment {
  final int id;
  final int doctorId;
  final int patientId;
  final String startAt;
  final String endAt;
  final String status;
  final String paymentStatus;
  final String notes;

  Appointment({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.startAt,
    required this.endAt,
    required this.status,
    required this.paymentStatus,
    required this.notes,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      doctorId: json['doctorId'] is int ? json['doctorId'] : int.tryParse(json['doctorId'].toString()) ?? 0,
      patientId: json['patientId'] is int ? json['patientId'] : int.tryParse(json['patientId'].toString()) ?? 0,
      startAt: json['startAt'].toString(),
      endAt: json['endAt'].toString(),
      status: json['status'].toString(),
      paymentStatus: json['paymentStatus'].toString(),
      notes: json['notes'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'patientId': patientId,
      'startAt': startAt,
      'endAt': endAt,
      'status': status,
      'paymentStatus': paymentStatus,
      'notes': notes,
    };
  }
}