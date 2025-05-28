import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// ignore: use_key_in_widget_constructors
class MusicPage extends StatelessWidget {
  final List<Map<String, String>> videos = [
    {'id': 'OqikXPCnl3M', 'title': 'Stop Overthinking - Relaxing Music'},
    {'id': 'goYtPNV5KHc', 'title': 'Calm Mind | Soft Music'},
    {'id': 'wKg71lcs5Nw', 'title': 'Stress Relief Music'},
    {'id': 'T8KzGmhpE0o', 'title': 'Sleep Music & Healing'},
    {'id': 'v0IewxR8nag', 'title': 'Peaceful Soothing Sounds'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calming Music')),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return Container(
            margin: EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(video['title']!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                YoutubePlayer(
                  controller: YoutubePlayerController(
                    initialVideoId: video['id']!,
                    flags: YoutubePlayerFlags(autoPlay: false, mute: false),
                  ),
                  showVideoProgressIndicator: true,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
