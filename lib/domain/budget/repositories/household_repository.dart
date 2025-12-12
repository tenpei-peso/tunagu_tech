import '../../../utility/result.dart';
import '../entities/household.dart';

/// Repository for managing shared households/books and invites.
abstract class HouseholdRepository {
  Future<Result<Household>> createHousehold({
    required String name,
    required String ownerUid,
  });

  Stream<Result<List<Household>>> watchHouseholds(String uid);

  Future<Result<void>> inviteMember({
    required String householdId,
    required String email,
  });

  Future<Result<void>> acceptInvite({
    required String inviteId,
  });
}
