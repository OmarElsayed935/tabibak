import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth.dart';

class RoleSelectionScreen extends ConsumerWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.local_hospital,
                  size: 80, color: Color(0xFF1E88E5)),
              const SizedBox(height: 16),
              Text('طبيبك',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('منصة طبية متكاملة',
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 48),
              _RoleCard(
                title: 'أنا طبيب',
                subtitle: 'إدارة المرضى والروشتات والمواعيد',
                icon: Icons.medical_services,
                onTap: () async {
                  final u = AppUser(
                    id: 'd1',
                    name: 'د. محمد كامل',
                    role: UserRole.doctor,
                    specialty: 'باطنة',
                    license: '12345',
                  );
                  await ref.read(authRepoProvider).set(u);
                  ref.read(currentUserProvider.notifier).state = u;
                },
              ),
              const SizedBox(height: 16),
              _RoleCard(
                title: 'أنا مريض',
                subtitle: 'ملفي الطبي، مواعيدي، روشتاتي',
                icon: Icons.person,
                onTap: () async {
                  final u = AppUser(
                    id: 'p1',
                    name: 'أحمد محمد',
                    role: UserRole.patient,
                  );
                  await ref.read(authRepoProvider).set(u);
                  ref.read(currentUserProvider.notifier).state = u;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final VoidCallback onTap;
  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(children: [
            Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ]),
        ),
      ),
    );
  }
}