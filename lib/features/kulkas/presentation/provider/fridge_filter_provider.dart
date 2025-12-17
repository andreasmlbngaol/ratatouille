import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:ratatouille/features/recipes/domain/model/ingredient/ingredient_tag.dart';
import 'package:ratatouille/features/recipes/domain/model/recipe/recipe_detail.dart';
import 'package:ratatouille/features/recipes/domain/use_case/recipe_use_case.dart';

import '../../../recipes/domain/use_case/ingredient/search_ingredient_tags_use_case.dart';

class FridgeFilterProvider extends ChangeNotifier {
  // Use cases - inject dari constructor
  final SearchIngredientTagsUseCase searchIngredientTagsUseCase;
  final RecipeUseCase recipeUseCase;

  // Include ingredients
  List<IngredientTag> includeIngredients = [];
  List<IngredientTag> includeSearchResults = [];
  bool isSearchingInclude = false;
  String currentIncludeQuery = '';
  Timer? _includeDebounce;

  // Exclude ingredients
  List<IngredientTag> excludeIngredients = [];
  List<IngredientTag> excludeSearchResults = [];
  bool isSearchingExclude = false;
  String currentExcludeQuery = '';
  Timer? _excludeDebounce;

  // Rating & Time
  bool isLoading = false;
  int selectedRating = 4;
  int? minTime;
  int? maxTime;

  List<RecipeDetail> results = [];

  // Error handling
  String? errorMessage;

  // Constructor
  FridgeFilterProvider({
    required this.searchIngredientTagsUseCase,
    required this.recipeUseCase,
  });

// Getters

  /// Search ingredient tags dengan debounce (Include)
  Future<void> searchIncludeIngredients(String query) async {
    currentIncludeQuery = query;

    // Reset jika query terlalu pendek
    if (query.length < 3) {
      _includeDebounce?.cancel();
      includeSearchResults = [];
      isSearchingInclude = false;
      notifyListeners();
      return;
    }

    // Debounce
    _includeDebounce?.cancel();
    _includeDebounce = Timer(const Duration(milliseconds: 400), () async {
      isSearchingInclude = true;
      notifyListeners();

      final result = await searchIngredientTagsUseCase.call(query: query);

      result.fold(
        (failure) {
          errorMessage = failure.message;
          includeSearchResults = [];
        },
          (tags) {
            // Cek: query masih relevan?
            if (currentIncludeQuery == query) {
              includeSearchResults = tags;
            }
          }
      );

      isSearchingInclude = false;
      notifyListeners();
    });
  }

  Future<void> searchExcludeIngredients(String query) async {
    currentExcludeQuery = query;

    if (query.length < 3) {
      _excludeDebounce?.cancel();
      excludeSearchResults = [];
      isSearchingExclude = false;
      notifyListeners();
      return;
    }

    // Debounce
    _excludeDebounce?.cancel();
    _excludeDebounce = Timer(const Duration(milliseconds: 400), () async {
      isSearchingExclude = true;
      notifyListeners();

      final result = await searchIngredientTagsUseCase.call(query: query);

      result.fold(
              (failure) {
            errorMessage = failure.message;
            excludeSearchResults = [];
          },
              (tags) {
            // Cek: query masih relevan?
            if (currentExcludeQuery == query) {
              excludeSearchResults = tags;
            }
          }
      );

      isSearchingExclude = false;
      notifyListeners();
    });
  }

  void selectIncludeIngredient(IngredientTag tag) {
    if (includeIngredients.any((ing) => ing.id == tag.id)) {
      errorMessage = 'Bahan sudah ditambahkan';
      notifyListeners();
      return;
    }

    includeIngredients.add(tag);
    includeSearchResults = [];
    currentIncludeQuery = '';
    isSearchingInclude = false;
    notifyListeners();
  }

  void selectExcludeIngredient(IngredientTag tag) {
    if (excludeIngredients.any((ing) => ing.id == tag.id)) {
      errorMessage = 'Bahan sudah ditambahkan';
      notifyListeners();
      return;
    }

    excludeIngredients.add(tag);
    excludeSearchResults = [];
    currentExcludeQuery = '';
    isSearchingExclude = false;
    notifyListeners();
  }

  void removeIncludeIngredient(int ingredientId) {
    includeIngredients.removeWhere((ing) => ing.id == ingredientId);
    notifyListeners();
  }

  void removeExcludeIngredient(int ingredientId) {
    excludeIngredients.removeWhere((ing) => ing.id == ingredientId);
    notifyListeners();
  }

  void setRating(int rating) {
    selectedRating = rating;
    notifyListeners();
  }

  void setMinTime(int time) {
    minTime = time;
    notifyListeners();
  }

  void setMaxTime(int time) {
    maxTime = time;
    notifyListeners();
  }

  Future<void> applyFilter() async {
    isLoading = true;
    errorMessage = null;

    notifyListeners();

    final result = await recipeUseCase.fridgeFilter(
      includedIngredients: includeIngredients.map((ing) => ing.id).toList(),
      excludedIngredients: excludeIngredients.map((ing) => ing.id).toList(),
      minRating: selectedRating.toDouble(),
      minEstTime: minTime,
      maxEstTime: maxTime
    );

    result.fold(
      (failure) {
        errorMessage = failure.message;
        results = [];
        isLoading = false;
        notifyListeners();
      },
      (recipes) {
        results = recipes;
        isLoading = false;
        notifyListeners();
      }
    );

    notifyListeners();
  }
}