import 'package:flutter/cupertino.dart';
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
  Future<RecipeDetailModel>getRecipeDetail(int recipeId) async {
    try {
      debugPrint("recipe remote data source impl get recipe detail");
      final response = await apiClient.get("/api/recipes/$recipeId");
      debugPrint("recipe remote data source impl get recipe detail: $response");
      return RecipeDetailModel.fromJson(response);
    } on ApiException catch (e) {
      debugPrint("recipe remote data source impl get recipe detail api exception");
      throw Exception(e.message);
    } catch (e) {
      debugPrint("recipe remote data source impl get recipe detail exception: $e");
      throw Exception("Something went wrong");
    }
  }

  @override
  Future<RecipeWithImagesModel> getOrCreateDraftRecipe() async {
    try {
      debugPrint("recipe remote data source impl get or create draft recipe");
      final response = await apiClient.get("/api/recipes/drafts");
      return RecipeWithImagesModel.fromJson(response);
    } on ApiException catch (e) {
      debugPrint("recipe remote data source impl get or create draft recipe api exception");
      throw Exception(e.message);
    } catch (e) {
      debugPrint("recipe remote data source impl get or create draft recipe exception");
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
          }
      );
      return RecipeWithImagesModel.fromJson(response);
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }

  @override
  Future<RecipeWithImagesModel> updateRecipeStatus({
    required int recipeId,
    required RecipeStatus status
  }) async {
    try {
      final response = await apiClient.patch(
          "/api/recipes/$recipeId/status",
          body: {
            "status": status.name
          }
      );
      return RecipeWithImagesModel.fromJson(response);
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
      debugPrint("Uploading recipe image...");
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
      return RecipeWithImagesModel.fromJson(response);
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
        "/api/recipes/ingredient-tags",
        body: {
          "name": name
        }
      );
      return IngredientTagModel.fromJson(response);
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }

  @override
  Future<List<IngredientTagModel>> searchIngredientTags(String query) async {
    try {
      final response = await apiClient.getList("/api/recipes/ingredient-tags?query=$query");
      return response.map((e) => IngredientTagModel.fromJson(e)).toList();
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }

  @override
  Future<List<IngredientWithTagModel>> getIngredients(int recipeId) async {
    try {
      debugPrint("Getting ingredients...");
      final response = await apiClient.getList(
          "/api/recipes/$recipeId/ingredients");
      debugPrint("Ingredients: $response");
      return response.map((e) => IngredientWithTagModel.fromJson(e)).toList();
    } on ApiException catch (e) {
      debugPrint("Error getting ingredients: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      debugPrint("Error getting ingredients: $e");
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
       final response = await apiClient.postList(
         "/api/recipes/$recipeId/ingredients",
           body: {
             "tagId": tagId,
             "amount": amount,
             "unit": unit,
             "alternative": alternative
           }
       );
       return response.map((e) => IngredientWithTagModel.fromJson(e)).toList();
     } on ApiException catch (e) {
       throw Exception(e.message);
     } catch (e) {
       throw Exception("Something went wrong");
     }
  }

  @override
  Future<List<StepWithImagesModel>> getSteps(int recipeId) async {
    try {
      final response = await apiClient.getList(
          "/api/recipes/$recipeId/steps");
      return response.map((e) => StepWithImagesModel.fromJson(e)).toList();
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }

  @override
  Future<List<StepWithImagesModel>> createEmptyStep(int recipeId, int stepNumber) async {
    try {
      final response = await apiClient.postList(
        "/api/recipes/$recipeId/steps",
        body: {
          "stepNumber": stepNumber
        }
      );
      return response.map((e) => StepWithImagesModel.fromJson(e)).toList();
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }

  @override
  Future<List<StepWithImagesModel>> updateStep(int recipeId, int stepId, String content) async {
    try {
      final response = await apiClient.patchList(
          "/api/recipes/$recipeId/steps/$stepId",
          body: {
            "content": content
          }
      );
      return response.map((e) => StepWithImagesModel.fromJson(e)).toList();
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
      final response = await apiClient.multipartWithFilesList(
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
      return response.map((e) => StepWithImagesModel.fromJson(e)).toList();
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }

  @override
  Future<List<RecipeDetailModel>> search({
    required String query,
    double? minRating,
    int? minEstTime,
    int? maxEstTime,
  }) async {
    try {
      debugPrint("Search recipes: $query");
      final queryParams = <String, String>{
        'query': query, // nanti di-encode otomatis
      };

      if (minRating != null) {
        queryParams['minRating'] = minRating.toString();
      }
      if (minEstTime != null) {
        queryParams['minEstTime'] = minEstTime.toString();
      }
      if (maxEstTime != null) {
        queryParams['maxEstTime'] = maxEstTime.toString();
      }

      final uri = Uri(
        path: '/recipes',
        queryParameters: queryParams,
      );

      debugPrint("Search recipes: $uri");

      final response = await apiClient.getList(
        "/api${uri.toString()}",
      );

      debugPrint("Search recipes: $response");

      return response
          .take(5)
          .map((e) => RecipeDetailModel.fromJson(e))
          .toList();
    } on ApiException catch (e) {
      debugPrint("Search recipes: ${e.message}");
      throw Exception(e.message);
    } catch (_) {
      debugPrint("Search recipes: Something went wrong");
      throw Exception("Something went wrong");
    }
  }
}