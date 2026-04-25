import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildRow(context, provider, 0),
          _buildRow(context, provider, 1),
          _buildRow(context, provider, 2),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, GameProvider provider, int row) {
    return Expanded(
      child: Row(
        children: [
          _buildCell(context, provider, row * 3 + 0),
          const SizedBox(width: 8),
          _buildCell(context, provider, row * 3 + 1),
          const SizedBox(width: 8),
          _buildCell(context, provider, row * 3 + 2),
        ],
      ),
    );
  }

  Widget _buildCell(BuildContext context, GameProvider provider, int index) {
    final cellValue = provider.board[index];
    final isWinningCell = provider.winningLine.contains(index);
    final canTap = cellValue.isEmpty && provider.gameResult == null;

    return Expanded(
      child: GestureDetector(
        onTap: canTap
            ? () => context.read<GameProvider>().makeMove(index)
            : null,
        child: Container(
          height: null,
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2E),
            borderRadius: BorderRadius.circular(12),
            border: isWinningCell
                ? Border.all(color: const Color(0xFFFF9800), width: 2.5)
                : Border.all(color: Colors.transparent, width: 2.5),
          ),
          alignment: Alignment.center,
          child: cellValue.isEmpty
              ? null
              : Text(
                  cellValue,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFFF9800),
                  ),
                ),
        ),
      ),
    );
  }
}
