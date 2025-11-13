
import 'package:ratatouille/features/users/data/model/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getUser();
  Future<void> saveUser(UserModel user);
  Future<void> clearUser();
}