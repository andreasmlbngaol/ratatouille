import 'package:dartz/dartz.dart';
import 'package:ratatouille/domain/model/failure.dart';
import 'package:ratatouille/features/users/domain/model/auth/user.dart';
import 'package:ratatouille/features/users/domain/model/social/user_detail.dart';

abstract class UsersRepository {
  Future<Either<Failure, User>> getCachedUser();

  Future<Either<Failure, User>> getOrCreateUser();
  Future<Either<Failure, User>> updateProfile({
    String? name,
    String? bio
});

  Future<Either<Failure, User>> uploadProfilePicture(
      List<int> imageBytes,
      String fileName
  );

  Future<Either<Failure, User>> uploadCoverPicture(
      List<int> imageBytes,
      String fileName
  );

  Future<Either<Failure, UserDetail>> getUserDetail(String userId);
  Future<Either<Failure, UserDetail>> followUser(String userId);
  Future<Either<Failure, UserDetail>> unfollowUser(String userId);
  Future<Either<Failure, void>> signOut();
}