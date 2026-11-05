import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/user_profile.dart';
import '../../../../core/theme/app_theme.dart';
import 'verification_badge.dart';
import 'intent_pill.dart';

class ProfileCard extends StatefulWidget {
  final UserProfile profile;
  final bool isUnblurred;
  final VoidCallback onToggleUnblur;

  const ProfileCard({
    super.key,
    required this.profile,
    required this.isUnblurred,
    required this.onToggleUnblur,
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  int _currentPhotoIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final photos = widget.profile.avatarUrls.isNotEmpty
        ? widget.profile.avatarUrls
        : ['https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=800&q=80'];

    final bool shouldBlur = widget.profile.isPrivacyBlurred && !widget.isUnblurred;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.slateCardDark : AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Area with Aspect Ratio
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 0.85,
                    child: CachedNetworkImage(
                      imageUrl: photos[_currentPhotoIndex],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: isDark ? AppTheme.slateSurfaceDark : Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.primaryRose,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.person, size: 60, color: Colors.grey),
                      ),
                    ),
                  ),

                  // Privacy Shield Blur Overlay
                  if (shouldBlur)
                    Positioned.fill(
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.35),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.4),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.shield_rounded,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Discreet Privacy Shield Active',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'This member preserves their visual privacy until a mutual connection or temporary preview.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 12,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                OutlinedButton.icon(
                                  onPressed: widget.onToggleUnblur,
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.white, width: 1.2),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  icon: const Icon(Icons.visibility_outlined, size: 16),
                                  label: const Text(
                                    'Peek Preview',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Subtle Top Indicator for Multiple Photos
                  if (photos.length > 1)
                    Positioned(
                      top: 12,
                      left: 16,
                      right: 16,
                      child: Row(
                        children: List.generate(photos.length, (index) {
                          return Expanded(
                            child: Container(
                              height: 3,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                color: _currentPhotoIndex == index
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.35),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                  // Left/Right Tap Detectors for Photo Navigation
                  if (photos.length > 1)
                    Positioned.fill(
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                if (_currentPhotoIndex > 0) {
                                  setState(() => _currentPhotoIndex--);
                                }
                              },
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                if (_currentPhotoIndex < photos.length - 1) {
                                  setState(() => _currentPhotoIndex++);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Quick Toggle Unblur button if preview is active
                  if (widget.profile.isPrivacyBlurred && widget.isUnblurred)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: GestureDetector(
                        onTap: widget.onToggleUnblur,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.visibility_off_outlined, color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text(
                                'Re-blur',
                                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // Details Body
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Intent Pill
                    IntentPill(intentKey: widget.profile.intent),
                    const SizedBox(height: 12),

                    // Name, Age, Verification
                    Row(
                      children: [
                        Text(
                          widget.profile.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.profile.age}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                          ),
                        ),
                        if (widget.profile.isVerified) const VerificationBadge(),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Location / Distance in Bangladesh
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: AppTheme.primaryRose,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.profile.area}, ${widget.profile.division}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${widget.profile.distanceKm} km away',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                          ),
                        ),
                      ],
                    ),

                    // Profession & Education (Crucial for Bangladeshi Matrimonial/Dating Trust)
                    if (widget.profile.profession != null || widget.profile.education != null) ...[
                      const SizedBox(height: 14),
                      if (widget.profile.profession != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              Icon(
                                Icons.work_outline_rounded,
                                size: 16,
                                color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.profile.profession!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (widget.profile.education != null)
                        Row(
                          children: [
                            Icon(
                              Icons.school_outlined,
                              size: 16,
                              color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.profile.education!,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],

                    // Bio
                    if (widget.profile.bio.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        widget.profile.bio,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight,
                        ),
                      ),
                    ],

                    // Cultural Prompts
                    if (widget.profile.prompts.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      ...widget.profile.prompts.map((prompt) {
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? AppTheme.slateSurfaceDark : AppTheme.slateLight,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                prompt.question,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryRose,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                prompt.answer,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                  color: isDark ? AppTheme.textMainDark : AppTheme.textMainLight,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

