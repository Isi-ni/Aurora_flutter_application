import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditDraftPage extends StatefulWidget {
  final Map<String, dynamic> entry;
  const EditDraftPage({super.key, required this.entry});

  @override
  State<EditDraftPage> createState() => _EditDraftPageState();
}

class _EditDraftPageState extends State<EditDraftPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, TextEditingController> _controllers = {};
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final questions = widget.entry['questions'] as Map<String, dynamic>;
    for (var q in questions.entries) {
      _controllers[q.key] = TextEditingController(text: q.value?.toString() ?? '');
    }
  }

  Future<void> _saveDraft() async {
    if (_saving) return;
    setState(() => _saving = true);

    final updatedQuestions = {
      for (var entry in _controllers.entries) entry.key: entry.value.text,
    };

    try {
      await _firestore.collection('journals').doc(widget.entry['id']).update({
        'questions': updatedQuestions,
        'updatedAt': Timestamp.now(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Draft saved successfully.')),
      );
      Navigator.pop(context); // Return to draft list
    } catch (e) {
      debugPrint('Error saving draft: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save draft.')),
        );
      }
    }

    if (mounted) setState(() => _saving = false);
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Draft')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (var entry in _controllers.entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  controller: entry.value,
                  decoration: InputDecoration(
                    labelText: entry.key,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: null,
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _saving ? null : _saveDraft,
              icon: const Icon(Icons.save),
              label: const Text('Save Draft'),
            ),
          ],
        ),
      ),
    );
  }
}
