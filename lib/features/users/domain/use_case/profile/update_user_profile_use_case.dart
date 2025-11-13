import 'package:dartz/dartz.dart';
import 'package:ratatouille/domain/model/failure.dart';
import 'package:ratatouille/features/users/domain/model/auth/user.dart';
import 'package:ratatouille/features/users/domain/model/profile/picture_type.dart';
import 'package:ratatouille/features/users/domain/repository/users_repository.dart';

class UpdateUserProfileUseCase {
  final UsersRepository repository;

  UpdateUserProfileUseCase(this.repository);

  Future<Either<Failure, User>> updateInfo({
    String? name,
    String? bio
  }) async {
    if (name == null && bio == null) {
      return Left(Failure("At least one field must be updated"));
    }

    return repository.updateProfile(name: name, bio: bio);
  }

  Future<Either<Failure, User>> uploadPicture({
    required PictureType type,
    required List<int> imageBytes,
    required String fileName
  }) async {
    try {
      if (imageBytes.isEmpty) {
        return Left(Failure("Image cannot be empty"));
      }

      const maxSize = 5 * 1024 * 1024;
      if (imageBytes.length > maxSize) {
        return Left(Failure("Image cannot be larger than 5MB"));
      }

      switch (type) {
        case PictureType.profile:
          return repository.uploadProfilePicture(imageBytes, fileName);

        case PictureType.cover:
          return repository.uploadCoverPicture(imageBytes, fileName);
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
