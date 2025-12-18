import 'package:flutter/foundation.dart';
import 'package:ratatouille/features/users/domain/repository/users_repository.dart';
import '../../domain/model/social/user_detail.dart';
import '../../domain/use_case/user_use_case.dart';

class ProfileProvider extends ChangeNotifier {
  final UsersRepository usersRepository;
  final UserUseCase userUseCase;

  bool isLoading = false;
  String? errorMessage;
  UserDetail? detail;

  ProfileProvider({
    required this.usersRepository,
    required this.userUseCase,
  });

  Future<void> fetchMyUserDetail() async {
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

  Future<void> fetchOtherUserDetail(String userId) async {
    isLoading = true;
    errorMessage = null;
    detail = null;
    notifyListeners();

    final result = await usersRepository.getUserDetail(userId);

    result.fold(
      (failure) {
        errorMessage = failure.message;
        isLoading = false;
      },
      (data) {
        detail = data;
        isLoading = false;
      },
    );

    notifyListeners();
  }

  Future<void> follow(String userId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await usersRepository.followUser(userId);

    result.fold(
        (failure) {
          errorMessage = failure.message;
          isLoading = false;
          notifyListeners();
        },
        (data) async {
          if(data) {
            final newDetail = await userUseCase.getUserDetail(userId);
            newDetail.fold(
                    (failure) {
                  errorMessage = failure.message;
                  isLoading = false;
                  notifyListeners();
                },
                    (data) {
                  detail = data;
                  isLoading = false;
                  notifyListeners();
                }
            );
          }
        }
    );
  }

  Future<void> unfollow(String userId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await usersRepository.unfollowUser(userId);

    result.fold(
        (failure) {
          errorMessage = failure.message;
          isLoading = false;
          notifyListeners();
        },
        (data) async {
          if (data) {
            final newDetail = await userUseCase.getUserDetail(userId);
            newDetail.fold(
                    (failure) {
                  errorMessage = failure.message;
                  isLoading = false;
                  notifyListeners();
                },
                    (data) {
                  detail = data;
                  isLoading = false;
                  notifyListeners();
                }
            );
          }
        }
    );
  }
}