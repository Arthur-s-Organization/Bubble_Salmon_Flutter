import 'dart:convert';
import 'dart:io';
import 'package:bubble_salmon/class/conversation.dart';
import 'package:bubble_salmon/global/utils.dart';
import 'package:bubble_salmon/repositories/conversation_repository.dart';
import 'package:bubble_salmon/services/conversation_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GroupSettingsModal extends StatefulWidget {
  final Conversation conversation;

  const GroupSettingsModal({super.key, required this.conversation});

  @override
  _GroupSettingsModalState createState() => _GroupSettingsModalState();
}

class _GroupSettingsModalState extends State<GroupSettingsModal> {
  final TextEditingController _nameController = TextEditingController();
  String? _base64Image;
  final _repository =
      ConversationRepository(apiConversationService: ApiConversationService());
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.conversation.name;
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final bytes = await imageFile.readAsBytes();
      setState(() {
        _base64Image = base64Encode(bytes);
      });
    }
  }

  Future<void> _updateGroup() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Le nom du groupe ne peut pas être vide."),
        backgroundColor: Colors.red,
      ));
      return;
    }

    setState(() => _isLoading = true);
    final response = await _repository.updateGroup(
      widget.conversation.id,
      _nameController.text.trim(),
      _base64Image,
    );

    setState(() => _isLoading = false);

    if (response["status"] == "error") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response["message"]),
        backgroundColor: Colors.red,
      ));
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(
        top: 24.0,
        left: 24.0,
        right: 24.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28.0),
          topRight: Radius.circular(28.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                  labelText: "Nom du groupe",
                  labelStyle: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 18.0,
                  ),
                  floatingLabelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  )),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              cursorColor: theme.colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 24.0),
          Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    height: 90,
                    width: 90,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: _base64Image != null
                        ? Image.memory(
                            base64Decode(_base64Image!),
                            fit: BoxFit.cover,
                          )
                        : widget.conversation.imageFileName != null &&
                                widget.conversation.imageRepository != null
                            ? Image.network(
                                Global.getImagePath(
                                    widget.conversation.imageRepository!,
                                    widget.conversation.imageFileName!),
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/img/placeholderColor.png",
                                fit: BoxFit.cover,
                              ),
                  ),
                ),
                TextButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(
                    Icons.photo_library,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 20,
                  ),
                  label: Text(
                    "Changer l'image",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32.0),
          ElevatedButton(
            onPressed: _isLoading ? null : _updateGroup,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              elevation: 0,
            ),
            child: _isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    "Mettre à jour",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
