import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../auth.dart';
import '../models.dart';

class AddPrescriptionScreen extends ConsumerStatefulWidget {
  final String patientId;
  const AddPrescriptionScreen({super.key, required this.patientId});
  @override
  ConsumerState<AddPrescriptionScreen> createState() =>
      _AddPrescriptionScreenState();
}

class _AddPrescriptionScreenState
    extends ConsumerState<AddPrescriptionScreen> {
  final _drug = TextEditingController();
  final _dose = TextEditingController();
  final _freq = TextEditingController();
  final _notes = TextEditingController();
  final _items = <PrescriptionItem>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('روشتة جديدة')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
              controller: _drug,
              decoration: const InputDecoration(labelText: 'اسم الدواء')),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
                child: TextField(
                    controller: _dose,
                    decoration: const InputDecoration(labelText: 'الجرعة'))),
            const SizedBox(width: 8),
            Expanded(
                child: TextField(
                    controller: _freq,
                    decoration: const InputDecoration(labelText: 'التكرار'))),
          ]),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('إضافة دواء للروشتة'),
            onPressed: () {
              if (_drug.text.isEmpty) return;
              setState(() {
                _items.add(
                    PrescriptionItem(_drug.text, _dose.text, _freq.text));
                _drug.clear();
                _dose.clear();
                _freq.clear();
              });
            },
          ),
          const SizedBox(height: 16),
          ..._items.map((i) => ListTile(
                leading: const Icon(Icons.medication),
                title: Text(i.drug),
                subtitle: Text('${i.dose} • ${i.frequency}'),
              )),
          const SizedBox(height: 16),
          TextField(
            controller: _notes,
            maxLines: 3,
            decoration:
                const InputDecoration(labelText: 'ملاحظات (اختياري)'),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _items.isEmpty
                ? null
                : () {
                    final user = ref.read(currentUserProvider)!;
                    final p = Prescription(
                      id: const Uuid().v4(),
                      patientId: widget.patientId,
                      doctorName: user.name,
                      date: DateTime.now(),
                      items: List.of(_items),
                      notes: _notes.text.isEmpty ? null : _notes.text,
                    );
                    ref.read(appStateProvider.notifier).addPrescription(p);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم حفظ الروشتة')));
                    context.pop();
                  },
            child: const Text('حفظ الروشتة'),
          ),
        ],
      ),
    );
  }
}