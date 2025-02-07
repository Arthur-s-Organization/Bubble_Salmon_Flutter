import 'package:bubble_salmon/global/http_interceptor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Global {
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatPreviewTime(DateTime dateTime) {
    DateTime now = DateTime.now();
    bool isToday = now.year == dateTime.year &&
        now.month == dateTime.month &&
        now.day == dateTime.day;

    if (isToday) {
      return formatTime(dateTime);
    } else {
      return formatDate(dateTime);
    }
  }

  static String getImagePath(String imageRepository, String imageFileName) {
    return '${dotenv.env['API_URL']}/uploads/images/$imageRepository/$imageFileName';
  }

  static Future<String?> getToken() async {
    final FlutterSecureStorage storage = const FlutterSecureStorage();
    return await storage.read(key: "jwt_token");
  }

  static Future<void> clearToken() async {
    final FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.delete(key: "jwt_token");
  }

  static final http.Client httpClient = HttpInterceptor();
}
