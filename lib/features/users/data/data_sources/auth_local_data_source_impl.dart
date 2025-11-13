import 'package:hive/hive.dart';
import 'package:ratatouille/features/users/data/model/user_model.dart';
import 'package:ratatouille/features/users/domain/data_source/auth_local_data_source.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String boxName = "auth_box";

  @override
  Future<void> clearUser() async {
    final box = await Hive.openBox<UserModel>(boxName);
    await box.delete("users");
  }

  @override
  Future<UserModel?> getUser() async {
    final box = await Hive.openBox<UserModel>(boxName);
    return box.get("users");
  }

  @override
  Future<void> saveUser(UserModel user) async {
    final box = await Hive.openBox<UserModel>(boxName);
    box.put("users", user);
  }
  
}