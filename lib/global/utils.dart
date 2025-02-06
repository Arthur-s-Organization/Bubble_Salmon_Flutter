import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Global {
  static String formatTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  static String getImagePath(String imageRepository, String imageFileName) {
    return '${dotenv.env['API_URL']}/uploads/images/${imageRepository}/${imageFileName}';
  }

  static Future<String?> getToken() async {
    final FlutterSecureStorage storage = const FlutterSecureStorage();
    return await storage.read(key: "jwt_token");
  }

  static Future<void> clearToken() async {
    final FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.delete(key: "jwt_token");
  }
}
