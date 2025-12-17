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
  final int createdAt;
  final int updatedAt;
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

extension RecipeWithImagesCopy on RecipeWithImages {
  RecipeWithImages copyWith({
    int? id,
    String? authorId,
    String? name,
    String? description,
    bool? isPublic,
    int? estTimeInMinutes,
    int? portion,
    RecipeStatus? status,
    int? createdAt,
    int? updatedAt,
    List<RatatouilleImage>? images,
  }) {
    return RecipeWithImages(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      name: name ?? this.name,
      description: description ?? this.description,
      isPublic: isPublic ?? this.isPublic,
      estTimeInMinutes: estTimeInMinutes ?? this.estTimeInMinutes,
      portion: portion ?? this.portion,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      images: images ?? this.images,
    );
  }
}
