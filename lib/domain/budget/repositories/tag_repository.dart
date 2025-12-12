import '../../../utility/result.dart';
import '../entities/tag.dart';

abstract class TagRepository {
  Future<Result<Tag>> create(Tag tag);

  Future<Result<Tag>> update(Tag tag);

  Future<Result<void>> delete(String id);

  Stream<Result<List<Tag>>> watchAll(String bookId);

  Stream<Result<List<Tag>>> watchTags({required String bookId});
}
