import 'package:flutter/material.dart';
import '../services/api_service.dart';

final apiService = ApiService(baseUrl: 'http://3.142.93.102:8085');

class DoctorsPage extends StatefulWidget {
  @override
  _DoctorsPageState createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  List<dynamic> doctors = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    try {
      final data = await apiService.get('/api/v1/doctors');
      setState(() {
        doctors = (data as List).map((json) => {
          'id': json['id'] ?? 0,
          'fullName': (json['fullName'] ?? '').toString(),
          'specialty': (json['specialty'] ?? '').toString(),
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> deleteDoctor(String id) async {
    try {
      await apiService.delete('/api/v1/doctors/$id');
      setState(() {
        doctors.removeWhere((doctor) => doctor['id'].toString() == id);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el médico: $e')),
      );
    }
  }

  void handleDoctorAction(BuildContext context, String action, Map<String, dynamic> doctor) async {
    switch (action) {
      case 'update':
        Navigator.pushNamed(
          context,
          '/create_doctor',
          arguments: doctor,
        ).then((_) {
          // Refrescar la lista después de actualizar
          setState(() {});
        });
        break;
      case 'delete':
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirmar Eliminación'),
            content: Text('¿Está seguro de que desea eliminar al médico ${doctor['fullName']}?'),
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
          deleteDoctor((doctor['id'] ?? '').toString());
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
        title: Text('Gestión de Médicos'),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text('Error: $errorMessage'))
              : ListView.builder(
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    return ListTile(
                      title: Text(doctor['fullName']?.toString() ?? 'Sin nombre'),
                      subtitle: Text('Especialidad: ${doctor['specialty']?.toString() ?? 'Sin especialidad'}'),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) => handleDoctorAction(context, value, doctor),
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
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            '/create_doctor',
          );
          if (result == true) {
            fetchDoctors();
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Agregar nuevo médico',
      ),
    );
  }
}