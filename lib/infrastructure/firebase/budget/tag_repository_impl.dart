// Dart imports:
import 'dart:async';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../../common_provider/firebase_client_provider.dart';
import '../../../domain/budget/entities/tag.dart';
import '../../../domain/budget/repositories/tag_repository.dart';
import '../../../utility/result.dart';
import 'budget_mapper.dart';

final tagRepositoryProvider = Provider<TagRepository>((ref) {
  final firestore = ref.read(firebaseClientProvider);
  return FirestoreTagRepository(firestore);
});

class FirestoreTagRepository implements TagRepository {
  FirestoreTagRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _tags =>
      _firestore.collection('tags');

  @override
  Future<Result<Tag>> create(Tag tag) async {
    try {
      final docRef =
          tag.id.isEmpty ? _tags.doc() : _tags.doc(tag.id);
      final created = tag.copyWith(
        id: docRef.id,
        createdAt: tag.createdAt,
        updatedAt: tag.updatedAt,
      );
      await docRef.set(tagToDoc(created));
      return Result.success(created);
    } catch (e) {
      return Result.error('Failed to create tag: $e');
    }
  }

  @override
  Future<Result<Tag>> update(Tag tag) async {
    try {
      await _tags.doc(tag.id).update(tagToDoc(tag));
      return Result.success(tag);
    } catch (e) {
      return Result.error('Failed to update tag: $e');
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await _tags.doc(id).delete();
      return Result.success(null);
    } catch (e) {
      return Result.error('Failed to delete tag: $e');
    }
  }

  @override
  Stream<Result<List<Tag>>> watchAll(String bookId) {
    return _tags
        .where('bookId', isEqualTo: bookId)
        .orderBy('name')
        .snapshots()
        .transform(
      StreamTransformer<QuerySnapshot<Map<String, dynamic>>, Result<List<Tag>>>.
          fromHandlers(
        handleData: (snapshot, sink) {
          try {
            final tags = snapshot.docs.map(tagFromDoc).toList(growable: false);
            sink.add(Result.success(tags));
          } catch (e) {
            sink.add(Result.error('Failed to parse tags: $e'));
          }
        },
        handleError: (error, stackTrace, sink) {
          sink.add(Result.error('Failed to watch tags: $error'));
        },
      ),
    );
  }
}
