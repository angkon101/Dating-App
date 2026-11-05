import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:porichoy/core/theme/app_theme.dart';
import 'package:porichoy/core/constants/bd_constants.dart';
import 'package:porichoy/features/discover/domain/user_profile.dart';
import 'package:porichoy/features/matches/domain/match_model.dart';
import 'package:porichoy/features/chat/presentation/chat_screen.dart';
import 'package:porichoy/features/profile/presentation/controllers/settings_controller.dart';
import 'package:porichoy/features/discover/presentation/controllers/discover_controller.dart';
import 'package:porichoy/features/discover/presentation/widgets/profile_card.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> with SingleTickerProviderStateMixin {
  Offset _dragOffset = Offset.zero;
  double _dragAngle = 0;

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta;
      _dragAngle = (_dragOffset.dx / 300) * (math.pi / 16);
    });
  }

  void _onPanEnd(DragEndDetails details, UserProfile profile) {
    const threshold = 120.0;
    if (_dragOffset.dx > threshold) {
      _handleLike(profile);
    } else if (_dragOffset.dx < -threshold) {
      _handlePass(profile);
    } else if (_dragOffset.dy < -threshold) {
      _handleSuperlike(profile);
    } else {
      setState(() {
        _dragOffset = Offset.zero;
        _dragAngle = 0;
      });
    }
  }

  void _handleLike(UserProfile profile) {
    setState(() {
      _dragOffset = Offset.zero;
      _dragAngle = 0;
    });
    final match = ref.read(discoverProvider.notifier).swipeLike(profile);
    if (match != null) {
      _showMatchDialog(match);
    }
  }

  void _handlePass(UserProfile profile) {
    setState(() {
      _dragOffset = Offset.zero;
      _dragAngle = 0;
    });
    ref.read(discoverProvider.notifier).swipePass(profile);
  }

  void _handleSuperlike(UserProfile profile) {
    setState(() {
      _dragOffset = Offset.zero;
      _dragAngle = 0;
    });
    final match = ref.read(discoverProvider.notifier).swipeSuperlike(profile);
    _showMatchDialog(match);
  }

  void _showMatchDialog(MatchModel match) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Match',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return _MatchCelebrationDialog(
          match: match,
          onStartChat: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(match: match),
              ),
            );
          },
        );
      },
    );
  }

  void _showFilterSheet() {
    final discoverState = ref.read(discoverProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _FilterBottomSheet(
          initialDivision: discoverState.filterDivision,
          initialIntent: discoverState.filterIntent,
          onApply: (division, intent) {
            ref.read(discoverProvider.notifier).applyFilters(
              division: division,
              intent: intent,
            );
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final discoverState = ref.watch(discoverProvider);
    final settings = ref.watch(settingsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              BDConstants.appName,
              style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.5),
            ),
            const SizedBox(width: 6),
            Text(
              '(${BDConstants.appNameBangla})',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
              ),
            ),
          ],
        ),
        actions: [
          // Discreet Shield Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: settings.isDiscreetMode
                  ? AppTheme.skyPrivacy.withValues(alpha: 0.15)
                  : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: settings.isDiscreetMode
                    ? AppTheme.skyPrivacy.withValues(alpha: 0.4)
                    : Colors.transparent,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.shield_rounded,
                  size: 14,
                  color: settings.isDiscreetMode ? AppTheme.skyPrivacy : Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  settings.isDiscreetMode ? 'Shield ON' : 'Standard',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: settings.isDiscreetMode ? AppTheme.skyPrivacy : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: _showFilterSheet,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Card Deck Stack
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: discoverState.candidates.isEmpty
                    ? _buildEmptyState(isDark)
                    : Stack(
                        children: [
                          // Background next card preview
                          if (discoverState.candidates.length > 1)
                            Positioned.fill(
                              child: Transform.scale(
                                scale: 0.94,
                                child: Opacity(
                                  opacity: 0.6,
                                  child: ProfileCard(
                                    profile: discoverState.candidates[1],
                                    isUnblurred: discoverState.unblurredProfileIds.contains(discoverState.candidates[1].id),
                                    onToggleUnblur: () {},
                                  ),
                                ),
                              ),
                            ),

                          // Top interactive card
                          Positioned.fill(
                            child: GestureDetector(
                              onPanUpdate: _onPanUpdate,
                              onPanEnd: (details) => _onPanEnd(details, discoverState.candidates.first),
                              child: Transform.translate(
                                offset: _dragOffset,
                                child: Transform.rotate(
                                  angle: _dragAngle,
                                  child: Stack(
                                    children: [
                                      ProfileCard(
                                        profile: discoverState.candidates.first,
                                        isUnblurred: discoverState.unblurredProfileIds.contains(discoverState.candidates.first.id),
                                        onToggleUnblur: () {
                                          ref.read(discoverProvider.notifier).toggleTemporaryUnblur(discoverState.candidates.first.id);
                                        },
                                      ),

                                      // Swipe Stamps Overlay
                                      if (_dragOffset.dx > 40)
                                        Positioned(
                                          top: 40,
                                          left: 30,
                                          child: Transform.rotate(
                                            angle: -0.2,
                                            child: _buildStamp(
                                              'LIKE',
                                              AppTheme.emeraldVerified,
                                              (_dragOffset.dx / 120).clamp(0.0, 1.0),
                                            ),
                                          ),
                                        ),
                                      if (_dragOffset.dx < -40)
                                        Positioned(
                                          top: 40,
                                          right: 30,
                                          child: Transform.rotate(
                                            angle: 0.2,
                                            child: _buildStamp(
                                              'PASS',
                                              AppTheme.primaryRose,
                                              (-_dragOffset.dx / 120).clamp(0.0, 1.0),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            // Bottom Action Controls
            if (discoverState.candidates.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Rewind / Undo
                    _buildActionButton(
                      icon: Icons.replay_rounded,
                      color: Colors.grey,
                      size: 46,
                      iconSize: 22,
                      onTap: () => ref.read(discoverProvider.notifier).undoSwipe(),
                    ),

                    // Pass (X)
                    _buildActionButton(
                      icon: Icons.close_rounded,
                      color: AppTheme.primaryRose,
                      size: 60,
                      iconSize: 30,
                      onTap: () => _handlePass(discoverState.candidates.first),
                    ),

                    // Super-Like (Star)
                    _buildActionButton(
                      icon: Icons.star_rounded,
                      color: AppTheme.amberSuperlike,
                      size: 48,
                      iconSize: 24,
                      onTap: () => _handleSuperlike(discoverState.candidates.first),
                    ),

                    // Like (Heart)
                    _buildActionButton(
                      icon: Icons.favorite_rounded,
                      color: AppTheme.emeraldVerified,
                      size: 60,
                      iconSize: 30,
                      onTap: () => _handleLike(discoverState.candidates.first),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStamp(String text, Color color, double opacity) {
    return Opacity(
      opacity: opacity,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 3),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required double size,
    required double iconSize,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isDark ? AppTheme.slateCardDark : AppTheme.surfaceWhite,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
            width: 1,
          ),
        ),
        child: Center(
          child: Icon(icon, color: color, size: iconSize),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
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
                Icons.people_outline_rounded,
                size: 48,
                color: AppTheme.primaryRose,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'All Caught Up in Your Area!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'No new profiles match your current Bangladeshi division or intent filters right now.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.read(discoverProvider.notifier).loadProfiles(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Refresh & Reset Candidates'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterBottomSheet extends StatefulWidget {
  final String? initialDivision;
  final String? initialIntent;
  final Function(String? division, String? intent) onApply;

  const _FilterBottomSheet({
    this.initialDivision,
    this.initialIntent,
    required this.onApply,
  });

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  String? _selectedDivision;
  String? _selectedIntent;

  @override
  void initState() {
    super.initState();
    _selectedDivision = widget.initialDivision;
    _selectedIntent = widget.initialIntent;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.slateCardDark : AppTheme.surfaceWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Filters & Preferences',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          const Text(
            'Division in Bangladesh',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: const Text('All Divisions'),
                selected: _selectedDivision == null,
                onSelected: (val) => setState(() => _selectedDivision = null),
              ),
              ...BDConstants.divisions.map((div) {
                return ChoiceChip(
                  label: Text(div),
                  selected: _selectedDivision == div,
                  onSelected: (val) => setState(() => _selectedDivision = val ? div : null),
                );
              }),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Relationship Intent',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Any Intent'),
                selected: _selectedIntent == null,
                onSelected: (val) => setState(() => _selectedIntent = null),
              ),
              ...BDConstants.intents.entries.map((entry) {
                return ChoiceChip(
                  label: Text(entry.value.title),
                  selected: _selectedIntent == entry.key,
                  onSelected: (val) => setState(() => _selectedIntent = val ? entry.key : null),
                );
              }),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => widget.onApply(_selectedDivision, _selectedIntent),
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchCelebrationDialog extends StatelessWidget {
  final MatchModel match;
  final VoidCallback onStartChat;

  const _MatchCelebrationDialog({
    required this.match,
    required this.onStartChat,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppTheme.slateDark,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: AppTheme.primaryRose.withValues(alpha: 0.4), width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.favorite_rounded,
              color: AppTheme.primaryRose,
              size: 48,
            ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
            const SizedBox(height: 16),
            const Text(
              'It’s a Connection!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'মনের মিল হয়েছে',
              style: TextStyle(
                color: AppTheme.primaryRose,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'You and ${match.partner.name} liked each other.\nRespectful, thoughtful communication creates the best bonds.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onStartChat,
                icon: const Icon(Icons.chat_bubble_outline_rounded),
                label: const Text('Send a Thoughtful Message'),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Keep Browsing',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

