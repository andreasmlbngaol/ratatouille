import 'package:dartz/dartz.dart';
import 'package:ratatouille/core/domain/model/failure.dart';
import 'package:ratatouille/features/recipes/domain/model/ingredient/ingredient_with_tag.dart';
import 'package:ratatouille/features/recipes/domain/repository/recipe_repository.dart';

class GetIngredientsUseCase {
  final RecipesRepository repository;

  GetIngredientsUseCase(this.repository);

  Future<Either<Failure, List<IngredientWithTag>>> call({
    required int recipeId
  }) async {
    try {
      if (recipeId <= 0) {
        return Left(Failure("Invalid recipe ID"));
      }

      return await repository.getIngredients(recipeId);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
