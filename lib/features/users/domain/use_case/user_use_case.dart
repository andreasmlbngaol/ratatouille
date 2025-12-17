import 'package:dartz/dartz.dart';
import 'package:ratatouille/features/recipes/domain/repository/recipe_repository.dart';
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
}