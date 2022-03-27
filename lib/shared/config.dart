import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String get baseUrl => _getString('BASE_URL');
  static String get googleApiKey  => _getString('GOOGLE_API_KEY');

  static String _getString(String value) => dotenv.get(value);
}