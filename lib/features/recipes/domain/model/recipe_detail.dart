import 'package:ratatouille/features/recipes/domain/model/ingredient_with_tag.dart';
import 'package:ratatouille/features/recipes/domain/model/ratatouille_image.dart';
import 'package:ratatouille/features/recipes/domain/model/recipe.dart';
import 'package:ratatouille/features/recipes/domain/model/step_with_images.dart';

class RecipeDetail {
  final Recipe recipe;
  final List<RatatouilleImage> images;
  final List<IngredientWithTag> ingredients;
  final List<StepWithImages> steps;

  const RecipeDetail({
    required this.recipe,
    required this.images,
    required this.ingredients,
    required this.steps
  });
}