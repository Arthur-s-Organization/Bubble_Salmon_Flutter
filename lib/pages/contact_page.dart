import 'package:bubble_salmon/class/user.dart';
import 'package:bubble_salmon/global/utils.dart';
import 'package:bubble_salmon/repositories/contact_repository.dart';
import 'package:bubble_salmon/repositories/conversation_repository.dart';
import 'package:bubble_salmon/services/contact_service.dart';
import 'package:bubble_salmon/services/conversation_service.dart';
import 'package:bubble_salmon/widget/bottom_bar.dart';
import 'package:bubble_salmon/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<User> _contacts = [];
  bool _isLoading = true;
  String? _errorMessage;
  final ContactRepository _contactRepository =
      ContactRepository(apiContactService: ApiContactService());

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final response = await _contactRepository.getContacts();
    setState(() {
      _isLoading = false;
      _contacts = response["contacts"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Rechercher...",
                  hintStyle:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("Saumons",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary)),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _contacts.isEmpty
                      ? const Center(child: Text("Aucun contact trouvé."))
                      : ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: _contacts.length,
                          itemBuilder: (context, index) {
                            final contact = _contacts[index];
                            return Card(
                              color: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: ListTile(
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Container(
                                          height: 60,
                                          width: 60,
                                          child: contact.imageFileName !=
                                                      null &&
                                                  contact.imageRepository !=
                                                      null
                                              ? Image.network(
                                                  Global.getImagePath(
                                                      contact.imageRepository!,
                                                      contact.imageFileName!),
                                                  fit: BoxFit.cover,
                                                )
                                              : Container(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  child: Center(
                                                    child: Text(
                                                      contact.firstname[0],
                                                      style: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                )),
                                    ),
                                    title: Text(
                                      "${contact.firstname} ${contact.lastname}",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                    subtitle: Text(
                                      contact.phone,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                    ),
                                    trailing: Icon(Icons.arrow_forward,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    onTap: () async {
                                      // Montrer un indicateur de chargement
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          );
                                        },
                                      );

                                      final conversationRepository =
                                          ConversationRepository(
                                        apiConversationService:
                                            ApiConversationService(),
                                      );

                                      final result =
                                          await conversationRepository
                                              .getOrCreateConversation(
                                                  contact.id);

                                      // Fermer l'indicateur de chargement
                                      Navigator.pop(context);

                                      if (result["status"] == "success") {
                                        // Naviguer vers la page de conversation
                                        Navigator.pushNamed(
                                          context,
                                          '/conversation',
                                          arguments: {
                                            "conversationId":
                                                result["conversationId"]
                                                    .toString()
                                          },
                                        );
                                      } else {
                                        // Afficher une erreur
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(result["message"]),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                  )),
                            );
                          },
                        ),
            ),
          ],
        ),
        bottomNavigationBar: BottomBar(currentIndex: 0, context: context));
  }
}
