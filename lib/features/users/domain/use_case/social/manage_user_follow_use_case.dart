import 'package:dartz/dartz.dart';
import 'package:ratatouille/domain/model/failure.dart';
import 'package:ratatouille/features/users/domain/model/social/user_detail.dart';
import 'package:ratatouille/features/users/domain/repository/users_repository.dart';

class ManageUserFollowUseCae {
  final UsersRepository repository;

  ManageUserFollowUseCae(this.repository);

  Future<Either<Failure, UserDetail>> follow(String userId) async {
    if(userId.isEmpty) {
      return Left(Failure("Invalid user ID"));
    }

    return await repository.followUser(userId);
  }

  Future<Either<Failure, UserDetail>> unfollow(String userId) async {
    if(userId.isEmpty) {
      return Left(Failure("Invalid user ID"));
    }

    return await repository.unfollowUser(userId);
  }
}