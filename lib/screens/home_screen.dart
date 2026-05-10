import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/offre_touristique.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  int _selectedCategory = 0;
  int _carouselPage = 0;
  final PageController _carouselController = PageController(viewportFraction: 0.85);

  late AnimationController _entryController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  // Pre-computed animations — created once in initState, not on every build
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _searchFade;
  late Animation<Offset> _searchSlide;
  late Animation<double> _aiFade;
  late Animation<Offset> _aiSlide;
  late Animation<double> _catFade;
  late Animation<Offset> _catSlide;
  late Animation<double> _exploreFade;
  late Animation<Offset> _exploreSlide;
  late Animation<double> _offersFade;
  late Animation<Offset> _offersSlide;
  late Animation<double> _fabFade;

  final _categories = const [
    _Category(icon: Icons.hotel_rounded, label: 'Hotels'),
    _Category(icon: Icons.directions_car_rounded, label: 'Vehicles'),
    _Category(icon: Icons.explore_rounded, label: 'Experiences'),
    _Category(icon: Icons.restaurant_rounded, label: 'Restaurants'),
    _Category(icon: Icons.storefront_rounded, label: 'Artisan Shop'),
  ];

  final _carouselImages = const [
    'https://images.unsplash.com/photo-1597212618440-806262de4f6b?w=800&q=80',
    'https://images.unsplash.com/photo-1558642452-9d2a7deb7f62?w=800&q=80',
    'https://images.unsplash.com/photo-1548018560-c7196e4f6bec?w=800&q=80',
  ];

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Pre-compute all entry animations once
    _headerFade = _makeFade(0.0, 0.25);
    _headerSlide = _makeSlide(0.0, 0.25);
    _searchFade = _makeFade(0.1, 0.35);
    _searchSlide = _makeSlide(0.1, 0.35);
    _aiFade = _makeFade(0.15, 0.45);
    _aiSlide = _makeSlide(0.15, 0.45);
    _catFade = _makeFade(0.25, 0.55);
    _catSlide = _makeSlide(0.25, 0.55);
    _exploreFade = _makeFade(0.35, 0.65);
    _exploreSlide = _makeSlide(0.35, 0.65);
    _offersFade = _makeFade(0.5, 0.8);
    _offersSlide = _makeSlide(0.5, 0.8);
    _fabFade = _makeFade(0.7, 1.0);
  }

  Animation<double> _makeFade(double s, double e) =>
      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _entryController,
        curve: Interval(s, e, curve: Curves.easeOut),
      ));

  Animation<Offset> _makeSlide(double s, double e) =>
      Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _entryController,
          curve: Interval(s, e, curve: Curves.easeOutCubic),
        ),
      );

  @override
  void dispose() {
    _carouselController.dispose();
    _entryController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 18) return 'Good afternoon';
    return 'Good evening';
  }

  String _firstName() {
    final user = ref.read(authProvider).currentUser;
    if (user != null && user.nom.isNotEmpty) {
      return user.nom.split(' ').first;
    }
    return 'Traveler';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background orb — ISOLATED AnimatedBuilder (only this repaints 60fps)
        Positioned(
          top: -80,
          right: -60,
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _pulseAnim,
              builder: (context, _) => _orb(240, _pulseAnim.value * 0.08),
            ),
          ),
        ),

        // Main content — only rebuilds during entry animation (1.2s), then stops
        AnimatedBuilder(
          animation: _entryController,
          builder: (context, _) {
            return SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 18),
                      _buildSearchBar(),
                      const SizedBox(height: 16),
                      _buildAiBanner(),
                      const SizedBox(height: 24),
                      _buildCategories(),
                      const SizedBox(height: 24),
                      _buildExploreSection(),
                      const SizedBox(height: 24),
                      _buildRecommendedOffers(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        // FAB
        Positioned(
          bottom: 24,
          right: 20,
          child: FadeTransition(
            opacity: _fabFade,
            child: _buildFab(),
          ),
        ),
      ],
    );
  }

  // ── Header ──
  Widget _buildHeader() {
    return FadeTransition(
      opacity: _headerFade,
      child: SlideTransition(
        position: _headerSlide,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _greeting(),
                      style: TextStyle(
                        fontFamily: 'DarkerGrotesque',
                        color: Colors.white.withValues(alpha: 0.45),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Hello, ${_firstName()}',
                      style: const TextStyle(
                        fontFamily: 'DarkerGrotesque',
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              // Marrakech badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8C00).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFFF8C00).withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFF8C00),
                      ),
                      child: SizedBox(width: 6, height: 6),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Marrakech',
                      style: TextStyle(
                        fontFamily: 'DarkerGrotesque',
                        color: Color(0xFFFF8C00),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Avatar
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 1.5,
                  ),
                  color: Colors.white.withValues(alpha: 0.08),
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: Colors.white.withValues(alpha: 0.5),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Search ──
  Widget _buildSearchBar() {
    return FadeTransition(
      opacity: _searchFade,
      child: SlideTransition(
        position: _searchSlide,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 14),
                Icon(Icons.search_rounded,
                    color: Colors.white.withValues(alpha: 0.3), size: 20),
                const SizedBox(width: 10),
                Text(
                  'Search hotels, experiences, crafts...',
                  style: TextStyle(
                    fontFamily: 'DarkerGrotesque',
                    color: Colors.white.withValues(alpha: 0.25),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── AI Banner ──
  Widget _buildAiBanner() {
    return FadeTransition(
      opacity: _aiFade,
      child: SlideTransition(
        position: _aiSlide,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFF8C00).withValues(alpha: 0.18),
                  const Color(0xFFE77728).withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFFF8C00).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                // Sparkle icon
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF8C00).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Color(0xFFFF8C00),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ask our AI Travel Assistant',
                        style: TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Get personalized recommendations instantly',
                        style: TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          color: Colors.white.withValues(alpha: 0.45),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chat_bubble_outline_rounded,
                    color: Colors.white.withValues(alpha: 0.3), size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Categories ──
  Widget _buildCategories() {
    return FadeTransition(
      opacity: _catFade,
      child: SlideTransition(
        position: _catSlide,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Categories',
                style: TextStyle(
                  fontFamily: 'DarkerGrotesque',
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, i) {
                  final cat = _categories[i];
                  final active = i == _selectedCategory;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedCategory = i);
                      // Navigate to the corresponding list screen
                      if (_categories[i].label == 'Hotels') {
                        context.push('/hotels');
                      } else if (_categories[i].label == 'Vehicles') {
                        context.push('/vehicules');
                      } else if (_categories[i].label == 'Experiences') {
                        context.push('/experiences');
                      } else if (_categories[i].label == 'Restaurants') {
                        context.push('/restaurants');
                      } else if (_categories[i].label == 'Artisan Shop') {
                        context.push('/boutiques');
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 72,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: 48, height: 48,
                            decoration: BoxDecoration(
                              color: active
                                  ? const Color(0xFFFF8C00)
                                  : Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: active
                                    ? const Color(0xFFFF8C00)
                                    : Colors.white.withValues(alpha: 0.08),
                              ),
                            ),
                            child: Icon(
                              cat.icon,
                              color: active
                                  ? Colors.black
                                  : Colors.white.withValues(alpha: 0.45),
                              size: 22,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            cat.label,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'DarkerGrotesque',
                              color: active
                                  ? const Color(0xFFFF8C00)
                                  : Colors.white.withValues(alpha: 0.4),
                              fontSize: 11,
                              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Explore Marrakech ──
  Widget _buildExploreSection() {
    return FadeTransition(
      opacity: _exploreFade,
      child: SlideTransition(
        position: _exploreSlide,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Text('✨ ', style: TextStyle(fontSize: 16)),
                      Text(
                        'Explore Marrakech',
                        style: TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Full map',
                    style: TextStyle(
                      fontFamily: 'DarkerGrotesque',
                      color: const Color(0xFFFF8C00).withValues(alpha: 0.85),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 160,
              child: PageView.builder(
                controller: _carouselController,
                onPageChanged: (p) => setState(() => _carouselPage = p),
                itemCount: _carouselImages.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        _carouselImages[i],
                        fit: BoxFit.cover,
                        cacheWidth: 800,
                        loadingBuilder: (ctx, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            color: const Color(0xFF2A2A2A),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFFF8C00),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (ctx, e, s) => Container(
                          color: const Color(0xFF2A2A2A),
                          child: const Center(
                            child: Icon(Icons.landscape_rounded,
                                size: 40, color: Color(0xFF555555)),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            // Page dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_carouselImages.length, (i) {
                final active = i == _carouselPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: active
                        ? const Color(0xFFFF8C00)
                        : Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ── Recommended Offers ──
  Widget _buildRecommendedOffers() {
    final offers = OffreTouristique.sampleOffers.take(2).toList();
    return FadeTransition(
      opacity: _offersFade,
      child: SlideTransition(
        position: _offersSlide,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recommended Offers',
                    style: TextStyle(
                      fontFamily: 'DarkerGrotesque',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'See all',
                    style: TextStyle(
                      fontFamily: 'DarkerGrotesque',
                      color: const Color(0xFFFF8C00).withValues(alpha: 0.85),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: offers.map((offer) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: offer == offers.first ? 8 : 0,
                        left: offer == offers.last ? 8 : 0,
                      ),
                      child: _OfferCard(offer: offer),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── FAB ──
  Widget _buildFab() {
    return Container(
      width: 56, height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF8C00), Color(0xFFE77728)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF8C00).withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () {},
          child: const Icon(
            Icons.auto_awesome_rounded,
            color: Colors.black,
            size: 26,
          ),
        ),
      ),
    );
  }

  Widget _orb(double size, double alpha) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            const Color(0xFFFF8C00).withValues(alpha: alpha),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

// ── Offer Card ──
class _OfferCard extends StatelessWidget {
  const _OfferCard({required this.offer});
  final OffreTouristique offer;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: Image.network(
                offer.imageUrl ?? '',
                fit: BoxFit.cover,
                cacheWidth: 400,
                loadingBuilder: (ctx, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: const Color(0xFF2A2A2A),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFF8C00), strokeWidth: 2,
                      ),
                    ),
                  );
                },
                errorBuilder: (ctx, e, s) => Container(
                  color: const Color(0xFF2A2A2A),
                  child: const Center(
                    child: Icon(Icons.image_rounded,
                        size: 30, color: Color(0xFF555555)),
                  ),
                ),
              ),
            ),
          ),
          // Info
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer.nom,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'DarkerGrotesque',
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  offer.type,
                  style: TextStyle(
                    fontFamily: 'DarkerGrotesque',
                    color: Colors.white.withValues(alpha: 0.35),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '\$${offer.prix.toInt()}',
                      style: const TextStyle(
                        fontFamily: 'DarkerGrotesque',
                        color: Color(0xFFFF8C00),
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      ' /night',
                      style: TextStyle(
                        fontFamily: 'DarkerGrotesque',
                        color: Colors.white.withValues(alpha: 0.3),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Category data ──
class _Category {
  final IconData icon;
  final String label;
  const _Category({required this.icon, required this.label});
}
