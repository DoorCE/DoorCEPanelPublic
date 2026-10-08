class AppVersion {
  static const String buildDate =
  String.fromEnvironment('BUILD_DATE', defaultValue: '000000');
  static const String dockerTag =
  String.fromEnvironment('DOCKER_TAG', defaultValue: 'dev');

  static String get version => '$buildDate-$dockerTag';
}