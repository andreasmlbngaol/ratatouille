import 'package:dartz/dartz.dart';
import 'package:ratatouille/core/domain/model/failure.dart';
import 'package:ratatouille/features/recipes/domain/model/recipe/recipe_with_images.dart';
import 'package:ratatouille/features/recipes/domain/repository/recipe_repository.dart';

class GetOrCreateDraftRecipeUseCase {
  final RecipesRepository repository;

  GetOrCreateDraftRecipeUseCase(this.repository);

  Future<Either<Failure, RecipeWithImages>> call() async {
    return await repository.getOrCreateDraftRecipe();
  }
}