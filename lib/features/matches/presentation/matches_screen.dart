import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../domain/match_model.dart';
import '../../discover/presentation/controllers/discover_controller.dart';
import '../../chat/presentation/chat_screen.dart';
import '../../discover/presentation/widgets/verification_badge.dart';
import '../../../../core/theme/app_theme.dart';

class MatchesScreen extends ConsumerWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discoverState = ref.watch(discoverProvider);
    final matches = discoverState.matches;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches & Chats', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: matches.isEmpty
          ? _buildEmptyState(context, isDark)
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Horizontal "New Connections" Row
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                    child: Text(
                      'New Connections',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: matches.length,
                      itemBuilder: (context, index) {
                        final match = matches[index];
                        return _buildConnectionStoryItem(context, match, isDark);
                      },
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Divider(height: 1),
                  ),
                ),

                // Vertical Conversations Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                    child: Text(
                      'Conversations',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight,
                      ),
                    ),
                  ),
                ),

                // Conversations List
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final match = matches[index];
                      return _buildConversationTile(context, match, isDark);
                    },
                    childCount: matches.length,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildConnectionStoryItem(BuildContext context, MatchModel match, bool isDark) {
    final avatar = match.partner.avatarUrls.isNotEmpty
        ? match.partner.avatarUrls.first
        : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(match: match),
          ),
        );
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryRose, AppTheme.amberSuperlike],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: CachedNetworkImageProvider(avatar),
                  ),
                ),
                if (match.partner.isVerified)
                  const Positioned(
                    bottom: 0,
                    right: 0,
                    child: VerificationBadge(size: 16),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              match.partner.name.split(' ').first,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationTile(BuildContext context, MatchModel match, bool isDark) {
    final avatar = match.partner.avatarUrls.isNotEmpty
        ? match.partner.avatarUrls.first
        : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400';

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(match: match),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey[200],
              backgroundImage: CachedNetworkImageProvider(avatar),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          match.partner.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (match.partner.isVerified) const VerificationBadge(size: 16),
                      const Spacer(),
                      Text(
                        'Just now',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          match.lastMessagePreview ?? 'Say hello and break the ice!',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                          ),
                        ),
                      ),
                      if (match.unreadCount > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryRose,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${match.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryRoseLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 44,
                color: AppTheme.primaryRose,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Connections Yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'When you and someone in Bangladesh swipe right on each other, your connection will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

