class Doctor {
  final int id;
  final String fullName;
  final String specialty;

  Doctor({
    required this.id,
    required this.fullName,
    required this.specialty,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      fullName: json['fullName'].toString(),
      specialty: json['specialty'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'specialty': specialty,
    };
  }

  Doctor copyWith({
    int? id,
    String? fullName,
    String? specialty,
  }) {
    return Doctor(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      specialty: specialty ?? this.specialty,
    );
  }
}