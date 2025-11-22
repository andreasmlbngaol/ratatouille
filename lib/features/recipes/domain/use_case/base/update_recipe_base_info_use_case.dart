import 'package:dartz/dartz.dart';
import 'package:ratatouille/core/domain/model/failure.dart';
import 'package:ratatouille/features/recipes/domain/model/recipe/recipe_with_images.dart';
import 'package:ratatouille/features/recipes/domain/repository/recipe_repository.dart';

class UpdateRecipeBaseInfoUseCase {
  final RecipesRepository repository;

  UpdateRecipeBaseInfoUseCase(this.repository);

  Future<Either<Failure, RecipeWithImages>> call({
    required int recipeId,
    String? name,
    String? description,
    bool? isPublic,
    int? estTimeInMinutes,
    int? portion
  }) async {
    try {
      if (name == null && description == null && isPublic == null && estTimeInMinutes == null &&
          portion == null) {
        return Left(Failure("No field to update"));
      }

      if (recipeId <= 0) {
        return Left(Failure("Invalid recipe ID"));
      }

      if (estTimeInMinutes != null && estTimeInMinutes <= 0) {
        return Left(Failure("Estimated time must be greater than 0"));
      }

      if (portion != null && portion <= 0) {
        return Left(Failure("Portion must be greater than 0"));
      }

      return await repository.updateRecipeBaseInfo(
          recipeId: recipeId,
          name: name,
          description: description,
          isPublic: isPublic,
          estTimeInMinutes: estTimeInMinutes,
          portion: portion
      );
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}