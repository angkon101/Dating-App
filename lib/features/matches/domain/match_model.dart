import '../../discover/domain/user_profile.dart';

class MatchModel {
  final String id;
  final UserProfile partner;
  final DateTime matchedAt;
  final String? lastMessagePreview;
  final bool isPhotoRevealed;
  final int unreadCount;

  const MatchModel({
    required this.id,
    required this.partner,
    required this.matchedAt,
    this.lastMessagePreview,
    this.isPhotoRevealed = false,
    this.unreadCount = 0,
  });

  MatchModel copyWith({
    String? id,
    UserProfile? partner,
    DateTime? matchedAt,
    String? lastMessagePreview,
    bool? isPhotoRevealed,
    int? unreadCount,
  }) {
    return MatchModel(
      id: id ?? this.id,
      partner: partner ?? this.partner,
      matchedAt: matchedAt ?? this.matchedAt,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
      isPhotoRevealed: isPhotoRevealed ?? this.isPhotoRevealed,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

