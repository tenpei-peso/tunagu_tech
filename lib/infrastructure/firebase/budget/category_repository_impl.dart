// Dart imports:
import 'dart:async';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../../common_provider/firebase_client_provider.dart';
import '../../../domain/budget/entities/category.dart';
import '../../../domain/budget/repositories/category_repository.dart';
import '../../../theme/Tunagu_colors.dart';
import '../../../utility/result.dart';
import 'budget_mapper.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final firestore = ref.read(firebaseClientProvider);
  return FirestoreCategoryRepository(firestore);
});

class FirestoreCategoryRepository implements CategoryRepository {
  FirestoreCategoryRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _categories =>
      _firestore.collection('categories');

  @override
  Future<Result<List<Category>>> seedDefaults({
    required String bookId,
  }) async {
    try {
      final now = DateTime.now();
      final defaults = _defaultCategories(bookId, now);
      final batch = _firestore.batch();
      for (final category in defaults) {
        final ref = _categories.doc(category.id);
        batch.set(ref, categoryToDoc(category));
      }
      await batch.commit();
      return Result.success(defaults);
    } catch (e) {
      return Result.error('Failed to seed categories: $e');
    }
  }

  @override
  Future<Result<Category>> create(Category category) async {
    try {
      final docRef = category.id.isEmpty
          ? _categories.doc()
          : _categories.doc(category.id);
      final created = category.copyWith(
        id: docRef.id,
        createdAt: category.createdAt,
        updatedAt: category.updatedAt,
      );
      await docRef.set(categoryToDoc(created));
      return Result.success(created);
    } catch (e) {
      return Result.error('Failed to create category: $e');
    }
  }

  @override
  Future<Result<Category>> update(Category category) async {
    try {
      await _categories.doc(category.id).update(categoryToDoc(category));
      return Result.success(category);
    } catch (e) {
      return Result.error('Failed to update category: $e');
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await _categories.doc(id).delete();
      return Result.success(null);
    } catch (e) {
      return Result.error('Failed to delete category: $e');
    }
  }

  @override
  Stream<Result<List<Category>>> watchAll(String bookId) {
    return _categories
        .where('bookId', isEqualTo: bookId)
        .orderBy('name')
        .snapshots()
        .transform(
          StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
              Result<List<Category>>>.fromHandlers(
            handleData: (snapshot, sink) {
              try {
                final categories =
                    snapshot.docs.map(categoryFromDoc).toList(growable: false);
                sink.add(Result.success(categories));
              } catch (e) {
                sink.add(Result.error('Failed to parse categories: $e'));
              }
            },
            handleError: (error, stackTrace, sink) {
              sink.add(Result.error('Failed to watch categories: $error'));
            },
          ),
        );
  }

  List<Category> _defaultCategories(String bookId, DateTime now) {
    return <Category>[
      Category(
        id: _categories.doc().id,
        bookId: bookId,
        name: '食費',
        iconName: 'restaurant',
        colorValue: TunaguColors.red.value,
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      ),
      Category(
        id: _categories.doc().id,
        bookId: bookId,
        name: '交通',
        iconName: 'train',
        colorValue: TunaguColors.blue200.value,
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      ),
      Category(
        id: _categories.doc().id,
        bookId: bookId,
        name: '住居',
        iconName: 'home',
        colorValue: TunaguColors.gray800.value,
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      ),
      Category(
        id: _categories.doc().id,
        bookId: bookId,
        name: '水道光熱',
        iconName: 'lightbulb',
        colorValue: TunaguColors.indigo200.value,
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      ),
      Category(
        id: _categories.doc().id,
        bookId: bookId,
        name: '娯楽',
        iconName: 'movie',
        colorValue: TunaguColors.secondary.value,
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      ),
      Category(
        id: _categories.doc().id,
        bookId: bookId,
        name: '医療',
        iconName: 'medical_services',
        colorValue: TunaguColors.green400.value,
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      ),
      Category(
        id: _categories.doc().id,
        bookId: bookId,
        name: '教育',
        iconName: 'school',
        colorValue: TunaguColors.primary.value,
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      ),
      Category(
        id: _categories.doc().id,
        bookId: bookId,
        name: 'プレゼント',
        iconName: 'card_giftcard',
        colorValue: TunaguColors.red400.value,
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      ),
      Category(
        id: _categories.doc().id,
        bookId: bookId,
        name: '貯金',
        iconName: 'savings',
        colorValue: TunaguColors.green50.value,
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      ),
      Category(
        id: _categories.doc().id,
        bookId: bookId,
        name: 'その他',
        iconName: 'more_horiz',
        colorValue: TunaguColors.gray400.value,
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  //watchCategories
  @override
  Stream<Result<List<Category>>> watchCategories({required String bookId}) {
    return _categories
        .where('bookId', isEqualTo: bookId)
        .orderBy('name')
        .snapshots()
        .transform(
          StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
              Result<List<Category>>>.fromHandlers(
            handleData: (snapshot, sink) {
              try {
                final categories =
                    snapshot.docs.map(categoryFromDoc).toList(growable: false);
                sink.add(Result.success(categories));
              } catch (e) {
                sink.add(Result.error('Failed to parse categories: $e'));
              }
            },
            handleError: (error, stackTrace, sink) {
              sink.add(Result.error('Failed to watch categories: $error'));
            },
          ),
        );
  }
}
