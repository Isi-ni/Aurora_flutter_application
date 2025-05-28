import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JournalCreatePage extends StatefulWidget {
  final String userId;

  const JournalCreatePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<JournalCreatePage> createState() => _JournalCreatePageState();
}

class _JournalCreatePageState extends State<JournalCreatePage> {
  final List<TextEditingController> _controllers = List.generate(
    7,
    (_) => TextEditingController(),
  );

  final List<String> questions = [
    'What made you feel happy today?',
    'Did you face any challenges?',
    'How did you cope with stress?',
    'What are you grateful for?',
    'Did you learn something new?',
    'What is your mood right now?',
    'Any other thoughts?',
  ];

  bool _hasSaved = false;

  Future<Map<String, String>> _getAllAnswers() async {
    Map<String, String> answers = {};
    for (int i = 0; i < _controllers.length; i++) {
      answers['q${i + 1}'] = _controllers[i].text.trim();
    }
    return answers;
  }

  Future<void> _saveJournal({required String status}) async {
    final answers = await _getAllAnswers();
    final now = DateTime.now();

    final data = {
      'userId': widget.userId,
      'date': now,
      'questions': answers,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance.collection('journals').add(data);

    if (status == 'saved') {
      setState(() {
        _hasSaved = true;
      });
      for (var controller in _controllers) {
        controller.clear();
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasSaved) {
      await _saveJournal(status: 'draft');
    }
    return true;
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(title: const Text('Create Journal Entry')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date: $formattedDate',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              for (int i = 0; i < questions.length; i++) ...[
                Text(
                  'Question ${i + 1}:',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(questions[i]),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _controllers[i],
                  maxLines: null,
                  minLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Write your answer here...',
                  ),
                ),
                const SizedBox(height: 24),
              ],
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                  onPressed: () async {
                    try {
                      await _saveJournal(status: 'saved');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Journal saved!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error saving journal: $e')),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
