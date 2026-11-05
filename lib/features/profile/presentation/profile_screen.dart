import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controllers/settings_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/supabase_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile & Privacy', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Header
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.primaryRose, width: 2),
                        ),
                        child: const CircleAvatar(
                          radius: 46,
                          backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400',
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppTheme.emeraldVerified,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        settings.userName,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        '26',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${settings.userArea}, ${settings.userDivision} • Software Engineer',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Verification Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.emeraldVerified.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.emeraldVerified.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified_user_rounded, color: AppTheme.emeraldVerified, size: 28),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Identity Verified',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.emeraldVerified,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Real Bangladeshi phone number & selfie liveness confirmed.',
                          style: TextStyle(fontSize: 12, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Bangladesh Privacy Shield Section
            _buildSectionHeader('Bangladesh Privacy Shield 🛡️', isDark),
            const SizedBox(height: 12),

            _buildSwitchTile(
              title: 'Discreet Photo Shield',
              subtitle: 'Keep photos gently blurred on discovery. Unblurs on mutual connection or preview.',
              value: settings.isDiscreetMode,
              onChanged: notifier.toggleDiscreetMode,
              icon: Icons.blur_on_rounded,
              isDark: isDark,
            ),
            const SizedBox(height: 10),

            _buildSwitchTile(
              title: 'Family & Contacts Shield',
              subtitle: 'Prevent relatives, neighbors, and contacts (${settings.blockedContactsCount} protected) from seeing you.',
              value: settings.isContactsBlocked,
              onChanged: (_) {},
              icon: Icons.family_restroom_rounded,
              isDark: isDark,
            ),
            const SizedBox(height: 10),

            _buildSwitchTile(
              title: 'Ghost Mode',
              subtitle: 'Your profile remains completely invisible except to members you swipe right on.',
              value: settings.isGhostMode,
              onChanged: notifier.toggleGhostMode,
              icon: Icons.visibility_off_outlined,
              isDark: isDark,
            ),
            const SizedBox(height: 10),

            _buildSwitchTile(
              title: 'Screenshot Deterrent',
              subtitle: 'Deter screenshot attempts in chat to maintain discretion.',
              value: settings.isScreenshotBlockEnabled,
              onChanged: notifier.toggleScreenshotBlock,
              icon: Icons.camera_alt_outlined,
              isDark: isDark,
            ),
            const SizedBox(height: 28),

            // App Experience & Language
            _buildSectionHeader('Preferences & Culture', isDark),
            const SizedBox(height: 12),

            _buildSwitchTile(
              title: 'Dark Mode (OLED)',
              subtitle: 'Deep charcoal and battery-friendly dark theme.',
              value: settings.isDarkMode,
              onChanged: notifier.toggleDarkMode,
              icon: Icons.dark_mode_outlined,
              isDark: isDark,
            ),
            const SizedBox(height: 10),

            // Language Switcher
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.slateCardDark : AppTheme.surfaceWhite,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.language_rounded, color: AppTheme.primaryRose, size: 22),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'Language / ভাষা',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'en', label: Text('EN')),
                      ButtonSegment(value: 'bn', label: Text('বাংলা')),
                    ],
                    selected: {settings.language},
                    onSelectionChanged: (set) => notifier.setLanguage(set.first),
                    showSelectedIcon: false,
                    style: SegmentedButton.styleFrom(
                      selectedBackgroundColor: AppTheme.primaryRoseLight,
                      selectedForegroundColor: AppTheme.primaryRose,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Supabase Cloud Status Card
            _buildSectionHeader('Backend & Cloud Connection', isDark),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.slateCardDark : AppTheme.surfaceWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isDark ? AppTheme.borderDark : AppTheme.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: SupabaseService.isConfigured ? Colors.green : Colors.amber,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        SupabaseService.isConfigured ? 'Supabase Live Connected' : 'Demo Mode (Offline Database Active)',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    SupabaseService.isConfigured
                        ? 'Using PostgreSQL + PostGIS geo-discovery with Row-Level Security.'
                        : 'The app is running smoothly in zero-config offline mode with authentic Bangladeshi mock profiles. To plug in your live PostgreSQL database, run supabase/schema.sql in your Supabase project.',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.slateCardDark : AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryRose, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: AppTheme.primaryRose,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

