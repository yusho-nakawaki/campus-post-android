class ConversationModel {
  final String id;
  final String myName;
  final String partnerName;
  final String partnerEmail;
  bool myNotification;
  bool partnerNotification;

  // latest_message
  final String date;
  final String message;
  final String sender;
  bool isRead;

  ConversationModel({this.id, this.myName, this.partnerName,
    this.partnerEmail, this.myNotification, this.partnerNotification,
    this.date, this.message, this.sender, this.isRead});

  Map<String, dynamic> toMapConversation() {
    return {
      'id': id,
      'my_name': myName,
      'my_notification': myNotification,
      'partner_email': partnerEmail,
      'partner_name': partnerName,
      'partner_notification': partnerNotification,
      'latest_message': toMapChat()
    };
  }

  Map<String, dynamic> toMapChat() {
    return {
      'date': date,
      'message': message,
      'is_read': isRead,
      'sender': sender,
    };
  }

}