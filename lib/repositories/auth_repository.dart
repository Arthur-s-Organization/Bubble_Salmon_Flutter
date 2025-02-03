import 'package:bubble_salmon/services/auth_service.dart';

class AuthRepository {
  final ApiAuthService apiAuthService;

  const AuthRepository({
    required this.apiAuthService,
  });

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      Map<String, dynamic> response =
          await apiAuthService.login(username, password);

      if (response["statusCode"] != 200) {
        return {
          "status": "error",
          "message": response["body"]["message"] ?? "Erreur inconnue",
        };
      }

      return {
        "status": "success",
        "token": response["body"],
        "message": "Connexion réussie",
      };
    } catch (e) {
      return {
        "status": "error",
        "message": "Erreur lors de la connexion : ${e.toString()}",
      };
    }
  }
}
