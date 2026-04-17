import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/match_model.dart';
import '../services/firestore_service.dart';

void _logError(String message, Object error) {
  if (kDebugMode) {
    debugPrint('$message$error');
  }
}

class HistoryProvider extends ChangeNotifier {
  final FirestoreService _firestoreService;

  List<MatchModel> matches = <MatchModel>[];
  bool isLoading = true;
  StreamSubscription<List<MatchModel>>? _subscription;
  bool _isInitialized = false;

  HistoryProvider({FirestoreService? firestoreService})
    : _firestoreService = firestoreService ?? FirestoreService();

  int get totalGames => matches.length;

  String get winRate {
    if (matches.isEmpty) {
      return '0%';
    }

    final nonTieMatches = matches.where((m) => m.winner != 'Tie').toList();
    if (nonTieMatches.isEmpty) {
      return '0%';
    }

    final xWins = nonTieMatches.where((m) => m.winner == 'X').length;
    final rate = (xWins / nonTieMatches.length) * 100;
    return '${rate.round()}%';
  }

  void init() {
    if (_isInitialized) {
      return;
    }
    _isInitialized = true;

    _subscription?.cancel();
    isLoading = true;

    _subscription = _firestoreService.getMatchesStream().listen(
      (data) {
        matches = data;
        if (isLoading) {
          isLoading = false;
        }
        notifyListeners();
      },
      onError: (error) {
        _logError('Error listening to matches stream: ', error);
        _subscription?.cancel();
        if (isLoading) {
          isLoading = false;
        }
        notifyListeners();
      },
    );
  }

  Future<void> saveMatch(MatchModel match) async {
    try {
      await _firestoreService.saveMatch(match);
    } catch (e) {
      _logError('Error saving match: ', e);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
