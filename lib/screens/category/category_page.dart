import 'package:aurora_final/screens/category/chat/chat_screen.dart';
import 'package:aurora_final/screens/category/emergency.dart';
import 'package:aurora_final/screens/category/puzzle/puzzle.dart';
import 'package:aurora_final/screens/category/quotes.dart';
import 'package:aurora_final/screens/category/tests.dart';
import 'package:aurora_final/screens/category/tip_and_resources.dart';
import 'package:aurora_final/screens/dashboard/mood.dart';
import 'package:aurora_final/screens/journal/journal.dart';
import 'package:flutter/material.dart';


class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  void _navigate(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.blue.shade700,
        actions: [
          TextButton(onPressed: () {
            Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatScreen()), //  Navigate to Chatscreen
        );
          }, child: const Text('Chats', style: TextStyle(color: Colors.white))),
          TextButton(onPressed: () {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MoodTrackerUI()), //  Navigate to mood screen
        );
      },
      child: const Text('Dashboard', style: TextStyle(color: Colors.white)),),
          TextButton(onPressed: () {
            Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PuzzleHomePage()), //  Navigate to puzzle screen
        );
            
          }, child: const Text('Puzzle', style: TextStyle(color: Colors.white))),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CategoryPage()),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg-2.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Main Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 40,
              mainAxisSpacing: 40,
              children: [
                _buildTile(context, Icons.settings, 'Settings', Colors.black, const EmergencyContactPage()),
                _buildTile(context, Icons.book, 'Journals', Colors.blue, const JournalDashboard ()),
                _buildTile(context, Icons.check_circle, 'Tests', Colors.green, const TestScreen()),
                _buildTile(context, Icons.phone, 'Emergency', Colors.red, const EmergencyContactPage()),
                _buildTile(context, Icons.lightbulb, 'Tips & Resources', Colors.yellow, const TipAndResources()),
                _buildTile(context, Icons.format_quote, 'Quotes', Colors.purple, const QuoteScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context, IconData icon, String label, Color color, Widget targetPage) {
    return GestureDetector(
      onTap: () => _navigate(context, targetPage),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
