import 'package:flutter/material.dart';

class UpdateDocField extends StatefulWidget {
  const UpdateDocField({super.key});

  @override
  State<UpdateDocField> createState() => _UpdateDocFieldState();
}

class _UpdateDocFieldState extends State<UpdateDocField> {
  final _collectionNameController = TextEditingController();
  final _fieldToAddController = TextEditingController();
  final _fieldValueController = TextEditingController();

  Future<void> addField() async {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update doc field')),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: _collectionNameController,
            decoration: const InputDecoration(label: Text('Collection name')),
          ),
          const SizedBox(
            height: 24,
          ),
          TextField(
            controller: _fieldToAddController,
            decoration: const InputDecoration(label: Text('Field to add')),
          ),
          const SizedBox(
            height: 24,
          ),
          TextField(
            controller: _fieldValueController,
            decoration: const InputDecoration(label: Text('Field value')),
          ),
          const SizedBox(
            height: 24,
          ),
          ElevatedButton(
              onPressed: () => addField(), child: const Text('Add field'))
        ]),
      ),
    );
  }
}
