import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth.dart';
import 'core/theme.dart';
import 'screens/role_selection.dart';
import 'screens/doctor_home.dart';
import 'screens/patient_detail.dart';
import 'screens/add_prescription.dart';
import 'screens/patient_home.dart';
import 'screens/patient_qr.dart';
import 'screens/patient_vitals.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final user = ref.watch(currentUserProvider);
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      if (user == null) return state.matchedLocation == '/' ? null : '/';
      final target = user.role == UserRole.doctor ? '/doctor' : '/patient';
      if (state.matchedLocation == '/') return target;
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, __) => const RoleSelectionScreen()),
      GoRoute(path: '/doctor', builder: (_, __) => const DoctorHomeScreen()),
      GoRoute(
        path: '/doctor/patient/:id',
        builder: (_, s) => PatientDetailScreen(patientId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/doctor/prescription/:id',
        builder: (_, s) => AddPrescriptionScreen(patientId: s.pathParameters['id']!),
      ),
      GoRoute(path: '/patient', builder: (_, __) => const PatientHomeScreen()),
      GoRoute(path: '/patient/qr', builder: (_, __) => const PatientQrScreen()),
      GoRoute(path: '/patient/vitals', builder: (_, __) => const PatientVitalsScreen()),
    ],
  );
});

class TabibakApp extends ConsumerWidget {
  const TabibakApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'طبيبك',
      theme: appTheme,
      routerConfig: ref.watch(routerProvider),
      debugShowCheckedModeBanner: false,
    );
  }
}