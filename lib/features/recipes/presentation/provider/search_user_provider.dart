import 'package:flutter/cupertino.dart';
import 'package:ratatouille/features/users/domain/model/auth/user.dart';

import '../../../users/domain/use_case/user_use_case.dart';

class SearchUserProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  String query = '';

  List<RatatouilleUser> results = [];

  final UserUseCase userUseCase;

  SearchUserProvider({required this.userUseCase});

  Future<void> search({
    required String query,
  }) async {
    if (query.trim().length < 3) {
      errorMessage = 'Query must be at least 3 characters';
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;

    this.query = query;
    notifyListeners();

    final result = await userUseCase.search(
      query: query,
    );

    result.fold(
      (failure) {
        errorMessage = failure.message;
        results = [];
        isLoading = false;
      },
        (users) {
        results = users;
        isLoading = false;
      },
    );
    notifyListeners();
  }

  void clear() {
    query = '';
    results = [];
    errorMessage = null;
    notifyListeners();
  }
}