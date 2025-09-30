import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../services/api_service.dart';

class PatientProvider with ChangeNotifier {
  final ApiService apiService;
  List<Patient> _patients = [];

  PatientProvider({required this.apiService});

  List<Patient> get patients => _patients;

  Future<void> fetchPatients() async {
    final response = await apiService.get('/api/v1/patients');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      _patients = data.map((json) => Patient.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> addPatient(Patient patient) async {
    final response = await apiService.post('/api/v1/patients', patient.toJson());
    if (response.statusCode == 201) {
      _patients.add(patient);
      notifyListeners();
    }
  }
}