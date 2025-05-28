import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  final List<Map<String, String>> quotes = [
    {
      'quote': 'Believe you can and you’re halfway there.',
      'author': 'Theodore Roosevelt',
      'emoji': '💪'
    },
    {
      'quote': 'Every day is a second chance.',
      'author': 'Unknown',
      'emoji': '☀️'
    },
    {
      'quote': 'Breathe. It’s just a bad day, not a bad life.',
      'author': 'Unknown',
      'emoji': '🌿'
    },
    {
      'quote': 'You are enough just as you are.',
      'author': 'Meghan Markle',
      'emoji': '💖'
    },
    
  ];

  int todayIndex = 0;

  @override
  void initState() {
    super.initState();
    calculateTodayIndex();
  }

  void calculateTodayIndex() {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final diff = now.difference(startOfYear).inDays;
    setState(() {
      todayIndex = diff % quotes.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final quoteData = quotes[todayIndex];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.95),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '“',
                      style: TextStyle(
                        fontSize: 48,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      quoteData['quote'] ?? '',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '- ${quoteData['author']}',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      quoteData['emoji'] ?? '',
                      style: const TextStyle(fontSize: 28),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
