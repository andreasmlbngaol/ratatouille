import 'package:ratatouille/domain/network/api_client.dart';
import 'package:ratatouille/domain/network/api_exception.dart';
import 'package:ratatouille/domain/network/multipart_file_data.dart';
import 'package:ratatouille/features/users/data/model/user_detail_model.dart';
import 'package:ratatouille/features/users/data/model/user_model.dart';
import 'package:ratatouille/features/users/domain/data_source/auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  
  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> getOrCreateUser() async {
    try {
      final response = await apiClient.get("/api/users/me");
      final data = response["data"] as Map<String, dynamic>;
      return UserModel.fromJson(data);
    } on ApiException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<UserModel> updateProfile({String? name, String? bio}) async {
    try {
      if (name == null && bio == null) {
        throw Exception('At least one field must be provided');
      }

      final response = await apiClient.patch(
        "/api/users/me",
        body: {
          "name": name,
          "bio": bio
        }
      );
      final data = response["data"] as Map<String, dynamic>;
      return UserModel.fromJson(data);
    } on ApiException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<UserModel> uploadProfilePicture(List<int> imageBytes, String fileName) async {
    try {
      final response = await apiClient.multipartWithFiles(
          "/api/users/me/profile-picture",
          fields: {},
          files: [
            MultipartFileData(
              fieldName: "image",
              bytes: imageBytes,
              fileName: fileName,
              mimeType: "image/jpeg"
            )
          ]
      );
      final data = response["data"] as Map<String, dynamic>;
      return UserModel.fromJson(data);
    } on ApiException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<UserModel> uploadCoverPicture(List<int> imageBytes, String fileName) async {
    try {
      final response = await apiClient.multipartWithFiles(
          "/api/users/me/cover-picture",
          fields: {},
          files: [
            MultipartFileData(
                fieldName: "image",
                bytes: imageBytes,
                fileName: fileName,
                mimeType: "image/jpeg"
            )
          ]
      );
      final data = response["data"] as Map<String, dynamic>;
      return UserModel.fromJson(data);
    } on ApiException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<UserDetailModel> getUserDetail(String userId) async {
    try {
      final response = await apiClient.get("/api/users/$userId");
      final data = response["data"] as Map<String, dynamic>;
      return UserDetailModel.fromJson(data);
    } on ApiException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<UserDetailModel> followUser(String userId) async {
    try {
      final response = await apiClient.post(
        "/api/users/$userId",
        body: {},
      );
      final data = response["data"] as Map<String, dynamic>;
      return UserDetailModel.fromJson(data);
    } on ApiException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<UserDetailModel> unfollowUser(String userId) async {
    try {
      final response = await apiClient.delete("/api/users/$userId");
      final data = response["data"] as Map<String, dynamic>;
      return UserDetailModel.fromJson(data);
    } on ApiException catch (e) {
      throw Exception(e.message);
    }
  }
  
  
}