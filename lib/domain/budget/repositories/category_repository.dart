import '../../../utility/result.dart';
import '../entities/category.dart';

abstract class CategoryRepository {
  Future<Result<List<Category>>> seedDefaults({
    required String bookId,
  });

  Future<Result<Category>> create(Category category);

  Future<Result<Category>> update(Category category);

  Future<Result<void>> delete(String id);

  Stream<Result<List<Category>>> watchAll(String bookId);

  Stream<Result<List<Category>>> watchCategories({required String bookId});
}
