import 'package:ratatouille/features/recipes/domain/model/ingredient/ingredient_with_tag.dart';
import 'package:ratatouille/features/recipes/domain/model/recipe/recipe_with_images.dart';
import 'package:ratatouille/features/recipes/domain/model/step/step_with_images.dart';
import 'package:ratatouille/features/users/domain/model/auth/user.dart';

import '../comment/comment_with_image.dart';
import '../rating/recipe_rating.dart';

class RecipeDetail {
  final RatatouilleUser author;
  final RecipeWithImages recipe;
  final List<IngredientWithTag> ingredients;
  final List<StepWithImages> steps;
  final List<CommentWithImage> comments;
  final RecipeRating rating;
  final bool? isFavorited;
  final int favoriteCount;


  const RecipeDetail({
    required this.author,
    required this.recipe,
    required this.ingredients,
    required this.steps,
    required this.comments,
    required this.rating,
    required this.isFavorited,
    required this.favoriteCount
  });
}