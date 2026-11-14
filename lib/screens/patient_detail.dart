import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models.dart';

class PatientDetailScreen extends ConsumerWidget {
  final String patientId;
  const PatientDetailScreen({super.key, required this.patientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(appStateProvider.notifier);
    final patient = notifier.patientById(patientId);
    if (patient == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('مريض غير موجود')),
      );
    }
    final vitals = notifier.vitalsFor(patientId);
    final scripts = notifier.prescriptionsFor(patientId);
    final df = DateFormat('yyyy/MM/dd');
    return Scaffold(
      appBar: AppBar(title: Text(patient.name)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/doctor/prescription/${patient.id}'),
        icon: const Icon(Icons.add),
        label: const Text('روشتة جديدة'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _row('العمر', '${patient.age} سنة'),
                  _row('أمراض مزمنة',
                      patient.chronic.isEmpty ? '—' : patient.chronic.join(', ')),
                  _row('حساسية',
                      patient.allergies.isEmpty ? '—' : patient.allergies.join(', ')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('أحدث القياسات',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (vitals.isEmpty)
            const Text('لا توجد قياسات')
          else
            Card(
              child: Column(
                children: vitals
                    .take(3)
                    .map((v) => ListTile(
                          leading: const Icon(Icons.monitor_heart),
                          title: Text(
                              '${v.systolic}/${v.diastolic} • سكر ${v.glucose} • ${v.weight} كجم'),
                          subtitle: Text(df.format(v.date)),
                        ))
                    .toList(),
              ),
            ),
          const SizedBox(height: 16),
          Text('الروشتات', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (scripts.isEmpty)
            const Text('لا توجد روشتات')
          else
            ...scripts.map((r) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.receipt_long),
                    title: Text(df.format(r.date)),
                    subtitle: Text(r.items.map((i) => i.drug).join(', ')),
                  ),
                )),
        ],
      ),
    );
  }

  Widget _row(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          Text('$k: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(v)),
        ]),
      );
}