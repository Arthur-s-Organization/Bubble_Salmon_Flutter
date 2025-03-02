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

  Future<void> _loadContacts([String? searchTerm]) async {
    setState(() {
      _isLoading = true;
    });

    // Si un terme de recherche est fourni, utilisez-le pour la requête API
    final response = searchTerm != null && searchTerm.isNotEmpty
        ? await _contactRepository.searchContacts(searchTerm)
        : await _contactRepository.getContacts();

    setState(() {
      _isLoading = false;
      _contacts = response["contacts"];
      // Pas besoin de trier car l'API renvoie déjà les contacts triés
    });
  }

  // Méthode pour obtenir une map de contacts regroupés par initiale
  Map<String, List<User>> _getContactsByInitial() {
    final Map<String, List<User>> contactsByInitial = {};

    for (var contact in _contacts) {
      // Utiliser la première lettre du nom d'utilisateur comme clé
      final initial = contact.username[0].toUpperCase();

      if (!contactsByInitial.containsKey(initial)) {
        contactsByInitial[initial] = [];
      }

      contactsByInitial[initial]!.add(contact);
    }

    // Trier les clés alphabétiquement
    final sortedKeys = contactsByInitial.keys.toList()..sort();
    final sortedMap = {
      for (var key in sortedKeys) key: contactsByInitial[key]!
    };

    return sortedMap;
  }

  @override
  Widget build(BuildContext context) {
    final contactsByInitial = _getContactsByInitial();

    return Scaffold(
        appBar: CustomAppBar(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                style: TextStyle(color: Colors.white), // Texte saisi en blanc
                decoration: InputDecoration(
                  hintText: "Rechercher...",
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2),
                  ),
                ),
                onChanged: (value) {
                  _loadContacts(value);
                },
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _contacts.isEmpty
                      ? const Center(
                          child: Text(
                          "Aucun contact trouvé.",
                          style: TextStyle(color: Colors.white),
                        ))
                      : ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: contactsByInitial.keys.length +
                              contactsByInitial.values
                                  .fold(0, (sum, list) => sum + list.length),
                          itemBuilder: (context, index) {
                            int currentIndex = 0;

                            for (var initial in contactsByInitial.keys) {
                              if (currentIndex == index) {
                                return Container(
                                  margin:
                                      const EdgeInsets.only(top: 4, bottom: 4),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  width: double.infinity,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        initial,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Container(
                                          height: 1,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              currentIndex++;

                              final contacts = contactsByInitial[initial]!;

                              if (index < currentIndex + contacts.length) {
                                final contact = contacts[index - currentIndex];

                                return Card(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer,
                                  child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8),
                                      child: ListTile(
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          child: Container(
                                              height: 60,
                                              width: 60,
                                              child: contact.imageFileName !=
                                                          null &&
                                                      contact.imageRepository !=
                                                          null
                                                  ? Image.network(
                                                      Global.getImagePath(
                                                          contact
                                                              .imageRepository!,
                                                          contact
                                                              .imageFileName!),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Container(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
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
                                          contact.username,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                        subtitle: Text(
                                          contact.phone,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onTertiaryContainer),
                                        ),
                                        trailing: Icon(Icons.arrow_forward,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                        onTap: () async {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
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

                                          Navigator.pop(context);

                                          if (result["status"] == "success") {
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
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content:
                                                    Text(result["message"]),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        },
                                      )),
                                );
                              }

                              currentIndex += contacts.length;
                            }

                            return null;
                          },
                        ),
            ),
          ],
        ),
        bottomNavigationBar: BottomBar(currentIndex: 0, context: context));
  }
}
