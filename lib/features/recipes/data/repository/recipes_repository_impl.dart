import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:ratatouille/core/domain/model/failure.dart';
import 'package:ratatouille/features/recipes/domain/data_source/recipe_remote_data_source.dart';
import 'package:ratatouille/features/recipes/domain/model/comment/comment_with_image.dart';
import 'package:ratatouille/features/recipes/domain/model/ingredient/ingredient_tag.dart';
import 'package:ratatouille/features/recipes/domain/model/ingredient/ingredient_with_tag.dart';
import 'package:ratatouille/features/recipes/domain/model/recipe/recipe_detail.dart';
import 'package:ratatouille/features/recipes/domain/model/recipe/recipe_status.dart';
import 'package:ratatouille/features/recipes/domain/model/recipe/recipe_with_images.dart';
import 'package:ratatouille/features/recipes/domain/model/step/step_with_images.dart';
import 'package:ratatouille/features/recipes/domain/repository/recipe_repository.dart';

class RecipesRepositoryImpl implements RecipesRepository {
  final RecipeRemoteDataSource remoteDataSource;

  RecipesRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, RecipeDetail>> getRecipeDetail(int recipeId) async {
    try {
      debugPrint("recipes repository: get recipe detail start");
      final recipeDetailModel = await remoteDataSource.getRecipeDetail(
          recipeId);
      debugPrint("recipes repository: get recipe detail end");
      return Right(recipeDetailModel.toDomain());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RecipeWithImages>> getOrCreateDraftRecipe() async {
    try {
      debugPrint("recipes repository: get or create draft recipe");
      final recipeModel = await remoteDataSource.getOrCreateDraftRecipe();
      return Right(recipeModel.toDomain());
    } catch (e) {
      debugPrint("recipes repository failure");
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RecipeWithImages>> updateRecipeBaseInfo({
    required int recipeId,
    String? name,
    String? description,
    bool? isPublic,
    int? estTimeInMinutes,
    int? portion
  }) async {
    try {
      final recipeModel = await remoteDataSource.updateRecipe(
          recipeId: recipeId,
          name: name,
          description: description,
          isPublic: isPublic,
          estTimeInMinutes: estTimeInMinutes,
          portion: portion
      );
      return Right(recipeModel.toDomain());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RecipeWithImages>> publishRecipe(int recipeId) async {
    try {
      debugPrint("recipes repository: publish recipe start");
      final recipeModel = await remoteDataSource.updateRecipeStatus(
          recipeId: recipeId,
          status: RecipeStatus.PUBLISHED
      );
      debugPrint("recipes repository: publish recipe end");
      return Right(recipeModel.toDomain());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RecipeWithImages>> uploadRecipeImage({
    required int recipeId,
    required List<int> imageBytes,
    required String fileName
  }) async {
    try {
      debugPrint("recipes repository: upload recipe image start");
      final recipeModel = await remoteDataSource.uploadRecipeImage(
          recipeId: recipeId,
          imageBytes: imageBytes,
          fileName: fileName
      );
      debugPrint("recipes repository: upload recipe image end");
      return Right(recipeModel.toDomain());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, IngredientTag>> createIngredientTag(String name) async {
    try {
      debugPrint("recipes repository: create ingredient tag start");
      final tagModel = await remoteDataSource.createIngredientTag(name);
      debugPrint("recipes repository: create ingredient tag end");
      return Right(tagModel.toDomain());
    } catch (e) {
      debugPrint("recipes repository: create ingredient tag failure");
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<IngredientTag>>> searchIngredientTags(String query) async {
    try {
      final tagsModel = await remoteDataSource.searchIngredientTags(query);
      return Right(tagsModel.map((e) => e.toDomain()).toList());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<IngredientWithTag>>> getIngredients(int recipeId) async {
    try {
      debugPrint("recipes repository: get ingredients start");
      final ingredientsModel = await remoteDataSource.getIngredients(recipeId);
      return Right(ingredientsModel.map((e) => e.toDomain()).toList());
    } catch (e) {
      debugPrint("recipes repository: get ingredients end");
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<IngredientWithTag>>> addIngredient({
    required int recipeId,
    required int tagId,
    double? amount,
    String? unit,
    String? alternative
  }) async {
    try {
      final ingredientsModel = await remoteDataSource.addIngredient(
          recipeId: recipeId,
          tagId: tagId,
          amount: amount,
          unit: unit,
          alternative: alternative
      );
      return Right(ingredientsModel.map((e) => e.toDomain()).toList());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StepWithImages>>> getSteps(int recipeId) async {
    try {
      final stepsModel = await remoteDataSource.getSteps(recipeId);
      return Right(stepsModel.map((e) => e.toDomain()).toList());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StepWithImages>>> createEmptyStep(int recipeId, int stepNumber) async {
    try {
      final stepsModel = await remoteDataSource.createEmptyStep(recipeId, stepNumber);
      return Right(stepsModel.map((e) => e.toDomain()).toList());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StepWithImages>>> updateStep(int recipeId, int stepId, String content) async {
    try {
      final stepsModel = await remoteDataSource.updateStep(recipeId, stepId, content);
      return Right(stepsModel.map((e) => e.toDomain()).toList());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StepWithImages>>> uploadStepImage({
    required int recipeId,
    required int stepId,
    required List<int> imageBytes,
    required String fileName
  }) async {
    try {
      final stepsModel = await remoteDataSource.uploadStepImage(
          recipeId: recipeId,
          stepId: stepId,
          imageBytes: imageBytes,
          fileName: fileName
      );
      return Right(stepsModel.map((e) => e.toDomain()).toList());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RecipeDetail>>> search(String query, double? minRating, int? minEstTime, int? maxEstTime) async {
    try {
      debugPrint("recipes repository: search start");
      final recipesModel = await remoteDataSource.search(
        query: query,
        minRating: minRating,
        minEstTime: minEstTime,
        maxEstTime: maxEstTime
      );
      debugPrint("recipes repository: search end");
      return Right(recipesModel.map((e) => e.toDomain()).toList());
    } catch (e) {
      debugPrint("recipes repository: search failure");
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> saveRecipe(int recipeId) async {
    try {
      debugPrint("recipes repository: save recipe start");
      await remoteDataSource.saveRecipe(recipeId);
      debugPrint("recipes repository: save recipe end");
      return const Right(true);
    } catch (e) {
      debugPrint("recipes repository: save recipe failure");
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> removeSavedRecipe(int recipeId) async {
    try {
      debugPrint("recipes repository: remove saved recipe start");
      await remoteDataSource.removeSavedRecipe(recipeId);
      debugPrint("recipes repository: remove saved recipe end");
      return const Right(true);
    } catch (e) {
      debugPrint("recipes repository: remove saved recipe failure");
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CommentWithImage>>> fetchComments(int recipeId) async {
    try {
      debugPrint("recipes repository: fetch comments start");
      final commentsModel = await remoteDataSource.fetchComments(recipeId);
      debugPrint("recipes repository: fetch comments end");
      return Right(commentsModel.map((e) => e.toDomain()).toList());
    } catch (e) {
      debugPrint("recipes repository: fetch comments failure");
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CommentWithImage>> postComment(int recipeId, String content) async {
    try {
      debugPrint("recipes repository: post comment start");
      final commentsModel = await remoteDataSource.postComment(recipeId, content);
      debugPrint("recipes repository: post comment end");
      return Right(commentsModel.toDomain());
    } catch (e) {
      debugPrint("recipes repository: post comment failure: $e");
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> submitRating(int recipeId, int rating) async {
    try {
      debugPrint("recipes repository: submit rating start");
      await remoteDataSource.submitRating(recipeId, rating);
      debugPrint("recipes repository: submit rating end");
      return const Right(true);
    } catch (e) {
      debugPrint("recipes repository: submit rating failure");
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RecipeDetail>>> getMyRecipes() async {
    try {
      debugPrint("recipes repository: get my recipes start");
      final recipesModel = await remoteDataSource.getMyRecipes();
      debugPrint("recipes repository: get my recipes end");
      return Right(recipesModel.map((e) => e.toDomain()).toList());
    } catch (e) {
      debugPrint("recipes repository: get my recipes failure");
      return Left(Failure(e.toString()));

    }
  }
}