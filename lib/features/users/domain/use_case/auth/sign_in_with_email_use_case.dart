import 'package:dartz/dartz.dart';
import 'package:ratatouille/domain/model/failure.dart';
import 'package:ratatouille/features/users/domain/service/auth_service.dart';

class SignInWithEmailUseCase {
  final AuthService authService;

  SignInWithEmailUseCase(this.authService);

  Future<Either<Failure, String>> call({
    required String email,
    required String password
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return Left(Failure("Email and password can't be empty"));
      }

      final idToken = await authService.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      return Right(idToken);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}