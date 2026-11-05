class ChatMessage {
  final String id;
  final String matchId;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isFromMe;
  final bool isRead;

  const ChatMessage({
    required this.id,
    required this.matchId,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isFromMe,
    this.isRead = true,
  });

  ChatMessage copyWith({
    String? id,
    String? matchId,
    String? senderId,
    String? text,
    DateTime? timestamp,
    bool? isFromMe,
    bool? isRead,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      matchId: matchId ?? this.matchId,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isFromMe: isFromMe ?? this.isFromMe,
      isRead: isRead ?? this.isRead,
    );
  }
}

