import 'package:flutter/foundation.dart';
import 'package:ratatouille/domain/network/token_provider.dart';
import 'package:ratatouille/features/users/domain/service/auth_service.dart';

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