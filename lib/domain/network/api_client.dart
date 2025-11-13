import 'package:ratatouille/domain/network/multipart_file_data.dart';

abstract class ApiClient {
  Future<Map<String, dynamic>> get(String endpoint);

  Future<Map<String, dynamic>> post(String endpoint, {required dynamic body});

  Future<Map<String, dynamic>> put(String endpoint, {required dynamic body});

  Future<Map<String, dynamic>> patch(String endpoint, {required dynamic body});

  Future<Map<String, dynamic>> delete(String endpoint);

  Future<Map<String, dynamic>> multipartWithFiles(String endpoint, {
    required Map<String, dynamic> fields,
    required List<MultipartFileData> files
  });
}