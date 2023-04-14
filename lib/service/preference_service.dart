import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  @override
  Future<String?> getDatabasePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('db_path');
  }

  @override
  Future<void> saveDatabasePath(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('db_path', value);
  }
}