import 'package:ratatouille/features/recipes/domain/model/image/ratatouille_image.dart';
import 'package:ratatouille/features/recipes/domain/model/recipe/recipe_status.dart';

class RecipeWithImages {
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
  final List<RatatouilleImage> images;

  const RecipeWithImages({
    required this.id,
    required this.authorId,
    required this.name,
    required this.description,
    required this.isPublic,
    required this.estTimeInMinutes,
    required this.portion,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.images
  });
}