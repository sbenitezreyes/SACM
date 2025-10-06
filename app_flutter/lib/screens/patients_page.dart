import '../services/api_service.dart';
import 'package:flutter/material.dart';

final apiService = ApiService(baseUrl: 'http://3.142.93.102:8085');

class PatientsPage extends StatefulWidget {
  @override
  _PatientsPageState createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  List<dynamic> patients = [];
  List<dynamic> filteredPatients = [];
  bool isLoading = true;
  String? errorMessage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPatients();
    _searchController.addListener(_filterPatients);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchPatients() async {
    try {
      final data = await apiService.get('/api/v1/patients');
      setState(() {
        patients = data;
        filteredPatients = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _filterPatients() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredPatients = patients;
      } else {
        filteredPatients = patients.where((patient) {
          final documentId = patient['documentId'].toString().toLowerCase();
          final fullName = patient['fullName'].toString().toLowerCase();
          return documentId.contains(query) || fullName.contains(query);
        }).toList();
      }
    });
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
        title: Text(
          'Pacientes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchPatients,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : errorMessage != null
              ? _buildErrorState()
              : patients.isEmpty
                  ? _buildEmptyState()
                  : Column(
                      children: [
                        // Barra de búsqueda
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Buscar por documento o nombre...',
                              prefixIcon: Icon(Icons.search),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () {
                                        _searchController.clear();
                                      },
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                        ),
                        // Contador de resultados
                        if (_searchController.text.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${filteredPatients.length} resultado(s) encontrado(s)',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        // Lista de pacientes
                        Expanded(
                          child: filteredPatients.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                                      SizedBox(height: 16),
                                      Text(
                                        'No se encontraron pacientes',
                                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Intenta con otro documento o nombre',
                                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  itemCount: filteredPatients.length,
                                  itemBuilder: (context, index) {
                                    final patient = filteredPatients[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.white, Colors.blue.withOpacity(0.03)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16),
                              leading: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).primaryColor,
                                      Theme.of(context).primaryColor.withOpacity(0.7),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              title: Text(
                                patient['fullName'] ?? 'Sin nombre',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoRow(Icons.email, patient['email'] ?? 'Sin email'),
                                    SizedBox(height: 4),
                                    _buildInfoRow(Icons.badge, patient['documentId'] ?? 'Sin documento'),
                                  ],
                                ),
                              ),
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) => handlePatientAction(context, value, patient),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                icon: Icon(Icons.more_vert),
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: 'update',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, size: 20),
                                        SizedBox(width: 12),
                                        Text('Actualizar'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, size: 20, color: Colors.red),
                                        SizedBox(width: 12),
                                        Text('Eliminar', style: TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                        ),
                      ],
                    ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/create_patient');
          if (result == true) {
            fetchPatients();
          }
        },
        icon: Icon(Icons.add),
        label: Text('Nuevo Paciente'),
        tooltip: 'Agregar Paciente',
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No hay pacientes registrados',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Presiona el botón + para agregar uno',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red[300],
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              errorMessage!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: fetchPatients,
            icon: Icon(Icons.refresh),
            label: Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}