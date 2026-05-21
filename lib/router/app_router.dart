import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/destination_screen.dart';
import '../screens/main_shell.dart';
import '../screens/hotel_list_screen.dart';
import '../screens/hotel_detail_screen.dart';
import '../screens/vehicule_list_screen.dart';
import '../screens/vehicule_detail_screen.dart';
import '../screens/experience_list_screen.dart';
import '../screens/experience_detail_screen.dart';
import '../screens/restaurant_list_screen.dart';
import '../screens/restaurant_detail_screen.dart';
import '../screens/boutique_list_screen.dart';
import '../screens/boutique_detail_screen.dart';
import '../screens/payment_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/attraction_list_screen.dart';
import '../screens/attraction_detail_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      // Splash
      GoRoute(
        path: '/splash',
        name: 'splash',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),

      // Onboarding
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),

      // Login
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            );
          },
        ),
      ),

      // Signup
      GoRoute(
        path: '/signup',
        name: 'signup',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SignupScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        ),
      ),

      // Forgot Password
      GoRoute(
        path: '/forgot-password',
        name: 'forgotPassword',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ForgotPasswordScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        ),
      ),

      // Destinations
      GoRoute(
        path: '/destinations',
        name: 'destinations',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const DestinationScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: child,
            );
          },
        ),
      ),

      // Main app (home with tabs)
      GoRoute(
        path: '/home',
        name: 'home',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MainShell(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: child,
            );
          },
        ),
      ),

      // Hotel listing
      GoRoute(
        path: '/hotels',
        name: 'hotels',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const HotelListScreen(),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            );
          },
        ),
      ),

      // Hotel detail
      GoRoute(
        path: '/hotel/:id',
        name: 'hotelDetail',
        pageBuilder: (context, state) {
          final hotelId = state.pathParameters['id']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: HotelDetailScreen(hotelId: hotelId),
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.15),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
          );
        },
      ),

      // Vehicle listing
      GoRoute(
        path: '/vehicules',
        name: 'vehicules',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const VehiculeListScreen(),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            );
          },
        ),
      ),

      // Vehicle detail
      GoRoute(
        path: '/vehicule/:id',
        name: 'vehiculeDetail',
        pageBuilder: (context, state) {
          final vehiculeId = state.pathParameters['id']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: VehiculeDetailScreen(vehiculeId: vehiculeId),
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.15),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
          );
        },
      ),

      // Experience listing
      GoRoute(
        path: '/experiences',
        name: 'experiences',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ExperienceListScreen(),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                  .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
              child: child,
            );
          },
        ),
      ),

      // Experience detail
      GoRoute(
        path: '/experience/:id',
        name: 'experienceDetail',
        pageBuilder: (context, state) {
          final experienceId = state.pathParameters['id']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: ExperienceDetailScreen(experienceId: experienceId),
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
                    .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
          );
        },
      ),

      // Restaurant listing
      GoRoute(
        path: '/restaurants',
        name: 'restaurants',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RestaurantListScreen(),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                  .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
              child: child,
            );
          },
        ),
      ),

      // Restaurant detail
      GoRoute(
        path: '/restaurant/:id',
        name: 'restaurantDetail',
        pageBuilder: (context, state) {
          final restaurantId = state.pathParameters['id']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: RestaurantDetailScreen(restaurantId: restaurantId),
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
                    .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
          );
        },
      ),

      // Boutique listing
      GoRoute(
        path: '/boutiques',
        name: 'boutiques',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const BoutiqueListScreen(),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                  .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
              child: child,
            );
          },
        ),
      ),

      // Boutique detail
      GoRoute(
        path: '/boutique/:id',
        name: 'boutiqueDetail',
        pageBuilder: (context, state) {
          final boutiqueId = state.pathParameters['id']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: BoutiqueDetailScreen(boutiqueId: boutiqueId),
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
                    .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
          );
        },
      ),

      // Payment
      GoRoute(
        path: '/payment/:id',
        name: 'payment',
        pageBuilder: (context, state) {
          final bookingId = state.pathParameters['id']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: PaymentScreen(bookingId: bookingId),
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
                    .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
          );
        },
      ),

      // Edit Profile
      GoRoute(
        path: '/edit-profile',
        name: 'editProfile',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const EditProfileScreen(),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
                  .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
        ),
      ),

      // Attraction listing
      GoRoute(
        path: '/attractions',
        name: 'attractions',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AttractionListScreen(),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                  .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
              child: child,
            );
          },
        ),
      ),

      // Attraction detail
      GoRoute(
        path: '/attraction/:id',
        name: 'attractionDetail',
        pageBuilder: (context, state) {
          final attractionId = state.pathParameters['id']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: AttractionDetailScreen(attractionId: attractionId),
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
                    .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
          );
        },
      ),
    ],
  );
});
