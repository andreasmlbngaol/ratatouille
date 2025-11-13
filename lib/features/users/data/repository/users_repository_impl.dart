import 'package:dartz/dartz.dart';
import 'package:ratatouille/domain/model/failure.dart';
import 'package:ratatouille/features/users/domain/data_source/auth_local_data_source.dart';
import 'package:ratatouille/features/users/domain/data_source/auth_remote_data_source.dart';
import 'package:ratatouille/features/users/domain/model/auth/user.dart';
import 'package:ratatouille/features/users/domain/model/social/user_detail.dart';
import 'package:ratatouille/features/users/domain/repository/users_repository.dart';

class UsersRepositoryImpl implements UsersRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  
  UsersRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> getOrCreateUser() async {
    try {
      final userModel = await remoteDataSource.getOrCreateUser();
      await localDataSource.saveUser(userModel);
      return Right(userModel.toDomain());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserDetail>> getUserDetail(String userId) async {
    try {
      final userDetailModel = await remoteDataSource.getUserDetail(userId);
      return Right(userDetailModel.toDomain());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await localDataSource.clearUser();
      return Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserDetail>> followUser(String userId) async {
    try {
      final userDetailModel = await remoteDataSource.followUser(userId);
      return Right(userDetailModel.toDomain());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserDetail>> unfollowUser(String userId) async {
    try {
      final userDetailModel = await remoteDataSource.unfollowUser(userId);
      return Right(userDetailModel.toDomain());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({String? name, String? bio}) async {
    try {
      final userModel = await remoteDataSource.updateProfile(
        name: name,
        bio: bio
      );
      await localDataSource.saveUser(userModel);
      return Right(userModel.toDomain());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> uploadCoverPicture(List<int> imageBytes, String fileName) async {
    try {
      final userModel = await remoteDataSource.uploadCoverPicture(imageBytes, fileName);
      await localDataSource.saveUser(userModel);
      return Right(userModel.toDomain());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> uploadProfilePicture(List<int> imageBytes, String fileName) async {
    try {
      final userModel = await remoteDataSource.uploadProfilePicture(imageBytes, fileName);
      await localDataSource.saveUser(userModel);
      return Right(userModel.toDomain());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCachedUser() async {
    try {
      final userModel = await localDataSource.getUser();

      if(userModel == null) {
        return Left(Failure('No user found'));
      }

      return Right(userModel.toDomain());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
  
  
}