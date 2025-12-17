import 'package:json_annotation/json_annotation.dart';
import 'package:ratatouille/features/recipes/data/model/image/ratatouille_image_model.dart';
import 'package:ratatouille/features/users/data/model/user_model.dart';

import '../../../domain/model/comment/comment_with_image.dart';

part 'comment_with_image_model.g.dart';

@JsonSerializable()
class CommentWithImageModel {
  final int id;
  final int recipeId;
  final UserModel author;
  final String content;
  final int createdAt;
  final RatatouilleImageModel? image;

  const CommentWithImageModel({
    required this.id,
    required this.recipeId,
    required this.author,
    required this.content,
    required this.createdAt,
    required this.image
  });

  factory CommentWithImageModel.fromJson(Map<String, dynamic> json) =>
      _$CommentWithImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentWithImageModelToJson(this);

  CommentWithImage toDomain() {
    return CommentWithImage(
      id: id,
      recipeId: recipeId,
      author: author.toDomain(),
      content: content,
      createdAt: createdAt,
      image: image?.toDomain()
    );
  }

  factory CommentWithImageModel.fromDomain(CommentWithImage comment) {
    final image = comment.image == null ? null : RatatouilleImageModel.fromDomain(comment.image!);
    return CommentWithImageModel(
      id: comment.id,
      recipeId: comment.recipeId,
      author: UserModel.fromDomain(comment.author),
      content: comment.content,
      createdAt: comment.createdAt,
      image: image
    );
  }
}