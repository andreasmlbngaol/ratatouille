import 'package:ratatouille/features/recipes/data/model/ingredient/ingredient_tag_model.dart';
import 'package:ratatouille/features/recipes/data/model/ingredient/ingredient_with_tag_model.dart';
import 'package:ratatouille/features/recipes/data/model/recipe/recipe_detail_model.dart';
import 'package:ratatouille/features/recipes/data/model/recipe/recipe_with_images_model.dart';
import 'package:ratatouille/features/recipes/data/model/step/step_with_images_model.dart';
import 'package:ratatouille/features/recipes/domain/model/recipe/recipe_status.dart';

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
    RecipeStatus? status
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
}