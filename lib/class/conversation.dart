import 'package:bubble_salmon/class/message.dart';

class Conversation {
  final String id;
  final String name;
  final String? imageRepository;
  final String? imageFileName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Message? lastMessage;
  final int type;

  Conversation({
    required this.id,
    required this.name,
    this.imageRepository,
    this.imageFileName,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessage,
    required this.type,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
        id: json['id'].toString(),
        name: json['name'],
        imageRepository: json['imageRepository'],
        imageFileName: json['imageFileName'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        lastMessage:
            json['last_message'] != null && json['last_message']['id'] != null
                ? Message.fromJson(json['last_message'])
                : null,
        type: json['type']);
  }

  static List<Conversation> listFromJson(List<dynamic> list) {
    return list
        .whereType<Map<String, dynamic>>()
        .map((item) => Conversation.fromJson(item))
        .toList();
  }
}
