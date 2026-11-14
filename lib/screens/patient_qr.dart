import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../auth.dart';

class PatientQrScreen extends ConsumerWidget {
  const PatientQrScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider)!;
    return Scaffold(
      appBar: AppBar(title: const Text('هويتي الطبية')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: QrImageView(data: user.id, size: 240),
              ),
            ),
            const SizedBox(height: 24),
            Text(user.name,
                style: Theme.of(context).textTheme.titleLarge),
            const Text('اعرض هذا الكود لأي طبيب لفتح ملفك الطبي',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}