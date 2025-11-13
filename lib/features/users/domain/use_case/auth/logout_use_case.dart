import 'package:dartz/dartz.dart';
import 'package:ratatouille/domain/model/failure.dart';
import 'package:ratatouille/features/users/domain/repository/users_repository.dart';
import 'package:ratatouille/features/users/domain/service/auth_service.dart';

class LogoutUseCase {
  final UsersRepository repository;
  final AuthService authService;

  LogoutUseCase({
    required this.repository,
    required this.authService,
  });

  Future<Either<Failure, void>> call() async {
    try {
      await repository.signOut();
      await authService.signOut();
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}