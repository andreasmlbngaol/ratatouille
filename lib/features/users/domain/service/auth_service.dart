abstract class AuthService {
  Future<String> signInWithEmailAndPassword({
    required String email,
    required String password
  });

  Future<String> signUpWithEmailAndPassword({
    required String email,
    required String password
  });

  Future<String> signInWithGoogle();
  Future<String> getIdToken();
  Future<bool> isEmailVerified();
  Future<void> sendEmailVerification();
  // Future<void> sendPasswordResetEmail({
  //   required String email
  // });
  //
  Future<void> signOut();
}