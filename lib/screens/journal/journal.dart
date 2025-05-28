import 'package:aurora_final/screens/journal/create_journal.dart';
import 'package:aurora_final/screens/journal/draft.dart';
import 'package:aurora_final/screens/journal/saved.dart';
import 'package:flutter/material.dart';
// import 'create_journal_page.dart';
// import 'drafts_page.dart';
// import 'saved_journal_page.dart';

class JournalDashboard extends StatelessWidget {
  const JournalDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tiles = [
      {
        'title': 'Create',
        'icon': Icons.create,
        'page': JournalCreatePage(key: UniqueKey(), userId: ''),
        
      },
      {'title': 'Drafts', 'icon': Icons.note_alt, 'page': const DraftJournalPage()},
      {'title': 'Saved', 'icon': Icons.bookmark, 'page': const SavedJournalPage()},
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg-3.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: tiles
              .map((tile) => GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => tile['page']));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          const BoxShadow(color: Colors.black38, blurRadius: 6, offset: Offset(3, 3))
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(tile['icon'], size: 28, color: Colors.black87),
                          const SizedBox(width: 12),
                          Text(
                            tile['title'],
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}


