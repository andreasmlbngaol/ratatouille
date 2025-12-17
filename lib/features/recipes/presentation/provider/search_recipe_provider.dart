
import 'package:flutter/foundation.dart';
import 'package:ratatouille/features/recipes/domain/model/recipe/recipe_detail.dart';

import '../../domain/use_case/recipe_use_case.dart';

class SearchRecipeProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  String query = '';
  double? minRating;
  int? minEstTime;
  int? maxEstTime;

  List<RecipeDetail> results = [];

  final RecipeUseCase recipeUseCase;

  SearchRecipeProvider({required this.recipeUseCase});

  Future<void> search({
    required String query,
    double? minRating,
    int? minEstTime,
    int? maxEstTime,
  }) async {
    if (query.trim().length < 3) {
      errorMessage = 'Query must be at least 3 characters';
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;

    this.query = query;
    this.minRating = minRating;
    this.minEstTime = minEstTime;
    this.maxEstTime = maxEstTime;

    notifyListeners();

    final result = await recipeUseCase.search(
      query: query,
      minRating: minRating,
      minEstTime: minEstTime,
      maxEstTime: maxEstTime,
    );

    result.fold(
      (failure) {
        errorMessage = failure.message;
        results = [];
        isLoading = false;
      },
      (recipes) {
        results = recipes;
        isLoading = false;
      },
    );
    notifyListeners();
  }

  void clear() {
    query = '';
    minRating = null;
    minEstTime = null;
    maxEstTime = null;
    results = [];
    errorMessage = null;
    notifyListeners();
  }
}