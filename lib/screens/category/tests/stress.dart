import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

void main() {
  runApp(const AuroraApp());
}

class AuroraApp extends StatelessWidget {
  const AuroraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const StressIntroScreen(),
    );
  }
}

class StressIntroScreen extends StatelessWidget {
  const StressIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stress Test"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "About the Stress Test",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "This quiz is designed to help assess the level of stress you're experiencing. Please answer the following questions honestly.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  "Estimated Time: 3-5 minutes",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StressQuizScreen(),
                  ),
                ),
                child: const Text("Take the Quiz"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StressQuizScreen extends StatefulWidget {
  const StressQuizScreen({super.key});

  @override
  State<StressQuizScreen> createState() => _StressQuizScreenState();
}

class _StressQuizScreenState extends State<StressQuizScreen> {
  final Map<String, int> _answers = {};
  final List<String> _questions = [
    'Feeling overwhelmed with all your responsibilities?',
    'Finding it difficult to relax?',
    'Feeling nervous or anxious often?',
    'Being easily irritated or angered?',
    'Having trouble sleeping because of stress?',
    'Feeling constantly tired, even after a good night’s sleep?',
    'Avoiding situations that might cause stress?',
    'Feeling like you are unable to manage your workload or tasks?',
  ];

  final List<String> _options = [
    'Not at all',
    'Several days',
    'More than half the days',
    'Nearly every day',
  ];

  final Map<String, int> _scoreMapping = {
    'Not at all': 0,
    'Several days': 1,
    'More than half the days': 2,
    'Nearly every day': 3,
  };

  int calculateScore() {
    return _answers.values.fold(0, (sum, value) => sum + value);
  }

  void _showResult(BuildContext context) {
    final int score = calculateScore();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(score: score),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stress Quiz'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How often have you been bothered by the following over the past 2 weeks?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ..._questions.map((question) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(question, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    Column(
                      children: _options.map((option) => RadioListTile(
                            title: Text(option),
                            value: _scoreMapping[option]!,

                            groupValue: _answers[question],
                            onChanged: (value) {
                              setState(() {
                                _answers[question] = value!;
                              });
                            },
                          )).toList(),
                    ),
                  ],
                )),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => _showResult(context),
                child: const Text('See Result'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final int score;

  const ResultScreen({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final double percentage = (score / 24).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Result')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 100.0,
              lineWidth: 13.0,
              animation: true,
              percent: percentage,
              center: Text("${(percentage * 100).toInt()}%", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
              progressColor: Colors.orange,
            ),
            const SizedBox(height: 20),
            Text(
              score >= 14
                  ? 'Moderate to high stress - Consider seeking stress management strategies.'
                  : score >= 7
                      ? 'Mild stress - Manage stress through relaxation techniques.'
                      : 'Low stress - Continue maintaining good mental health.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
