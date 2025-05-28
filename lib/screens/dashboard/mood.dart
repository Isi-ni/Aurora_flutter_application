import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MoodTrackerUI extends StatefulWidget {
  const MoodTrackerUI({super.key});

  @override
  State<MoodTrackerUI> createState() => _MoodTrackerUIState();
}

class _MoodTrackerUIState extends State<MoodTrackerUI> {
  final List<String> moods = ['😊 Happy', '😢 Sad', '😡 Angry', '😌 Calm', '🥴 Overwhelm'];
  final Map<String, List<Map<String, int>>> moodHistory = {}; // Local mood history
  final Map<String, int> tempMoodLevels = {};
  String selectedRange = '1 Week';

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String userId = 'testUser'; // Replace with actual user ID if using Firebase Auth

  @override
  void initState() {
    super.initState();
    loadMoodHistory();
  }

  void updateMood(String mood, int level) {
    setState(() {
      tempMoodLevels[mood] = level;
    });
  }

  Future<void> submitMoods() async {
    final now = DateTime.now();
    final dateKey = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final moodEntry = Map<String, int>.from(tempMoodLevels);

    if (moodEntry.isEmpty) return;

    try {
      final ref = firestore.collection('users').doc(userId).collection('moodHistory').doc(dateKey);
      final snapshot = await ref.get();

      List moodsToday = [];
      if (snapshot.exists) {
        moodsToday = snapshot.data()?['entries'] ?? [];
      }

      if (moodsToday.length < 3) {
        moodsToday.add(moodEntry);

        await ref.set({'entries': moodsToday});
        setState(() {
          moodHistory[dateKey] = List<Map<String, int>>.from(
            moodsToday.map<Map<String, int>>((e) => Map<String, int>.from(e)),
          );
          tempMoodLevels.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You can only enter moods 3 times per day.")),
        );
      }
    } catch (e) {
      print("Error submitting moods: $e");
    }
  }

  Future<void> loadMoodHistory() async {
    try {
      final ref = firestore.collection('users').doc(userId).collection('moodHistory');
      final snapshot = await ref.get();

      final Map<String, List<Map<String, int>>> loaded = {};
      for (var doc in snapshot.docs) {
        final entries = (doc['entries'] as List).map<Map<String, int>>(
          (entry) => Map<String, int>.from(entry as Map),
        ).toList();
        loaded[doc.id] = entries;
      }

      setState(() {
        moodHistory.clear();
        moodHistory.addAll(loaded);
      });
    } catch (e) {
      print("Error loading mood history: $e");
    }
  }

  Future<void> clearHistory() async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear All History"),
        content: const Text("Are you sure you want to delete all mood history?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("OK")),
        ],
      ),
    );

    if (shouldClear == true) {
      try {
        final ref = firestore.collection('users').doc(userId).collection('moodHistory');
        final snapshot = await ref.get();

        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }

        setState(() => moodHistory.clear());
      } catch (e) {
        print("Error clearing history: $e");
      }
    }
  }

  List<String> filterDates(List<String> allDates) {
    final now = DateTime.now();
    final daysBack = selectedRange == '1 Week'
        ? 7
        : selectedRange == '1 Month'
            ? 30
            : 90;
    return allDates.where((dateStr) {
      final parts = dateStr.split('-');
      final date = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
      return now.difference(date).inDays <= daysBack;
    }).toList();
  }

  Widget buildMoodChart() {
    final allKeys = moodHistory.keys.toList();
    final keys = filterDates(allKeys);

    List<FlSpot> allSpots = [];
    Map<int, String> spotToDateMap = {};

    for (int i = 0; i < keys.length; i++) {
      final entries = moodHistory[keys[i]]!;
      for (int j = 0; j < entries.length; j++) {
        int index = allSpots.length;
        allSpots.add(FlSpot(index.toDouble(), (entries[j]['😊 Happy'] ?? 0).toDouble()));
        spotToDateMap[index] = keys[i];
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: allSpots.length * 40.0,
        height: 300,
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: 5,
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    int index = value.toInt();
                    final date = spotToDateMap[index];
                    if (date != null) {
                      final parts = date.split('-');
                      final dt = DateTime.parse("${parts[0]}-${parts[1].padLeft(2, '0')}-${parts[2].padLeft(2, '0')}");
                      return Text("${["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][dt.weekday % 7]}\n${dt.day}/${dt.month}", style: const TextStyle(fontSize: 10));
                    }
                    return const Text('');
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, _) => Text(value.toInt().toString()),
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: allSpots,
                isCurved: true,
                color: Colors.blue,
                barWidth: 2,
                dotData: FlDotData(show: true),
              ),
            ],
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: Colors.black87,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final index = spot.x.toInt();
                    final date = spotToDateMap[index];
                    if (date != null) {
                      final moods = moodHistory[date];
                      if (moods != null && moods.isNotEmpty) {
                        final summary = <String, int>{};
                        for (var entry in moods) {
                          for (var mood in entry.entries) {
                            summary[mood.key] = (summary[mood.key] ?? 0) + mood.value;
                          }
                        }
                        final moodText = summary.entries.map((e) => "${e.key}: ${e.value}").join("\n");
                        return LineTooltipItem(
                          "$date\n$moodText",
                          const TextStyle(color: Colors.white),
                        );
                      }
                    }
                    return null;
                  }).whereType<LineTooltipItem>().toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mood Tracker UI")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text("Viewed by: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: selectedRange,
                  items: ['1 Week', '1 Month', '3 Months']
                      .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                      .toList(),
                  onChanged: (value) => setState(() => selectedRange = value!),
                ),
              ],
            ),
            const SizedBox(height: 16),
            buildMoodChart(),
            const SizedBox(height: 20),
            const Text("How are you feeling today?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...moods.map((mood) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(mood),
                    DropdownButton<int>(
                      value: tempMoodLevels[mood] ?? 0,
                      items: List.generate(6, (i) => DropdownMenuItem(value: i, child: Text("$i"))),
                      onChanged: (val) => updateMood(mood, val!),
                    )
                  ],
                )),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: submitMoods, child: const Text("Enter")),
                ElevatedButton(onPressed: () => setState(() => tempMoodLevels.clear()), child: const Text("Reset")),
                ElevatedButton(onPressed: clearHistory, child: const Text("Clear")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(const MaterialApp(home: MoodTrackerUI()));

