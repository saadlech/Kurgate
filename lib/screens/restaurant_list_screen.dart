import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen({super.key});
  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen>
    with TickerProviderStateMixin {
  int _selectedFilter = 0;
  final _searchController = TextEditingController();
  late AnimationController _entryController;
  late Animation<double> _headerFade, _searchFade, _filterFade;
  late Animation<Offset> _headerSlide;
  final List<Animation<double>> _cardFades = [];
  final List<Animation<Offset>> _cardSlides = [];

  final _filters = const [
    'Tous',
    'Marocain',
    'International',
    'Rooftop',
    'Street Food',
  ];

  final _restaurants = const [
    _RestaurantData(
      id: 'resto_001',
      name: 'Le Jardin',
      location: 'Souk Sidi Abdelaziz, Médina',
      price: 25,
      rating: 4.7,
      reviews: 487,
      imageUrl: 'assets/images/restaurants/le_jardin/1.png',
      tags: ['Terrasse', 'Végétarien', 'Bio'],
      category: 'International',
      specialite: 'Méditerranéen',
      horaires: '12h-23h',
    ),
    _RestaurantData(
      id: 'resto_002',
      name: 'Nomad',
      location: 'Derb Aarjan, Médina',
      price: 30,
      rating: 4.8,
      reviews: 623,
      imageUrl: 'assets/images/restaurants/nomad/1.png',
      tags: ['Rooftop', 'Vue Médina', 'Cocktails'],
      category: 'Rooftop',
      specialite: 'Marocain Moderne',
      horaires: '10h-23h',
    ),
    _RestaurantData(
      id: 'resto_003',
      name: 'Al Fassia',
      location: 'Guéliz, Marrakech',
      price: 35,
      rating: 4.9,
      reviews: 389,
      imageUrl: 'assets/images/restaurants/al_fassia/1.png',
      tags: ['Tajine', 'Couscous', 'Familial'],
      category: 'Marocain',
      specialite: 'Cuisine Fassi',
      horaires: '12h-14h30 · 19h-23h',
    ),
    _RestaurantData(
      id: 'resto_004',
      name: 'CAFE CLOCK',
      location: 'Derb Chtouka, Kasbah',
      price: 12,
      rating: 4.5,
      reviews: 712,
      imageUrl: 'assets/images/restaurants/cafe_clock/1.png',
      tags: ['Burger Chameau', 'Live Music', 'Culturel'],
      category: 'Street Food',
      specialite: 'Fusion',
      horaires: '9h-22h',
    ),
    _RestaurantData(
      id: 'resto_005',
      name: 'La Table du Palais',
      location: 'Royal Mansour, Médina',
      price: 120,
      rating: 4.9,
      reviews: 234,
      imageUrl: 'assets/images/restaurants/la_table_du_palais/1.png',
      tags: ['Gastronomique', 'Étoilé', 'Luxe'],
      category: 'International',
      specialite: 'Français-Marocain',
      horaires: '19h-23h',
    ),
    _RestaurantData(
      id: 'resto_006',
      name: 'Chez Lamine Hadj Mustapha',
      location: 'Place Jemaa el-Fna',
      price: 8,
      rating: 4.6,
      reviews: 1024,
      imageUrl: 'assets/images/restaurants/chez_lamine/1.png',
      tags: ['Tanjia', 'Authentique', 'Populaire'],
      category: 'Street Food',
      specialite: 'Tanjia Marrakchia',
      horaires: '11h-22h',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
    _headerFade = _makeFade(0.0, 0.3);
    _headerSlide = _makeSlide(0.0, 0.3);
    _searchFade = _makeFade(0.1, 0.4);
    _filterFade = _makeFade(0.15, 0.5);
    for (int i = 0; i < _restaurants.length; i++) {
      final d = 0.2 + (i * 0.12);
      final e = (d + 0.3).clamp(0.0, 1.0);
      _cardFades.add(_makeFade(d, e));
      _cardSlides.add(_makeSlide(d, e));
    }
  }

  Animation<double> _makeFade(double s, double e) =>
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _entryController,
          curve: Interval(s, e, curve: Curves.easeOut),
        ),
      );
  Animation<Offset> _makeSlide(double s, double e) =>
      Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _entryController,
          curve: Interval(s, e, curve: Curves.easeOutCubic),
        ),
      );
  @override
  void dispose() {
    _searchController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  List<_RestaurantData> get _filtered {
    if (_selectedFilter == 0) return _restaurants;
    return _restaurants
        .where((r) => r.category == _filters[_selectedFilter])
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: AnimatedBuilder(
        animation: _entryController,
        builder: (context, _) {
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                FadeTransition(
                  opacity: _headerFade,
                  child: SlideTransition(
                    position: _headerSlide,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => context.pop(),
                            icon: const Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Restaurants',
                                style: TextStyle(
                                  fontFamily: 'DarkerGrotesque',
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              Text(
                                'Marrakech · ${_filtered.length} adresses',
                                style: TextStyle(
                                  fontFamily: 'DarkerGrotesque',
                                  color: Colors.white.withValues(alpha: 0.4),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Search
                FadeTransition(
                  opacity: _searchFade,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 14),
                          Icon(
                            Icons.search_rounded,
                            color: Colors.white.withValues(alpha: 0.3),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(
                                fontFamily: 'DarkerGrotesque',
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Rechercher un restaurant...',
                                hintStyle: TextStyle(
                                  fontFamily: 'DarkerGrotesque',
                                  color: Colors.white.withValues(alpha: 0.25),
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                              ),
                              cursorColor: const Color(0xFFFF8C00),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Filters
                FadeTransition(
                  opacity: _filterFade,
                  child: SizedBox(
                    height: 36,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _filters.length,
                      itemBuilder: (context, i) {
                        final active = i == _selectedFilter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedFilter = i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: active
                                    ? const Color(0xFFFF8C00)
                                    : Colors.white.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: active
                                      ? const Color(0xFFFF8C00)
                                      : Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                              child: Text(
                                _filters[i],
                                style: TextStyle(
                                  fontFamily: 'DarkerGrotesque',
                                  color: active
                                      ? Colors.black
                                      : Colors.white.withValues(alpha: 0.6),
                                  fontSize: 13,
                                  fontWeight: active
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // List
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final r = _filtered[index];
                      final fi = index.clamp(0, _cardFades.length - 1);
                      return FadeTransition(
                        opacity: _cardFades[fi],
                        child: SlideTransition(
                          position: _cardSlides[fi],
                          child: _RestaurantCard(
                            restaurant: r,
                            onTap: () => context.push('/restaurant/${r.id}'),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  const _RestaurantCard({required this.restaurant, required this.onTap});
  final _RestaurantData restaurant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      restaurant.imageUrl,
                      fit: BoxFit.cover,
                      cacheWidth: 600,
                      gaplessPlayback: true,
                      errorBuilder: (_, _, _) => Container(
                        color: const Color(0xFF2A2A2A),
                        child: const Center(
                          child: Icon(
                            Icons.restaurant_rounded,
                            size: 40,
                            color: Color(0xFF555555),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF8C00).withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      restaurant.category,
                      style: const TextStyle(
                        fontFamily: 'DarkerGrotesque',
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFF8C00),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          restaurant.rating.toString(),
                          style: const TextStyle(
                            fontFamily: 'DarkerGrotesque',
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: const TextStyle(
                            fontFamily: 'DarkerGrotesque',
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '\$${restaurant.price}',
                              style: const TextStyle(
                                fontFamily: 'DarkerGrotesque',
                                color: Color(0xFFFF8C00),
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: '/moy',
                              style: TextStyle(
                                fontFamily: 'DarkerGrotesque',
                                color: Colors.white.withValues(alpha: 0.35),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.white.withValues(alpha: 0.4),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          restaurant.location,
                          style: TextStyle(
                            fontFamily: 'DarkerGrotesque',
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _specChip(
                        Icons.restaurant_menu_rounded,
                        restaurant.specialite,
                      ),
                      const SizedBox(width: 8),
                      _specChip(Icons.access_time_rounded, restaurant.horaires),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (i) => Icon(
                          i < restaurant.rating.floor()
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: const Color(0xFFFF8C00),
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '(${restaurant.reviews} avis)',
                        style: TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          color: Colors.white.withValues(alpha: 0.35),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: restaurant.tags
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontFamily: 'DarkerGrotesque',
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _specChip(IconData icon, String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFFFF8C00).withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: const Color(0xFFFF8C00).withValues(alpha: 0.15),
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: const Color(0xFFFF8C00).withValues(alpha: 0.7),
          size: 13,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'DarkerGrotesque',
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

class _RestaurantData {
  final String id, name, location, imageUrl, category, specialite, horaires;
  final int price, reviews;
  final double rating;
  final List<String> tags;
  const _RestaurantData({
    required this.id,
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
    required this.tags,
    required this.category,
    required this.specialite,
    required this.horaires,
  });
}
