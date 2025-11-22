import 'package:json_annotation/json_annotation.dart';
import 'package:ratatouille/features/recipes/data/model/ingredient/ingredient_with_tag_model.dart';
import 'package:ratatouille/features/recipes/data/model/recipe/recipe_with_images_model.dart';
import 'package:ratatouille/features/recipes/data/model/step/step_with_images_model.dart';
import 'package:ratatouille/features/recipes/domain/model/recipe/recipe_detail.dart';

part 'recipe_detail_model.g.dart';

@JsonSerializable()
class RecipeDetailModel {
  final RecipeWithImagesModel recipe;
  final List<IngredientWithTagModel> ingredients;
  final List<StepWithImagesModel> steps;

  const RecipeDetailModel({
    required this.recipe,
    required this.ingredients,
    required this.steps
  });

  factory RecipeDetailModel.fromJson(Map<String, dynamic> json) =>
      _$RecipeDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeDetailModelToJson(this);

  RecipeDetail toDomain() {
    return RecipeDetail(
        recipe: recipe.toDomain(),
        ingredients: ingredients.map((ingredient) => ingredient.toDomain()).toList(),
        steps: steps.map((step) => step.toDomain()).toList()
    );
  }

  factory RecipeDetailModel.fromDomain(RecipeDetail recipe) {
    return RecipeDetailModel(
        recipe: RecipeWithImagesModel.fromDomain(recipe.recipe),
        ingredients: recipe.ingredients.map((ingredient) =>
            IngredientWithTagModel.fromDomain(ingredient)).toList(),
        steps: recipe.steps.map((step) =>
            StepWithImagesModel.fromDomain(step)).toList()
    );
  }
}
