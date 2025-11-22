import 'package:ratatouille/features/recipes/domain/model/image/ratatouille_image.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ratatouille_image_model.g.dart';

@JsonSerializable()
class RatatouilleImageModel {
  final int id;
  final String url;
  final DateTime createdAt;

  const RatatouilleImageModel({
    required this.id,
    required this.url,
    required this.createdAt
  });

  factory RatatouilleImageModel.fromJson(Map<String, dynamic> json) =>
      _$RatatouilleImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$RatatouilleImageModelToJson(this);

  RatatouilleImage toDomain() {
    return RatatouilleImage(
        id: id,
        url: url,
        createdAt: createdAt
    );
  }

  factory RatatouilleImageModel.fromDomain(RatatouilleImage image) {
    return RatatouilleImageModel(
        id: image.id,
        url: image.url,
        createdAt: image.createdAt
    );
  }
}