import 'package:dartz/dartz.dart';
import 'package:ratatouille/features/users/domain/model/auth/user.dart';
import 'package:ratatouille/features/users/domain/model/social/user_detail.dart';

import '../../../../core/domain/model/failure.dart';

abstract class UsersRepository {
  Future<Either<Failure, RatatouilleUser>> getCachedUser();

  Future<Either<Failure, RatatouilleUser>> getOrCreateUser();
  Future<Either<Failure, RatatouilleUser>> updateProfile({
    String? name,
    String? bio
});

  Future<Either<Failure, RatatouilleUser>> uploadProfilePicture(
      List<int> imageBytes,
      String fileName
  );

  Future<Either<Failure, RatatouilleUser>> uploadCoverPicture(
      List<int> imageBytes,
      String fileName
  );

  Future<Either<Failure, UserDetail>> getUserDetail(String userId);
  Future<Either<Failure, UserDetail>> getMyUserDetail();
  Future<Either<Failure, UserDetail>> followUser(String userId);
  Future<Either<Failure, UserDetail>> unfollowUser(String userId);
  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, List<RatatouilleUser>>> search({
    required String query,
  });


}
