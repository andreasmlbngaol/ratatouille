import 'package:dartz/dartz.dart';
import 'package:ratatouille/core/domain/model/failure.dart';
import 'package:ratatouille/features/recipes/domain/model/step/step_with_images.dart';
import 'package:ratatouille/features/recipes/domain/repository/recipe_repository.dart';

class UploadStepImageUseCase {
  final RecipesRepository repository;

  UploadStepImageUseCase(this.repository);

  Future<Either<Failure, List<StepWithImages>>> call({
    required int recipeId,
    required int stepId,
    required List<int> imageBytes,
    required String fileName,
  }) async {
    try {
      if (recipeId <= 0) {
        return Left(Failure("Invalid recipe ID"));
      }

      if (stepId <= 0) {
        return Left(Failure("Invalid step ID"));
      }

      if (imageBytes.isEmpty) {
        return Left(Failure("Image can't be empty"));
      }

      if (fileName.isEmpty) {
        return Left(Failure("File name can't be empty"));
      }

      return await repository.uploadStepImage(
        recipeId: recipeId,
        stepId: stepId,
        imageBytes: imageBytes,
        fileName: fileName,
      );
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}