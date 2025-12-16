import 'package:dartz/dartz.dart';
import 'package:ratatouille/core/domain/model/failure.dart';
import 'package:ratatouille/features/recipes/domain/model/step/step_with_images.dart';
import 'package:ratatouille/features/recipes/domain/repository/recipe_repository.dart';

class GetStepsUseCase {
  final RecipesRepository repository;

  GetStepsUseCase(this.repository);

  Future<Either<Failure, List<StepWithImages>>> call({
    required int recipeId
  }) async {
    try {
      if (recipeId <= 0) {
        return Left(Failure("Invalid recipe ID"));
      }

      return await repository.getSteps(recipeId);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}