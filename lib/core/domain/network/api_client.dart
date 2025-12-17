import 'multipart_file_data.dart';

abstract class ApiClient {
  Future<Map<String, dynamic>> get(String endpoint);

  Future<List<dynamic>> getList(String endpoint);

  Future<dynamic> getSingle(String endpoint);

  Future<Map<String, dynamic>> post(String endpoint, {required dynamic body});

  Future<List<dynamic>> postList(String endpoint, {required dynamic body});

  Future<dynamic> postSingle(String endpoint, {required dynamic body});

  Future<Map<String, dynamic>> put(String endpoint, {required dynamic body});

  Future<Map<String, dynamic>> patch(String endpoint, {required dynamic body});

  Future<List<dynamic>> patchList(String endpoint, {required dynamic body});

  Future<Map<String, dynamic>> delete(String endpoint);

  // Future<Map<String, dynamic>> deleteList(String endpoint);
  Future<dynamic> deleteSingle(String endpoint);

  Future<Map<String, dynamic>> multipartWithFiles(String endpoint, {
    required Map<String, dynamic> fields,
    required List<MultipartFileData> files
  });

  Future<List<dynamic>> multipartWithFilesList(String endpoint, {
    required Map<String, dynamic> fields,
    required List<MultipartFileData> files
  });
}