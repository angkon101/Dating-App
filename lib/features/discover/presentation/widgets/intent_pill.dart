import 'package:flutter/material.dart';
import '../../../../core/constants/bd_constants.dart';
import '../../../../core/theme/app_theme.dart';

class IntentPill extends StatelessWidget {
  final String intentKey;
  final bool showBangla;

  const IntentPill({
    super.key,
    required this.intentKey,
    this.showBangla = false,
  });

  @override
  Widget build(BuildContext context) {
    final intentData = BDConstants.intents[intentKey] ?? BDConstants.intents['meaningful_dating']!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.slateCardDark : AppTheme.primaryRoseLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppTheme.borderDark : AppTheme.primaryRose.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            intentData.icon,
            size: 14,
            color: AppTheme.primaryRose,
          ),
          const SizedBox(width: 5),
          Text(
            showBangla ? intentData.titleBangla : intentData.title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryRose,
            ),
          ),
        ],
      ),
    );
  }
}

