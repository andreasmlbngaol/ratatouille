import 'package:flutter/foundation.dart';
import 'package:ratatouille/features/users/domain/repository/users_repository.dart';
import '../../domain/model/social/user_detail.dart';

class ProfileProvider extends ChangeNotifier {
  final UsersRepository usersRepository;

  bool isLoading = false;
  String? errorMessage;
  UserDetail? detail;

  ProfileProvider({required this.usersRepository});

  Future<void> fetchUserDetail() async {
    isLoading = true;
    errorMessage = null;
    detail = null;
    notifyListeners();

    final result = await usersRepository.getMyUserDetail();

    result.fold(
      (failure) {
        errorMessage = failure.message;
        isLoading = false;
        notifyListeners();
      },
      (data) {
        detail = data;
        isLoading = false;
        notifyListeners();
      },
    );
  }
}