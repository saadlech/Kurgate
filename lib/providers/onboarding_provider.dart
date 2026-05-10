import 'package:flutter_riverpod/flutter_riverpod.dart';

// Track whether user has seen onboarding
final hasSeenOnboardingProvider = StateProvider<bool>((ref) => false);

// Track whether splash animation has completed
final splashCompleteProvider = StateProvider<bool>((ref) => false);
