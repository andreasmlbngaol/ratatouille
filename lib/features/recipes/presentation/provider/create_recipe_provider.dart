import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ratatouille/features/recipes/domain/model/ingredient/ingredient_tag.dart';
import 'package:ratatouille/features/recipes/domain/model/ingredient/ingredient_with_tag.dart';
import 'package:ratatouille/features/recipes/domain/model/recipe/recipe_with_images.dart';
import 'package:ratatouille/features/recipes/domain/model/step/step_with_images.dart';
import 'package:ratatouille/features/recipes/domain/use_case/base/publish_recipe_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/base/update_recipe_base_info_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/base/upload_recipe_image_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/draft/get_or_create_draft_recipe_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/ingredient/add_ingredient_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/ingredient/create_ingredient_tag_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/ingredient/get_ingredients_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/ingredient/search_ingredient_tags_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/steps/create_empty_step_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/steps/get_steps_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/steps/update_step_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/steps/upload_step_image_use_case.dart';

class CreateRecipeProvider extends ChangeNotifier {
  // Use Cases
  final GetOrCreateDraftRecipeUseCase getOrCreateDraftRecipeUseCase;
  final UpdateRecipeBaseInfoUseCase updateRecipeBaseInfoUseCase;
  final UploadRecipeImageUseCase uploadRecipeImageUseCase;
  final SearchIngredientTagsUseCase searchIngredientTagsUseCase;
  final CreateIngredientTagUseCase createIngredientTagUseCase;
  final GetIngredientsUseCase getIngredientsUseCase;
  final AddIngredientUseCase addIngredientUseCase;
  final GetStepsUseCase getStepsUseCase;
  final CreateEmptyStepUseCase createEmptyStepUseCase;
  final UpdateStepUseCase updateStepUseCase;
  final UploadStepImageUseCase uploadStepImageUseCase;
  final PublishRecipeUseCase publishRecipeUseCase;

  // State
  RecipeWithImages? recipe;
  List<IngredientWithTag> ingredients = [];
  List<StepWithImages> steps = [];
  List<IngredientTag> searchResults = [];
  Timer? _debounce;

  // UI State
  bool isLoading = false;
  String? errorMessage;
  int currentPageIndex = 0;
  bool skipAmount = false;

  // Ingredient search state
  bool isSearchingIngredient = false;
  String currentIngredientQuery = '';
  int? selectedStepForImage;

  // Ingredient form state
  IngredientTag? selectedIngredientTag;
  double? ingredientAmount;
  String? ingredientUnit;
  String? ingredientAlternative;

  // Step form state
  String? currentStepContent;
  int? currentEditingStepId;

  CreateRecipeProvider({
    required this.getOrCreateDraftRecipeUseCase,
    required this.updateRecipeBaseInfoUseCase,
    required this.uploadRecipeImageUseCase,
    required this.searchIngredientTagsUseCase,
    required this.createIngredientTagUseCase,
    required this.getIngredientsUseCase,
    required this.addIngredientUseCase,
    required this.getStepsUseCase,
    required this.createEmptyStepUseCase,
    required this.updateStepUseCase,
    required this.uploadStepImageUseCase,
    required this.publishRecipeUseCase,
  });

  // ==================== INITIALIZATION ====================
  Future<void> initializeDraftRecipe() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await getOrCreateDraftRecipeUseCase.call();

    result.fold(
          (failure) {
        errorMessage = failure.message;
        isLoading = false;
      },
          (recipeData) {
            debugPrint("Recipe: ${recipeData.name}");
        recipe = recipeData;
        ingredients = [];
        steps = [];
        isLoading = false;
      },
    );

    notifyListeners();
  }

  // ==================== BASE INFO PAGE ====================
  Future<void> updateRecipeBaseInfo({
    required String name,
    required String description,
    required bool isPublic,
    required int estTimeInMinutes,
    required int portion,
  }) async {
    if (recipe == null) return;

    // Validasi basic
    if (name.trim().isEmpty) {
      errorMessage = 'Nama resep tidak boleh kosong';
      notifyListeners();
      return;
    }

    if (estTimeInMinutes <= 0) {
      errorMessage = 'Waktu perkiraan harus lebih dari 0 menit';
      notifyListeners();
      return;
    }

    if (portion <= 0) {
      errorMessage = 'Porsi harus lebih dari 0';
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await updateRecipeBaseInfoUseCase.call(
      recipeId: recipe!.id,
      name: name.trim(),
      description: description.trim().isEmpty ? null : description.trim(),
      isPublic: isPublic,
      estTimeInMinutes: estTimeInMinutes,
      portion: portion,
    );

    result.fold(
          (failure) {
        errorMessage = failure.message;
        isLoading = false;
      },
          (updatedRecipe) {
        recipe = updatedRecipe;
        isLoading = false;
      },
    );

    notifyListeners();
  }

  Future<void> uploadRecipeImage(XFile imageFile) async {
    if (recipe == null) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final imageBytes = await imageFile.readAsBytes();
      final fileName = imageFile.name;

      final result = await uploadRecipeImageUseCase.call(
        recipeId: recipe!.id,
        imageBytes: imageBytes,
        fileName: fileName,
      );

      debugPrint("Result: ${result.isRight()}");

      result.fold(
            (failure) {
              debugPrint("Failure: ${failure.message}");
          errorMessage = failure.message;
          isLoading = false;
        },
            (updatedRecipe) {
          recipe = recipe!.copyWith(images: updatedRecipe.images);
          isLoading = false;
        },
      );
    } catch (e) {
      errorMessage = 'Error loading image: ${e.toString()}';
      isLoading = false;
    }

    notifyListeners();
  }

  // ==================== INGREDIENTS PAGE ====================

  Future<void> loadIngredients() async {
    if (recipe == null) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await getIngredientsUseCase.call(recipeId: recipe!.id);
    result.fold(
          (failure) {
        errorMessage = failure.message;
        isLoading = false;
      },
          (ingredientsData) {
        ingredients = ingredientsData;
        isLoading = false;
      },
    );

    notifyListeners();
  }

  Future<void> searchIngredientTags(String query) async {
    currentIngredientQuery = query;

    // Reset jika query terlalu pendek
    if (query.length < 3) {
      _debounce?.cancel();
      searchResults = [];
      isSearchingIngredient = false;
      notifyListeners();
      return;
    }

    // Debounce
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      isSearchingIngredient = true;
      notifyListeners();

      final result = await searchIngredientTagsUseCase.call(query: query);

      result.fold(
            (failure) {
          errorMessage = failure.message;
          searchResults = [];
        },
            (tags) {
          // Cek: query masih relevan?
          if (currentIngredientQuery == query) {
            searchResults = tags;
          }
        },
      );

      isSearchingIngredient = false;
      notifyListeners();
    });
  }

  Future<void> selectIngredientTag(IngredientTag tag) async {
    debugPrint("Tag: ${tag.name}");
    selectedIngredientTag = tag;
    searchResults = [];
    currentIngredientQuery = '';
    isSearchingIngredient = false;
    notifyListeners();
  }

  Future<void> createNewIngredientTag(String name) async {
    if (name.isEmpty) {
      errorMessage = 'Tag name cannot be empty';
      notifyListeners();
      return;
    }

    isSearchingIngredient = true;
    errorMessage = null;
    notifyListeners();

    final result = await createIngredientTagUseCase.call(name: name);

    result.fold(
          (failure) {
        errorMessage = failure.message;
        isSearchingIngredient = false;
      },
          (tag) {
        selectedIngredientTag = tag;
        searchResults = [];
        currentIngredientQuery = '';
        isSearchingIngredient = false;
      },
    );

    notifyListeners();
  }

  void setSkipAmount(bool value) {
    skipAmount = value;
    ingredientAmount = null;
    ingredientUnit = null;
    notifyListeners();
  }

  void setIngredientAmount(double? amount) {
    ingredientAmount = amount;
    notifyListeners();
  }

  void setIngredientUnit(String? unit) {
    if(unit == null) {
      ingredientUnit = null;
      return;
    }
    ingredientUnit = unit.isEmpty ? null : unit;
    notifyListeners();
  }

  void setIngredientAlternative(String alternative) {
    ingredientAlternative = alternative.isEmpty ? null : alternative;
    notifyListeners();
  }

  Future<void> saveIngredient() async {
    if (recipe == null || selectedIngredientTag == null) {
      errorMessage = 'Invalid ingredient data';
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await addIngredientUseCase.call(
      recipeId: recipe!.id,
      tagId: selectedIngredientTag!.id,
      amount: ingredientAmount,
      unit: ingredientUnit,
      alternative: ingredientAlternative,
    );

    result.fold(
          (failure) {
        errorMessage = failure.message;
        isLoading = false;
      },
          (updatedIngredients) {
        ingredients = updatedIngredients;
        // Reset form
        selectedIngredientTag = null;
        ingredientAmount = null;
        ingredientUnit = null;
        ingredientAlternative = null;
        isLoading = false;
      },
    );

    notifyListeners();
  }

  void cancelIngredientForm() {
    selectedIngredientTag = null;
    ingredientAmount = null;
    ingredientUnit = null;
    ingredientAlternative = null;
    searchResults = [];
    currentIngredientQuery = '';
    notifyListeners();
  }

  // ==================== STEPS PAGE ====================
  Future<void> loadSteps() async {
    if (recipe == null) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await getStepsUseCase.call(recipeId: recipe!.id);
    result.fold(
          (failure) {
        errorMessage = failure.message;
        isLoading = false;
        },
          (stepsData) {
        steps = stepsData;
        isLoading = false;
      }
    );

    notifyListeners();
  }

  Future<void> addNewStep() async {
    if (recipe == null) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final stepNumber = steps.length + 1;

    final result = await createEmptyStepUseCase.call(
      recipeId: recipe!.id,
      stepNumber: stepNumber,
    );

    result.fold(
          (failure) {
        errorMessage = failure.message;
        isLoading = false;
      },
          (updatedSteps) {
        steps = updatedSteps;
        // Auto-select the newly created step for editing
        if (steps.isNotEmpty) {
          currentEditingStepId = steps.last.id;
          currentStepContent = '';
        }
        isLoading = false;
      },
    );

    notifyListeners();
  }

  void setCurrentStepContent(String content) {
    currentStepContent = content;
    notifyListeners();
  }

  Future<void> updateCurrentStep() async {
    if (recipe == null || currentEditingStepId == null || currentStepContent == null || currentStepContent!.isEmpty) {
      errorMessage = 'Step content cannot be empty';
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await updateStepUseCase.call(
      recipeId: recipe!.id,
      stepId: currentEditingStepId!,
      content: currentStepContent!,
    );

    result.fold(
          (failure) {
        errorMessage = failure.message;
        isLoading = false;
      },
          (updatedSteps) {
        steps = updatedSteps;
        currentEditingStepId = null;
        currentStepContent = null;
        isLoading = false;
      },
    );

    notifyListeners();
  }

  Future<void> uploadStepImage(XFile imageFile, int stepId) async {
    if (recipe == null) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final imageBytes = await imageFile.readAsBytes();
      final fileName = imageFile.name;

      final result = await uploadStepImageUseCase.call(
        recipeId: recipe!.id,
        stepId: stepId,
        imageBytes: imageBytes,
        fileName: fileName,
      );

      result.fold(
            (failure) {
          errorMessage = failure.message;
          isLoading = false;
        },
            (updatedSteps) {
          steps = updatedSteps;
          isLoading = false;
        },
      );
    } catch (e) {
      errorMessage = 'Error loading image: ${e.toString()}';
      isLoading = false;
    }

    notifyListeners();
  }

  // ==================== NAVIGATION ====================
  void setCurrentPage(int index) {
    currentPageIndex = index;
    notifyListeners();
  }

  void goToNextPage() {
    if (currentPageIndex < 3) {
      currentPageIndex++;
      notifyListeners();
    }
  }

  void goToPreviousPage() {
    if (currentPageIndex > 0) {
      currentPageIndex--;
      notifyListeners();
    }
  }

  // ==================== PREVIEW & PUBLISH ====================
  Future<bool> publishRecipe() async {
    if (recipe == null) {
      errorMessage = 'Recipe not found';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await publishRecipeUseCase.call(recipe!.id);

    result.fold(
          (failure) {
        errorMessage = failure.message;
        isLoading = false;
      },
          (publishedRecipe) {
        recipe = publishedRecipe;
        isLoading = false;
      },
    );

    notifyListeners();
    return result.isRight();
  }

  // ==================== UTILITIES ====================
  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  void reset() {
    recipe = null;
    ingredients = [];
    steps = [];
    searchResults = [];
    isLoading = false;
    errorMessage = null;
    currentPageIndex = 0;
    isSearchingIngredient = false;
    currentIngredientQuery = '';
    selectedIngredientTag = null;
    ingredientAmount = null;
    ingredientUnit = null;
    ingredientAlternative = null;
    currentStepContent = null;
    currentEditingStepId = null;
    notifyListeners();
  }
}
