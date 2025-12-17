import '../image/ratatouille_image.dart';

class CommentWithImage {
  final int id;
  final int recipeId;
  final String authorId;
  final String content;
  final int createdAt;
  final RatatouilleImage? image;

  const CommentWithImage({
    required this.id,
    required this.recipeId,
    required this.authorId,
    required this.content,
    required this.createdAt,
    required this.image
  });
}