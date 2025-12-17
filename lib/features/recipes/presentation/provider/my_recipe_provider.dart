import 'package:flutter/foundation.dart';
import 'package:ratatouille/features/recipes/domain/model/recipe/recipe_detail.dart';
import 'package:ratatouille/features/recipes/domain/use_case/recipe_use_case.dart';

class MyRecipeProvider extends ChangeNotifier {
  final RecipeUseCase recipeUseCase;

  MyRecipeProvider({required this.recipeUseCase});

  bool isLoading = false;
  String? errorMessage;
  List<RecipeDetail> recipes = [];

  Future<void> fetchMyRecipes() async {
    isLoading = true;
    errorMessage = null;
    recipes = [];
    notifyListeners();

    final result = await recipeUseCase.getMyRecipes();

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