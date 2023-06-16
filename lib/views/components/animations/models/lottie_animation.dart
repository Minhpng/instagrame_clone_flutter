enum LottieAnimation {
  dataNotFound(name: 'data_not_found'),
  // data_not_found.json
  empty(name: 'empty'),
  error(name: 'error'),
  loading(name: 'loading'),
  smallError(name: 'small_error');

  final String? name;
  const LottieAnimation({required this.name});

  String get getFullPath => 'assets/animations/$name.json';
}
