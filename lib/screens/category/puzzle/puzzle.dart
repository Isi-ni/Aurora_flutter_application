import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';



class PuzzleHomePage extends StatelessWidget {
  const PuzzleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/puzzle1.jpg", fit: BoxFit.cover),
          Container(color: const ui.Color.fromARGB(136, 38, 15, 15)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Jigsaw Puzzle  🧩",
                    style: TextStyle(fontSize: 42, color: ui.Color.fromARGB(255, 245, 14, 14), fontWeight: FontWeight.bold)),
                const SizedBox(height: 80),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => PuzzleGamePage(gridSize: 4))),
                  child: const Text("Easy"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => PuzzleGamePage(gridSize: 5))),
                  child: const Text("Medium "),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => PuzzleGamePage(gridSize: 6))),
                  child: const Text("Hard "),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PuzzleGamePage extends StatefulWidget {
  final int gridSize;
  const PuzzleGamePage({super.key, required this.gridSize});
  @override
  State<PuzzleGamePage> createState() => _PuzzleGamePageState();
}

class _PuzzleGamePageState extends State<PuzzleGamePage> {
  late List<int> tiles;
  late List<int> correctOrder;
  late ui.Image image;
  bool imageLoaded = false;
  bool isSoundOn = true;
  late AudioPlayer _audioPlayer;
  bool isMusicPlaying = true;


  @override
void initState() {
  super.initState();
  _audioPlayer = AudioPlayer();
  _loadImage();
  _playMusic();
}


  void _loadImage() async {
  final img = await loadImage(context, "assets/images/puzzle1.jpg");
  setState(() {
    image = img;
    imageLoaded = true;
    initPuzzle();});
  }

  
  void _playMusic() async {
  try {
    print("Attempting to play music...");
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.setSource(AssetSource('audios/bg_music.mp3'));
    await _audioPlayer.resume();
    print("Music playing!");
  } catch (e) {
    print("Music play error: $e");
  }
}

  void _toggleMusic() async {
    setState(() => isMusicPlaying = !isMusicPlaying);
    if (isMusicPlaying) {
      await _audioPlayer.resume();
    } else {
      await _audioPlayer.pause();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void initPuzzle() {
    final total = widget.gridSize * widget.gridSize;
    correctOrder = List.generate(total, (i) => i);
    tiles = List.from(correctOrder);
    tiles.shuffle(Random());
  }

  void swapTiles(int oldIndex, int newIndex) {
    setState(() {
      final temp = tiles[oldIndex];
      tiles[oldIndex] = tiles[newIndex];
      tiles[newIndex] = temp;

      if (isSolved()) {
        Future.delayed(const Duration(milliseconds: 300), () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("🎉 Congratulations!"),
              content: const Text("You completed the puzzle."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() => tiles.shuffle(Random()));
                  },
                  child: const Text("OK"),
                )
              ],
            ),
          );
        });
      }
    });
  }

  bool isSolved() {
    for (int i = 0; i < tiles.length; i++) {
      if (tiles[i] != correctOrder[i]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (!imageLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final size = MediaQuery.of(context).size.width * 0.9;
    final tileSize = size / widget.gridSize;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Jigsaw Puzzle"),
        actions: [
          IconButton(
            icon: Icon(isSoundOn ? Icons.volume_up : Icons.volume_off),
            onPressed: () => setState(() => isSoundOn = !isSoundOn),
          ),
          IconButton(
            icon: Icon(isMusicPlaying ? Icons.music_note : Icons.music_off),
            onPressed: _toggleMusic,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            width: size,
            height: size,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tiles.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.gridSize,
              ),
              itemBuilder: (context, index) {
                final tileIndex = tiles[index];
                return DragTarget<int>(
                  onWillAccept: (fromIndex) => fromIndex != index,
                  onAccept: (fromIndex) => swapTiles(fromIndex, index),
                  builder: (context, candidateData, rejectedData) {
                    return Draggable<int>(
                      data: index,
                      feedback: tileWidget(tileIndex, tileSize, true),
                      childWhenDragging: Container(color: Colors.black12),
                      child: tileWidget(tileIndex, tileSize, false),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text("Reset"),
                onPressed: () => setState(() => tiles.shuffle(Random())),
              ),
              const SizedBox(width: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.lightbulb),
                label: const Text("Tips"),
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Puzzle Hint"),
                    content: Image.asset("assets/images/puzzle1.jpg"),
                    actions: [
                      TextButton(
                        child: const Text("Close"),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget tileWidget(int index, double tileSize, bool isDragging) {
    int x = index % widget.gridSize;
    int y = index ~/ widget.gridSize;
    final cropRect = Rect.fromLTWH(
      x * (image.width / widget.gridSize),
      y * (image.height / widget.gridSize),
      image.width / widget.gridSize,
      image.height / widget.gridSize,
    );

    return CustomPaint(
      size: Size(tileSize, tileSize),
      painter: ImageTilePainter(image, cropRect),
    );
  }
}

Future<ui.Image> loadImage(BuildContext context, String assetPath) async {
  final data = await DefaultAssetBundle.of(context).load(assetPath);
  final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
  final frame = await codec.getNextFrame();
  return frame.image;
}


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class ImageTilePainter extends CustomPainter {
  final ui.Image image;
  final Rect sourceRect;

  ImageTilePainter(this.image, this.sourceRect);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    canvas.drawImageRect(
      image,
      sourceRect,
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
