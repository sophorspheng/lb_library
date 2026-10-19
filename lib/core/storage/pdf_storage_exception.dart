class PdfStorageException implements Exception {
  const PdfStorageException(this.message);

  final String message;

  @override
  String toString() => message;
}
