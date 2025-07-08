class ApiError implements Exception{
  final int? statusCode;
  final String? message;

  ApiError({this.statusCode, this.message});
}