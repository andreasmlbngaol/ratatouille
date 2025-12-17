import 'package:dartz/dartz.dart';

import '../../../../core/domain/model/failure.dart';
import '../model/recipe/recipe_detail.dart';
import '../repository/recipe_repository.dart';

class RecipeUseCase {
  final RecipesRepository repository;

  RecipeUseCase(this.repository);

  Future<Either<Failure, List<RecipeDetail>>> search({
    required String query,
    double? minRating,
    int? minEstTime,
    int? maxEstTime,
  }) async {
    return await repository.search(query, minRating, minEstTime, maxEstTime);
  }

  Future<Either<Failure, RecipeDetail>> getRecipeDetail(int recipeId) async {
    return await repository.getRecipeDetail(recipeId);
  }
}