import 'package:dartz/dartz.dart';
import 'package:ratatouille/core/domain/model/failure.dart';
import 'package:ratatouille/features/users/domain/model/auth/user.dart';
import 'package:ratatouille/features/users/domain/repository/users_repository.dart';

class CheckAuthStatusUseCase {
  final UsersRepository repository;

  CheckAuthStatusUseCase(this.repository);

  Future<Either<Failure, RatatouilleUser>> call() async {
    return await repository.getCachedUser();
  }
}