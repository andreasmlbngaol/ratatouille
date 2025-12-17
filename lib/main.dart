import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ratatouille/core/di/service_locator.dart';
import 'package:ratatouille/features/recipes/domain/use_case/base/publish_recipe_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/base/update_recipe_base_info_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/base/upload_recipe_image_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/draft/get_or_create_draft_recipe_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/ingredient/add_ingredient_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/ingredient/create_ingredient_tag_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/ingredient/search_ingredient_tags_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/steps/create_empty_step_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/steps/update_step_use_case.dart';
import 'package:ratatouille/features/recipes/domain/use_case/steps/upload_step_image_use_case.dart';
import 'package:ratatouille/features/recipes/presentation/provider/create_recipe_provider.dart';
import 'package:ratatouille/features/recipes/presentation/provider/my_recipe_provider.dart';
import 'package:ratatouille/features/recipes/presentation/provider/recipe_detail_provider.dart';
import 'package:ratatouille/features/recipes/presentation/provider/search_recipe_provider.dart';
import 'package:ratatouille/features/users/data/model/user_model.dart';
import 'package:ratatouille/firebase_options.dart';
import 'package:ratatouille/core/presentation/router.dart';
import 'package:ratatouille/core/presentation/theme.dart';
import 'package:provider/provider.dart';

import 'features/users/presentation/provider/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // biar konten tembus status bar
      systemNavigationBarColor: Colors.transparent, // biar tembus nav bar
      statusBarIconBrightness: Brightness.dark, // icon status bar hitam
      systemNavigationBarIconBrightness: Brightness.dark,
    )
  );

  // initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // initialize hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());

  await setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthProvider(
              checkAuthStatusUseCase: getIt(),
              authenticateUseCase: getIt(),
              signInWithEmailUseCase: getIt(),
              signInWithGoogleUseCase: getIt(),
              signUpWithEmailUseCase: getIt(),
              signOutUseCase: getIt(),
              verifyEmailUseCase: getIt(),
              completeProfileSetupUseCase: getIt(),
              updateUserProfileUseCase: getIt(),
            )
          ),
          ChangeNotifierProvider(
            create: (_) => CreateRecipeProvider(
              getOrCreateDraftRecipeUseCase: getIt<GetOrCreateDraftRecipeUseCase>(),
              updateRecipeBaseInfoUseCase: getIt<UpdateRecipeBaseInfoUseCase>(),
              uploadRecipeImageUseCase: getIt<UploadRecipeImageUseCase>(),
              searchIngredientTagsUseCase: getIt<SearchIngredientTagsUseCase>(),
              createIngredientTagUseCase: getIt<CreateIngredientTagUseCase>(),
              getIngredientsUseCase: getIt(),
              addIngredientUseCase: getIt<AddIngredientUseCase>(),
              getStepsUseCase: getIt(),
              createEmptyStepUseCase: getIt<CreateEmptyStepUseCase>(),
              updateStepUseCase: getIt<UpdateStepUseCase>(),
              uploadStepImageUseCase: getIt<UploadStepImageUseCase>(),
              publishRecipeUseCase: getIt<PublishRecipeUseCase>(),
            )
          ),
          ChangeNotifierProvider(
            create: (_) => SearchRecipeProvider(
              recipeUseCase: getIt(),
            )
          ),
          ChangeNotifierProvider(
            create: (_) => RecipeDetailProvider(
              recipeUseCase: getIt(),
              authLocalDataSource: getIt(),
            )
          ),
          ChangeNotifierProvider(
            create: (_) => MyRecipeProvider(
              recipeUseCase: getIt(),
            )
          ),
        ],
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return MaterialApp.router(
              builder: FToastBuilder(),
              routerConfig: createRouter(context, authProvider),
              title: 'Ratatouille',
              theme: lightMaterialTheme,
            );
          },
        )
    );
  }
}