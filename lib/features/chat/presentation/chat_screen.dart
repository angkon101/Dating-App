import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../matches/domain/match_model.dart';
import '../domain/chat_message.dart';
import '../../../../core/theme/app_theme.dart';
import '../../discover/presentation/widgets/verification_badge.dart';

class ChatScreen extends StatefulWidget {
  final MatchModel match;

  const ChatScreen({super.key, required this.match});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isMutualRevealed = false;
  bool _hasRequestedReveal = false;

  late List<ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    _isMutualRevealed = widget.match.isPhotoRevealed;
    _messages = [
      ChatMessage(
        id: 'msg_1',
        matchId: widget.match.id,
        senderId: widget.match.partner.id,
        text: 'Hi Nafis! I loved your prompt about old Dhaka heritage.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        isFromMe: false,
      ),
      ChatMessage(
        id: 'msg_2',
        matchId: widget.match.id,
        senderId: 'me',
        text: 'Thanks ${widget.match.partner.name.split(' ').first}! Beauty Lassi and Ahsan Manzil on a calm Friday morning are unmatched.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
        isFromMe: true,
      ),
    ];
  }

  void _sendMessage([String? textToSend]) {
    final text = textToSend ?? _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
          matchId: widget.match.id,
          senderId: 'me',
          text: text,
          timestamp: DateTime.now(),
          isFromMe: true,
        ),
      );
      if (textToSend == null) _textController.clear();
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Simulated authentic auto-reply after 2 seconds
    if (_messages.length == 3) {
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() {
          _messages.add(
            ChatMessage(
              id: 'msg_reply',
              matchId: widget.match.id,
              senderId: widget.match.partner.id,
              text: 'Totally agree! It is rare finding people in Dhaka who still appreciate heritage like that.',
              timestamp: DateTime.now(),
              isFromMe: false,
            ),
          );
        });
      });
    }
  }

  void _handleRevealRequest() {
    setState(() {
      _hasRequestedReveal = true;
      _isMutualRevealed = true; // Auto-reciprocated for demo
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            Icon(Icons.lock_open_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Mutual Photo Reveal granted by both members!'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final partner = widget.match.partner;
    final avatar = partner.avatarUrls.isNotEmpty
        ? partner.avatarUrls.first
        : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400';

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: CachedNetworkImageProvider(avatar),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      partner.name,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    if (partner.isVerified) const VerificationBadge(size: 14),
                  ],
                ),
                Text(
                  '${partner.area}, ${partner.division}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {
              _showChatOptionsSheet();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Privacy Shield & Mutual Reveal Notice Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: isDark ? AppTheme.slateCardDark : AppTheme.primaryRoseLight.withValues(alpha: 0.5),
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, size: 16, color: AppTheme.primaryRose),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isMutualRevealed
                          ? 'Photos Unlocked • Mutual consent given'
                          : 'Privacy Shield Active • Discreet connection',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryRose,
                      ),
                    ),
                  ),
                  if (!_isMutualRevealed)
                    TextButton(
                      onPressed: _handleRevealRequest,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Unlock Photos',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                      ),
                    ),
                ],
              ),
            ),

            // Messages Stream
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return _buildMessageBubble(msg, isDark);
                },
              ),
            ),

            // Quick Bangladeshi Icebreaker Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  _buildQuickChip('Tong cha or Artisan coffee? ☕'),
                  _buildQuickChip('Best Kacchi in Dhaka? 🍛'),
                  _buildQuickChip('Favorite spot to watch rain? 🌧️'),
                ],
              ),
            ),

            // Chat Input Bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.slateCardDark : AppTheme.surfaceWhite,
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Type a thoughtful message...',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: isDark ? AppTheme.slateSurfaceDark : AppTheme.slateLight,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryRose,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      onPressed: () => _sendMessage(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        onPressed: () => _sendMessage(label),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg, bool isDark) {
    return Align(
      alignment: msg.isFromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: msg.isFromMe
              ? AppTheme.primaryRose
              : (isDark ? AppTheme.slateCardDark : AppTheme.slateLight),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(msg.isFromMe ? 18 : 4),
            bottomRight: Radius.circular(msg.isFromMe ? 4 : 18),
          ),
          border: msg.isFromMe
              ? null
              : Border.all(
                  color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
                  width: 1,
                ),
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            color: msg.isFromMe
                ? Colors.white
                : (isDark ? AppTheme.textMainDark : AppTheme.textMainLight),
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  void _showChatOptionsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.slateCardDark : AppTheme.surfaceWhite,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.shield_outlined, color: AppTheme.skyPrivacy),
                title: const Text('Safety & Respect Guidelines'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.block_outlined, color: Colors.orange),
                title: const Text('Unmatch respectfully'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag_outlined, color: Colors.red),
                title: const Text('Report concern'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Report submitted for safety review.')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

