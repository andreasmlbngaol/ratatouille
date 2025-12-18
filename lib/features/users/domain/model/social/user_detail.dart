import 'package:ratatouille/features/users/domain/model/auth/user.dart';

import '../../../../recipes/domain/model/recipe/recipe_detail.dart';

class UserDetail {
  final RatatouilleUser user;
  final List<RecipeDetail> recipes;
  final bool isMe;
  final bool? isFollowing;
  final bool? isFollower;
  final int followersCount;
  final int followingCount;

  const UserDetail({
    required this.user,
    required this.recipes,
    required this.isMe,
    required this.isFollowing,
    required this.isFollower,
    required this.followersCount,
    required this.followingCount,
  });
}