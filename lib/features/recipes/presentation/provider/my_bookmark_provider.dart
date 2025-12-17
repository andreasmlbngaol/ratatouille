import 'package:flutter/foundation.dart';
import 'package:ratatouille/features/recipes/domain/model/recipe/recipe_detail.dart';
import 'package:ratatouille/features/recipes/domain/use_case/recipe_use_case.dart';

class MyBookmarkProvider extends ChangeNotifier {
  final RecipeUseCase recipeUseCase;

  MyBookmarkProvider({required this.recipeUseCase});

  bool isLoading = false;
  String? errorMessage;
  List<RecipeDetail> recipes = [];

  Future<void> fetchBookmarkedRecipes() async {
    isLoading = true;
    errorMessage = null;
    recipes = [];
    notifyListeners();

    final result = await recipeUseCase.fetchBookmarkedRecipes();

    result.fold(
          (failure) {
        errorMessage = failure.message;
        isLoading = false;
        notifyListeners();
      },
          (data) {
        recipes = data;
        isLoading = false;
        notifyListeners();
      },
    );
  }
}