class BubbleModel {
  final String id;
  final String content;
  final String date;
  final bool isRead;
  final String senderEmail;
  final String type;

  BubbleModel({this.id, this.content, this.date, this.isRead, this.senderEmail, this.type});

  Map<String, dynamic> toMapBubble() {
    return {
      'id': id,
      'content': content,
      'date': date,
      'is_Read': isRead,
      'type': type,
      'sender_email': senderEmail,
    };
  }
}