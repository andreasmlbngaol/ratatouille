import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ratatouille/features/auth/presentation/pages/sign_in_screen.dart';
import 'package:ratatouille/features/auth/presentation/pages/splash_screen.dart';

final router = GoRouter(
    initialLocation: "/sign_in",

    routes: [

      route(
          path: "/splash",
          child: (navController, _) => SplashScreen(
              onNavigateToHome: () => navController.go("/home"),
              onNavigateToVerification: () => navController.go("/email_verification"), // Ini nanti diganti sama route untuk email verification
              onNavigateToSignIn: () => navController.go("/sign_in")
          )
      ),

      route(
          path: "/sign_in",
          child: (navController, _) => SignInScreen(
              onNavigateToHome: () => navController.go("/home"),
              onNavigateToVerification: () => navController.go("/email_verification"), // Ini nanti diganti sama route untuk email verification
              onNavigateToSignUp: () => navController.go("/sign_up")
          )
      ),
      //
      // route(
      //     path: "/sign_up",
      //     child: (navController, _) => SignUpScreen(
      //         onNavigateToHome: () => navController.go("/home"),
      //         onNavigateToVerification: () => navController.go("/email_verification"), // Ini nanti diganti sama route untuk email verification
      //         onNavigateToSignIn: () => navController.go("/sign_in")
      //     )
      // ),

      // route(
      //     path: "/email_verification",
      //     child: (navController, _) => EmailVerificationScreen(
      //         onNavigateToHome: () => navController.go("/home"),
      //         onNavigateToSignIn: () => navController.go("/sign_in")
      //     )
      // ),
      //
      // route(
      //     path: "/home",
      //     child: (navController, _) => ContainerScreen(
      //       onNavigateToSignIn: () => navController.go("/sign_in"),
      //       onNavigateToAddRecipe: () => navController.push("/recipe_base"),
      //     )
      // ),
      //
      // route(
      //     path: "/recipe_base",
      //     child: (navController, _) => AddRecipeBaseScreen(
      //       onNext: (recipeId) => navController.push("/recipe_ingredients/$recipeId"),
      //     )
      // ),
      //
      // route(
      //     path: "/recipe_ingredients/:recipeId",
      //     child: (navController, state) {
      //       final recipeId = int.parse(state.pathParameters["recipeId"]!);
      //       debugPrint("Recipe Id in router: $recipeId");
      //       return AddRecipeIngredientScreen(recipeId: recipeId);
      //     }
      // )
    ]
);

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