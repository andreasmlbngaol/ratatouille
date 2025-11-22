import 'package:flutter/cupertino.dart';
import 'package:ratatouille/features/users/domain/model/auth/user.dart';
import 'package:ratatouille/features/users/domain/use_case/auth/authenticate_use_case.dart';
import 'package:ratatouille/features/users/domain/use_case/auth/check_auth_status_use_case.dart';
import 'package:ratatouille/features/users/domain/use_case/auth/sign_out_use_case.dart';
import 'package:ratatouille/features/users/domain/use_case/auth/sign_in_with_email_use_case.dart';
import 'package:ratatouille/features/users/domain/use_case/auth/sign_in_with_google_use_case.dart';
import 'package:ratatouille/features/users/domain/use_case/auth/sign_up_with_email_use_case.dart';
import 'package:ratatouille/features/users/domain/use_case/auth/verify_email_use_case.dart';
import 'package:ratatouille/features/users/domain/use_case/profile/complete_profile_setup_use_case.dart';
import 'package:ratatouille/features/users/domain/use_case/profile/update_user_profile_use_case.dart';

class AuthProvider extends ChangeNotifier {
  final AuthenticateUseCase _authenticateUseCase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final SignOutUseCase _logoutUseCase;
  final SignInWithEmailUseCase _signInWithEmailUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final SignUpWithEmailUseCase _signUpWithEmailUseCase;
  final VerifyEmailUseCase _verifyEmailUseCase;
  final CompleteProfileSetupUseCase _completeProfileSetupUseCase;
  // final UpdateUserProfileUseCase _updateUserProfileUseCase;

  AuthProvider({
    required AuthenticateUseCase authenticateUseCase,
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
    required SignOutUseCase signOutUseCase,
    required SignInWithEmailUseCase signInWithEmailUseCase,
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
    required SignUpWithEmailUseCase signUpWithEmailUseCase,
    required VerifyEmailUseCase verifyEmailUseCase,
    required CompleteProfileSetupUseCase completeProfileSetupUseCase,
    required UpdateUserProfileUseCase updateUserProfileUseCase
  }) : _authenticateUseCase = authenticateUseCase,
        _checkAuthStatusUseCase = checkAuthStatusUseCase,
  _logoutUseCase = signOutUseCase,
  _signInWithEmailUseCase = signInWithEmailUseCase,
  _signInWithGoogleUseCase = signInWithGoogleUseCase,
  _signUpWithEmailUseCase = signUpWithEmailUseCase,
  _verifyEmailUseCase = verifyEmailUseCase,
  _completeProfileSetupUseCase = completeProfileSetupUseCase
  // _updateUserProfileUseCase = updateUserProfileUseCase
  {
    checkAuthStatus();
  }

  RatatouilleUser? _user;
  String? _error;
  bool _isLoading = false;

  RatatouilleUser? get user => _user;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  Future<void> checkAuthStatus() async {
    debugPrint('🔍 checkAuthStatus started');
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _checkAuthStatusUseCase();
      result.fold(
            (failure) {
          debugPrint('❌ Auth check failed: ${failure.message}');
          // Ini NORMAL untuk first-time user (tidak ada cached user)
          _user = null;
          _error = failure.message;
        },
            (user) {
          debugPrint('✅ Auth check success: ${user.email}');
          _user = user;
          _error = null;
        },
      );
    } catch (e) {
      debugPrint('⚠️ Exception during checkAuthStatus: $e');
      _user = null;
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
      debugPrint('🔄 checkAuthStatus finished - isLoading: false');
    }
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final signInResult = await _signInWithEmailUseCase(
          email: email,
          password: password
      );

      bool success = false;
      await signInResult.fold(
          (failure) {
            _error = failure.message;
          },
          (idToken) async {
            final authResult = await _authenticateUseCase();
            await authResult.fold(
                (failure) {
                  _error = failure.message;
                },
                (user) {
                  _user = user;
                  _error = null;
                  success = true;
                }
            );
          }
      );

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      final signInResult = await _signInWithGoogleUseCase();

      bool success = false;

      await signInResult.fold(
            (failure) async {
          debugPrint('❌ Google sign in failed: ${failure.message}');
          debugPrint(failure.message);
          _error = failure.message;
          success = false;
        },
            (idToken) async {
          debugPrint('✅ Google sign in success, idToken: $idToken');

          // Step 2: Authenticate dengan backend
          final authResult = await _authenticateUseCase();

          authResult.fold(
                (failure) {
              debugPrint('❌ Backend authenticate failed: ${failure.message}');
              _error = failure.message;
              success = false;
            },
                (user) {
              debugPrint('✅ Backend authenticate success: ${user.email}');
              _user = user;
              _error = null;
              success = true;
            },
          );
        },
      );

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUpWithEmailAndPassword(String email, String password, String confirmPassword) async {
    _isLoading = true;
    notifyListeners();

    try {
      final signUpResult = await _signUpWithEmailUseCase(
          email: email,
          password: password,
          confirmPassword: confirmPassword
      );

      bool success = false;
      await signUpResult.fold(
              (failure) async {
            debugPrint('❌ Sign up failed: ${failure.message}');
            _error = failure.message;
          },
              (idToken) async {
            debugPrint('✅ Firebase sign up success, idToken: $idToken');
            final authResult = await _authenticateUseCase();
            await authResult.fold(
                    (failure) {
                  _error = failure.message;
                },
                    (user) async {
                      debugPrint('✅ Backend authenticate success: ${user.email}');
                      _user = user;
                  _error = null;

                      debugPrint('📧 Sending email verification to ${user.email}');
                      final sendEmailResult = await _verifyEmailUseCase.sendEmailVerification();

                      sendEmailResult.fold(
                          (failure) {
                            debugPrint('❌ Email verification send failed: ${failure.message}');
                          },
                          (_) {
                            debugPrint('✅ Email verification send success');
                          }
                      );

                      success = true;
                }
            );
          }
      );

      debugPrint('📝 signUpWithEmail result: success=$success');
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      debugPrint('⚠️ Exception during signUpWithEmail: $e');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateName(String name) async {
    _isLoading = true;
    notifyListeners();

    final result = await _completeProfileSetupUseCase.updateName(name);

    bool success = false;
    await result.fold(
        (failure) {
          _error = failure.message;
        },
        (user) {
          _user = user;
          _error = null;
          success = true;
        }
    );

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<bool> uploadProfilePicture(
      List<int> imageBytes,
      String fileName,
      ) async {
    debugPrint('📸 uploadProfilePicture');

    try {
      final result = await _completeProfileSetupUseCase.uploadProfilePicture(
        imageBytes,
        fileName,
      );

      bool success = false;
      result.fold(
            (failure) {
          debugPrint('❌ Upload failed: ${failure.message}');
          _error = failure.message;
        },
            (user) {
          debugPrint('✅ Upload success: ${user.profilePictureUrl}');
          _user = user;
          _error = null;
          success = true;
        },
      );

      notifyListeners();
      return success;
    } catch (e) {
      debugPrint('⚠️ Exception: $e');
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    await _logoutUseCase();
    _user = null;
    _error = null;

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> checkAndSyncEmailVerification() async {
    debugPrint('🔍 checkAndSyncEmailVerification');
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _verifyEmailUseCase.checkAndSyncEmailVerification();

      bool success = false;
      result.fold(
            (failure) {
          _error = failure.message;
          success = false;
        },
            (user) {
          _user = user;
          _error = null;
          success = true;
        },
      );

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      debugPrint('⚠️ Exception during checkAndSyncEmailVerification: $e');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> resendEmailVerification() async {
    debugPrint('📧 resendEmailVerification');

    try {
      final result = await _verifyEmailUseCase.sendEmailVerification();

      bool success = false;
      result.fold(
            (failure) {
          debugPrint('❌ Resend failed: ${failure.message}');
          _error = failure.message;
        },
            (_) {
          debugPrint('✅ Verification email resent');
          _error = null;
          success = true;
        },
      );

      notifyListeners();
      return success;
    } catch (e) {
      debugPrint('⚠️ Exception during resendEmailVerification: $e');
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}