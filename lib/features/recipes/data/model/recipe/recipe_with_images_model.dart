import 'package:json_annotation/json_annotation.dart';
import 'package:ratatouille/features/recipes/data/model/image/ratatouille_image_model.dart';
import 'package:ratatouille/features/recipes/domain/model/recipe/recipe_status.dart';
import 'package:ratatouille/features/recipes/domain/model/recipe/recipe_with_images.dart';

part 'recipe_with_images_model.g.dart';

@JsonSerializable()
class RecipeWithImagesModel {
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
  final List<RatatouilleImageModel> images;

  const RecipeWithImagesModel({
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

  factory RecipeWithImagesModel.fromJson(Map<String, dynamic> json) =>
      _$RecipeWithImagesModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeWithImagesModelToJson(this);

  RecipeWithImages toDomain() {
    return RecipeWithImages(
        id: id,
        authorId: authorId,
        name: name,
        description: description,
        isPublic: isPublic,
        estTimeInMinutes: estTimeInMinutes,
        portion: portion,
        status: status,
        createdAt: createdAt,
        updatedAt: updatedAt,
        images: images.map((image) => image.toDomain()).toList()
    );
  }

  factory RecipeWithImagesModel.fromDomain(RecipeWithImages recipe) {
    return RecipeWithImagesModel(
        id: recipe.id,
        authorId: recipe.authorId,
        name: recipe.name,
        description: recipe.description,
        isPublic: recipe.isPublic,
        estTimeInMinutes: recipe.estTimeInMinutes,
        portion: recipe.portion,
        status: recipe.status,
        createdAt: recipe.createdAt,
        updatedAt: recipe.updatedAt,
        images: recipe.images.map((image) =>
            RatatouilleImageModel.fromDomain(image)).toList()
    );
  }
}