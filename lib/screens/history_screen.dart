import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../providers/history_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/match_tile.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<HistoryProvider>().init();
    final historyProvider = context.watch<HistoryProvider>();
    final gameProvider = context.watch<GameProvider>();

    final rightAppBarText = gameProvider.player1Name.trim().isEmpty
        ? 'PLAYER 1'
        : gameProvider.player1Name.trim().toUpperCase();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF9F6),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          '#Kata Golla by 7',
          style: GoogleFonts.plusJakartaSans(
            color: AppTheme.primary,
            fontSize: 32,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: Text(
                rightAppBarText,
                style: GoogleFonts.plusJakartaSans(
                  color: AppTheme.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'VAULT ARCHIVES',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
                color: const Color(0xFF8B8B8B),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Match History',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'TOTAL GAMES',
                    value: historyProvider.totalGames.toString(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'WIN RATE',
                    value: historyProvider.winRate,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (historyProvider.isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 32),
                child: Center(
                  child: CircularProgressIndicator(color: AppTheme.primary),
                ),
              )
            else if (historyProvider.matches.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 28),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.sports_esports_outlined,
                        size: 48,
                        color: Color(0xFF8B8B8B),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'No matches yet!',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF8B8B8B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Play a game to see history',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF8B8B8B),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Column(
                children: historyProvider.matches
                    .map((match) => MatchTile(match: match))
                    .toList(),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamedAndRemoveUntil(context, '/setup', (_) => false);
          }
        },
        backgroundColor: const Color(0xFFFAF9F6),
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: const Color(0xFF8B8B8B),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_esports_outlined),
            activeIcon: Icon(Icons.sports_esports),
            label: 'PLAY',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'HISTORY'),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAE9E4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: const Color(0xFF8B8B8B),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFFF9800),
            ),
          ),
        ],
      ),
    );
  }
}
