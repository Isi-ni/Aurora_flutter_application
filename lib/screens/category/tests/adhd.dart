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
      home: const ADHDIntroScreen(),
    );
  }
}

class ADHDIntroScreen extends StatelessWidget {
  const ADHDIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADHD Test"),
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
                  "About the ADHD Test",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "This quiz is designed to help assess symptoms of ADHD. Answer the questions as honestly as possible to understand your attention levels. This is not a diagnostic tool, but it may help guide you towards further evaluation.",
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
                    builder: (context) => const ADHDQuizScreen(),
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

class ADHDQuizScreen extends StatefulWidget {
  const ADHDQuizScreen({super.key});

  @override
  State<ADHDQuizScreen> createState() => _ADHDQuizScreenState();
}

class _ADHDQuizScreenState extends State<ADHDQuizScreen> {
  final Map<String, int> _answers = {};
  final List<String> _questions = [
    'Do you often find it difficult to pay attention in conversations?',
    'Do you frequently make careless mistakes in work or other activities?',
    'Do you find it difficult to stay organized?',
    'Are you often easily distracted by stimuli or external noises?',
    'Do you frequently forget important dates or appointments?',
    'Do you feel restless or constantly on the go?',
    'Do you often interrupt others or find it hard to wait your turn?',
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
        title: const Text('ADHD Quiz'),
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
    final double percentage = (score / 21).clamp(0.0, 1.0);

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
                  ? 'High risk of ADHD - Consider seeking professional help.'
                  : score >= 7
                      ? 'Moderate risk - Strategies for improving focus may help.'
                      : 'Low risk - Continue maintaining good mental health.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
