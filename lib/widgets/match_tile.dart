import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/match_model.dart';

class MatchTile extends StatelessWidget {
  final MatchModel match;

  const MatchTile({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final _TileMeta meta = _buildMeta(match);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAE9E4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  match.timeAgo.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: const Color(0xFF8B8B8B),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: meta.outcomeColor),
                ),
                child: Text(
                  meta.outcome,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: meta.outcomeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 72,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meta.symbol,
                      style: GoogleFonts.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFFF9800),
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      meta.label,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        color: const Color(0xFF8B8B8B),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 48,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                color: const Color(0xFFEAE9E4),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'vs ${meta.opponentName}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      meta.details,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF8B8B8B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _TileMeta _buildMeta(MatchModel m) {
    if (m.winner == 'X') {
      final opponent = m.player2.isEmpty ? 'Guest' : m.player2;
      return _TileMeta(
        symbol: 'X',
        label: 'YOU',
        outcome: 'VICTORY',
        outcomeColor: const Color(0xFF16A34A),
        opponentName: opponent,
        details: 'Classic Match • Local Play',
      );
    }

    if (m.winner == 'O') {
      return _TileMeta(
        symbol: 'O',
        label: 'GUEST',
        outcome: 'DEFEAT',
        outcomeColor: const Color(0xFFDC2626),
        opponentName: 'You',
        details: 'Round 12 • Local Play',
      );
    }

    final opponent = m.player2.isEmpty ? 'Opponent' : m.player2;
    return _TileMeta(
      symbol: 'XO',
      label: '',
      outcome: 'DRAW',
      outcomeColor: const Color(0xFF6B7280),
      opponentName: opponent,
      details: 'Stalemate • Time Out',
    );
  }
}

class _TileMeta {
  final String symbol;
  final String label;
  final String outcome;
  final Color outcomeColor;
  final String opponentName;
  final String details;

  const _TileMeta({
    required this.symbol,
    required this.label,
    required this.outcome,
    required this.outcomeColor,
    required this.opponentName,
    required this.details,
  });
}
