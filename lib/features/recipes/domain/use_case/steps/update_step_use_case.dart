import 'package:dartz/dartz.dart';
import 'package:ratatouille/core/domain/model/failure.dart';
import 'package:ratatouille/features/recipes/domain/model/step/step_with_images.dart';
import 'package:ratatouille/features/recipes/domain/repository/recipe_repository.dart';

class UpdateStepUseCase {
  final RecipesRepository repository;

  UpdateStepUseCase(this.repository);

  Future<Either<Failure, List<StepWithImages>>> call({
    required int recipeId,
    required int stepId,
    required String content,
  }) async {
    try {
      if (recipeId <= 0) {
        return Left(Failure("Invalid recipe ID"));
      }

      if (stepId <= 0) {
        return Left(Failure("Invalid step ID"));
      }

      if (content.isEmpty) {
        return Left(Failure("Step content can't be empty"));
      }

      return await repository.updateStep(recipeId, stepId, content);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
