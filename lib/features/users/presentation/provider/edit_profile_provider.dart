import 'package:flutter/cupertino.dart';
import 'package:ratatouille/features/users/domain/data_source/auth_local_data_source.dart';
import 'package:ratatouille/features/users/domain/model/auth/user.dart';
import 'package:ratatouille/features/users/domain/use_case/auth/authenticate_use_case.dart';
import 'package:ratatouille/features/users/domain/use_case/profile/complete_profile_setup_use_case.dart';

class EditProfileProvider extends ChangeNotifier {
  final CompleteProfileSetupUseCase profileUseCase;
  final AuthenticateUseCase authenticateUseCase;
  
  bool isLoading = false;
  String? errorMessage;

  RatatouilleUser? user;

  EditProfileProvider({
    required this.profileUseCase,
    required this.authenticateUseCase,
  });
  
  Future<void> getCachedUser() async {
    isLoading = true;
    errorMessage = null;

    final result = await authenticateUseCase();
    result.fold(
        (failure) {
          errorMessage = failure.message;
          isLoading = false;
        },
        (data) {
          user = data;
          isLoading = false;
        }
    );
  }

  Future<void> updateProfile({
    required String name,
    required String? bio
  }) async {
    isLoading = true;
    errorMessage = null;

    final result = await profileUseCase.updateProfile(name: name, bio: bio);

    result.fold(
        (failure) {
          errorMessage = failure.message;
          isLoading = false;
        },
        (data) {
          user = data;
          isLoading = false;
        }
    );
  }

  Future<void> uploadProfilePicture(
      List<int> imageBytes,
      String fileName,
      ) async {
    try {
      final result = await profileUseCase.uploadProfilePicture(
        imageBytes,
        fileName,
      );

      result.fold(
            (failure) {
          errorMessage = failure.message;
        },
            (usr) {
          user = usr;
          errorMessage = null;
        },
      );

      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> uploadCoverPicture(
      List<int> imageBytes,
      String fileName
  ) async {
    try {
      final result = await profileUseCase.uploadCoverPicture(
        imageBytes,
        fileName,
      );

      result.fold(
            (failure) {
          errorMessage = failure.message;
              notifyListeners();
        },
            (usr) {
          user = usr;
          debugPrint("User: $usr");
          errorMessage = null;
          notifyListeners();
        },
      );

      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}