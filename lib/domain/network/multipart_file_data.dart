class MultipartFileData {
  final String fieldName;
  final List<int> bytes;
  final String fileName;
  final String mimeType;

  MultipartFileData({
    required this.fieldName,
    required this.bytes,
    required this.fileName,
    required this.mimeType,
  });
}