import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// ignore: use_key_in_widget_constructors
class MotivationalVideosPage extends StatelessWidget {
  final List<Map<String, String>> videos = [
    {'id': 'ZXsQAXx_ao0', 'title': 'How Bad Do You Want It?'},
    {'id': 'mgmVOuLgFB0', 'title': 'Dream - Motivational'},
    {'id': '3m0xy_HXICw', 'title': 'Morning Motivation 2025'},
    {'id': 'NBKaSyppWFk', 'title': 'Don’t Lose Focus'},
    {'id': '4e_pu8cdQbM', 'title': 'Life is Short'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Motivational Videos')),
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
