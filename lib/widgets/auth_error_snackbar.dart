import 'package:flutter/material.dart';
import '../providers/auth_provider.dart';

/// Shows a premium styled error SnackBar with icon based on error type.
void showAuthErrorSnackBar(BuildContext context, String message, AuthErrorType? errorType) {
  ScaffoldMessenger.of(context).clearSnackBars();

  final (IconData icon, Color color) = switch (errorType) {
    AuthErrorType.invalidCredentials => (Icons.lock_outline_rounded, const Color(0xFFFF6B6B)),
    AuthErrorType.networkError => (Icons.wifi_off_rounded, const Color(0xFFFFB347)),
    AuthErrorType.emailAlreadyRegistered => (Icons.person_off_rounded, const Color(0xFFFCA91C)),
    AuthErrorType.weakPassword => (Icons.security_rounded, const Color(0xFFFF6B6B)),
    AuthErrorType.serverError => (Icons.cloud_off_rounded, const Color(0xFFFF6B6B)),
    _ => (Icons.error_outline_rounded, const Color(0xFFFF6B6B)),
  };

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon with glow
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // Message
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: 'DarkerGrotesque',
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ),
            // Dismiss button
            GestureDetector(
              onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.close_rounded,
                  color: Colors.white.withValues(alpha: 0.4),
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
