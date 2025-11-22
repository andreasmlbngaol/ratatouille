import 'package:dartz/dartz.dart';
import 'package:ratatouille/core/domain/model/failure.dart';
import 'package:ratatouille/features/recipes/domain/model/ingredient/ingredient_tag.dart';
import 'package:ratatouille/features/recipes/domain/repository/recipe_repository.dart';

class CreateIngredientTagUseCase {
  final RecipesRepository repository;

  CreateIngredientTagUseCase(this.repository);

  Future<Either<Failure, IngredientTag>> call({
    required String name,
  }) async {
    try {
      if (name.isEmpty) {
        return Left(Failure("Tag name can't be empty"));
      }

      if (name.length > 50) {
        return Left(Failure("Tag name is too long (max 100 characters)"));
      }

      return await repository.createIngredientTag(name);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
