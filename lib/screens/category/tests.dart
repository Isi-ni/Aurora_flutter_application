import 'package:aurora_final/screens/category/tests/adhd.dart';
import 'package:aurora_final/screens/category/tests/anxiety.dart';
import 'package:aurora_final/screens/category/tests/depression.dart';
import 'package:aurora_final/screens/category/tests/ptsd.dart';
import 'package:aurora_final/screens/category/tests/stress.dart';
import 'package:flutter/material.dart';



class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/test_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Column(
            children: [
              const SizedBox(height: 40),

              // Top Menu Bar
              // Container(
              //   color: Colors.purple,
              //   padding: const EdgeInsets.symmetric(vertical: 10),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: const [
              //       Text('Chat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              //       Text('Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              //       Text('Puzzle', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              //       Text('Menu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              //     ],
              //   ),
              // ),

              // const SizedBox(height: 20),

              // Highlighted 'Test' Heading with Back Button as Icon
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 5),
                      const Image(
                        image: AssetImage('assets/icons/test.png'),
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Test',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Test Buttons
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTestButton(context, 'Anxiety', const AnxietyIntroScreen()),
                    _buildTestButton(context, 'Depression', const DepressionIntroScreen()),
                    _buildTestButton(context, 'Stress', const StressIntroScreen()),
                    _buildTestButton(context, 'ADHD', const ADHDIntroScreen()),
                    _buildTestButton(context, 'PTSD', const PTSDIntroScreen()),
                    _buildTestButton(context, 'More Tests', const MoreTestsScreen()),
                    _buildTestButton(context, 'Score Board', const ScoreBoardScreen()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTestButton(BuildContext context, String label, Widget screen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(200, 50),
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        ),
        child: Text(label),
      ),
    );
  }
}

// Sample Pages for Each Test


// class DepressionIntroScreen extends StatelessWidget {
//   const DepressionIntroScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(child: Text("Depression Test Introduction Page")),
//     );
//   }
// }

// class StressIntroScreen extends StatelessWidget {
//   const StressIntroScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(child: Text("Stress Test Introduction Page")),
//     );
//   }
// }

// class ADHDIntroScreen extends StatelessWidget {
//   const ADHDIntroScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(child: Text("ADHD Test Introduction Page")),
//     );
//   }
// }

// class PTSDIntroScreen extends StatelessWidget {
//   const PTSDIntroScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(child: Text("PTSD Test Introduction Page")),
//     );
//   }
// }

class MoreTestsScreen extends StatelessWidget {
  const MoreTestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("More Tests Coming Soon!")),
    );
  }
}

class ScoreBoardScreen extends StatelessWidget {
  const ScoreBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Score Board Page")),
    );
  }
}

