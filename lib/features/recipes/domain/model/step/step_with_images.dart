import 'package:ratatouille/features/recipes/domain/model/image/ratatouille_image.dart';

class StepWithImages {
  final int id;
  final int recipeId;
  final int stepNumber;
  final String content;
  final List<RatatouilleImage> images;

  const StepWithImages({
    required this.id,
    required this.recipeId,
    required this.stepNumber,
    required this.content,
    required this.images
  });
}
