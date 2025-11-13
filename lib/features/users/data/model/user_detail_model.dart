import 'package:json_annotation/json_annotation.dart';
import 'package:ratatouille/features/users/data/model/user_model.dart';
import 'package:ratatouille/features/users/domain/model/social/user_detail.dart';

part 'user_detail_model.g.dart';

@JsonSerializable()
class UserDetailModel {
  final UserModel user;
  final bool isMe;
  final bool isFollowing;
  final int followerCount;
  final int followingCount;

  const UserDetailModel({
    required this.user,
    required this.isMe,
    required this.isFollowing,
    required this.followerCount,
    required this.followingCount,
  });

  factory UserDetailModel.fromJson(Map<String, dynamic> json) =>
      _$UserDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailModelToJson(this);

  /// Convert to domain entity
  UserDetail toDomain() {
    return UserDetail(
      user: user.toDomain(),
      isMe: isMe,
      isFollowing: isFollowing,
      followerCount: followerCount,
      followingCount: followingCount,
    );
  }

  /// Convert from domain entity
  factory UserDetailModel.fromDomain(UserDetail userDetail) {
    return UserDetailModel(
      user: UserModel.fromDomain(userDetail.user),
      isMe: userDetail.isMe,
      isFollowing: userDetail.isFollowing,
      followerCount: userDetail.followerCount,
      followingCount: userDetail.followingCount,
    );
  }
}
