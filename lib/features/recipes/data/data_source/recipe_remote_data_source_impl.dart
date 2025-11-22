import 'package:ratatouille/core/domain/network/api_client.dart';
import 'package:ratatouille/core/domain/network/api_exception.dart';
import 'package:ratatouille/core/domain/network/multipart_file_data.dart';
import 'package:ratatouille/features/recipes/data/model/ingredient/ingredient_tag_model.dart';
import 'package:ratatouille/features/recipes/data/model/ingredient/ingredient_with_tag_model.dart';
import 'package:ratatouille/features/recipes/data/model/recipe/recipe_detail_model.dart';
import 'package:ratatouille/features/recipes/data/model/recipe/recipe_with_images_model.dart';
import 'package:ratatouille/features/recipes/data/model/step/step_with_images_model.dart';
import 'package:ratatouille/features/recipes/domain/data_source/recipe_remote_data_source.dart';
import 'package:ratatouille/features/recipes/domain/model/recipe/recipe_status.dart';

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final ApiClient apiClient;

  RecipeRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<RecipeDetailModel> getRecipeDetail(int recipeId) async {
    try {
      final response = await apiClient.get("/api/recipes/$recipeId");
      final data = response["data"] as Map<String, dynamic>;
      return RecipeDetailModel.fromJson(data);
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }

  @override
  Future<RecipeWithImagesModel> getOrCreateDraftRecipe() async {
    try {
      final response = await apiClient.get("/api/recipes/drafts");
      final data = response["data"] as Map<String, dynamic>;
      return RecipeWithImagesModel.fromJson(data);
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }

  @override
  Future<RecipeWithImagesModel> updateRecipe({
    required int recipeId,
    String? name,
    String? description,
    bool? isPublic,
    int? estTimeInMinutes,
    int? portion,
    RecipeStatus? status
  }) async {
    try {
      final response = await apiClient.patch(
          "/api/recipes/$recipeId",
          body: {
            "name": name,
            "description": description,
            "isPublic": isPublic,
            "estTimeInMinutes": estTimeInMinutes,
            "portion": portion,
            "status": status
          }
      );
      final data = response["data"] as Map<String, dynamic>;
      return RecipeWithImagesModel.fromJson(data);
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }

  @override
  Future<RecipeWithImagesModel> uploadRecipeImage({
    required int recipeId,
    required List<int> imageBytes,
    required String fileName
  }) async {
    try {
      final response = await apiClient.multipartWithFiles(
          "/api/recipes/$recipeId/pictures",
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
      return RecipeWithImagesModel.fromJson(data);
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }

  @override
  Future<IngredientTagModel> createIngredientTag(String name) async {
    try {
      final response = await apiClient.post(
        "/api/ingredient-tags",
        body: {
          "name": name
        }
      );
      final data = response["data"] as Map<String, dynamic>;
      return IngredientTagModel.fromJson(data);
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }

  @override
  Future<List<IngredientTagModel>> searchIngredientTags(String query) async {
    try {
      final response = await apiClient.get("/api/ingredient-tags?query=$query");
      final data = response["data"] as List<dynamic>;
      return data.map((e) => IngredientTagModel.fromJson(e)).toList();
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }

  @override
  Future<List<IngredientWithTagModel>> addIngredient({
    required int recipeId,
    required int tagId,
    double? amount,
    String? unit,
    String? alternative
  }) async {
     try {
       final response = await apiClient.post(
         "/api/recipes/$recipeId/ingredients",
           body: {
             "tagId": tagId,
             "amount": amount,
             "unit": unit,
             "alternative": alternative
           }
       );
       final data = response["data"] as List<dynamic>;
       return data.map((e) => IngredientWithTagModel.fromJson(e)).toList();
     } on ApiException catch (e) {
       throw Exception(e.message);
     } catch (e) {
       throw Exception("Something went wrong");
     }
  }

  @override
  Future<List<StepWithImagesModel>> createEmptyStep(int recipeId, int stepNumber) async {
    try {
      final response = await apiClient.post(
        "/api/recipes/$recipeId/steps",
        body: {
          "stepNumber": stepNumber
        }
      );
      final data = response["data"] as List<dynamic>;
      return data.map((e) => StepWithImagesModel.fromJson(e)).toList();
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }

  @override
  Future<List<StepWithImagesModel>> updateStep(int recipeId, int stepId, String content) async {
    try {
      final response = await apiClient.patch(
          "/api/recipes/$recipeId/steps/$stepId",
          body: {
            "content": content
          }
      );
      final data = response["data"] as List<dynamic>;
      return data.map((e) => StepWithImagesModel.fromJson(e)).toList();
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }

  @override
  Future<List<StepWithImagesModel>> uploadStepImage({
    required int recipeId,
    required int stepId,
    required List<int> imageBytes,
    required String fileName
  }) async {
    try {
      final response = await apiClient.multipartWithFiles(
          "/api/recipes/$recipeId/steps/$stepId/pictures",
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
      final data = response["data"] as List<dynamic>;
      return data.map((e) => StepWithImagesModel.fromJson(e)).toList();
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }
}