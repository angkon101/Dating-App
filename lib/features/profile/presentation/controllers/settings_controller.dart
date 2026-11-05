import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final bool isDiscreetMode;
  final bool isScreenshotBlockEnabled;
  final bool isGhostMode;
  final bool isContactsBlocked;
  final int blockedContactsCount;
  final bool isDarkMode;
  final String language; // 'en' or 'bn'
  final bool isVerified;
  final String userName;
  final String userDivision;
  final String userArea;

  const SettingsState({
    this.isDiscreetMode = true,
    this.isScreenshotBlockEnabled = true,
    this.isGhostMode = false,
    this.isContactsBlocked = true,
    this.blockedContactsCount = 42,
    this.isDarkMode = false,
    this.language = 'en',
    this.isVerified = true,
    this.userName = 'Nafis Al-Razi',
    this.userDivision = 'Dhaka',
    this.userArea = 'Gulshan-1',
  });

  SettingsState copyWith({
    bool? isDiscreetMode,
    bool? isScreenshotBlockEnabled,
    bool? isGhostMode,
    bool? isContactsBlocked,
    int? blockedContactsCount,
    bool? isDarkMode,
    String? language,
    bool? isVerified,
    String? userName,
    String? userDivision,
    String? userArea,
  }) {
    return SettingsState(
      isDiscreetMode: isDiscreetMode ?? this.isDiscreetMode,
      isScreenshotBlockEnabled: isScreenshotBlockEnabled ?? this.isScreenshotBlockEnabled,
      isGhostMode: isGhostMode ?? this.isGhostMode,
      isContactsBlocked: isContactsBlocked ?? this.isContactsBlocked,
      blockedContactsCount: blockedContactsCount ?? this.blockedContactsCount,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      isVerified: isVerified ?? this.isVerified,
      userName: userName ?? this.userName,
      userDivision: userDivision ?? this.userDivision,
      userArea: userArea ?? this.userArea,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    _loadFromPreferences();
    return const SettingsState();
  }

  Future<void> _loadFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = state.copyWith(
        isDiscreetMode: prefs.getBool('discreet_mode') ?? true,
        isScreenshotBlockEnabled: prefs.getBool('screenshot_block') ?? true,
        isGhostMode: prefs.getBool('ghost_mode') ?? false,
        isDarkMode: prefs.getBool('dark_mode') ?? false,
        language: prefs.getString('language') ?? 'en',
      );
    } catch (_) {
      // Fallback defaults
    }
  }

  void toggleDiscreetMode(bool value) async {
    state = state.copyWith(isDiscreetMode: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('discreet_mode', value);
  }

  void toggleScreenshotBlock(bool value) async {
    state = state.copyWith(isScreenshotBlockEnabled: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('screenshot_block', value);
  }

  void toggleGhostMode(bool value) async {
    state = state.copyWith(isGhostMode: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ghost_mode', value);
  }

  void toggleDarkMode(bool value) async {
    state = state.copyWith(isDarkMode: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);
  }

  void setLanguage(String lang) async {
    state = state.copyWith(language: lang);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
