import 'package:json_annotation/json_annotation.dart';
import 'package:ratatouille/features/recipes/data/model/ingredient/ingredient_with_tag_model.dart';
import 'package:ratatouille/features/recipes/data/model/recipe/recipe_with_images_model.dart';
import 'package:ratatouille/features/recipes/data/model/step/step_with_images_model.dart';
import 'package:ratatouille/features/recipes/domain/model/recipe/recipe_detail.dart';
import 'package:ratatouille/features/users/data/model/user_model.dart';

import '../comment/comment_with_image_model.dart';
import '../rating/recipe_rating_model.dart';

part 'recipe_detail_model.g.dart';

@JsonSerializable()
class RecipeDetailModel {
  final UserModel author;
  final RecipeWithImagesModel recipe;
  final List<IngredientWithTagModel> ingredients;
  final List<StepWithImagesModel> steps;
  final List<CommentWithImageModel> comments;
  final RecipeRatingModel rating;
  final bool? isFavorited;
  final int favoriteCount;

  const RecipeDetailModel({
    required this.author,
    required this.recipe,
    required this.ingredients,
    required this.steps,
    required this.comments,
    required this.rating,
    required this.isFavorited,
    required this.favoriteCount
  });

  factory RecipeDetailModel.fromJson(Map<String, dynamic> json) =>
      _$RecipeDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeDetailModelToJson(this);

  RecipeDetail toDomain() {
    return RecipeDetail(
        author: author.toDomain(),
        recipe: recipe.toDomain(),
        ingredients: ingredients.map((ingredient) => ingredient.toDomain()).toList(),
        steps: steps.map((step) => step.toDomain()).toList(),
        comments: comments.map((comment) => comment.toDomain()).toList(),
        rating: rating.toDomain(),
        isFavorited: isFavorited,
        favoriteCount: favoriteCount
    );
  }

  factory RecipeDetailModel.fromDomain(RecipeDetail recipe) {
    return RecipeDetailModel(
        author: UserModel.fromDomain(recipe.author),
        recipe: RecipeWithImagesModel.fromDomain(recipe.recipe),
        ingredients: recipe.ingredients.map((ingredient) =>
            IngredientWithTagModel.fromDomain(ingredient)).toList(),
        steps: recipe.steps.map((step) =>
            StepWithImagesModel.fromDomain(step)).toList(),
        comments: recipe.comments.map((comment) =>
            CommentWithImageModel.fromDomain(comment)).toList(),
        rating: RecipeRatingModel.fromDomain(recipe.rating),
        isFavorited: recipe.isFavorited,
        favoriteCount: recipe.favoriteCount
    );
  }
}
