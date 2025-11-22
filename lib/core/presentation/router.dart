import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ratatouille/core/presentation/app_routes.dart';
import 'package:ratatouille/core/presentation/pages/not_found_page.dart';
import 'package:ratatouille/features/users/presentation/pages/complete_setup_page.dart';
import 'package:ratatouille/features/users/presentation/pages/email_verification_page.dart';
import 'package:ratatouille/features/users/presentation/pages/sign_in_page.dart';
import 'package:ratatouille/features/users/presentation/pages/sign_up_page.dart';
import 'package:ratatouille/features/users/presentation/pages/splash_page.dart';
import 'package:ratatouille/features/users/presentation/provider/auth_provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter(BuildContext context, AuthProvider authProvider) => GoRouter(
  navigatorKey: navigatorKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: authProvider,
    redirect: (context, state) async {
      // final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isLoading = authProvider.isLoading;
      final user = authProvider.user;
      final location = state.matchedLocation;

      debugPrint('🔄 Redirecting to $location');

      // Jika masih loading, stay at current page
      if (isLoading) {
        debugPrint('⏳ Still loading, stay at $location');
        return null;
      }

      // Jika tidak authenticated
      if (user == null) {
        if (location == AppRoutes.signIn || location == AppRoutes.signUp) {
          return null; // Stay at sign_in/sign_up
        }
        debugPrint('🚫 Not authenticated, redirect ${AppRoutes.signIn}');
        return AppRoutes.signIn;
      }

      // User sudah login
      if (!user.isEmailVerified) {
        if (location == AppRoutes.emailVerification) {
          return null;
        }
        debugPrint('📧 Email not verified, redirect to ${AppRoutes.emailVerification}');
        return AppRoutes.emailVerification;
      }

      debugPrint("User name: ${user.name}");

      if (user.name.isEmpty) {
        if (location == AppRoutes.completeSetup) {
          return null;
        }
        debugPrint('👤 Name empty, redirect to ${AppRoutes.completeSetup}');
        return AppRoutes.completeSetup;
      }

      if (location == AppRoutes.signIn ||
          location == AppRoutes.signUp ||
          location == AppRoutes.emailVerification ||
          location == AppRoutes.completeSetup ||
          location == AppRoutes.splash) {
        debugPrint('✅ User setup complete, redirect to ${AppRoutes.home}');
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
      )
    ],
  errorBuilder: (context, state) => NotFoundPage(location: state.matchedLocation)
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