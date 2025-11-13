import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ratatouille/features/users/domain/service/auth_service.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  FirebaseAuthService({
    required this.firebaseAuth,
    required this.googleSignIn,
  });

  @override
  Future<String> signInWithEmailAndPassword({required String email, required String password}) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      final idToken = await userCredential.user?.getIdToken();
      if (idToken == null) {
        throw Exception("Failed to get ID token");
      }

      return idToken;

    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  @override
  Future<String> signUpWithEmailAndPassword({required String email, required String password}) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      final idToken = await userCredential.user?.getIdToken();
      if (idToken == null) {
        throw Exception("Failed to get ID token");
      }

      return idToken;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  @override
  Future<String> signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception("Google sign-in canceled");
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
      );

      final userCredential = await firebaseAuth.signInWithCredential(credential);
      final idToken = await userCredential.user?.getIdToken();
      if (idToken == null) {
        throw Exception("Failed to get ID token");
      }

      return idToken;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  @override
  Future<String> getIdToken() async {
    try {
      final user = firebaseAuth.currentUser;
      if(user == null) {
        throw Exception("No user signed in");
      }

      final idToken = await user.getIdToken();
      return idToken!;
    } catch (e) {
      throw Exception("Failed to get ID token: $e");
    }
  }

  @override
  Future<bool> isEmailVerified() async {
    try {
      final user = firebaseAuth.currentUser;
      if(user == null) {
        throw Exception("No user signed in");
      }

      await user.reload();
      return user.emailVerified;
    } catch (e) {
      throw Exception("Failed to check email verification status: $e");
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      final user = firebaseAuth.currentUser;
      if(user == null) {
        throw Exception("No user signed in");
      }

      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
      await googleSignIn.signOut();
    } catch (e) {
      throw Exception("Failed to sign out: $e");
    }
  }

  Exception _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case "user-not-found":
        return Exception("No user found for that email.");
      case "wrong-password":
        return Exception("Incorrect password");
      case "email-already-in-use":
        return Exception("Email already in use");
      case "weak-password":
        return Exception("Password is too weak");
      case "invalid-email":
        return Exception("Invalid email address");
      case "user-disabled":
        return Exception("User account has been disabled");
      case "too-many-requests":
        return Exception("Too many requests. Try again later");
      default:
        return Exception("Authentication failed: ${e.message}");
    }
  }
}