// Nouveau fichier : create_group_dialog.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:bubble_salmon/class/user.dart';
import 'package:bubble_salmon/repositories/auth_repository.dart';
import 'package:bubble_salmon/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bubble_salmon/repositories/contact_repository.dart';
import 'package:bubble_salmon/repositories/conversation_repository.dart';

class CreateGroupDialog extends StatefulWidget {
  final ContactRepository contactRepository;
  final ConversationRepository conversationRepository;

  const CreateGroupDialog({
    super.key,
    required this.contactRepository,
    required this.conversationRepository,
  });

  @override
  State<CreateGroupDialog> createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends State<CreateGroupDialog> {
  final AuthRepository authRepository =
      AuthRepository(apiAuthService: ApiAuthService());
  final TextEditingController _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  List<String> selectedUserIds = [];
  List<User> availableUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final userResponse = await authRepository.getUserId();

    if (userResponse["status"] == "success") {
      final int myUserId = userResponse["user"];

      final result = await widget.contactRepository.getContacts();
      if (result["status"] == "success") {
        setState(() {
          availableUsers = result["contacts"]
              .where((user) => int.tryParse(user.id.toString()) != myUserId)
              .toList();
          isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _createGroup() async {
    if (_nameController.text.isEmpty || selectedUserIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Veuillez remplir tous les champs requis')),
      );
      return;
    }

    String? base64Image;
    if (_selectedImage != null) {
      final bytes = await _selectedImage!.readAsBytes();
      base64Image = base64Encode(bytes);
    }

    final result = await widget.conversationRepository.createGroup(
      _nameController.text,
      selectedUserIds,
      base64Image,
    );

    if (result["status"] == "success") {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["message"])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Créer un groupe',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nom du groupe',
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedImage != null)
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: FutureBuilder<Uint8List>(
                  future: _selectedImage!.readAsBytes(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Image.memory(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ),
            TextButton(
              onPressed: _pickImage,
              child: Text(
                'Ajouter une image',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const CircularProgressIndicator()
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: availableUsers.length,
                  itemBuilder: (context, index) {
                    final user = availableUsers[index];
                    final isSelected = selectedUserIds.contains(user.id);
                    return CheckboxListTile(
                      title: Text(
                        user.username,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedUserIds.add(user.id);
                          } else {
                            selectedUserIds.remove(user.id);
                          }
                        });
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Annuler',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _createGroup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text('Créer',
                      style: TextStyle(
                        color: Colors.black,
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
