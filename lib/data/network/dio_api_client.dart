import 'package:dio/dio.dart';
import 'package:ratatouille/domain/network/api_client.dart';
import 'package:ratatouille/domain/network/api_exception.dart';
import 'package:ratatouille/domain/network/multipart_file_data.dart';
import 'package:ratatouille/domain/network/token_provider.dart';

class DioApiClient implements ApiClient {
  final Dio dio;
  final String baseUrl;
  final TokenProvider tokenProvider;

  DioApiClient({
    required this.dio,
    required this.baseUrl,
    required this.tokenProvider
  }) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    dio.interceptors.add(
        InterceptorsWrapper(
            onRequest: (options, handler) async {
              final token = await tokenProvider.getIdToken();
              if (token != null) {
                options.headers["Authorization"] = "Bearer $token";
              }
              options.headers["Content-Type"] = "application/json";
              return handler.next(options);
            },
            onError: (error, handler) {
              return handler.next(error);
            }
        )
    );
  }

  @override
  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await dio.delete("$baseUrl$endpoint");
      _checkResponse(response);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await dio.get(
          "$baseUrl$endpoint"
      );
      _checkResponse(response);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<Map<String, dynamic>> multipartWithFiles(String endpoint,
      {
        required Map<String, dynamic> fields,
        required List<MultipartFileData> files
      }) async {
    try {
      final formData = FormData();

      // Add fields
      fields.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });

      // Add files
      for (final file in files) {
        formData.files.add(
          MapEntry(
            file.fieldName,
            MultipartFile.fromBytes(
              file.bytes,
              filename: file.fileName,
              contentType: DioMediaType.parse(file.mimeType),
            ),
          ),
        );
      }

      final response = await dio.post(
        '$baseUrl$endpoint',
        data: formData,
      );

      _checkResponse(response);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // @override
  // Future<Map<String, dynamic>> multipart(String endpoint, {required Map<String, dynamic> fields, required List<MultipartFile> files}) async {
  // }

  @override
  Future<Map<String, dynamic>> patch(String endpoint, {required body}) async {
    try {
      final response = await dio.patch(
          "$baseUrl$endpoint",
          data: body
      );
      _checkResponse(response);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<Map<String, dynamic>> post(String endpoint, {required body}) async {
    try {
      final response = await dio.post(
          "$baseUrl$endpoint",
          data: body
      );
      _checkResponse(response);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<Map<String, dynamic>> put(String endpoint, {required body}) async {
    try {
      final response = await dio.put(
          "$baseUrl$endpoint",
          data: body
      );
      _checkResponse(response);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  void _checkResponse(Response response) {
    if (response.statusCode == null || response.statusCode! >= 400) {
      throw ApiException(
          message: response.data?["message"] ?? "Unknown Error",
          statusCode: response.statusCode
      );
    }
  }

  ApiException _handleDioException(DioException e) {
    return ApiException(
        message: e.message ?? "Network error",
        statusCode: e.response?.statusCode,
        originalException: e
    );
  }

}