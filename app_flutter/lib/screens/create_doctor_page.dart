import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateDoctorPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _specialtyController = TextEditingController();

  Future<void> simulateCreateDoctor(Map<String, dynamic> doctorData) async {
    // Simulación de creación de médico
    await Future.delayed(Duration(seconds: 1));
    print('Médico creado exitosamente (simulación)');
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? doctor = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (doctor != null) {
      _nameController.text = (doctor['fullName'] ?? '').toString();
      _specialtyController.text = (doctor['specialty'] ?? '').toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(doctor == null ? 'Crear Nuevo Médico' : 'Actualizar Médico'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre Completo',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _specialtyController,
                decoration: InputDecoration(
                  labelText: 'Especialidad',
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  final fullName = _nameController.text;
                  final specialty = _specialtyController.text;

                  if (fullName.isEmpty || specialty.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Datos Inválidos'),
                        content: Text('Por favor, complete todos los campos.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Aceptar'),
                          ),
                        ],
                      ),
                    );
                    return;
                  }

                  if (doctor == null) {
                    try {
                      // Crear médico
                      final response = await http.post(
                        Uri.parse('http://3.142.93.102:8085/api/v1/doctors'),
                        headers: {'Content-Type': 'application/json'},
                        body: json.encode({
                          'fullName': fullName,
                          'specialty': specialty,
                        }),
                      );
                      if (response.statusCode == 201 || response.statusCode == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Médico creado exitosamente.')),
                        );
                      } else {
                        throw Exception('Error al crear médico: ${response.body}');
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al crear médico: $e')),
                      );
                    }
                  } else {
                    try {
                      // Actualizar médico
                      final response = await http.put(
                        Uri.parse('http://3.142.93.102:8085/api/v1/doctors/${doctor['id']}'),
                        headers: {'Content-Type': 'application/json'},
                        body: json.encode({
                          'fullName': fullName,
                          'specialty': specialty,
                        }),
                      );
                      if (response.statusCode == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Médico actualizado exitosamente.')),
                        );
                      } else {
                        throw Exception('Error al actualizar médico: ${response.body}');
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al actualizar médico: $e')),
                      );
                    }
                  }

                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
                child: Text(doctor == null ? 'Guardar' : 'Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}