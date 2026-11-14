import 'package:flutter_riverpod/flutter_riverpod.dart';

class Patient {
  final String id, name;
  final int age;
  final List<String> chronic, allergies;
  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.chronic,
    required this.allergies,
  });
}

class Vital {
  final String id, patientId;
  final DateTime date;
  final int systolic, diastolic;
  final double glucose, weight;
  Vital({
    required this.id,
    required this.patientId,
    required this.date,
    required this.systolic,
    required this.diastolic,
    required this.glucose,
    required this.weight,
  });
}

class PrescriptionItem {
  final String drug, dose, frequency;
  PrescriptionItem(this.drug, this.dose, this.frequency);
}

class Prescription {
  final String id, patientId, doctorName;
  final DateTime date;
  final List<PrescriptionItem> items;
  final String? notes;
  Prescription({
    required this.id,
    required this.patientId,
    required this.doctorName,
    required this.date,
    required this.items,
    this.notes,
  });
}

class AppState {
  final List<Patient> patients;
  final List<Vital> vitals;
  final List<Prescription> prescriptions;
  AppState({
    required this.patients,
    required this.vitals,
    required this.prescriptions,
  });
  AppState copyWith({
    List<Patient>? patients,
    List<Vital>? vitals,
    List<Prescription>? prescriptions,
  }) =>
      AppState(
        patients: patients ?? this.patients,
        vitals: vitals ?? this.vitals,
        prescriptions: prescriptions ?? this.prescriptions,
      );
}

final seedState = AppState(
  patients: [
    Patient(id: 'p1', name: 'أحمد محمد', age: 45,
        chronic: ['سكري نوع 2'], allergies: ['بنسلين']),
    Patient(id: 'p2', name: 'فاطمة علي', age: 32,
        chronic: ['أنيميا'], allergies: []),
    Patient(id: 'p3', name: 'محمود سعيد', age: 60,
        chronic: ['ضغط'], allergies: ['أسبرين']),
  ],
  vitals: [
    Vital(id: 'v1', patientId: 'p1', date: DateTime.now().subtract(const Duration(days: 1)),
        systolic: 135, diastolic: 88, glucose: 165, weight: 82),
    Vital(id: 'v2', patientId: 'p1', date: DateTime.now().subtract(const Duration(days: 7)),
        systolic: 145, diastolic: 92, glucose: 190, weight: 83),
    Vital(id: 'v3', patientId: 'p3', date: DateTime.now().subtract(const Duration(days: 2)),
        systolic: 150, diastolic: 95, glucose: 110, weight: 90),
  ],
  prescriptions: [
    Prescription(
      id: 'rx1',
      patientId: 'p1',
      doctorName: 'د. محمد كامل',
      date: DateTime.now().subtract(const Duration(days: 3)),
      items: [PrescriptionItem('ميتفورمين 500', 'قرص', 'مرتين يوميًا')],
      notes: 'متابعة بعد أسبوعين',
    ),
  ],
);

class AppStateNotifier extends Notifier<AppState> {
  @override
  AppState build() => seedState;

  void addVital(Vital v) => state = state.copyWith(vitals: [...state.vitals, v]);
  void addPrescription(Prescription p) =>
      state = state.copyWith(prescriptions: [...state.prescriptions, p]);

  Patient? patientById(String id) =>
      state.patients.where((p) => p.id == id).firstOrNull;

  List<Vital> vitalsFor(String pid) =>
      (state.vitals.where((v) => v.patientId == pid).toList()
        ..sort((a, b) => b.date.compareTo(a.date)));

  List<Prescription> prescriptionsFor(String pid) =>
      (state.prescriptions.where((p) => p.patientId == pid).toList()
        ..sort((a, b) => b.date.compareTo(a.date)));
}

final appStateProvider =
    NotifierProvider<AppStateNotifier, AppState>(AppStateNotifier.new);