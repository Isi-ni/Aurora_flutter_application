import 'package:aurora_final/screens/journal/edit_daft.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// Separate file for EditDraftPage

class DraftJournalPage extends StatefulWidget {
  const DraftJournalPage({super.key});

  @override
  State<DraftJournalPage> createState() => _DraftJournalPageState();
}

class _DraftJournalPageState extends State<DraftJournalPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _draftEntries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDrafts();
  }

  Future<void> _loadDrafts() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('journals')
          .where('status', isEqualTo: 'draft')
          .orderBy('updatedAt', descending: true)
          .get();

      if (!mounted) return;
      _draftEntries = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'questions': Map<String, dynamic>.from(data['questions'] ?? {}),
          'updatedAt': data['updatedAt'],
        };
      }).toList();
    } catch (e) {
      debugPrint('Error loading drafts: $e');
    }
    if (mounted) setState(() => _loading = false);
  }

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown';
    final dt = timestamp.toDate();
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
           '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  void _editDraft(Map<String, dynamic> entry) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditDraftPage(entry: entry),
      ),
    ).then((_) => _loadDrafts()); // Reload drafts on return
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Draft Journal Entries')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _draftEntries.isEmpty
              ? const Center(child: Text('No drafts found.'))
              : ListView.builder(
                  itemCount: _draftEntries.length,
                  itemBuilder: (context, index) {
                    final entry = _draftEntries[index];
                    return ListTile(
                      title: Text('Draft from ${formatTimestamp(entry['updatedAt'])}'),
                      subtitle: Text('${entry['questions'].length} responses'),
                      trailing: const Icon(Icons.edit),
                      onTap: () => _editDraft(entry),
                    );
                  },
                ),
    );
  }
}
