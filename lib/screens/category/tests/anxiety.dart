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
      home: AnxietyQuizScreen(),
    );
  }
}

class AnxietyQuizScreen extends StatefulWidget {
  const AnxietyQuizScreen({super.key});

  @override
  State<AnxietyQuizScreen> createState() => _AnxietyQuizScreenState();
}

class _AnxietyQuizScreenState extends State<AnxietyQuizScreen> {
  final Map<String, int> _answers = {};
  final List<String> _questions = [
    'Feeling nervous, anxious, or on edge?',
    'Not being able to stop or control worrying?',
    'Worrying too much about different things?',
    'Trouble relaxing?',
    "Being so restless that it's hard to sit still?",
    'Becoming easily annoyed or irritable?',
    'Feeling afraid as if something awful might happen?',
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
        title: const Text('Anxiety Quiz'),
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
              'How often have they been bothered by the following over the past 2 weeks?',
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
    final double percentage = (score / 21).clamp(0.0, 1.0); // 21 is the maximum possible score

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
              progressColor: Colors.purple,
            ),
            const SizedBox(height: 20),
            Text(
              score >= 10
                  ? 'Moderate to severe anxiety - Further assessment recommended.'
                  : score >= 5
                      ? 'Mild anxiety - Monitor your mental health.'
                      : 'Minimal anxiety - Keep maintaining good mental health.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}


class AnxietyIntroScreen extends StatelessWidget {
  const AnxietyIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Anxiety Test"),
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
                  "About the Anxiety Test",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "This quiz is designed to help you understand your anxiety levels. Answer the questions honestly for accurate results. This is not a medical diagnosis but can offer helpful insights.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  "Estimated Time: 3-5 minutes",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),

            // 'Take the Quiz' Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AnxietyQuizScreen(),
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
