// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_element
enum Routes {
  home(
    path: '/',
    name: 'home',
  ),
  liveStream(
    path: '/id',
    name: 'live-stream',
  ),
  ;

  final String path, name;
  final String? title;
  const Routes({
    required this.name,
    required this.path,
    this.title,
  });

  /// removes the first '/' in [path]
  ///
  /// `return path.replaceFirst('/', '');`
  String get subpath {
    return path.replaceFirst('/', '');
  }

  String get dynamicSubpath => path.replaceFirst('/', ':');

  /// returns new route name with a given [parentName]
  ///
  /// `return '$parentName-$name'`
  String subname(String parentName) {
    return '$parentName-$name';
  }
}
