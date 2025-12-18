import 'package:dartz/dartz.dart';
import 'package:ratatouille/features/users/domain/model/social/user_detail.dart';
import 'package:ratatouille/features/users/domain/repository/users_repository.dart';

import '../../../../core/domain/model/failure.dart';
import '../model/auth/user.dart';

class UserUseCase {
  final UsersRepository usersRepository;

  UserUseCase({
    required this.usersRepository,
  });

  Future<Either<Failure, List<RatatouilleUser>>> search({
    required String query,
  }) async {
    return await usersRepository.search(query: query);
  }

  Future<Either<Failure, UserDetail>> getUserDetail(String userId) async {
    return await usersRepository.getUserDetail(userId);
  }

}