import 'package:flutter/cupertino.dart';
import 'package:ratatouille/features/recipes/domain/use_case/recipe_use_case.dart';
import 'package:ratatouille/features/users/domain/data_source/auth_local_data_source.dart';
import 'package:ratatouille/features/users/domain/model/auth/user.dart';

import '../../domain/model/comment/comment_with_image.dart';
import '../../domain/model/recipe/recipe_detail.dart';

class RecipeDetailProvider extends ChangeNotifier {
  final RecipeUseCase recipeUseCase;
  final AuthLocalDataSource authLocalDataSource;

  RecipeDetailProvider({
    required this.recipeUseCase,
    required this.authLocalDataSource,
  });

  bool isLoading = false;
  String? errorMessage;

  RatatouilleUser? currentUserId;
  RecipeDetail? detail;
  List<CommentWithImage> comments = [];

  Future<void> fetch(int recipeId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    currentUserId = (await authLocalDataSource.getUser())?.toDomain();
    final result = await recipeUseCase.getRecipeDetail(recipeId);

    result.fold(
          (failure) {
        errorMessage = failure.message;
        isLoading = false;
        notifyListeners();
      },
          (data) {
        detail = data;
        isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> saveRecipe(int recipeId) async {
    errorMessage = null;
    notifyListeners();

    final result = await recipeUseCase.saveRecipe(recipeId);
    result.fold(
          (failure) {
        errorMessage = failure.message;
        isLoading = false;
        notifyListeners();
      },
          (data) async {
        if (data) {
          final newDetail = await recipeUseCase.getRecipeDetail(recipeId);
          newDetail.fold(
                  (failure) {
                errorMessage = failure.message;
                isLoading = false;
                notifyListeners();
              },
                  (data) {
                detail = data;
                isLoading = false;
                notifyListeners();
              }
          );
        }
      },
    );
  }

  Future<void> removeSavedRecipe(int recipeId) async {
    errorMessage = null;
    notifyListeners();

    final result = await recipeUseCase.removeSavedRecipe(recipeId);
    result.fold(
          (failure) {
        errorMessage = failure.message;
        isLoading = false;
        notifyListeners();
      },
          (data) async {
        if (data) {
          final newDetail = await recipeUseCase.getRecipeDetail(recipeId);
          newDetail.fold(
                  (failure) {
                errorMessage = failure.message;
                isLoading = false;
                notifyListeners();
              },
                  (data) {
                detail = data;
                isLoading = false;
                notifyListeners();
              }
          );
        }
      },
    );
  }

  Future<void> fetchComments(int recipeId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await recipeUseCase.fetchComments(recipeId);
    result.fold(
          (failure) {
            errorMessage = failure.message;
            isLoading = false;
            notifyListeners();
          },
          (data) {
            comments = data;
            isLoading = false;
            notifyListeners();
          },
    );
  }

  Future<void> postComment(int recipeId, String content) async {
    // isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await recipeUseCase.postComment(recipeId, content);

    result.fold(
      (failure) {
        errorMessage = failure.message;
        isLoading = false;
      },
      (data) async {
        comments = comments + [data];
        final newDetail = await recipeUseCase.getRecipeDetail(recipeId);
        newDetail.fold(
                (failure) {
              errorMessage = failure.message;
              isLoading = false;
              notifyListeners();
            },
                (data) {
              detail = data;
              isLoading = false;
              notifyListeners();
            }
        );
        isLoading = false;
      }
    );

    notifyListeners();
  }

  Future<void> submitRating(int recipeId, int rating) async {
    debugPrint("submitRating: $recipeId, $rating");
    errorMessage = null;
    notifyListeners();

    final result = await recipeUseCase.submitRating(recipeId, rating);

    result.fold(
          (failure) {
            errorMessage = failure.message;
            isLoading = false;
            notifyListeners();
          },
          (data) async {
            if (data) {
              final newDetail = await recipeUseCase.getRecipeDetail(recipeId);
              newDetail.fold(
                      (failure) {
                    errorMessage = failure.message;
                    isLoading = false;
                    notifyListeners();
                  },
                      (data) {
                    detail = data;
                    isLoading = false;
                    notifyListeners();
                  }
              );
            }
          }
    );
  }
}