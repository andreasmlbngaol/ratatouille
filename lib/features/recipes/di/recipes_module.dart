import 'package:ratatouille/core/di/service_locator.dart';
import 'package:ratatouille/core/domain/network/api_client.dart';
import 'package:ratatouille/features/recipes/data/data_source/recipe_remote_data_source_impl.dart';
import 'package:ratatouille/features/recipes/data/repository/recipes_repository_impl.dart';
import 'package:ratatouille/features/recipes/domain/data_source/recipe_remote_data_source.dart';
import 'package:ratatouille/features/recipes/domain/repository/recipe_repository.dart';
import 'package:ratatouille/features/recipes/domain/use_case/base/publish_recipe_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/base/update_recipe_base_info_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/base/upload_recipe_image_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/detail/get_recipe_detail_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/draft/get_or_create_draft_recipe_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/ingredient/add_ingredient_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/ingredient/create_ingredient_tag_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/ingredient/get_ingredients_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/ingredient/search_ingredient_tags_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/steps/create_empty_step_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/steps/get_steps_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/steps/update_step_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/steps/upload_step_image_use_case.dart';

void setupRecipesModule() {
  // Data Source
  getIt.registerSingleton<RecipeRemoteDataSource>(
    RecipeRemoteDataSourceImpl(apiClient: getIt<ApiClient>())
  );

  // Repository
  getIt.registerSingleton<RecipesRepository>(
    RecipesRepositoryImpl(remoteDataSource: getIt<RecipeRemoteDataSource>())
  );

  // Use Case
  getIt.registerSingleton<PublishRecipeUseCase>(
    PublishRecipeUseCase(getIt())
  );

  getIt.registerSingleton<UpdateRecipeBaseInfoUseCase>(
    UpdateRecipeBaseInfoUseCase(getIt())
  );

  getIt.registerSingleton<UploadRecipeImageUseCase>(
    UploadRecipeImageUseCase(getIt())
  );

  getIt.registerSingleton<GetRecipeDetailUseCase>(
    GetRecipeDetailUseCase(getIt())
  );

  getIt.registerSingleton<GetOrCreateDraftRecipeUseCase>(
    GetOrCreateDraftRecipeUseCase(getIt())
  );

  getIt.registerSingleton<GetIngredientsUseCase>(
    GetIngredientsUseCase(getIt())
  );

  getIt.registerSingleton<AddIngredientUseCase>(
    AddIngredientUseCase(getIt())
  );

  getIt.registerSingleton<CreateIngredientTagUseCase>(
    CreateIngredientTagUseCase(getIt())
  );

  getIt.registerSingleton<SearchIngredientTagsUseCase>(
    SearchIngredientTagsUseCase(getIt())
  );

  getIt.registerSingleton<GetStepsUseCase>(
    GetStepsUseCase(getIt())
  );

  getIt.registerSingleton<CreateEmptyStepUseCase>(
    CreateEmptyStepUseCase(getIt())
  );

  getIt.registerSingleton<UpdateStepUseCase>(
    UpdateStepUseCase(getIt())
  );

  getIt.registerSingleton<UploadStepImageUseCase>(
    UploadStepImageUseCase(getIt())
  );
}