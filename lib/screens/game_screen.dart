import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/match_model.dart';
import '../providers/game_provider.dart';
import '../providers/history_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/game_board.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _resultSaved = false;
  bool _isShowingResultSheet = false;
  bool _resultPopupShown = false;
  GameProvider? _gameProvider;
  bool _timerStarted = false;

  @override
  void initState() {
    super.initState();
    _resultSaved = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _gameProvider ??= context.read<GameProvider>();
    if (!_timerStarted) {
      _timerStarted = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        _gameProvider?.startTurnTimer();
      });
    }
  }

  @override
  void deactivate() {
    _gameProvider?.stopTurnTimer();
    super.deactivate();
  }

  @override
  void dispose() {
    _gameProvider?.stopTurnTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();

    if (provider.gameResult == null) {
      _resultSaved = false;
      _resultPopupShown = false;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleGameResultIfNeeded();
      });
    }

    return Theme(
      data: AppTheme.darkTheme,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) {
            return;
          }

          final gameInProgress =
              provider.gameResult == null && provider.board.any((c) => c.isNotEmpty);

          if (!gameInProgress) {
            Navigator.of(context).pop();
            return;
          }

          final leave = await showDialog<bool>(
            context: context,
            builder: (dialogContext) {
              return AlertDialog(
                title: const Text('Leave Game?'),
                content: const Text('Your current game progress will be lost.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, true),
                    child: const Text('Leave'),
                  ),
                ],
              );
            },
          );

          if (leave == true && context.mounted) {
            _gameProvider?.abandonMatch();
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFF1C1C1E),
          appBar: AppBar(
            backgroundColor: const Color(0xFF1C1C1E),
            elevation: 0,
            scrolledUnderElevation: 0,
            title: const Text(
              '#Kata Golla by 7',
              style: TextStyle(
                color: AppTheme.primary,
                fontSize: 32,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings_rounded, color: AppTheme.primary),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'CURRENT TURN',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color(0xFF9A9A9E),
                      letterSpacing: 2.4,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: const Color(0x66FF9800), width: 1.2),
                      color: const Color(0x1AFF9800),
                    ),
                    child: Text(
                      'PLAYER ${provider.currentPlayer}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${provider.turnTimeLeft}s',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color(0xFFB7B7BB),
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: _ScoreCard(
                          label: 'X WINS',
                          value: provider.xWins,
                          topAccent: const Color(0xFFFF9800),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ScoreCard(
                          label: 'TIES',
                          value: provider.ties,
                          topAccent: const Color(0xFF505055),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ScoreCard(
                          label: 'O WINS',
                          value: provider.oWins,
                          topAccent: const Color(0xFFFFD600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Expanded(
                    child: Center(
                      child: GameBoard(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            context.read<GameProvider>().resetBoard();
                          },
                          child: const Text('Restart Round'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<GameProvider>().resetAll();
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/setup',
                              (_) => false,
                            );
                          },
                          child: const Text('New Game'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: const Color(0xFF2C2C2E),
            child: BottomNavigationBar(
              currentIndex: 0,
              onTap: (index) {
                if (index == 1) {
                  _gameProvider?.abandonMatch();
                  Navigator.pushReplacementNamed(context, '/history');
                }
              },
              backgroundColor: const Color(0xFF2C2C2E),
              selectedItemColor: AppTheme.primary,
              unselectedItemColor: const Color(0xFF9A9A9E),
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.sports_esports_outlined),
                  activeIcon: Icon(Icons.sports_esports),
                  label: 'PLAY',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  label: 'HISTORY',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleGameResultIfNeeded() async {
    if (!mounted || _isShowingResultSheet || _resultPopupShown) {
      return;
    }

    final route = ModalRoute.of(context);
    if (route != null && !route.isCurrent) {
      return;
    }

    final gameProvider = context.read<GameProvider>();
    if (gameProvider.gameResult == null) {
      return;
    }

    _resultPopupShown = true;

    if (!_resultSaved) {
      _resultSaved = true;
      final match = MatchModel(
        player1: gameProvider.player1Name.isEmpty
            ? 'Player 1'
            : gameProvider.player1Name,
        player2: gameProvider.player2Name.isEmpty
            ? 'Player 2'
            : gameProvider.player2Name,
        winner: gameProvider.gameResult!,
        board: List<String>.from(gameProvider.board),
        createdAt: Timestamp.now(),
      );

      await context.read<HistoryProvider>().saveMatch(match);
    }

    _isShowingResultSheet = true;

    final winner = gameProvider.gameResult;
    final isTie = winner == 'Tie';
    final winnerName = winner == 'X'
        ? (gameProvider.player1Name.isEmpty
            ? 'Player 1'
            : gameProvider.player1Name)
        : winner == 'O'
            ? (gameProvider.player2Name.isEmpty
                ? 'Player 2'
                : gameProvider.player2Name)
            : 'Draw';

    if (!mounted) {
      _isShowingResultSheet = false;
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF2C2C2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isTie ? '🤝' : '🏆',
                  style: const TextStyle(fontSize: 44),
                ),
                const SizedBox(height: 10),
                Text(
                  isTie ? "It's a Draw!" : '$winnerName Wins!',
                  style: Theme.of(sheetContext).textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '${gameProvider.player1Name.isEmpty ? 'Player 1' : gameProvider.player1Name} '
                  'vs '
                  '${gameProvider.player2Name.isEmpty ? 'Player 2' : gameProvider.player2Name}',
                  style: Theme.of(sheetContext).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFB5B5B8),
                      ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      context.read<GameProvider>().resetBoard();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.black,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Play Again'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      context.read<GameProvider>().resetAll();
                      Navigator.pop(sheetContext);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/setup',
                        (_) => false,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: AppTheme.primary, width: 1.4),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('New Game'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    _isShowingResultSheet = false;
  }
}

class _ScoreCard extends StatelessWidget {
  final String label;
  final int value;
  final Color topAccent;

  const _ScoreCard({
    required this.label,
    required this.value,
    required this.topAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            height: 3,
            width: double.infinity,
            decoration: BoxDecoration(
              color: topAccent,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: const Color(0xFFB7B7BB),
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            '$value',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}
