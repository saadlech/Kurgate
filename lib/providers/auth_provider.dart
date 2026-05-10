import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/utilisateur.dart';

// Auth state
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final Utilisateur? currentUser;
  final String? errorMessage;
  final AuthErrorType? errorType;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.currentUser,
    this.errorMessage,
    this.errorType,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    Utilisateur? currentUser,
    String? errorMessage,
    AuthErrorType? errorType,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      currentUser: currentUser ?? this.currentUser,
      errorMessage: errorMessage,
      errorType: errorType,
    );
  }
}

// Error types for UI differentiation
enum AuthErrorType {
  invalidCredentials,
  networkError,
  emailAlreadyRegistered,
  weakPassword,
  serverError,
  unknown,
}

// Auth notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  final _supabase = Supabase.instance.client;

  /// Checks if the error is a network/connectivity issue
  bool _isNetworkError(Object error) {
    final msg = error.toString().toLowerCase();
    // On web, dart:io SocketException doesn't exist, so we rely on string matching
    return msg.contains('socketexception') ||
        msg.contains('network is unreachable') ||
        msg.contains('connection refused') ||
        msg.contains('connection timed out') ||
        msg.contains('host lookup') ||
        msg.contains('no internet') ||
        msg.contains('failed host lookup') ||
        msg.contains('clientexception') ||
        msg.contains('xmlhttprequest error') ||
        msg.contains('networkerror');
  }

  /// Maps AuthException to user-friendly message + type
  ({String message, AuthErrorType type}) _mapAuthError(AuthException e) {
    final msg = e.message.toLowerCase();

    if (msg.contains('invalid login credentials') ||
        msg.contains('invalid_credentials')) {
      return (
        message: 'Incorrect email or password. Please try again.',
        type: AuthErrorType.invalidCredentials,
      );
    }

    if (msg.contains('email not confirmed')) {
      return (
        message: 'Please verify your email before signing in.',
        type: AuthErrorType.invalidCredentials,
      );
    }

    if (msg.contains('user already registered') ||
        msg.contains('already been registered')) {
      return (
        message: 'This email is already registered. Try signing in instead.',
        type: AuthErrorType.emailAlreadyRegistered,
      );
    }

    if (msg.contains('password') &&
        (msg.contains('weak') || msg.contains('short') || msg.contains('too'))) {
      return (
        message: 'Password is too weak. Use at least 6 characters.',
        type: AuthErrorType.weakPassword,
      );
    }

    if (msg.contains('rate limit') || msg.contains('too many requests')) {
      return (
        message: 'Too many attempts. Please wait a moment and try again.',
        type: AuthErrorType.serverError,
      );
    }

    // Fallback to the original message
    return (
      message: e.message,
      type: AuthErrorType.unknown,
    );
  }

  /// Handle generic errors with proper network detection
  void _handleGenericError(Object error, String context) {
    debugPrint('=== AUTH ERROR ($context) ===');
    debugPrint('Error type: ${error.runtimeType}');
    debugPrint('Error: $error');
    debugPrint('============================');

    if (_isNetworkError(error)) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No internet connection. Please check your network and try again.',
        errorType: AuthErrorType.networkError,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred. Please try again later.',
        errorType: AuthErrorType.serverError,
      );
    }
  }

  /// Fetch user profile from the `utilisateurs` table
  Future<Utilisateur?> _fetchUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('utilisateurs')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response != null) {
        return Utilisateur.fromMap(response);
      }
    } catch (e) {
      debugPrint('Failed to fetch user profile: $e');
    }
    return null;
  }

  /// Create or update user profile in the `utilisateurs` table
  Future<Utilisateur?> _upsertUserProfile({
    required String userId,
    required String nom,
    required String email,
    required int numDeTelephone,
  }) async {
    try {
      final userData = {
        'id': userId,
        'nom': nom,
        'email': email,
        'num_de_telephone': numDeTelephone,
      };
      await _supabase.from('utilisateurs').upsert(userData);
      return Utilisateur.fromMap(userData);
    } catch (e) {
      debugPrint('Failed to upsert user profile: $e');
      // Return a local-only user object so auth still works
      return Utilisateur(
        id: userId,
        nom: nom,
        email: email,
        numDeTelephone: numDeTelephone,
      );
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Fetch profile from the utilisateurs table
        final user = await _fetchUserProfile(response.user!.id);

        // Even if profile fetch fails, auth succeeded — create a minimal user
        final resolvedUser = user ?? Utilisateur(
          id: response.user!.id,
          nom: response.user!.userMetadata?['nom'] ?? '',
          email: email,
          numDeTelephone: (response.user!.userMetadata?['numDeTelephone'] as num?)?.toInt() ?? 0,
        );

        state = state.copyWith(
          isAuthenticated: true,
          isLoading: false,
          currentUser: resolvedUser,
        );
        return true;
      }

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Login failed. Please try again.',
        errorType: AuthErrorType.unknown,
      );
      return false;
    } on AuthException catch (e) {
      final mapped = _mapAuthError(e);
      state = state.copyWith(
        isLoading: false,
        errorMessage: mapped.message,
        errorType: mapped.type,
      );
      return false;
    } catch (e) {
      _handleGenericError(e, 'login');
      return false;
    }
  }

  Future<bool> signup({
    required String nom,
    required String email,
    required String password,
    required int numDeTelephone,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'nom': nom,
          'numDeTelephone': numDeTelephone,
        },
      );

      if (response.user != null) {
        // Insert user profile into the utilisateurs table (with fallback)
        await _upsertUserProfile(
          userId: response.user!.id,
          nom: nom,
          email: email,
          numDeTelephone: numDeTelephone,
        );

        // Sign out immediately — user must confirm email before logging in
        await _supabase.auth.signOut();

        state = state.copyWith(
          isAuthenticated: false,
          isLoading: false,
        );
        return true;
      }

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Signup failed. Please try again.',
        errorType: AuthErrorType.unknown,
      );
      return false;
    } on AuthException catch (e) {
      final mapped = _mapAuthError(e);
      state = state.copyWith(
        isLoading: false,
        errorMessage: mapped.message,
        errorType: mapped.type,
      );
      return false;
    } catch (e) {
      _handleGenericError(e, 'signup');
      return false;
    }
  }

  /// Send a password reset email
  Future<bool> resetPassword({required String email}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.kurgate://reset-callback/',
      );
      state = state.copyWith(isLoading: false);
      return true;
    } on AuthException catch (e) {
      final mapped = _mapAuthError(e);
      state = state.copyWith(
        isLoading: false,
        errorMessage: mapped.message,
        errorType: mapped.type,
      );
      return false;
    } catch (e) {
      _handleGenericError(e, 'resetPassword');
      return false;
    }
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
    state = const AuthState();
  }
}

// Providers
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
