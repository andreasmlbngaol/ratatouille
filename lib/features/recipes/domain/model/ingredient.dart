class Ingredient {
  final int id;
  final int recipeId;
  final int tagId;
  final double? amount;
  final String? unit;
  final String? alternative;

  const Ingredient({
    required this.id,
    required this.recipeId,
    required this.tagId,
    required this.amount,
    required this.unit,
    required this.alternative
  });
}