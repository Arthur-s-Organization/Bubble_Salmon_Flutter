import 'package:bubble_salmon/global/utils.dart';
import 'package:bubble_salmon/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final ApiAuthService apiAuthService;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

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

      String token = response["body"];

      await storage.write(key: "jwt_token", value: token);

      return {
        "status": "success",
        "token": token,
        "message": "Connexion réussie",
      };
    } catch (e) {
      return {
        "status": "error",
        "message": "Erreur lors de la connexion : ${e.toString()}",
      };
    }
  }

  Future<Map<String, dynamic>> register(
    String firstname,
    String lastname,
    String username,
    String password,
    String phone,
    String birthdate,
    String profilePicture,
  ) async {
    try {
      Map<String, dynamic> response = await apiAuthService.register(
        firstname,
        lastname,
        username,
        password,
        phone,
        birthdate,
        profilePicture,
      );

      if (response["statusCode"] != 200) {
        return {
          "status": "error",
          "message": response["body"]["message"] ?? "Erreur inconnue",
        };
      }

      return {
        "status": "success",
        "message": "Compte enregistré",
      };
    } catch (e) {
      return {
        "status": "error",
        "message": "Erreur lors de l'enregistrement : ${e.toString()}",
      };
    }
  }

  Future<Map<String, dynamic>> getUser() async {
    try {
      String? token = await Global.getToken();
      if (token == null) {
        return {"status": "error", "message": "Utilisateur non connecté"};
      }

      Map<String, dynamic> response = await apiAuthService.getUser(token);

      if (response["statusCode"] != 200) {
        return {
          "status": "error",
          "message": response["body"]["message"] ?? "Erreur inconnue",
        };
      }

      return {
        "status": "success",
        "user": response["body"],
      };
    } catch (e) {
      return {
        "status": "error",
        "message":
            "Erreur lors de la récupération de l'utilisateur : ${e.toString()}",
      };
    }
  }

  Future<Map<String, dynamic>> getUserId() async {
    try {
      String? token = await Global.getToken();
      if (token == null) {
        return {"status": "error", "message": "Utilisateur non connecté"};
      }

      Map<String, dynamic> response = await apiAuthService.getUser(token);

      if (response["statusCode"] != 200) {
        return {
          "status": "error",
          "message": response["body"]["message"] ?? "Erreur inconnue",
        };
      }
      return {
        "status": "success",
        "user": response["body"]["id"],
      };
    } catch (e) {
      return {
        "status": "error",
        "message":
            "Erreur lors de la récupération de l'utilisateur : ${e.toString()}",
      };
    }
  }
}
