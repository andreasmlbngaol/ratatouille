import 'package:dartz/dartz.dart';
import 'package:ratatouille/core/domain/model/failure.dart';
import 'package:ratatouille/features/recipes/domain/model/step/step_with_images.dart';
import 'package:ratatouille/features/recipes/domain/repository/recipe_repository.dart';

class CreateEmptyStepUseCase {
  final RecipesRepository repository;

  CreateEmptyStepUseCase(this.repository);

  Future<Either<Failure, List<StepWithImages>>> call({
    required int recipeId,
    required int stepNumber,
  }) async {
    try {
      if (recipeId <= 0) {
        return Left(Failure("Invalid recipe ID"));
      }

      if (stepNumber <= 0) {
        return Left(Failure("Step number must be greater than 0"));
      }

      return await repository.createEmptyStep(recipeId, stepNumber);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
