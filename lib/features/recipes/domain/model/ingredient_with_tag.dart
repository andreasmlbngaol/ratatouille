import 'package:ratatouille/features/recipes/domain/model/ingredient.dart';
import 'package:ratatouille/features/recipes/domain/model/ingredient_tag.dart';

class IngredientWithTag {
  final Ingredient ingredient;
  final IngredientTag ingredientTag;

  const IngredientWithTag({
    required this.ingredient,
    required this.ingredientTag
  });
}