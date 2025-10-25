import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class PatientDetailPage extends StatelessWidget {
  final String patientId;
  
  const PatientDetailPage({
    super.key,
    required this.patientId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient $patientId'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 80,
              color: AppTheme.primaryColor,
            ),
            SizedBox(height: 24),
            Text(
              'Patient Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Coming Soon',
              style: TextStyle(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
