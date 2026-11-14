import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../auth.dart';
import '../models.dart';

class DoctorHomeScreen extends ConsumerWidget {
  const DoctorHomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final patients = ref.watch(appStateProvider).patients;
    return Scaffold(
      appBar: AppBar(
        title: Text(user?.name ?? 'الطبيب'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authRepoProvider).clear();
              ref.read(currentUserProvider.notifier).state = null;
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('مرضاك', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...patients.map((p) => Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text(p.name[0])),
                  title: Text(p.name),
                  subtitle: Text('${p.age} سنة • ${p.chronic.join(", ")}'),
                  trailing: const Icon(Icons.chevron_left),
                  onTap: () => context.push('/doctor/patient/${p.id}'),
                ),
              )),
          const SizedBox(height: 24),
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: ListTile(
              leading: const Icon(Icons.qr_code_scanner),
              title: const Text('مسح QR مريض'),
              subtitle: const Text('افتح ملف مريض بمسح الكود'),
              onTap: () => _showScannerDialog(context),
            ),
          ),
        ],
      ),
    );
  }

  void _showScannerDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('مسح QR'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(hintText: 'كود المريض (مثال: p2)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          FilledButton(
            onPressed: () {
              final id = ctrl.text.trim();
              Navigator.pop(ctx);
              if (id.isNotEmpty) context.push('/doctor/patient/$id');
            },
            child: const Text('فتح'),
          ),
        ],
      ),
    );
  }
}