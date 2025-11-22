import 'package:json_annotation/json_annotation.dart';
import 'package:ratatouille/features/recipes/data/model/ingredient/ingredient_tag_model.dart';
import 'package:ratatouille/features/recipes/domain/model/ingredient/ingredient_with_tag.dart';
part 'ingredient_with_tag_model.g.dart';

@JsonSerializable()
class IngredientWithTagModel {
  final int id;
  final int recipeId;
  final double? amount;
  final String? unit;
  final String? alternative;
  final IngredientTagModel tag;

  const IngredientWithTagModel({
    required this.id,
    required this.recipeId,
    required this.amount,
    required this.unit,
    required this.alternative,
    required this.tag
  });

  factory IngredientWithTagModel.fromJson(Map<String, dynamic> json) =>
      _$IngredientWithTagModelFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientWithTagModelToJson(this);

  IngredientWithTag toDomain() {
    return IngredientWithTag(
        id: id,
        recipeId: recipeId,
        amount: amount,
        unit: unit,
        alternative: alternative,
        tag: tag.toDomain()
    );
  }

  factory IngredientWithTagModel.fromDomain(IngredientWithTag ingredient) {
    return IngredientWithTagModel(
        id: ingredient.id,
        recipeId: ingredient.recipeId,
        amount: ingredient.amount,
        unit: ingredient.unit,
        alternative: ingredient.alternative,
        tag: IngredientTagModel.fromDomain(ingredient.tag)
    );
  }
}
