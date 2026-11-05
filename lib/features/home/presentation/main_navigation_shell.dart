import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../discover/presentation/discover_screen.dart';
import '../../matches/presentation/matches_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../discover/presentation/controllers/discover_controller.dart';
import '../../../../core/theme/app_theme.dart';

class MainNavigationShell extends ConsumerStatefulWidget {
  const MainNavigationShell({super.key});

  @override
  ConsumerState<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends ConsumerState<MainNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DiscoverScreen(),
    MatchesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final discoverState = ref.watch(discoverProvider);
    final matchCount = discoverState.matches.length;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
              width: 1,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() => _currentIndex = index);
          },
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.style_outlined),
              selectedIcon: Icon(Icons.style, color: AppTheme.primaryRose),
              label: 'Discover',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: matchCount > 0,
                label: Text('$matchCount'),
                backgroundColor: AppTheme.primaryRose,
                child: const Icon(Icons.chat_bubble_outline_rounded),
              ),
              selectedIcon: Badge(
                isLabelVisible: matchCount > 0,
                label: Text('$matchCount'),
                backgroundColor: AppTheme.primaryRose,
                child: const Icon(Icons.chat_bubble_rounded, color: AppTheme.primaryRose),
              ),
              label: 'Matches',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded, color: AppTheme.primaryRose),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

