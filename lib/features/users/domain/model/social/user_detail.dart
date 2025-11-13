import 'package:ratatouille/features/users/domain/model/auth/user.dart';

class UserDetail {
  final User user;
  final bool isMe;
  final bool isFollowing;
  final int followerCount;
  final int followingCount;

  const UserDetail({
    required this.user,
    required this.isMe,
    required this.isFollowing,
    required this.followerCount,
    required this.followingCount,
  });
}