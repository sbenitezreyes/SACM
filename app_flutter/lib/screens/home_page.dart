import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sistema de Gestión Médica',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppTheme.spacingLG),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: AppTheme.spacingMD,
          mainAxisSpacing: AppTheme.spacingMD,
          childAspectRatio: 1.1, // Hace las tarjetas más anchas y menos altas
          children: [
            _buildMenuCard(
              context,
              icon: Icons.people,
              title: 'Pacientes',
              subtitle: 'Gestionar pacientes',
              color: AppTheme.primaryColor,
              onTap: () => Navigator.pushNamed(context, '/patients'),
            ),
            _buildMenuCard(
              context,
              icon: Icons.calendar_today,
              title: 'Citas',
              subtitle: 'Gestionar citas',
              color: AppTheme.accentColor,
              onTap: () => Navigator.pushNamed(context, '/appointments'),
            ),
            _buildMenuCard(
              context,
              icon: Icons.medical_services,
              title: 'Médicos',
              subtitle: 'Gestionar médicos',
              color: AppTheme.successColor,
              onTap: () => Navigator.pushNamed(context, '/doctors'),
            ),
            _buildMenuCard(
              context,
              icon: Icons.settings,
              title: 'Configuración',
              subtitle: 'Ajustes del sistema',
              color: AppTheme.textSecondary,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Próximamente')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMD),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMD),
          child: Padding(
            padding: EdgeInsets.all(AppTheme.spacingMD),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(AppTheme.spacingSM),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withOpacity(0.8), color],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: AppTheme.spacingSM),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppTheme.spacingXS),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}