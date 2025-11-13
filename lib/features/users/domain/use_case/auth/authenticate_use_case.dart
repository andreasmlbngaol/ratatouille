import 'package:dartz/dartz.dart';
import 'package:ratatouille/domain/model/failure.dart';
import 'package:ratatouille/features/users/domain/model/auth/user.dart';
import 'package:ratatouille/features/users/domain/repository/users_repository.dart';

class AuthenticateUseCase {
  final UsersRepository repository;

  AuthenticateUseCase(this.repository);

  Future<Either<Failure, User>> call() async {
    return await repository.getOrCreateUser();
  }
}