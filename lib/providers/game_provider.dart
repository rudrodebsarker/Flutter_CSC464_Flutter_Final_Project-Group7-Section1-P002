import 'dart:async';

import 'package:flutter/foundation.dart';

class GameProvider extends ChangeNotifier {
  static const int _turnDurationSeconds = 10;
  static const List<List<int>> _winningCombinations = <List<int>>[
    <int>[0, 1, 2],
    <int>[3, 4, 5],
    <int>[6, 7, 8],
    <int>[0, 3, 6],
    <int>[1, 4, 7],
    <int>[2, 5, 8],
    <int>[0, 4, 8],
    <int>[2, 4, 6],
  ];

  List<String> board = List<String>.filled(9, '');
  String currentPlayer = 'X';
  String player1Name = '';
  String player2Name = '';
  int xWins = 0;
  int oWins = 0;
  int ties = 0;
  String? gameResult;
  String _startingPlayer = 'X';
  List<int> _winningLine = <int>[];
  int _turnTimeLeft = _turnDurationSeconds;
  Timer? _turnTimer;

  int get turnTimeLeft => _turnTimeLeft;

  void setPlayerNames(String p1, String p2) {
    player1Name = p1;
    player2Name = p2;
    startTurnTimer();
    notifyListeners();
  }

  void makeMove(int index) {
    if (index < 0 || index >= board.length) {
      notifyListeners();
      return;
    }

    if (board[index].isNotEmpty || gameResult != null) {
      notifyListeners();
      return;
    }

    _turnTimer?.cancel();
    board[index] = currentPlayer;

    final winner = _checkWinner();
    if (winner != null) {
      gameResult = winner;
      if (winner == 'X') {
        xWins++;
      } else if (winner == 'O') {
        oWins++;
      }
      _turnTimeLeft = 0;
    } else if (_isBoardFull()) {
      gameResult = 'Tie';
      ties++;
      _winningLine = <int>[];
      _turnTimeLeft = 0;
    } else {
      currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
      startTurnTimer();
    }

    notifyListeners();
  }

  void resetBoard() {
    _turnTimer?.cancel();
    board = List<String>.filled(9, '');
    _winningLine = <int>[];
    _startingPlayer = _startingPlayer == 'X' ? 'O' : 'X';
    currentPlayer = _startingPlayer;
    gameResult = null;
    _turnTimeLeft = _turnDurationSeconds;
    startTurnTimer();
    notifyListeners();
  }

  void resetAll() {
    _turnTimer?.cancel();
    board = List<String>.filled(9, '');
    currentPlayer = 'X';
    player1Name = '';
    player2Name = '';
    xWins = 0;
    oWins = 0;
    ties = 0;
    gameResult = null;
    _startingPlayer = 'X';
    _winningLine = <int>[];
    _turnTimeLeft = _turnDurationSeconds;
    notifyListeners();
  }

  void abandonMatch() {
    _turnTimer?.cancel();
    _turnTimer = null;
    board = List<String>.filled(9, '');
    _winningLine = <int>[];
    gameResult = null;
    _turnTimeLeft = _turnDurationSeconds;
    currentPlayer = _startingPlayer;
    notifyListeners();
  }

  void startTurnTimer() {
    if (gameResult != null) {
      return;
    }

    _turnTimer?.cancel();
    _turnTimeLeft = _turnDurationSeconds;
    _turnTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (gameResult != null) {
        timer.cancel();
        return;
      }

      if (_turnTimeLeft > 1) {
        _turnTimeLeft--;
        notifyListeners();
        return;
      }

      timer.cancel();
      _handleTurnTimeout();
    });
    notifyListeners();
  }

  void _handleTurnTimeout() {
    if (gameResult != null) {
      return;
    }

    final winner = currentPlayer == 'X' ? 'O' : 'X';
    gameResult = winner;
    if (winner == 'X') {
      xWins++;
    } else {
      oWins++;
    }
    _turnTimeLeft = 0;
    notifyListeners();
  }

  void stopTurnTimer() {
    _turnTimer?.cancel();
    _turnTimer = null;
  }

  @override
  void dispose() {
    stopTurnTimer();
    super.dispose();
  }

  String? _checkWinner() {
    for (final combo in _winningCombinations) {
      final a = combo[0];
      final b = combo[1];
      final c = combo[2];

      final mark = board[a];
      if (mark.isNotEmpty && mark == board[b] && mark == board[c]) {
        _winningLine = combo;
        return mark;
      }
    }

    _winningLine = <int>[];
    return null;
  }

  bool _isBoardFull() {
    return board.every((cell) => cell.isNotEmpty);
  }

  List<int> get winningLine => List<int>.from(_winningLine);
}
