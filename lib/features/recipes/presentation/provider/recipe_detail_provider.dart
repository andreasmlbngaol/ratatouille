import 'package:flutter/cupertino.dart';
import 'package:ratatouille/features/recipes/domain/use_case/recipe_use_case.dart';

import '../../domain/model/recipe/recipe_detail.dart';

class RecipeDetailProvider extends ChangeNotifier {
  final RecipeUseCase recipeUseCase;

  RecipeDetailProvider({required this.recipeUseCase});

  bool isLoading = false;
  String? errorMessage;

  RecipeDetail? detail;

  Future<void> fetch(int recipeId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

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
}