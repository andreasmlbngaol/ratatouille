import 'package:json_annotation/json_annotation.dart';
import 'package:ratatouille/features/recipes/domain/model/ingredient/ingredient_tag.dart';

part 'ingredient_tag_model.g.dart';

@JsonSerializable()
class IngredientTagModel {
  final int id;
  final String name;

  const IngredientTagModel({
    required this.id,
    required this.name
  });

  factory IngredientTagModel.fromJson(Map<String, dynamic> json) =>
      _$IngredientTagModelFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientTagModelToJson(this);

  IngredientTag toDomain() {
    return IngredientTag(
        id: id,
        name: name
    );
  }

  factory IngredientTagModel.fromDomain(IngredientTag tag) {
    return IngredientTagModel(
        id: tag.id,
        name: tag.name
    );
  }
}