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
      home: const DepressionIntroScreen(),
    );
  }
}

class DepressionIntroScreen extends StatelessWidget {
  const DepressionIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Depression Test"),
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
                  "About the Depression Test",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "This quiz is designed to help you assess symptoms of depression over the past two weeks. Your answers can help you reflect on your mental health. This is not a diagnostic tool, but it can guide you toward seeking support if needed.",
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
                    builder: (context) => const DepressionQuizScreen(),
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

class DepressionQuizScreen extends StatefulWidget {
  const DepressionQuizScreen({super.key});

  @override
  State<DepressionQuizScreen> createState() => _DepressionQuizScreenState();
}

class _DepressionQuizScreenState extends State<DepressionQuizScreen> {
  final Map<String, int> _answers = {};
  final List<String> _questions = [
    'Do you feel a lack of interest or pleasure in doing things?',
    'Have you been feeling down, depressed, or hopeless?',
    'Do you have trouble sleeping or sleep too much?',
    'Have you felt tired or had low energy?',
    'Have you experienced poor appetite or overeating?',
    'Do you feel bad about yourself or feel like a failure?',
    'Do you find it difficult to concentrate on activities?',
    'Have you been moving or speaking unusually slowly or restlessly?',
    'Have you had thoughts that you would be better off dead or of hurting yourself?',
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
    String resultText;

    if (score >= 20) {
      resultText = 'Severe Depression – It is strongly recommended to seek professional help.';
    } else if (score >= 15) {
      resultText = 'Moderately Severe Depression – Active treatment is advised.';
    } else if (score >= 10) {
      resultText = 'Moderate Depression – Consider therapy or consulting a specialist.';
    } else if (score >= 5) {
      resultText = 'Mild Depression – Monitoring and self-care recommended.';
    } else {
      resultText = 'Minimal or No Depression – Keep taking care of your mental well-being.';
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(result: resultText, score: score),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Depression Quiz'),
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
  final String result;
  final int score;

  const ResultScreen({super.key, required this.result, required this.score});

  @override
  Widget build(BuildContext context) {
    double percentage = (score / 27) * 100;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Result')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 60.0,
                lineWidth: 10.0,
                percent: percentage / 100,
                center: Text('${percentage.toStringAsFixed(1)}%'),
                progressColor: Colors.blue,
              ),
              const SizedBox(height: 20),
              Text(result, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
