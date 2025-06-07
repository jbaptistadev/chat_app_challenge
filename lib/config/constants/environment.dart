import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static initEnvironment() async {
    await dotenv.load(fileName: '.env');
  }

  static String supabaseUrl =
      dotenv.env['SUPABASE_URL'] ?? 'SUPABASE_URL not found';

  static String supabaseAnonKey =
      dotenv.env['SUPABASE_ANON_KEY'] ?? 'SUPABASE_ANON_KEY not found';
}
