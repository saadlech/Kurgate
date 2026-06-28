import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'bookings_screen.dart';
import 'map_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import 'chat_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  final Set<int> _initializedTabs = {0}; // Only build tabs when first visited

  final _tabs = const [
    _TabItem(icon: Icons.home_rounded, label: 'Home'),
    _TabItem(icon: Icons.calendar_today_rounded, label: 'Bookings'),
    _TabItem(icon: Icons.map_rounded, label: 'Map'),
    _TabItem(icon: Icons.shopping_cart_rounded, label: 'Cart'),
    _TabItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  void _switchToTab(int index) {
    setState(() {
      _initializedTabs.add(index);
      _currentIndex = index;
    });
  }

  Widget _buildTab(int index) {
    switch (index) {
      case 0:
        return HomeScreen(onProfileTap: () => _switchToTab(4));
      case 1:
        return const BookingsScreen();
      case 2:
        return const MapScreen();
      case 3:
        return const CartScreen();
      case 4:
        return const ProfileScreen();
      default:
        return _placeholder(_tabs[index].label);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: IndexedStack(
        index: _currentIndex,
        children: List.generate(_tabs.length, (i) {
          if (_initializedTabs.contains(i)) {
            return _buildTab(i);
          }
          // Return empty placeholder until tab is first selected
          return const SizedBox.shrink();
        }),
      ),
      floatingActionButton: _buildChatFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.06),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_tabs.length, (i) {
                final tab = _tabs[i];
                final active = i == _currentIndex;
                return GestureDetector(
                  onTap: () => _switchToTab(i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            tab.icon,
                            color: active
                                ? const Color(0xFFFF8C00)
                                : Colors.white.withValues(alpha: 0.35),
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tab.label,
                          style: TextStyle(
                            fontFamily: 'DarkerGrotesque',
                            color: active
                                ? const Color(0xFFFF8C00)
                                : Colors.white.withValues(alpha: 0.3),
                            fontSize: 11,
                            fontWeight: active
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatFab() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 56),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, _, _) => const ChatScreen(),
              transitionsBuilder: (_, animation, _, child) {
                return SlideTransition(
                  position:
                      Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 400),
            ),
          );
        },
        child: SizedBox(
          width: 64,
          height: 72,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Glow effect behind the mascot
              Positioned(
                bottom: 2,
                child: Container(
                  width: 40,
                  height: 12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF8C00).withValues(alpha: 0.4),
                        blurRadius: 18,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
              // Full mascot image
              Image.asset(
                'assets/images/ai_assistant.png',
                width: 64,
                height: 72,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF8C00), Color(0xFFE77728)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder(String title) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.construction_rounded,
            color: Colors.white.withValues(alpha: 0.2),
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'DarkerGrotesque',
              color: Colors.white.withValues(alpha: 0.3),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Coming soon',
            style: TextStyle(
              fontFamily: 'DarkerGrotesque',
              color: Colors.white.withValues(alpha: 0.15),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem {
  final IconData icon;
  final String label;
  const _TabItem({required this.icon, required this.label});
}
