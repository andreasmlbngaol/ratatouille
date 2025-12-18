import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ratatouille/core/presentation/app_routes.dart';
import 'package:ratatouille/core/presentation/pages/not_found_page.dart';
import 'package:ratatouille/features/kulkas/presentation/pages/fridge_filter_page.dart';
import 'package:ratatouille/features/recipes/presentation/pages/comment_recipe_page.dart';
import 'package:ratatouille/features/recipes/presentation/pages/create_recipe/create_recipe_base_info_page.dart';
import 'package:ratatouille/features/recipes/presentation/pages/create_recipe/create_recipe_ingredients_page.dart';
import 'package:ratatouille/features/recipes/presentation/pages/create_recipe/create_recipe_preview_page.dart';
import 'package:ratatouille/features/recipes/presentation/pages/create_recipe/create_recipe_steps_page.dart';
import 'package:ratatouille/features/recipes/presentation/pages/favorite_page.dart';
import 'package:ratatouille/features/recipes/presentation/pages/home_page.dart';
import 'package:ratatouille/features/recipes/presentation/pages/main_shell.dart';
import 'package:ratatouille/features/recipes/presentation/pages/my_recipe_page.dart';
import 'package:ratatouille/features/users/presentation/pages/andre_detail_page.dart';
import 'package:ratatouille/features/users/presentation/pages/bintang_detail_page.dart';
import 'package:ratatouille/features/users/presentation/pages/edit_profile_page.dart';
import 'package:ratatouille/features/users/presentation/pages/profile_page.dart';
import 'package:ratatouille/features/recipes/presentation/pages/search_recipe_page.dart';
import 'package:ratatouille/features/recipes/presentation/pages/search_user_page.dart';
import 'package:ratatouille/features/users/presentation/pages/complete_setup_page.dart';
import 'package:ratatouille/features/users/presentation/pages/email_verification_page.dart';
import 'package:ratatouille/features/users/presentation/pages/settings_page.dart';
import 'package:ratatouille/features/users/presentation/pages/sign_in_page.dart';
import 'package:ratatouille/features/users/presentation/pages/sign_up_page.dart';
import 'package:ratatouille/features/users/presentation/pages/splash_page.dart';
import 'package:ratatouille/features/users/presentation/provider/auth_provider.dart';
import 'package:ratatouille/features/users/presentation/pages/other_profile_page.dart';

import '../../features/kulkas/presentation/pages/result_fridge_filter_page.dart';
import '../../features/recipes/presentation/pages/recipe_detail_page.dart';
import '../../features/users/presentation/pages/clara_detail_page.dart';
import '../../features/users/presentation/pages/developer_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter(BuildContext context, AuthProvider authProvider) => GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: authProvider,
    redirect: (context, state) async {
      final isLoading = authProvider.isLoading;
      final user = authProvider.user;
      final location = state.matchedLocation;

      if (isLoading) { return null; }

      if (user == null) {
        if (location == AppRoutes.signIn || location == AppRoutes.signUp) {
          return null;
        }
        return AppRoutes.signIn;
      }

      if (!user.isEmailVerified) {
        if (location == AppRoutes.emailVerification) {
          return null;
        }
        return AppRoutes.emailVerification;
      }

      if (user.name.isEmpty) {
        if (location == AppRoutes.completeSetup) {
          return null;
        }
        return AppRoutes.completeSetup;
      }

      if (location == AppRoutes.signIn ||
          location == AppRoutes.signUp ||
          location == AppRoutes.emailVerification ||
          location == AppRoutes.completeSetup ||
          location == AppRoutes.splash) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      route(
          path: AppRoutes.splash,
          child: (context, _) => SplashPage()
      ),

      route(
          path: AppRoutes.signIn,
          child: (context, _) => SignInPage()
      ),

      route(
          path: AppRoutes.signUp,
          child: (context, _) => SignUpPage()
      ),

      route(
        path: AppRoutes.emailVerification,
        child: (context, _) => EmailVerificationPage()
      ),

      route(
        path: AppRoutes.completeSetup,
        child: (context, _) => CompleteSetupPage()
      ),

      ShellRoute(
        navigatorKey: GlobalKey<NavigatorState>(),
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          route(
            path: AppRoutes.home,
            child: (context, _) => HomePage(),
          ),
          route(
            path: AppRoutes.favorite,
            child: (context, _) => FavoritePage(),
          ),
          route(
            path: AppRoutes.myRecipe,
            child: (context, _) => MyRecipePage(),
          ),
          route(
            path: AppRoutes.profile,
            child: (context, _) => ProfilePage(),
          ),
        ]
      ),

      route(
        path: AppRoutes.searchRecipe,
        child: (context, _) => SearchRecipePage(),
      ),

      route(
        path: "${AppRoutes.recipeDetail}/:id",
        child: (context, state) {
          debugPrint(state.pathParameters['id']);
          final id = int.parse(state.pathParameters['id']!);
          return RecipeDetailPage(id: id);
        },
      ),

      route(
        path: "${AppRoutes.commentPage}/:id",
        child: (context, state) {
          debugPrint(state.pathParameters['id']);
          final id = int.parse(state.pathParameters['id']!);
          return CommentPage(id: id);
        }
      ),

      route(
        path: AppRoutes.searchUser,
        child: (context, _) => SearchUserPage(),
      ),
      route(
        path: AppRoutes.settings,
        child: (context, _) => SettingsPage()
      ),

      // Create Recipe
      route(
        path: AppRoutes.createRecipeBaseInfo,
        child: (context, _) => CreateRecipeBaseInfoPage()
      ),

      route(
        path: AppRoutes.createRecipeIngredients,
        child: (context, _) => CreateRecipeIngredientsPage()
      ),

      route(
        path: AppRoutes.createRecipeSteps,
        child: (context, _) => CreateRecipeStepsPage()
      ),

      route(
        path: AppRoutes.createRecipePreview,
        child: (context, _) => CreateRecipePreviewPage()
      ),

      route(
        path: AppRoutes.fridgeFilter,
        child: (context, _) => FridgeFilterPage()
      ),

      route(
        path: AppRoutes.resultFilter,
        child: (context, _) => ResultFridgeFilterPage(),
      ),

      // Profile
      route(
        path: AppRoutes.editProfile,
        child: (context, _) => EditProfilePage(),
      ),

      route(
          path: "${AppRoutes.otherProfile}/:id",
          child: (context, state) {
            debugPrint(state.pathParameters['id']);
            final id = state.pathParameters['id']!;
            return OtherProfilePage(userId: id);
          }
      ),

      route(
        path: AppRoutes.developerPage,
        child: (context, _) => DeveloperPage(),
      ),

      route(
        path: AppRoutes.bintangDetailPage,
        child: (context, _) => BintangDetailPage(),
      ),

      route(
        path: AppRoutes.andreDetailPage,
        child: (context, _) => AndreDetailPage(),
      ),

      route(
        path: AppRoutes.claraDetailPage,
        child: (context, _) => ClaraDetailPage(),
      )
    ],
  errorBuilder: (context, state) => NotFoundPage(location: state.matchedLocation)
);

class BintangDeveloperPage {
}

class DetailDeveloperPage {
}

GoRoute route({
  required String path,
  required Widget Function(BuildContext, GoRouterState) child,
}) => GoRoute(
  path: path,
  pageBuilder: (context, state) => CustomTransitionPage(
    key: state.pageKey,
    child: child(context, state),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  ),
);