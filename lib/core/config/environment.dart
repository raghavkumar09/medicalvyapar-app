import 'package:flutter_dotenv/flutter_dotenv.dart';

enum EnvironmentType { dev, prod }

class Environment {
  factory Environment() => _instance;
  static final Environment _instance = Environment._internal();
  Environment._internal();

  String get baseUrl => dotenv.get('BASE_URL', fallback: 'http://localhost:3000/api/v1');
  bool get debugLogging => dotenv.get('DEBUG_LOGGING', fallback: 'false').toLowerCase() == 'true';
  String get appName => dotenv.get('APP_NAME', fallback: 'MediVyapar');

  static late EnvironmentType _currentEnv;
  static EnvironmentType get current => _currentEnv;

  static Future<void> init(EnvironmentType env) async {
    _currentEnv = env;
    final fileName = env == EnvironmentType.dev ? ".env.development" : ".env";
    await dotenv.load(fileName: fileName);
  }
}
