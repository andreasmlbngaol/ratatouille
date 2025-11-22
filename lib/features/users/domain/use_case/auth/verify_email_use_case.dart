import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:ratatouille/core/domain/model/failure.dart';
import 'package:ratatouille/features/users/domain/model/auth/user.dart';
import 'package:ratatouille/features/users/domain/repository/users_repository.dart';
import 'package:ratatouille/features/users/domain/service/auth_service.dart';

class VerifyEmailUseCase {
  final AuthService authService;
  final UsersRepository repository;

  VerifyEmailUseCase({
    required this.authService,
    required this.repository,
  });

  Future<Either<Failure, bool>> getVerificationStatus() async {
    try {
      final isVerified = await authService.isEmailVerified();
      return Right(isVerified);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, void>> sendEmailVerification() async {
    try {
      await authService.sendEmailVerification();
      return Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, RatatouilleUser>> checkAndSyncEmailVerification() async {
    debugPrint('Checking and syncing email verification');

    try {
      final isVerified = await authService.isEmailVerified();

      if(!isVerified) {
        return Left(Failure('Email not yet verified'));
      }

      debugPrint('Email verified');

      return await repository.getOrCreateUser();
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}