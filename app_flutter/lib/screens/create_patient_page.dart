import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CreatePatientPage extends StatefulWidget {
  @override
  _CreatePatientPageState createState() => _CreatePatientPageState();
}

class _CreatePatientPageState extends State<CreatePatientPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _documentIdController = TextEditingController();

  String? patientId;
  bool isUpdate = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _nameController.text = args['fullName'] ?? '';
      _emailController.text = args['email'] ?? '';
      _documentIdController.text = args['documentId'] ?? '';
      patientId = args['id']?.toString();
      isUpdate = true;
    }
  }

  Future<void> createPatient(Map<String, dynamic> patientData) async {
    final response = await http.post(
  Uri.parse('http://3.142.93.102:8085/api/v1/patients'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(patientData),
    );
    if (response.statusCode == 201) {
      print('Paciente creado exitosamente');
    } else {
      print('Error: ${response.statusCode}');
      throw Exception('Error al crear paciente: ${response.body}');
    }
  }

  Future<void> updatePatient(Map<String, dynamic> patientData) async {
    final response = await http.put(
  Uri.parse('http://3.142.93.102:8085/api/v1/patients/$patientId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(patientData),
    );
    if (response.statusCode == 200) {
      print('Paciente actualizado exitosamente');
    } else {
      print('Error: ${response.statusCode}');
      throw Exception('Error al actualizar paciente: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isUpdate ? 'Actualizar Paciente' : 'Crear Paciente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _documentIdController,
                decoration: InputDecoration(labelText: 'Documento'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el documento';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final patientData = {
                      'fullName': _nameController.text,
                      'email': _emailController.text,
                      'documentId': _documentIdController.text,
                    };
                    try {
                      if (isUpdate) {
                        await updatePatient(patientData);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Paciente actualizado exitosamente')),
                        );
                        Navigator.pop(context, true);
                      } else {
                        await createPatient(patientData);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Paciente creado exitosamente')),
                        );
                        Navigator.pop(context, true);
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
                child: Text(isUpdate ? 'Actualizar' : 'Crear'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}