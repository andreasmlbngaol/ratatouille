import 'package:dartz/dartz.dart';
import 'package:ratatouille/core/domain/model/failure.dart';
import 'package:ratatouille/features/recipes/domain/model/ingredient/ingredient_tag.dart';
import 'package:ratatouille/features/recipes/domain/repository/recipe_repository.dart';

class SearchIngredientTagsUseCase {
  final RecipesRepository repository;

  SearchIngredientTagsUseCase(this.repository);

  Future<Either<Failure, List<IngredientTag>>> call({
    required String query,
  }) async {
    try {
      if (query.length < 3) {
        return Left(Failure("Query must be at least 3 characters"));
      }

      return await repository.searchIngredientTags(query);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
