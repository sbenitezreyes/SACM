import '../services/api_service.dart';
import 'package:flutter/material.dart';

final apiService = ApiService(baseUrl: 'http://3.142.93.102:8085');

class PatientsPage extends StatefulWidget {
  @override
  _PatientsPageState createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  List<dynamic> patients = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    try {
      final data = await apiService.get('/api/v1/patients');
      setState(() {
        patients = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> deletePatient(String id) async {
    try {
      await apiService.delete('/api/v1/patients/$id');
      setState(() {
        patients.removeWhere((patient) => patient['id'] == id);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el paciente: $e')),
      );
    }
  }

  void handlePatientAction(BuildContext context, String action, Map<String, dynamic> patient) async {
    switch (action) {
      case 'update':
        final result = await Navigator.pushNamed(
          context,
          '/create_patient',
          arguments: patient,
        );
        if (result == true) {
          fetchPatients();
        }
        break;
      case 'delete':
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirmar Eliminación'),
            content: Text('¿Está seguro de que desea eliminar al paciente ${patient['fullName']}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Eliminar'),
              ),
            ],
          ),
        );

        if (confirm == true) {
          await deletePatient(patient['id'].toString());
          fetchPatients();
        }
        break;
      default:
        print('Acción desconocida');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pacientes'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : patients.isEmpty
                  ? Center(child: Text('Aún no hay pacientes registrados'))
                  : ListView.builder(
                      itemCount: patients.length,
                      itemBuilder: (context, index) {
                        final patient = patients[index];
                        return ListTile(
                          title: Text(patient['fullName'] ?? 'Sin nombre'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ID: ${patient['id'] ?? 'Sin ID'}'),
                              Text('Email: ${patient['email'] ?? 'Sin email'}'),
                              Text('Documento: ${patient['documentId'] ?? 'Sin documento'}'),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) => handlePatientAction(context, value, patient),
                            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                value: 'update',
                                child: Text('Actualizar'),
                              ),
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Eliminar'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create_patient');
        },
        child: Icon(Icons.add),
        tooltip: 'Agregar Paciente',
      ),
    );
  }
}