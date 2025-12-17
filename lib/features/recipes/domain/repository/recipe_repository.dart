import 'package:dartz/dartz.dart';
import 'package:ratatouille/core/domain/model/failure.dart';
import 'package:ratatouille/features/recipes/domain/model/ingredient/ingredient_tag.dart';
import 'package:ratatouille/features/recipes/domain/model/ingredient/ingredient_with_tag.dart';
import 'package:ratatouille/features/recipes/domain/model/recipe/recipe_detail.dart';
import 'package:ratatouille/features/recipes/domain/model/recipe/recipe_with_images.dart';
import 'package:ratatouille/features/recipes/domain/model/step/step_with_images.dart';

import '../model/comment/comment_with_image.dart';

abstract class RecipesRepository {
  Future<Either<Failure, RecipeDetail>> getRecipeDetail(int recipeId);

  Future<Either<Failure, RecipeWithImages>> getOrCreateDraftRecipe();

  Future<Either<Failure, RecipeWithImages>> updateRecipeBaseInfo({
    required int recipeId,
    String? name,
    String? description,
    bool? isPublic,
    int? estTimeInMinutes,
    int? portion
  });

  Future<Either<Failure, RecipeWithImages>> uploadRecipeImage({
    required int recipeId,
    required List<int> imageBytes,
    required String fileName,
  });

  Future<Either<Failure, IngredientTag>> createIngredientTag(String name);

  Future<Either<Failure, List<IngredientTag>>> searchIngredientTags(String query);

  Future<Either<Failure, List<IngredientWithTag>>> getIngredients(int recipeId);

  Future<Either<Failure, List<IngredientWithTag>>> addIngredient({
    required int recipeId,
    required int tagId,
    double? amount,
    String? unit,
    String? alternative
  });

  Future<Either<Failure, List<StepWithImages>>> getSteps(int recipeId);

  Future<Either<Failure, List<StepWithImages>>> createEmptyStep(int recipeId, int stepNumber);

  Future<Either<Failure, List<StepWithImages>>> updateStep(int recipeId, int stepId, String content);

  Future<Either<Failure, List<StepWithImages>>> uploadStepImage({
    required int recipeId,
    required int stepId,
    required List<int> imageBytes,
    required String fileName
  });

  Future<Either<Failure, RecipeWithImages>> publishRecipe(int recipeId);

  // Search Recipe
  Future<Either<Failure, List<RecipeDetail>>> search(
    String query,
    double? minRating,
    int? minEstTime,
    int? maxEstTime
  );

  Future<Either<Failure, bool>> saveRecipe(int recipeId);
  Future<Either<Failure, bool>> removeSavedRecipe(int recipeId);
  Future<Either<Failure, List<CommentWithImage>>> fetchComments(int recipeId);
  Future<Either<Failure, CommentWithImage>> postComment(int recipeId, String content);
  Future<Either<Failure, bool>> submitRating(int recipeId, int rating);
  Future<Either<Failure, List<RecipeDetail>>> getMyRecipes();
}