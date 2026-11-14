import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../auth.dart';
import '../models.dart';

class PatientHomeScreen extends ConsumerWidget {
  const PatientHomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider)!;
    final state = ref.watch(appStateProvider);
    final myVitals = state.vitals.where((v) => v.patientId == user.id).toList();
    final myRx =
        state.prescriptions.where((p) => p.patientId == user.id).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
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
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: ListTile(
              leading: const Icon(Icons.qr_code_2, size: 40),
              title: const Text('هويتي الطبية'),
              subtitle: Text('كود: ${user.id}'),
              trailing: const Icon(Icons.chevron_left),
              onTap: () => context.push('/patient/qr'),
            ),
          ),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
              child: _stat('القياسات', '${myVitals.length}',
                  Icons.monitor_heart, () => context.push('/patient/vitals')),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _stat('الروشتات', '${myRx.length}',
                  Icons.receipt_long, () {}),
            ),
          ]),
          const SizedBox(height: 24),
          Text('أحدث القياسات',
              style: Theme.of(context).textTheme.titleMedium),
          if (myVitals.isEmpty)
            const Text('لا توجد قياسات بعد')
          else
            ...myVitals.take(3).map((v) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.monitor_heart),
                    title: Text('${v.systolic}/${v.diastolic} • سكر ${v.glucose}'),
                    subtitle: Text('الوزن ${v.weight} كجم'),
                  ),
                )),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, IconData icon, VoidCallback onTap) =>
      Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Icon(icon, size: 32, color: Colors.blue),
              const SizedBox(height: 8),
              Text(value,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(color: Colors.grey)),
            ]),
          ),
        ),
      );
}