import 'package:flutter/cupertino.dart';

class SplashScreen extends StatelessWidget {
  final VoidCallback onNavigateToHome;
  final VoidCallback onNavigateToVerification;
  final VoidCallback onNavigateToSignIn;

  const SplashScreen({
    super.key,
    required this.onNavigateToHome,
    required this.onNavigateToVerification,
    required this.onNavigateToSignIn,
  });

  @override
  Widget build(BuildContext context) {
    // final viewModel = ref.read(splashProvider.notifier);

    /// Ini dijalankan pas UI nya siap di render. Jadi render selesai, baru cek apakah user sudah login atau belum
    // launchedEffect(() {
    //   viewModel.checkAuthUser(
    //       onAuthenticated: onNavigateToHome,
    //       onNoInternetConnection: () {
    //         Fluttertoast.showToast(
    //           msg: "No Internet Connection",
    //           toastLength: Toast.LENGTH_LONG,
    //           gravity: ToastGravity.BOTTOM,
    //         );
    //       },
    //       onNavigateToVerification: onNavigateToVerification,
    //       onUnauthenticated: onNavigateToSignIn,
    //       onServerError: () {
    //         Fluttertoast.showToast(
    //           msg: "Server Error",
    //           toastLength: Toast.LENGTH_LONG,
    //           gravity: ToastGravity.BOTTOM,
    //         );
    //       }
    //   );
    // });

    /// Ini UI nya :v
    return Center(
        child: Image.asset(
          "assets/images/logo_real.png",
          width: 220,
          height: 220,
          fit: BoxFit.cover,
        )
    );
  }
}