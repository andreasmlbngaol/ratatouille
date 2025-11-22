
import 'package:dartz/dartz.dart';
import 'package:ratatouille/core/domain/model/failure.dart';
import 'package:ratatouille/features/recipes/domain/model/recipe/recipe_detail.dart';
import 'package:ratatouille/features/recipes/domain/repository/recipe_repository.dart';

class GetRecipeDetailUseCase {
  final RecipesRepository repository;

  GetRecipeDetailUseCase(this.repository);

  Future<Either<Failure, RecipeDetail>> call(int recipeId) async {
    try {
      if (recipeId <= 0) {
        return Left(Failure("Invalid recipe ID"));
      }

      return await repository.getRecipeDetail(recipeId);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}