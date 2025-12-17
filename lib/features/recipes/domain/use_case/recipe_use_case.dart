import 'package:dartz/dartz.dart';

import '../../../../core/domain/model/failure.dart';
import '../model/comment/comment_with_image.dart';
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

  Future<Either<Failure, bool>> saveRecipe(int recipeId) async {
    return await repository.saveRecipe(recipeId);
  }

  Future<Either<Failure, bool>> removeSavedRecipe(int recipeId) async {
    return await repository.removeSavedRecipe(recipeId);
  }

  Future<Either<Failure, List<CommentWithImage>>> fetchComments(int recipeId) async {
    return await repository.fetchComments(recipeId);
  }

  Future<Either<Failure, CommentWithImage>> postComment(int recipeId, String content) async {
    return await repository.postComment(recipeId, content);
  }

  Future<Either<Failure, bool>> submitRating(int recipeId, int rating) async {
    return await repository.submitRating(recipeId, rating);
  }

  Future<Either<Failure, List<RecipeDetail>>> getMyRecipes() async {
    return await repository.getMyRecipes();
  }
}