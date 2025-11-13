import 'package:ratatouille/features/users/data/model/user_detail_model.dart';
import 'package:ratatouille/features/users/data/model/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> getOrCreateUser();

  Future<UserModel> updateProfile({
    String? name,
    String? bio
  });

  Future<UserModel> uploadProfilePicture(List<int> imageBytes,
      String fileName);

  Future<UserModel> uploadCoverPicture(List<int> imageBytes,
      String fileName);

  Future<UserDetailModel> getUserDetail(String userId);
  Future<UserDetailModel> followUser(String userId);
  Future<UserDetailModel> unfollowUser(String userId);
}