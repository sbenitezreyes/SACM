import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PatientDetailsPage extends StatefulWidget {
  final int patientId;

  const PatientDetailsPage({Key? key, required this.patientId}) : super(key: key);

  @override
  _PatientDetailsPageState createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  Map<String, dynamic>? patientDetails;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchPatientDetails();
  }

  Future<void> fetchPatientDetails() async {
    try {
  final response = await http.get(Uri.parse('http://3.142.93.102:8085/api/v1/patients/${widget.patientId}'));
      if (response.statusCode == 200) {
        setState(() {
          patientDetails = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Error: ${response.reasonPhrase}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error de conexión';
        isLoading = false;
      });
    }
  }

  Future<void> deletePatient() async {
    try {
  final response = await http.delete(Uri.parse('http://3.142.93.102:8085/api/v1/patients/${widget.patientId}'));
      // Cambié la URL a HTTP pero mantuve HTTPS como opción para producción.
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Paciente eliminado con éxito')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Paciente'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID del Paciente: ${widget.patientId}', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Text('Nombre: ${patientDetails?['name'] ?? 'Sin nombre'}', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Text('Edad: ${patientDetails?['age'] ?? 'Sin edad'}', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Text('Correo: ${patientDetails?['email'] ?? 'Sin correo'}', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: deletePatient,
                        child: Text('Eliminar Paciente'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}