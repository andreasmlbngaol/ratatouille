import 'package:dartz/dartz.dart';
import 'package:ratatouille/domain/model/failure.dart';
import 'package:ratatouille/features/users/domain/model/auth/user.dart';
import 'package:ratatouille/features/users/domain/repository/users_repository.dart';

class CompleteProfileSetupUseCase {
  final UsersRepository repository;

  CompleteProfileSetupUseCase(this.repository);

  Future<Either<Failure, User>> updateName(String name) async {
    try {
      if (name.isEmpty) {
        return Left(Failure('Name cannot be empty'));
      }
      if(name.length < 3) {
        return Left(Failure('Name must be at least 3 characters long'));
      }
      return await repository.updateProfile(name: name);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, User>> uploadProfilePicture(
      List<int> imageBytes,
      String fileName
  ) async {
    try {
      if(imageBytes.isEmpty) {
        return Left(Failure("Image cannot be empty"));
      }

      const maxSize = 5 * 1024 * 1024;
      if(imageBytes.length > maxSize) {
        return Left(Failure("Image must be less than 5MB"));
      }

      return await repository.uploadProfilePicture(imageBytes, fileName);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}