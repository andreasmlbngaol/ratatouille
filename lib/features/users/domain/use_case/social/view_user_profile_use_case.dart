import 'package:dartz/dartz.dart';
import 'package:ratatouille/domain/model/failure.dart';
import 'package:ratatouille/features/users/domain/model/social/user_detail.dart';
import 'package:ratatouille/features/users/domain/repository/users_repository.dart';

class ViewUserProfileUseCase {
  final UsersRepository repository;

  ViewUserProfileUseCase(this.repository);

  Future<Either<Failure, UserDetail>> call(String userId) async {
    if(userId.isEmpty) {
      return Left(Failure("Invalid user id"));
    }
    return await repository.getUserDetail(userId);
  }
}