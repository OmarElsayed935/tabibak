import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../auth.dart';
import '../models.dart';

class PatientVitalsScreen extends ConsumerStatefulWidget {
  const PatientVitalsScreen({super.key});
  @override
  ConsumerState<PatientVitalsScreen> createState() =>
      _PatientVitalsScreenState();
}

class _PatientVitalsScreenState extends ConsumerState<PatientVitalsScreen> {
  final _sys = TextEditingController();
  final _dia = TextEditingController();
  final _glu = TextEditingController();
  final _wt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider)!;
    final vitals =
        ref.watch(appStateProvider).vitals.where((v) => v.patientId == user.id).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('القياسات الحيوية')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Row(children: [
                  Expanded(
                      child: TextField(
                          controller: _sys,
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(labelText: 'الانقباضي'))),
                  const SizedBox(width: 8),
                  Expanded(
                      child: TextField(
                          controller: _dia,
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(labelText: 'الانبساطي'))),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(
                      child: TextField(
                          controller: _glu,
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(labelText: 'السكر'))),
                  const SizedBox(width: 8),
                  Expanded(
                      child: TextField(
                          controller: _wt,
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(labelText: 'الوزن'))),
                ]),
                const SizedBox(height: 12),
                FilledButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة قياس'),
                  onPressed: () {
                    final v = Vital(
                      id: const Uuid().v4(),
                      patientId: user.id,
                      date: DateTime.now(),
                      systolic: int.tryParse(_sys.text) ?? 0,
                      diastolic: int.tryParse(_dia.text) ?? 0,
                      glucose: double.tryParse(_glu.text) ?? 0,
                      weight: double.tryParse(_wt.text) ?? 0,
                    );
                    ref.read(appStateProvider.notifier).addVital(v);
                    _sys.clear();
                    _dia.clear();
                    _glu.clear();
                    _wt.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم الحفظ')));
                  },
                ),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          ...vitals.map((v) => Card(
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
}