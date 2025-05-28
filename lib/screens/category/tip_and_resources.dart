import 'package:aurora_final/screens/category/tips%20and%20resources/mindful_exercises.dart';
import 'package:aurora_final/screens/category/tips%20and%20resources/motivational_videos.dart';
import 'package:aurora_final/screens/category/tips%20and%20resources/relax_music.dart';
import 'package:flutter/material.dart';




class TipAndResources extends StatelessWidget {
  const TipAndResources({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/tips_bg.jpg"), // Add this image to assets
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTile(
                  context,
                  label: 'Motivational Videos',
                  icon: Icons.rocket_launch_rounded,
                  page: MotivationalVideosPage(),
                ),
                SizedBox(height: 20),
                _buildTile(
                  context,
                  label: 'Wellness Exercises',
                  icon: Icons.self_improvement,
                  page: ExercisePage(),
                ),
                SizedBox(height: 20),
                _buildTile(
                  context,
                  label: 'Calming Music',
                  icon: Icons.music_note,
                  page: MusicPage(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, {required String label, required IconData icon, required Widget page}) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.teal, size: 28),
            SizedBox(width: 10),
            Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
