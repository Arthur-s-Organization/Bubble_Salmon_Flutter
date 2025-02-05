import 'package:bubble_salmon/global/utils.dart';
import 'package:bubble_salmon/services/contact_service.dart';
import 'package:bubble_salmon/class/user.dart';

class ContactRepository {
  final ApiContactService apiContactService;

  const ContactRepository({
    required this.apiContactService,
  });

  Future<List<User>> getContacts() async {
    try {
      String? token = await Global.getToken();
      if (token == null) {
        return [];
      }

      Map<String, dynamic> response =
          await apiContactService.getContacts(token);

      if (response["statusCode"] != 200) {
        return [];
      }

      return User.listFromJson(response["body"]);
    } catch (e) {
      return [];
    }
  }
}
