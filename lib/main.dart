import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ratatouille/firebase_options.dart';
import 'package:ratatouille/router.dart';
import 'package:ratatouille/theme.dart';

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

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Color(0xFFFFFDDE),
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              builder: FToastBuilder(),
              routerConfig: router,
              title: 'MVVM Demo',
              theme: lightMaterialTheme,
              // darkTheme: darkMaterialTheme,
            )
        )
    );
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}