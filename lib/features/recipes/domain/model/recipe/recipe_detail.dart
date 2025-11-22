import 'package:ratatouille/features/recipes/domain/model/ingredient/ingredient_with_tag.dart';
import 'package:ratatouille/features/recipes/domain/model/recipe/recipe_with_images.dart';
import 'package:ratatouille/features/recipes/domain/model/step/step_with_images.dart';

class RecipeDetail {
  final RecipeWithImages recipe;
  final List<IngredientWithTag> ingredients;
  final List<StepWithImages> steps;

  const RecipeDetail({
    required this.recipe,
    required this.ingredients,
    required this.steps
  });
}