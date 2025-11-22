import 'package:ratatouille/features/recipes/domain/model/recipe_status.dart';

class Recipe {
  final int id;
  final String authorId;
  final String name;
  final String? description;
  final bool isPublic;
  final int estTimeInMinutes;
  final int portion;
  final RecipeStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Recipe({
    required this.id,
    required this.authorId,
    required this.name,
    required this.description,
    required this.isPublic,
    required this.estTimeInMinutes,
    required this.portion,
    required this.status,
    required this.createdAt,
    required this.updatedAt
  });

}