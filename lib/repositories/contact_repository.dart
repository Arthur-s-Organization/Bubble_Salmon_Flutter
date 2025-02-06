import 'package:bubble_salmon/global/utils.dart';
import 'package:bubble_salmon/services/contact_service.dart';
import 'package:bubble_salmon/class/user.dart';

class ContactRepository {
  final ApiContactService apiContactService;

  const ContactRepository({
    required this.apiContactService,
  });

  Future<Map<String, dynamic>> getContacts() async {
    try {
      Map<String, dynamic> response = await apiContactService.getContacts();

      if (response["statusCode"] != 200) {
        return {
          "status": "error",
          "message": response["body"]["message"] ?? "Erreur inconnue",
          "contacts": [],
        };
      }

      final List<User> contacts = User.listFromJson(response["body"]);
      return {
        "status": "success",
        "message": "Contacts récupérés",
        "contacts": contacts,
      };
    } catch (e) {
      return {
        "status": "error",
        "message":
            "Erreur lors de la récupération des contacts : ${e.toString()}",
        "contacts": [],
      };
    }
  }
}
