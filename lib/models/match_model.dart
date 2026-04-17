import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MatchModel {
  final String player1;
  final String player2;
  final String winner;
  final List<String> board;
  final Timestamp createdAt;

  MatchModel({
    required this.player1,
    required this.player2,
    required this.winner,
    required this.board,
    required this.createdAt,
  });

  MatchModel.fromFirestore(DocumentSnapshot doc)
      : player1 = (doc.get('player1') ?? '') as String,
        player2 = (doc.get('player2') ?? '') as String,
        winner = (doc.get('winner') ?? '') as String,
        board = _normalizeBoard(doc.get('board')),
        createdAt = _parseTimestamp(doc.get('createdAt'));

  Map<String, dynamic> toJson() {
    return {
      'player1': player1,
      'player2': player2,
      'winner': winner,
      'board': board,
      'createdAt': createdAt,
    };
  }

  String get winnerName {
    if (winner == 'X') {
      return player1;
    }
    if (winner == 'O') {
      return player2;
    }
    return 'Draw';
  }

  String get timeAgo {
    final now = DateTime.now();
    final matchTime = createdAt.toDate();
    final diff = now.difference(matchTime);

    if (diff.inMinutes < 1) {
      return 'Just now';
    }

    if (diff.inMinutes < 60) {
      final minutes = diff.inMinutes;
      return '$minutes minute${minutes == 1 ? '' : 's'} ago';
    }

    if (diff.inHours < 24) {
      final hours = diff.inHours;
      return '$hours hour${hours == 1 ? '' : 's'} ago';
    }

    if (diff.inDays == 1) {
      return 'Yesterday';
    }

    if (now.year == matchTime.year) {
      return DateFormat('MMM d, HH:mm').format(matchTime);
    }

    return DateFormat('MMM d, y, HH:mm').format(matchTime);
  }

  static List<String> _normalizeBoard(dynamic rawBoard) {
    if (rawBoard is! List) {
      return List<String>.filled(9, '');
    }

    final parsed = rawBoard.map((cell) => (cell ?? '').toString()).toList();

    if (parsed.length >= 9) {
      return parsed.take(9).toList();
    }

    return [...parsed, ...List<String>.filled(9 - parsed.length, '')];
  }

  static Timestamp _parseTimestamp(dynamic value) {
    if (value is Timestamp) {
      return value;
    }
    if (value is DateTime) {
      return Timestamp.fromDate(value);
    }
    return Timestamp.now();
  }
}
