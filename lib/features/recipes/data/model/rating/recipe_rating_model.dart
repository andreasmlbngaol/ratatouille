import 'package:json_annotation/json_annotation.dart';
import 'package:ratatouille/features/recipes/domain/model/rating/recipe_rating.dart';

part 'recipe_rating_model.g.dart';

@JsonSerializable()
class RecipeRatingModel {
  final double average;
  final int count;

  const RecipeRatingModel({
    required this.average,
    required this.count
  });

  factory RecipeRatingModel.fromJson(Map<String, dynamic> json) =>
      _$RecipeRatingModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeRatingModelToJson(this);

  RecipeRating toDomain() {
    return RecipeRating(
      average: average,
      count: count
    );
  }

  factory RecipeRatingModel.fromDomain(RecipeRating rating) {
    return RecipeRatingModel(
      average: rating.average,
      count: rating.count
    );
  }
}