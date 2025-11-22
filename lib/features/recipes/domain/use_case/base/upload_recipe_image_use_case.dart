import 'package:dartz/dartz.dart';
import 'package:ratatouille/core/domain/model/failure.dart';
import 'package:ratatouille/features/recipes/domain/model/recipe/recipe_with_images.dart';
import 'package:ratatouille/features/recipes/domain/repository/recipe_repository.dart';

class UploadRecipeImageUseCase {
  final RecipesRepository repository;

  UploadRecipeImageUseCase(this.repository);

  Future<Either<Failure, RecipeWithImages>> call({
    required int recipeId,
    required List<int> imageBytes,
    required String fileName,
  }) async {
    try {
      if (recipeId <= 0) {
        return Left(Failure("Invalid recipe ID"));
      }

      if (imageBytes.isEmpty) {
        return Left(Failure("Image can't be empty"));
      }

      if (fileName.isEmpty) {
        return Left(Failure("File name can't be empty"));
      }

      return await repository.uploadRecipeImage(
        recipeId: recipeId,
        imageBytes: imageBytes,
        fileName: fileName,
      );
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
