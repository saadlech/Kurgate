import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/destination_provider.dart';

class HotelListScreen extends ConsumerStatefulWidget {
  const HotelListScreen({super.key});

  @override
  ConsumerState<HotelListScreen> createState() => _HotelListScreenState();
}

class _HotelListScreenState extends ConsumerState<HotelListScreen>
    with TickerProviderStateMixin {
  int _selectedFilter = 0;
  final _searchController = TextEditingController();

  late AnimationController _entryController;

  // Pre-computed animations
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _searchFade;
  late Animation<double> _filterFade;
  final List<Animation<double>> _cardFades = [];
  final List<Animation<Offset>> _cardSlides = [];

  final _filters = const ['Tous', 'Riad', 'Luxe', 'Resort', 'Budget'];

  // Sample hotel data
  final _hotels = const [
    _HotelData(
      id: 'hotel_002',
      name: 'La Mamounia',
      location: 'Hivernage, Marrakech',
      price: 350,
      rating: 4.9,
      reviews: 512,
      imageUrl:
          'https://images.unsplash.com/photo-1548018560-c7196e4f6bec?w=600&q=80',
      imageAssets: [
        'assets/images/marrakech/hotels/la_mamounia/1.png',
        'assets/images/marrakech/hotels/la_mamounia/2.png',
        'assets/images/marrakech/hotels/la_mamounia/3.png',
        'assets/images/marrakech/hotels/la_mamounia/4.png',
        'assets/images/marrakech/hotels/la_mamounia/5.png',
        'assets/images/marrakech/hotels/la_mamounia/6.png',
      ],
      tags: ['5 étoiles', 'Spa', 'Restaurant'],
      category: 'Luxe',
    ),
    _HotelData(
      id: 'hotel_003',
      name: 'Riad Yasmine',
      location: 'Medina, Marrakech',
      price: 95,
      rating: 4.6,
      reviews: 187,
      imageUrl:
          'https://images.unsplash.com/photo-1591378603223-e15b45a81640?w=600&q=80',
      imageAssets: [
        'assets/images/marrakech/hotels/riad_yasmine/1.png',
        'assets/images/marrakech/hotels/riad_yasmine/2.png',
        'assets/images/marrakech/hotels/riad_yasmine/3.png',
        'assets/images/marrakech/hotels/riad_yasmine/4.png',
        'assets/images/marrakech/hotels/riad_yasmine/5.png',
        'assets/images/marrakech/hotels/riad_yasmine/6.png',
      ],
      tags: ['Riad', 'Jardin', 'Terrasse'],
      category: 'Riad',
    ),
    _HotelData(
      id: 'hotel_005',
      name: 'La Sultana',
      location: 'Kasbah, Marrakech',
      price: 280,
      rating: 4.8,
      reviews: 389,
      imageUrl:
          'https://images.unsplash.com/photo-1548018560-c7196e4f6bec?w=600&q=80',
      imageAssets: [
        'assets/images/marrakech/hotels/la_sultana/1.png',
        'assets/images/marrakech/hotels/la_sultana/2.png',
        'assets/images/marrakech/hotels/la_sultana/3.png',
        'assets/images/marrakech/hotels/la_sultana/4.png',
        'assets/images/marrakech/hotels/la_sultana/5.png',
        'assets/images/marrakech/hotels/la_sultana/6.png',
      ],
      tags: ['5 étoiles', 'Spa', 'Terrasse'],
      category: 'Luxe',
    ),
    _HotelData(
      id: 'hotel_006',
      name: 'Mandarin Oriental',
      location: 'Route de la Palmeraie, Marrakech',
      price: 420,
      rating: 4.9,
      reviews: 456,
      imageUrl:
          'https://images.unsplash.com/photo-1597212618440-806262de4f6b?w=600&q=80',
      imageAssets: [
        'assets/images/marrakech/hotels/mandarin_oriental/1.png',
        'assets/images/marrakech/hotels/mandarin_oriental/2.png',
        'assets/images/marrakech/hotels/mandarin_oriental/3.png',
        'assets/images/marrakech/hotels/mandarin_oriental/4.png',
        'assets/images/marrakech/hotels/mandarin_oriental/5.png',
        'assets/images/marrakech/hotels/mandarin_oriental/6.png',
      ],
      tags: ['5 étoiles', 'Villas', 'Piscine'],
      category: 'Luxe',
    ),
    _HotelData(
      id: 'hotel_007',
      name: 'Riad Kniza',
      location: 'Medina, Marrakech',
      price: 200,
      rating: 4.7,
      reviews: 278,
      imageUrl:
          'https://images.unsplash.com/photo-1590073242678-70ee3fc28e8e?w=600&q=80',
      imageAssets: [
        'assets/images/marrakech/hotels/riad_kniza/1.png',
        'assets/images/marrakech/hotels/riad_kniza/2.png',
        'assets/images/marrakech/hotels/riad_kniza/3.png',
        'assets/images/marrakech/hotels/riad_kniza/4.png',
        'assets/images/marrakech/hotels/riad_kniza/5.png',
        'assets/images/marrakech/hotels/riad_kniza/6.png',
      ],
      tags: ['Riad', 'Spa', 'Restaurant'],
      category: 'Riad',
    ),
    _HotelData(
      id: 'hotel_008',
      name: 'Royal Mansour',
      location: 'Médina, Marrakech',
      price: 550,
      rating: 4.9,
      reviews: 623,
      imageUrl:
          'https://images.unsplash.com/photo-1548018560-c7196e4f6bec?w=600&q=80',
      imageAssets: [
        'assets/images/marrakech/hotels/royal_mansour/1.png',
        'assets/images/marrakech/hotels/royal_mansour/2.png',
        'assets/images/marrakech/hotels/royal_mansour/3.png',
        'assets/images/marrakech/hotels/royal_mansour/4.png',
        'assets/images/marrakech/hotels/royal_mansour/5.png',
        'assets/images/marrakech/hotels/royal_mansour/6.png',
      ],
      tags: ['5 étoiles', 'Palace', 'Spa'],
      category: 'Luxe',
    ),
  ];

  // Casablanca hotels
  final _hotelsCasa = const [
    _HotelData(
      id: 'hotel_casa_001', name: 'Four Seasons Casablanca', location: 'Anfa Place, Casablanca',
      price: 380, rating: 4.9, reviews: 412,
      imageUrl: 'assets/images/casablanca/hotels/four_seasons_casa/1.png',
      imageAssets: ['assets/images/casablanca/hotels/four_seasons_casa/1.png', 'assets/images/casablanca/hotels/four_seasons_casa/2.png', 'assets/images/casablanca/hotels/four_seasons_casa/3.png'],
      tags: ['5 étoiles', 'Spa', 'Piscine'], category: 'Luxe',
    ),
    _HotelData(
      id: 'hotel_casa_002', name: 'Hôtel & Spa Le Doge', location: 'Quartier Gauthier, Casablanca',
      price: 250, rating: 4.8, reviews: 287,
      imageUrl: 'assets/images/casablanca/hotels/le_doge_casa/1.png',
      imageAssets: ['assets/images/casablanca/hotels/le_doge_casa/1.png', 'assets/images/casablanca/hotels/le_doge_casa/2.png', 'assets/images/casablanca/hotels/le_doge_casa/3.png'],
      tags: ['Art Déco', 'Spa', 'Charme'], category: 'Luxe',
    ),
    _HotelData(
      id: 'hotel_casa_003', name: 'Hyatt Regency Casablanca', location: 'Place des Nations Unies, Casablanca',
      price: 180, rating: 4.7, reviews: 534,
      imageUrl: 'assets/images/casablanca/hotels/hyatt_casa/1.png',
      imageAssets: ['assets/images/casablanca/hotels/hyatt_casa/1.png', 'assets/images/casablanca/hotels/hyatt_casa/2.png', 'assets/images/casablanca/hotels/hyatt_casa/3.png'],
      tags: ['Business', 'Restaurant', 'Centre-ville'], category: 'Business',
    ),
    _HotelData(
      id: 'hotel_casa_004', name: 'Kenzi Tower Hotel', location: 'Twin Center, Casablanca',
      price: 160, rating: 4.6, reviews: 389,
      imageUrl: 'assets/images/casablanca/hotels/kenzi_tower/1.png',
      imageAssets: ['assets/images/casablanca/hotels/kenzi_tower/1.png', 'assets/images/casablanca/hotels/kenzi_tower/2.png', 'assets/images/casablanca/hotels/kenzi_tower/3.png'],
      tags: ['Panoramique', 'Business', 'Spa'], category: 'Business',
    ),
    _HotelData(
      id: 'hotel_casa_005', name: 'Sofitel Casablanca', location: 'Tour Blanche, Casablanca',
      price: 300, rating: 4.8, reviews: 445,
      imageUrl: 'assets/images/casablanca/hotels/sofitel_casa/1.png',
      imageAssets: ['assets/images/casablanca/hotels/sofitel_casa/1.png', 'assets/images/casablanca/hotels/sofitel_casa/2.png', 'assets/images/casablanca/hotels/sofitel_casa/3.png'],
      tags: ['5 étoiles', 'Gastronomie', 'Luxe'], category: 'Luxe',
    ),
    _HotelData(
      id: 'hotel_casa_006', name: 'Hôtel Transatlantique', location: 'Rue El Ouahda, Casablanca',
      price: 75, rating: 4.3, reviews: 623,
      imageUrl: 'assets/images/casablanca/hotels/transatlantique/1.png',
      imageAssets: ['assets/images/casablanca/hotels/transatlantique/1.png', 'assets/images/casablanca/hotels/transatlantique/2.png', 'assets/images/casablanca/hotels/transatlantique/3.png'],
      tags: ['Historique', 'Centre', 'Économique'], category: 'Budget',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    // Pre-compute all animations once
    _headerFade = _makeFade(0.0, 0.3);
    _headerSlide = _makeSlide(0.0, 0.3);
    _searchFade = _makeFade(0.1, 0.4);
    _filterFade = _makeFade(0.15, 0.5);

    // Pre-compute card animations for all hotels
    for (int i = 0; i < _hotels.length; i++) {
      final delay = 0.2 + (i * 0.12);
      final end = (delay + 0.3).clamp(0.0, 1.0);
      _cardFades.add(_makeFade(delay, end));
      _cardSlides.add(_makeSlide(delay, end));
    }
  }

  Animation<double> _makeFade(double s, double e) =>
      Tween<double>(begin: 0.0, end: 1.0).animate(
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

  List<_HotelData> get _activeHotels {
    final isCasa = ref.watch(selectedDestinationProvider).idDestination == 'dest_002';
    return isCasa ? _hotelsCasa : _hotels;
  }

  List<_HotelData> get _filteredHotels {
    final base = _activeHotels;
    if (_selectedFilter == 0) return base;
    final filterName = _filters[_selectedFilter];
    return base.where((h) => h.category == filterName).toList();
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
                                'Hôtels & Riads',
                                style: TextStyle(
                                  fontFamily: 'DarkerGrotesque',
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              Text(
                                '${ref.watch(selectedDestinationProvider).nom} · ${_filteredHotels.length} établissements',
                                style: TextStyle(
                                  fontFamily: 'DarkerGrotesque',
                                  color: Colors.white.withValues(alpha: 0.4),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
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

                // Search bar
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
                                hintText: 'Rechercher un hôtel...',
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

                // Filter chips
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

                // Hotel list
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    itemCount: _filteredHotels.length,
                    addAutomaticKeepAlives: false,
                    separatorBuilder: (_, _) => const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final hotel = _filteredHotels[index];
                      final fadeIdx = index.clamp(0, _cardFades.length - 1);

                      return FadeTransition(
                        opacity: _cardFades[fadeIdx],
                        child: SlideTransition(
                          position: _cardSlides[fadeIdx],
                          child: _HotelCard(
                            hotel: hotel,
                            onTap: () => context.push('/hotel/${hotel.id}'),
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

// ── Hotel Card ──
class _HotelCard extends StatefulWidget {
  const _HotelCard({required this.hotel, required this.onTap});
  final _HotelData hotel;
  final VoidCallback onTap;

  @override
  State<_HotelCard> createState() => _HotelCardState();
}

class _HotelCardState extends State<_HotelCard> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  bool get _hasGallery => widget.hotel.imageAssets.isNotEmpty;
  int get _imageCount =>
      _hasGallery ? widget.hotel.imageAssets.length : 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image gallery with rating badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: _hasGallery
                        ? PageView.builder(
                            controller: _pageController,
                            itemCount: _imageCount,
                            onPageChanged: (i) =>
                                setState(() => _currentPage = i),
                            itemBuilder: (ctx, i) => Image.asset(
                              widget.hotel.imageAssets[i],
                              fit: BoxFit.cover,
                              cacheWidth: 600,
                              gaplessPlayback: true,
                              errorBuilder: (ctx, e, s) => Container(
                                color: const Color(0xFF2A2A2A),
                                child: const Center(
                                  child: Icon(
                                    Icons.hotel_rounded,
                                    size: 40,
                                    color: Color(0xFF555555),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Image.network(
                            widget.hotel.imageUrl,
                            fit: BoxFit.cover,
                            cacheWidth: 600,
                            loadingBuilder: (ctx, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                color: const Color(0xFF2A2A2A),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFFF8C00),
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (ctx, e, s) => Container(
                              color: const Color(0xFF2A2A2A),
                              child: const Center(
                                child: Icon(
                                  Icons.hotel_rounded,
                                  size: 40,
                                  color: Color(0xFF555555),
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
                // Dot indicators for gallery
                if (_hasGallery)
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_imageCount, (i) {
                        final active = i == _currentPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: active ? 20 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: active
                                ? const Color(0xFFFF8C00)
                                : Colors.white.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      }),
                    ),
                  ),
                // Photo count badge
                if (_hasGallery)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.photo_library_rounded,
                            color: Colors.white,
                            size: 13,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${_currentPage + 1}/$_imageCount',
                            style: const TextStyle(
                              fontFamily: 'DarkerGrotesque',
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Rating badge
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
                          widget.hotel.rating.toString(),
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

            // Info
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
                          widget.hotel.name,
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
                              text: '\$${widget.hotel.price}',
                              style: const TextStyle(
                                fontFamily: 'DarkerGrotesque',
                                color: Color(0xFFFF8C00),
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: '/nuit',
                              style: TextStyle(
                                fontFamily: 'DarkerGrotesque',
                                color: Colors.white.withValues(alpha: 0.35),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
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
                      Text(
                        widget.hotel.location,
                        style: TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (i) => Icon(
                          i < widget.hotel.rating.floor()
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: const Color(0xFFFF8C00),
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '(${widget.hotel.reviews} avis)',
                        style: TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          color: Colors.white.withValues(alpha: 0.35),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Tags
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: widget.hotel.tags.map((tag) {
                      return Container(
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
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Hotel data ──
class _HotelData {
  final String id;
  final String name;
  final String location;
  final int price;
  final double rating;
  final int reviews;
  final String imageUrl;
  final List<String> imageAssets;
  final List<String> tags;
  final String category;

  const _HotelData({
    required this.id,
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
    this.imageAssets = const [],
    required this.tags,
    required this.category,
  });
}
