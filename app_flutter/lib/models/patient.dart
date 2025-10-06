class Patient {
  final String id;
  final String fullName;
  final String documentId;
  final String email;

  Patient({required this.id, required this.fullName, required this.documentId, required this.email});

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'].toString(),
      fullName: json['fullName'].toString(),
      documentId: json['documentId'].toString(),
      email: json['email'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'documentId': documentId,
      'email': email,
    };
  }
}