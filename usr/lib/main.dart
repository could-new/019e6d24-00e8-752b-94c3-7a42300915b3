import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const RunnerGameApp());
}

class RunnerGameApp extends StatelessWidget {
  const RunnerGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'City Runner 3D',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.purple,
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoadingScreen(),
        '/menu': (context) => const MainMenuScreen(),
        '/game': (context) => const GameScreen(),
      },
    );
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/menu');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.directions_run, size: 80, color: Colors.purpleAccent),
            SizedBox(height: 20),
            Text('City Runner 3D', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 40),
            CircularProgressIndicator(color: Colors.purpleAccent),
          ],
        ),
      ),
    );
  }
}

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  String selectedCharacter = 'Boy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Select Character', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCharacterCard('Boy', Icons.boy, Colors.blue),
                _buildCharacterCard('Girl', Icons.girl, Colors.pink),
              ],
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/game', arguments: selectedCharacter);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              child: const Text('START RUNNING', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterCard(String name, IconData icon, Color color) {
    final isSelected = selectedCharacter == name;
    return GestureDetector(
      onTap: () => setState(() => selectedCharacter = name),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.3) : Colors.transparent,
          border: Border.all(color: isSelected ? color : Colors.grey, width: 3),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, size: 100, color: color),
            const SizedBox(height: 10),
            Text(name, style: TextStyle(fontSize: 24, color: isSelected ? color : Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  int score = 0;
  int coins = 0;
  int lane = 1; // 0: left, 1: center, 2: right
  double jumpHeight = 0;
  bool isSliding = false;
  late Timer gameTimer;
  List<Obstacle> obstacles = [];
  List<Coin> gameCoins = [];
  bool isGameOver = false;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    score = 0;
    coins = 0;
    lane = 1;
    obstacles.clear();
    gameCoins.clear();
    isGameOver = false;

    gameTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      updateGame();
    });
  }

  void updateGame() {
    setState(() {
      score += 1;
      
      // Move obstacles and coins
      for (var obs in obstacles) {
        obs.distance -= 0.05; // speed
      }
      for (var coin in gameCoins) {
        coin.distance -= 0.05;
      }

      obstacles.removeWhere((o) => o.distance < 0);
      gameCoins.removeWhere((c) => c.distance < 0);

      // Spawn
      if (Random().nextDouble() < 0.05) {
        obstacles.add(Obstacle(lane: Random().nextInt(3), distance: 1.0));
      }
      if (Random().nextDouble() < 0.1) {
        gameCoins.add(Coin(lane: Random().nextInt(3), distance: 1.0));
      }

      // Check collision
      for (var obs in obstacles) {
        if (obs.distance < 0.2 && obs.lane == lane && jumpHeight == 0) {
          gameOver();
        }
      }
      for (var coin in gameCoins) {
        if (coin.distance < 0.2 && coin.lane == lane && jumpHeight == 0) {
          coin.distance = -1; // collect
          coins += 10;
        }
      }
    });
  }

  void gameOver() {
    gameTimer.cancel();
    setState(() {
      isGameOver = true;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('Score: $score\nCoins: $coins'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/menu');
            },
            child: const Text('Menu'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              startGame();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void onSwipe(DragEndDetails details) {
    if (isGameOver) return;
    
    if (details.velocity.pixelsPerSecond.dx > 100) {
      if (lane < 2) setState(() => lane++);
    } else if (details.velocity.pixelsPerSecond.dx < -100) {
      if (lane > 0) setState(() => lane--);
    } else if (details.velocity.pixelsPerSecond.dy < -100) {
      // jump
      setState(() => jumpHeight = 100);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => jumpHeight = 0);
      });
    } else if (details.velocity.pixelsPerSecond.dy > 100) {
      // slide
      setState(() => isSliding = true);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => isSliding = false);
      });
    }
  }

  @override
  void dispose() {
    gameTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String character = ModalRoute.of(context)?.settings.arguments as String? ?? 'Boy';
    final isBoy = character == 'Boy';
    
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: onSwipe,
        onVerticalDragEnd: onSwipe,
        child: Stack(
          children: [
            // Background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
                ),
              ),
            ),
            
            // Perspective ground lines
            CustomPaint(
              painter: PerspectivePainter(),
              child: Container(),
            ),

            // Objects (Obstacles and Coins)
            ...obstacles.map((obs) => _buildObject(obs.lane, obs.distance, Colors.red, Icons.warning)),
            ...gameCoins.map((coin) => _buildObject(coin.lane, coin.distance, Colors.yellow, Icons.monetization_on)),

            // Player
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              bottom: 50 + jumpHeight,
              left: MediaQuery.of(context).size.width / 2 - 40 + (lane - 1) * 100,
              child: Transform.scale(
                scale: isSliding ? 0.7 : 1.0,
                child: Icon(
                  isBoy ? Icons.boy : Icons.girl,
                  size: 80,
                  color: isBoy ? Colors.blue : Colors.pink,
                ),
              ),
            ),

            // UI
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Score: $score', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('Coins: $coins', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.amber)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildObject(int objLane, double distance, Color color, IconData icon) {
    if (distance < 0 || distance > 1) return const SizedBox();
    
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Simple perspective projection
    final scale = 1 - distance;
    final y = screenHeight * 0.4 + (screenHeight * 0.5 * scale);
    
    final laneOffset = (objLane - 1) * 100 * scale;
    final x = screenWidth / 2 + laneOffset - (40 * scale);

    return Positioned(
      top: y,
      left: x,
      child: Transform.scale(
        scale: scale,
        child: Icon(icon, size: 80, color: color),
      ),
    );
  }
}

class Obstacle {
  int lane;
  double distance;
  Obstacle({required this.lane, required this.distance});
}

class Coin {
  int lane;
  double distance;
  Coin({required this.lane, required this.distance});
}

class PerspectivePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 2;
      
    final horizonY = size.height * 0.4;
    final bottomY = size.height;
    final centerX = size.width / 2;

    // Draw lanes
    canvas.drawLine(Offset(centerX, horizonY), Offset(centerX - 150, bottomY), paint);
    canvas.drawLine(Offset(centerX, horizonY), Offset(centerX + 150, bottomY), paint);
    canvas.drawLine(Offset(centerX, horizonY), Offset(centerX - 50, bottomY), paint);
    canvas.drawLine(Offset(centerX, horizonY), Offset(centerX + 50, bottomY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
