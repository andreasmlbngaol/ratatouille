import 'package:dartz/dartz.dart';
import 'package:ratatouille/domain/model/failure.dart';
import 'package:ratatouille/features/users/domain/service/auth_service.dart';

class SignInWithGoogleUseCase {
  final AuthService authService;

  SignInWithGoogleUseCase(this.authService);

  Future<Either<Failure, String>> call() async {
    try {
      final idToken = await authService.signInWithGoogle();
      return Right(idToken);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}