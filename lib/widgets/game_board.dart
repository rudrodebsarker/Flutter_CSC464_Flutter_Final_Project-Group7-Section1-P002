import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        const boardPadding = 12.0;
        const gap = 8.0;
        const maxCellSize = 100.0;
        const minCellSize = 46.0;

        final widthBasedCell =
            (constraints.maxWidth - (boardPadding * 2) - (gap * 2)) / 3;
        final hasFiniteHeight = constraints.maxHeight.isFinite;
        final heightBasedCell = hasFiniteHeight
            ? (constraints.maxHeight - (boardPadding * 2) - (gap * 2)) / 3
            : maxCellSize;

        final cellSize = math.min(
          maxCellSize,
          math.max(minCellSize, math.min(widthBasedCell, heightBasedCell)),
        );

        final boardSize = (cellSize * 3) + (gap * 2) + (boardPadding * 2);

        return Center(
          child: SizedBox(
            width: boardSize,
            height: boardSize,
            child: Container(
              padding: const EdgeInsets.all(boardPadding),
              decoration: BoxDecoration(
                color: const Color(0xFF242424),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildRow(context, provider, 0, cellSize),
                  const SizedBox(height: gap),
                  _buildRow(context, provider, 1, cellSize),
                  const SizedBox(height: gap),
                  _buildRow(context, provider, 2, cellSize),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRow(
    BuildContext context,
    GameProvider provider,
    int row,
    double cellSize,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCell(context, provider, row * 3 + 0, cellSize),
        const SizedBox(width: 8),
        _buildCell(context, provider, row * 3 + 1, cellSize),
        const SizedBox(width: 8),
        _buildCell(context, provider, row * 3 + 2, cellSize),
      ],
    );
  }

  Widget _buildCell(
    BuildContext context,
    GameProvider provider,
    int index,
    double cellSize,
  ) {
    final cellValue = provider.board[index];
    final isWinningCell = provider.winningLine.contains(index);
    final canTap = cellValue.isEmpty && provider.gameResult == null;
    final symbolSize = math.min(42.0, math.max(20.0, cellSize * 0.42));

    return GestureDetector(
      onTap: canTap ? () => context.read<GameProvider>().makeMove(index) : null,
      child: SizedBox(
        width: cellSize,
        height: cellSize,
        child: Container(
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
                    fontSize: symbolSize,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFFF9800),
                  ),
                ),
        ),
      ),
    );
  }
}
