import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_auth/features/admin_pannel/presentation/set_custom_claim_screen.dart';
import 'package:test_auth/features/admin_pannel/presentation/update_doc_field_screen.dart';

class AdminPanelScreen extends ConsumerWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SetCustomClaimScreen())),
                  child: const Text('Set claim')),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const UpdateDocField())),
                  child: const Text('Update doc field'))
            ]),
      ),
    );
  }
}
