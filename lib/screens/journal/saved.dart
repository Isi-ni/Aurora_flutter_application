import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SavedJournalPage extends StatefulWidget {
  const SavedJournalPage({Key? key}) : super(key: key);

  @override
  State<SavedJournalPage> createState() => _SavedJournalPageState();
}

class _SavedJournalPageState extends State<SavedJournalPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _savedEntries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedEntries();
  }

  Future<void> _loadSavedEntries() async {
    setState(() => _loading = true);
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('journals')
          .where('status', isEqualTo: 'saved')
          .orderBy('updatedAt', descending: true)
          .get();

      _savedEntries = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'questions': Map<String, dynamic>.from(data['questions'] ?? {}),
          'updatedAt': data['updatedAt'],
        };
      }).toList();
    } catch (e) {
      debugPrint('Error loading saved entries: $e');
    }
    setState(() => _loading = false);
  }

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown date';
    DateTime dt = timestamp.toDate();
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
           '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _deleteEntry(String docId) async {
    await _firestore.collection('journals').doc(docId).delete();
    _loadSavedEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Journal Entries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSavedEntries,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _savedEntries.isEmpty
              ? const Center(child: Text('No saved entries found.'))
              : ListView.builder(
                  itemCount: _savedEntries.length,
                  itemBuilder: (context, index) {
                    final entry = _savedEntries[index];
                    final questions = entry['questions'] as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Saved on: ${formatTimestamp(entry['updatedAt'] as Timestamp?)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Delete Entry'),
                                        content: const Text('Are you sure you want to delete this journal entry?'),
                                        actions: [
                                          TextButton(
                                            child: const Text('Cancel'),
                                            onPressed: () => Navigator.pop(context, false),
                                          ),
                                          ElevatedButton(
                                            child: const Text('Delete'),
                                            onPressed: () => Navigator.pop(context, true),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      await _deleteEntry(entry['id']);
                                    }
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ...questions.entries.map((q) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        q.key,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(q.value.toString()),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
