import 'package:get_it/get_it.dart';
import 'package:ratatouille/features/recipes/di/recipes_module.dart';
import 'package:ratatouille/features/users/di/users_module.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  setupUsersModule();
  setupRecipesModule();
}