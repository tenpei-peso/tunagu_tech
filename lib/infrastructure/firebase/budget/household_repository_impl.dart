// Dart imports:
import 'dart:async';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../../common_provider/firebase_client_provider.dart';
import '../../../domain/budget/entities/household.dart';
import '../../../domain/budget/repositories/household_repository.dart';
import '../../../utility/result.dart';
import 'budget_mapper.dart';

final householdRepositoryProvider = Provider<HouseholdRepository>((ref) {
  final firestore = ref.read(firebaseClientProvider);
  final auth = ref.read(firebaseAuthProvider);
  return FirestoreHouseholdRepository(firestore, auth);
});

class FirestoreHouseholdRepository implements HouseholdRepository {
  FirestoreHouseholdRepository(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _households =>
      _firestore.collection('households');

  CollectionReference<Map<String, dynamic>> get _invites =>
      _firestore.collection('invites');

  @override
  Future<Result<Household>> createHousehold({
    required String name,
    required String ownerUid,
  }) async {
    try {
      final now = DateTime.now();
      final docRef = _households.doc();
      final household = Household(
        id: docRef.id,
        name: name,
        memberIds: <String>[ownerUid],
        createdAt: now,
        updatedAt: now,
      );
      await docRef.set(householdToDoc(household));
      return Result.success(household);
    } catch (e) {
      return Result.error('Failed to create household: $e');
    }
  }

  @override
  Stream<Result<List<Household>>> watchHouseholds(String uid) {
    return _households
        .where('memberIds', arrayContains: uid)
        .snapshots()
        .transform(
      StreamTransformer<QuerySnapshot<Map<String, dynamic>>, Result<List<Household>>>
          .fromHandlers(
        handleData: (snapshot, sink) {
          try {
            final households = snapshot.docs
                .map(householdFromDoc)
                .toList(growable: false);
            sink.add(Result.success(households));
          } catch (e) {
            sink.add(Result.error('Failed to parse households: $e'));
          }
        },
        handleError: (error, stackTrace, sink) {
          sink.add(Result.error('Failed to watch households: $error'));
        },
      ),
    );
  }

  @override
  Future<Result<void>> inviteMember({
    required String householdId,
    required String email,
  }) async {
    try {
      await _invites.add(<String, dynamic>{
        'householdId': householdId,
        'email': email,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      });
      return Result.success(null);
    } catch (e) {
      return Result.error('Failed to send invite: $e');
    }
  }

  @override
  Future<Result<void>> acceptInvite({
    required String inviteId,
  }) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) {
        return Result.error('User not signed in');
      }
      final inviteDoc = await _invites.doc(inviteId).get();
      if (!inviteDoc.exists) {
        return Result.error('Invite not found');
      }
      final householdId = inviteDoc.get('householdId') as String;
      await _firestore.runTransaction((transaction) async {
        final householdRef = _households.doc(householdId);
        final householdSnap = await transaction.get(householdRef);
        if (!householdSnap.exists) {
          throw StateError('Household not found');
        }
        final memberIds = List<String>.from(
          householdSnap.get('memberIds') as List<dynamic>,
        );
        if (!memberIds.contains(uid)) {
          memberIds.add(uid);
          transaction.update(householdRef, <String, dynamic>{
            'memberIds': memberIds,
            'updatedAt': Timestamp.fromDate(DateTime.now()),
          });
        }
        transaction.delete(inviteDoc.reference);
      });
      return Result.success(null);
    } catch (e) {
      return Result.error('Failed to accept invite: $e');
    }
  }
}
