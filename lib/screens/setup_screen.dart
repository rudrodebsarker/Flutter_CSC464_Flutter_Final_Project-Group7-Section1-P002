import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../theme/app_theme.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final TextEditingController _player1Controller = TextEditingController();
  final TextEditingController _player2Controller = TextEditingController();

  @override
  void dispose() {
    _player1Controller.dispose();
    _player2Controller.dispose();
    super.dispose();
  }

  void _startGame() {
    final rawP1 = _player1Controller.text.trim();
    final rawP2 = _player2Controller.text.trim();

    if (rawP1.isEmpty && rawP2.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter at least one player name'),
        ),
      );
      return;
    }

    final p1 = rawP1.isEmpty ? 'Player 1' : rawP1;
    final p2 = rawP2.isEmpty ? 'Player 2' : rawP2;

    context.read<GameProvider>().setPlayerNames(p1, p2);

    Navigator.pushNamed(context, '/game');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF9F6),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'Prepare for Battle',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppTheme.neutral,
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'SETUP YOUR PLAYERS',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: const Color(0xFF8C847B),
                  letterSpacing: 3,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 34),
              _buildPlayerField(
                label: 'PLAYER 1 (X)',
                controller: _player1Controller,
                mark: 'X',
                isPlayerOne: true,
              ),
              const SizedBox(height: 20),
              _buildPlayerField(
                label: 'PLAYER 2 (O)',
                controller: _player2Controller,
                mark: 'O',
                isPlayerOne: false,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  onPressed: _startGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: const Color(0xFF4B2C00),
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'Start Game 🚀',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF6F5F2),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFEAE6DE)),
        ),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: BottomNavigationBar(
          currentIndex: 0,
          onTap: (index) {
            if (index == 1) {
              Navigator.pushNamed(context, '/history');
            }
          },
          backgroundColor: Colors.transparent,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: const Color(0xFF8D8D8D),
          elevation: 0,
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
    );
  }

  Widget _buildPlayerField({
    required String label,
    required TextEditingController controller,
    required String mark,
    required bool isPlayerOne,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppTheme.primary,
            letterSpacing: 1.4,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          textInputAction: TextInputAction.next,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppTheme.neutral,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'Enter name...',
            filled: true,
            fillColor: const Color(0xFFF0EFEB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: AppTheme.primary, width: 2),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isPlayerOne ? const Color(0xFFFFF2DF) : Colors.white,
                  border: Border.all(
                    color: isPlayerOne ? Colors.transparent : AppTheme.primary,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  mark,
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

}
