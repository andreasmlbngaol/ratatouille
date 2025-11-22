import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ratatouille/core/di/service_locator.dart';
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
            create: (context) => AuthProvider(
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
          )
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