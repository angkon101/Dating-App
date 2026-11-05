import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class VerificationBadge extends StatelessWidget {
  final double size;

  const VerificationBadge({super.key, this.size = 18});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Row(
              children: [
                Icon(Icons.verified, color: AppTheme.emeraldVerified, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Porichoy Verified: Real Bangladeshi phone & selfie liveness confirmed.',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(left: 6),
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          color: AppTheme.emeraldVerified,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: size - 4,
        ),
      ),
    );
  }
}

