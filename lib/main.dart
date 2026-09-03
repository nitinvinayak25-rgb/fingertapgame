import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // BLUE PLAYER  -> matches "PLAYER B" on the game page
          Container(
            color: const Color.fromARGB(255, 14, 2, 182),
            height: MediaQuery.of(context).size.height / 2,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "PLAYER B",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    height: 150,
                    minWidth: 150,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GamePage(),
                        ),
                      );
                    },
                    child: const Text("START"),
                  ),
                ],
              ),
            ),
          ),

          // RED PLAYER -> matches "PLAYER A" on the game page
          Container(
            color: const Color.fromARGB(255, 211, 4, 4),
            height: MediaQuery.of(context).size.height / 2,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "PLAYER A",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    height: 150,
                    minWidth: 150,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GamePage(),
                        ),
                      );
                    },
                    child: const Text("START"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  double blueCardHeight = 0;
  double redCardHeight = 0;

  int playerAscore = 0;
  int playerBscore = 0;

  bool initialized = false;

  // --- Countdown state ---
  final List<String> countdownSteps = ["5", "4", "3", "2", "1", "Let's start!"];
  int countdownIndex = 0;
  bool gameStarted = false;
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (countdownIndex < countdownSteps.length - 1) {
          countdownIndex++;
        } else {
          gameStarted = true;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    // Fix: cancel the timer so it doesn't keep firing after this page is gone.
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (initialized == false) {
      blueCardHeight = MediaQuery.of(context).size.height / 2;
      redCardHeight = MediaQuery.of(context).size.height / 2;
      initialized = true;
    }

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // PLAYER B
              GestureDetector(
                onTap: !gameStarted
                    ? null
                    : () {
                        setState(() {
                          blueCardHeight = blueCardHeight + 30;
                          redCardHeight = redCardHeight - 30;

                          playerBscore = playerBscore + 5;
                        });

                        double winningHeight =
                            MediaQuery.of(context).size.height - 60;

                        if (blueCardHeight > winningHeight) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ResultPage(playerBscore, "PLAYER B WON"),
                            ),
                          );
                        }
                      },
                child: Container(
                  color: const Color.fromARGB(255, 14, 2, 182),
                  alignment: Alignment.topLeft,
                  height: blueCardHeight,
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "PLAYER B",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        playerBscore.toString(),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // PLAYER A
              GestureDetector(
                onTap: !gameStarted
                    ? null
                    : () {
                        setState(() {
                          redCardHeight = redCardHeight + 30;
                          blueCardHeight = blueCardHeight - 30;

                          playerAscore = playerAscore + 5;
                        });

                        double winningHeight =
                            MediaQuery.of(context).size.height - 60;

                        if (redCardHeight > winningHeight) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ResultPage(playerAscore, "PLAYER A WON"),
                            ),
                          );
                        }
                      },
                child: Container(
                  color: const Color.fromARGB(255, 211, 4, 4),
                  height: redCardHeight,
                  alignment: Alignment.bottomLeft,
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "PLAYER A",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        playerAscore.toString(),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Countdown overlay, shown until gameStarted becomes true
          if (!gameStarted)
            Container(
              color: Colors.black.withOpacity(0.6),
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Text(
                  countdownSteps[countdownIndex],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final int score;
  final String player;

  const ResultPage(this.score, this.player, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: player == "PLAYER A WON"
          ? const Color.fromARGB(255, 211, 4, 4)
          : const Color.fromARGB(255, 14, 2, 182),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              score.toString(),
              style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
            Text(
              player,
              style: const TextStyle(fontSize: 40),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              color: Colors.black,
              child: const Text(
                "RESTART GAME",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
