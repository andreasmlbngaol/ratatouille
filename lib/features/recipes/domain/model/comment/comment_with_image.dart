import 'package:ratatouille/features/users/domain/model/auth/user.dart';

import '../image/ratatouille_image.dart';

class CommentWithImage {
  final int id;
  final int recipeId;
  final RatatouilleUser author;
  final String content;
  final int createdAt;
  final RatatouilleImage? image;

  const CommentWithImage({
    required this.id,
    required this.recipeId,
    required this.author,
    required this.content,
    required this.createdAt,
    required this.image
  });
}