import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/kurgate_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      imageUrl: 'assets/images/onboarding/discover_morocco.png',
      isLocal: true,
      title: 'Discover Morocco',
      description:
          'Your ultimate AI companion to discover destinations, book accommodations, rent vehicles, and explore local artisans.',
      subtitle:
          'Plan your perfect trip with personalized recommendations powered by artificial intelligence.',
    ),
    OnboardingData(
      imageUrl: 'assets/images/onboarding/smart_recommendations.png',
      isLocal: true,
      title: 'Smart Recommendations',
      description:
          'Get AI-powered suggestions tailored to your interests, budget, and travel style for an unforgettable experience.',
      subtitle:
          'From hidden gems to popular landmarks, we curate the best of Morocco just for you.',
    ),
    OnboardingData(
      imageUrl: 'assets/images/onboarding/book_with_ease.png',
      isLocal: true,
      title: 'Book with Ease',
      description:
          'Seamlessly book hotels, riads, cars, and guided tours all in one place with instant confirmation.',
      subtitle:
          'Experience hassle-free travel planning with secure payments and 24/7 customer support.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Logo area
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'assets/images/branding/logo_full.png',
                  height: 60,
                ),
              ),
            ),

            // PageView content with custom transitions
            Expanded(
              child: AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  return PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      // Calculate how far this page is from center
                      double pageOffset = 0.0;
                      if (_pageController.position.haveDimensions) {
                        pageOffset = (_pageController.page ?? 0.0) - index;
                      }
                      return _buildPage(_pages[index], pageOffset, screenWidth);
                    },
                  );
                },
              ),
            ),

            // Bottom section with dots and button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: Column(
                children: [
                  // Page indicators
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_pages.length, (index) {
                        final isActive = index == _currentPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.only(right: 8),
                          height: 6,
                          width: isActive ? 28 : 8,
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFFFF8C00)
                                : Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      }),
                    ),
                  ),

                  // Get Started button
                  KurgateButton(
                    label: _currentPage < _pages.length - 1
                        ? 'Next'
                        : 'Get Started',
                    trailingIcon: Icons.arrow_forward_rounded,
                    onPressed: () {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOutCubic,
                        );
                      } else {
                        context.go('/login');
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingData data, double pageOffset, double screenWidth) {
    final clampedOffset = pageOffset.clamp(-1.0, 1.0);
    const double imageParallax = 0.3;
    const double titleParallax = 0.5;
    const double descParallax = 0.7;
    const double subtitleParallax = 0.9;
    final opacity = (1 - clampedOffset.abs()).clamp(0.0, 1.0);
    final imageScale = 1.0 - (clampedOffset.abs() * 0.1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          // Image
          Transform.translate(
            offset: Offset(clampedOffset * screenWidth * imageParallax, 0),
            child: Transform.scale(
              scale: imageScale.clamp(0.85, 1.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.saturation,
                    ),
                    child: data.isLocal
                        ? Image.asset(
                            data.imageUrl,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            data.imageUrl,
                            fit: BoxFit.cover,
                            cacheWidth: 800,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color(0xFF2A2A2A),
                                child: const Center(
                                  child: Icon(Icons.landscape, size: 60, color: Color(0xFF555555)),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Title
          Transform.translate(
            offset: Offset(clampedOffset * screenWidth * titleParallax, 0),
            child: Text(
              data.title,
              style: TextStyle(
                fontFamily: 'DarkerGrotesque',
                color: Colors.white.withValues(alpha: opacity),
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                height: 1.2,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Description
          Flexible(
            child: Transform.translate(
              offset: Offset(clampedOffset * screenWidth * descParallax, 0),
              child: Text(
                data.description,
                style: TextStyle(
                  fontFamily: 'DarkerGrotesque',
                  color: Colors.white.withValues(alpha: opacity * 0.7),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Subtitle
          Transform.translate(
            offset: Offset(clampedOffset * screenWidth * subtitleParallax, 0),
            child: Text(
              data.subtitle,
              style: TextStyle(
                fontFamily: 'DarkerGrotesque',
                color: Colors.white.withValues(alpha: opacity * 0.4),
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String imageUrl;
  final bool isLocal;
  final String title;
  final String description;
  final String subtitle;

  const OnboardingData({
    required this.imageUrl,
    this.isLocal = false,
    required this.title,
    required this.description,
    required this.subtitle,
  });
}
