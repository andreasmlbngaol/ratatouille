import 'package:ratatouille/features/recipes/data/model/ingredient/ingredient_tag_model.dart';
import 'package:ratatouille/features/recipes/data/model/ingredient/ingredient_with_tag_model.dart';
import 'package:ratatouille/features/recipes/data/model/recipe/recipe_detail_model.dart';
import 'package:ratatouille/features/recipes/data/model/recipe/recipe_with_images_model.dart';
import 'package:ratatouille/features/recipes/data/model/step/step_with_images_model.dart';
import 'package:ratatouille/features/recipes/domain/model/recipe/recipe_status.dart';

import '../../data/model/comment/comment_with_image_model.dart';

abstract class RecipeRemoteDataSource {
  Future<RecipeDetailModel> getRecipeDetail(int recipeId);

  Future<RecipeWithImagesModel> getOrCreateDraftRecipe();

  Future<RecipeWithImagesModel> updateRecipe({
    required int recipeId,
    String? name,
    String? description,
    bool? isPublic,
    int? estTimeInMinutes,
    int? portion,
  });

  Future<RecipeWithImagesModel> updateRecipeStatus({
    required int recipeId,
    required RecipeStatus status
  });

  Future<RecipeWithImagesModel> uploadRecipeImage({
    required int recipeId,
    required List<int> imageBytes,
    required String fileName,
  });

  Future<IngredientTagModel> createIngredientTag(String name);

  Future<List<IngredientTagModel>> searchIngredientTags(String query);

  Future<List<IngredientWithTagModel>> getIngredients(int recipeId);

  Future<List<IngredientWithTagModel>> addIngredient({
    required int recipeId,
    required int tagId,
    double? amount,
    String? unit,
    String? alternative
  });

  Future<List<StepWithImagesModel>> getSteps(int recipeId);

  Future<List<StepWithImagesModel>> createEmptyStep(int recipeId, int stepNumber);

  Future<List<StepWithImagesModel>> updateStep(int recipeId, int stepId, String content);

  Future<List<StepWithImagesModel>> uploadStepImage({
    required int recipeId,
    required int stepId,
    required List<int> imageBytes,
    required String fileName
  });

  Future<List<RecipeDetailModel>> search({
    required String query,
    double? minRating,
    int? minEstTime,
    int? maxEstTime
  });

  Future<void> saveRecipe(int recipeId);

  Future<void> removeSavedRecipe(int recipeId);
  Future<List<CommentWithImageModel>> fetchComments(int recipeId);
  Future<CommentWithImageModel> postComment(int recipeId, String content);
  Future<bool> submitRating(int recipeId, int rating);
  Future<List<RecipeDetailModel>> getMyRecipes();
  Future<List<RecipeDetailModel>> fetchBookmarkedRecipes();
  Future<List<RecipeDetailModel>> fridgeFilter({
    required List<int> includedIngredients,
    required List<int> excludedIngredients,
    required double? minRating,
    required int? minEstTime,
    required int? maxEstTime
  });
}