class Step {
  final int id;
  final int recipeId;
  final int stepNumber;
  final String content;

  const Step({
    required this.id,
    required this.recipeId,
    required this.stepNumber,
    required this.content
  });
}