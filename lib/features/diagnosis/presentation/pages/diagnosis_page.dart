import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/vital_signs_card.dart';
import '../../../../shared/widgets/ai_prediction_card.dart';

class DiagnosisPage extends ConsumerStatefulWidget {
  const DiagnosisPage({super.key});

  @override
  ConsumerState<DiagnosisPage> createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends ConsumerState<DiagnosisPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 3;

  // Form data
  final Map<String, bool> _selectedSymptoms = {};
  final Map<String, dynamic> _vitalSigns = {
    'temperature': 37.0,
    'blood_pressure_systolic': 120,
    'blood_pressure_diastolic': 80,
    'heart_rate': 72,
    'respiratory_rate': 16,
    'oxygen_saturation': 98.0,
  };
  final Map<String, dynamic> _patientInfo = {
    'age': 30,
    'gender': 'Male',
    'weight': 70.0,
    'height': 170.0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Diagnosis'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              context.go('/diagnosis/history');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Indicator
          _buildProgressIndicator(),
          
          // Page Content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              children: [
                _buildSymptomsPage(),
                _buildVitalSignsPage(),
                _buildPatientInfoPage(),
              ],
            ),
          ),
          
          // Navigation Buttons
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: List.generate(_totalSteps, (index) {
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(
                    right: index < _totalSteps - 1 ? 8 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: index <= _currentStep
                        ? AppTheme.primaryColor
                        : AppTheme.textDisabled,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            'Step ${_currentStep + 1} of $_totalSteps',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Symptoms',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select all symptoms that apply to help with accurate diagnosis',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          
          // Common Symptoms
          _buildSymptomCategory('General Symptoms', [
            'Fever',
            'Fatigue',
            'Headache',
            'Nausea',
            'Dizziness',
            'Loss of appetite',
            'Weight loss',
            'Night sweats',
          ]),
          
          const SizedBox(height: 16),
          
          // Respiratory Symptoms
          _buildSymptomCategory('Respiratory', [
            'Cough',
            'Shortness of breath',
            'Chest pain',
            'Runny nose',
            'Sore throat',
            'Difficulty breathing',
          ]),
          
          const SizedBox(height: 16),
          
          // Digestive Symptoms
          _buildSymptomCategory('Digestive', [
            'Abdominal pain',
            'Diarrhea',
            'Constipation',
            'Vomiting',
            'Bloating',
            'Indigestion',
          ]),
          
          const SizedBox(height: 16),
          
          // Other Symptoms
          _buildSymptomCategory('Other', [
            'Joint pain',
            'Muscle aches',
            'Skin rash',
            'Swelling',
            'Vision problems',
            'Hearing problems',
          ]),
        ],
      ),
    );
  }

  Widget _buildSymptomCategory(String title, List<String> symptoms) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: symptoms.map((symptom) {
            final isSelected = _selectedSymptoms[symptom] ?? false;
            return FilterChip(
              label: Text(symptom),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedSymptoms[symptom] = selected;
                });
              },
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryColor,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildVitalSignsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vital Signs',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter the patient\'s current vital signs',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          
          VitalSignsCard(
            vitalSigns: _vitalSigns,
            onChanged: (key, value) {
              setState(() {
                _vitalSigns[key] = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPatientInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Patient Information',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter basic patient information for better diagnosis',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _patientInfo['age'].toString(),
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      suffixText: 'years',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _patientInfo['age'] = int.tryParse(value) ?? 0;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  DropdownButtonFormField<String>(
                    value: _patientInfo['gender'],
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                    ),
                    items: ['Male', 'Female', 'Other'].map((gender) {
                      return DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _patientInfo['gender'] = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    initialValue: _patientInfo['weight'].toString(),
                    decoration: const InputDecoration(
                      labelText: 'Weight',
                      suffixText: 'kg',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _patientInfo['weight'] = double.tryParse(value) ?? 0.0;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    initialValue: _patientInfo['height'].toString(),
                    decoration: const InputDecoration(
                      labelText: 'Height',
                      suffixText: 'cm',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _patientInfo['height'] = double.tryParse(value) ?? 0.0;
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // AI Prediction Preview
          const AIPredictionCard(),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Text('Previous'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _currentStep < _totalSteps - 1
                  ? () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  : () {
                      _performDiagnosis();
                    },
              child: Text(
                _currentStep < _totalSteps - 1 ? 'Next' : 'Get Diagnosis',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _performDiagnosis() {
    // TODO: Implement AI diagnosis logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI Diagnosis Complete'),
        content: const Text('The AI has analyzed the symptoms and provided a diagnosis.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to results page with diagnosis data
              final diagnosisData = {
                'symptoms': _selectedSymptoms.keys.where((key) => _selectedSymptoms[key] == true).toList(),
                'vitalSigns': _vitalSigns,
                'patientInfo': _patientInfo,
                'timestamp': DateTime.now().toIso8601String(),
              };
              context.go('/diagnosis/result', extra: diagnosisData);
            },
            child: const Text('View Results'),
          ),
        ],
      ),
    );
  }
}