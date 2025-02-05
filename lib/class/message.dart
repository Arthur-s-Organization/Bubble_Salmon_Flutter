// message.dart
class Message {
  final String id;
  final String userId;
  final String conversationId;
  final String? text;
  final String? imageRepository;
  final String? imageFileName;
  final DateTime createdAt;
  final DateTime updatedAt;

  Message({
    required this.id,
    required this.userId,
    required this.conversationId,
    this.text,
    this.imageRepository,
    this.imageFileName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      conversationId: json['conversation_id'].toString(),
      text: json['text'],
      imageRepository: json['imageRepository'],
      imageFileName: json['imageFileName'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  MessageType get messageType =>
      imageFileName != null ? MessageType.image : MessageType.text;
}

enum MessageType { text, image }
