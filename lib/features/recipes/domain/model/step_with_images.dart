import 'package:ratatouille/features/recipes/domain/model/ratatouille_image.dart';
import 'package:ratatouille/features/recipes/domain/model/step.dart';

class StepWithImages {
  final Step step;
  final List<RatatouilleImage> images;

  const StepWithImages({
    required this.step,
    required this.images
  });
}
