import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static final PreferenceService instance =
      PreferenceService._privateConstructor();

  PreferenceService._privateConstructor();

  @override
  Future<String> getDatabasePath() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('db_path')) {
      return prefs.getString('db_path')!;
    } else {
      return (await getApplicationDocumentsDirectory()).path;
    }
  }

  @override
  Future<void> saveDatabasePath(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('db_path', value);
  }
}
