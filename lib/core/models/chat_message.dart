class ChatMessage {
  //Message
  String? id;
  String text;
  DateTime createdAt;

  //user
  String userId;
  String userName;
  String userImageURL;

  ChatMessage({
    this.id,
    required this.text,
    required this.createdAt,
    required this.userId,
    required this.userName,
    required this.userImageURL,
  });
}
