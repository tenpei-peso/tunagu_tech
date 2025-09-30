class Result<T> {
  factory Result.error(String error) => Result._(error: error);

  factory Result.success(T data) => Result._(data: data);

  const Result._({this.data, this.error});
  final T? data;
  final String? error;

  bool get isSuccess => error == null;

  void when({
    required void Function(T data) success,
    required void Function(String error) failure,
  }) {
    if (isSuccess) {
      success(data as T);
    } else {
      failure(error!);
    }
  }
}