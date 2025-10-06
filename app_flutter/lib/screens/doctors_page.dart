import 'package:flutter/material.dart';
import '../services/api_service.dart';

final apiService = ApiService(baseUrl: 'http://ec2-3-21-127-81.us-east-2.compute.amazonaws.com:8085');

class DoctorsPage extends StatefulWidget {
  @override
  _DoctorsPageState createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  List<dynamic> doctors = [];
  List<dynamic> filteredDoctors = [];
  List<String> specialties = [];
  String? selectedSpecialty;
  bool isLoading = true;
  String? errorMessage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDoctors();
    _searchController.addListener(_filterDoctors);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        filteredDoctors = doctors;
        
        // Extraer especialidades únicas
        specialties = doctors
            .map((d) => d['specialty'].toString())
            .toSet()
            .toList()
          ..sort();
        
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _filterDoctors() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredDoctors = doctors.where((doctor) {
        final fullName = doctor['fullName'].toString().toLowerCase();
        final specialty = doctor['specialty'].toString().toLowerCase();
        
        // Filtrar por texto de búsqueda
        final matchesSearch = query.isEmpty || 
            fullName.contains(query) || 
            specialty.contains(query);
        
        // Filtrar por especialidad seleccionada
        final matchesSpecialty = selectedSpecialty == null || 
            doctor['specialty'] == selectedSpecialty;
        
        return matchesSearch && matchesSpecialty;
      }).toList();
    });
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
        title: Text(
          'Médicos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchDoctors,
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
              : doctors.isEmpty
                  ? _buildEmptyState()
                  : Column(
                      children: [
                        // Barra de búsqueda
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Buscar por nombre o especialidad...',
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
                        // Filtro por especialidad
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Icon(Icons.filter_list, size: 20, color: Colors.grey[600]),
                              SizedBox(width: 8),
                              Text(
                                'Especialidad:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: selectedSpecialty,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  hint: Text('Todas'),
                                  items: [
                                    DropdownMenuItem<String>(
                                      value: null,
                                      child: Text('Todas las especialidades'),
                                    ),
                                    ...specialties.map((s) => DropdownMenuItem(
                                          value: s,
                                          child: Text(s),
                                        )),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedSpecialty = value;
                                      _filterDoctors();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        // Contador de resultados
                        if (_searchController.text.isNotEmpty || selectedSpecialty != null)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${filteredDoctors.length} resultado(s) encontrado(s)',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        // Lista de doctores
                        Expanded(
                          child: filteredDoctors.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                                      SizedBox(height: 16),
                                      Text(
                                        'No se encontraron médicos',
                                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Intenta con otro nombre o especialidad',
                                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  itemCount: filteredDoctors.length,
                                  itemBuilder: (context, index) {
                                    final doctor = filteredDoctors[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.white, Colors.green.withOpacity(0.03)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.15),
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
                                      Colors.green,
                                      Colors.green.shade400,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.medical_services,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              title: Text(
                                doctor['fullName']?.toString() ?? 'Sin nombre',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Row(
                                  children: [
                                    Icon(Icons.local_hospital, size: 16, color: Colors.grey[600]),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        doctor['specialty']?.toString() ?? 'Sin especialidad',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) => handleDoctorAction(context, value, doctor),
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
          final result = await Navigator.pushNamed(
            context,
            '/create_doctor',
          );
          if (result == true) {
            fetchDoctors();
          }
        },
        icon: Icon(Icons.add),
        label: Text('Nuevo Médico'),
        tooltip: 'Agregar nuevo médico',
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medical_services_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No hay médicos registrados',
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
            onPressed: fetchDoctors,
            icon: Icon(Icons.refresh),
            label: Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}