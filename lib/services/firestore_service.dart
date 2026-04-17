import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/match_model.dart';

void _logError(String message, Object error) {
  if (kDebugMode) {
    debugPrint('$message$error');
  }
}

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> saveMatch(MatchModel match) async {
    try {
      await _firestore.collection('matches').add({
        ...match.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      _logError('Error saving match: ', e);
    }
  }

  Stream<List<MatchModel>> getMatchesStream() {
    try {
      return _firestore
          .collection('matches')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        try {
          return snapshot.docs.map((doc) {
            try {
              return MatchModel.fromFirestore(doc);
            } catch (e) {
              _logError('Error parsing match document ${doc.id}: ', e);
              return null;
            }
          }).whereType<MatchModel>().toList();
        } catch (e) {
          _logError('Error mapping match snapshots: ', e);
          return <MatchModel>[];
        }
      }).handleError((e) {
        _logError('Error streaming matches: ', e);
      });
    } catch (e) {
      _logError('Error creating matches stream: ', e);
      return const Stream<List<MatchModel>>.empty();
    }
  }
}
