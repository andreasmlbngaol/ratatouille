import 'package:dartz/dartz.dart';
import 'package:ratatouille/core/domain/model/failure.dart';
import 'package:ratatouille/features/recipes/domain/model/ingredient/ingredient_with_tag.dart';
import 'package:ratatouille/features/recipes/domain/repository/recipe_repository.dart';

class AddIngredientUseCase {
  final RecipesRepository repository;

  AddIngredientUseCase(this.repository);

  Future<Either<Failure, List<IngredientWithTag>>> call({
    required int recipeId,
    required int tagId,
    double? amount,
    String? unit,
    String? alternative,
  }) async {
    try {
      if (recipeId <= 0) {
        return Left(Failure("Invalid recipe ID"));
      }

      if (tagId <= 0) {
        return Left(Failure("Invalid tag ID"));
      }

      if (amount != null && amount <= 0) {
        return Left(Failure("Amount must be greater than 0"));
      }

      return await repository.addIngredient(
        recipeId: recipeId,
        tagId: tagId,
        amount: amount,
        unit: unit,
        alternative: alternative,
      );
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
