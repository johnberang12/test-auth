import 'package:flutter/material.dart';

class SetCustomClaimScreen extends StatefulWidget {
  const SetCustomClaimScreen({super.key});

  @override
  State<SetCustomClaimScreen> createState() => _SetCustomClaimScreenState();
}

class _SetCustomClaimScreenState extends State<SetCustomClaimScreen> {
  final _userIdController = TextEditingController();
  final _claimController = TextEditingController();
  String get userId => _userIdController.text;

  @override
  void dispose() {
    _userIdController.dispose();
    _claimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Claim')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            TextField(
              controller: _userIdController,
              decoration: const InputDecoration(hintText: 'User phone number'),
            ),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(onPressed: () {}, child: const Text('Set as admin'))
          ],
        ),
      ),
    );
  }
}
