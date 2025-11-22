import 'package:flutter/foundation.dart';
import 'package:ratatouille/features/users/domain/service/auth_service.dart';

import '../../domain/network/token_provider.dart';

class FirebaseTokenProvider implements TokenProvider {
  final AuthService authService;

  FirebaseTokenProvider(this.authService);

  @override
  Future<String?> getIdToken() async {
    try {
      return await authService.getIdToken();
    } catch (e) {
      debugPrint('Error getting ID token: $e');
      return null;
    }
  }
}