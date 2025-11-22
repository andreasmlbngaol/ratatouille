import 'package:ratatouille/features/recipes/domain/model/ingredient/ingredient_tag.dart';

class IngredientWithTag {
  final int id;
  final int recipeId;
  final double? amount;
  final String? unit;
  final String? alternative;
  final IngredientTag tag;

  const IngredientWithTag({
    required this.id,
    required this.recipeId,
    required this.amount,
    required this.unit,
    required this.alternative,
    required this.tag
  });
}