import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final VoidCallback? onProfileTap;
  const HomeScreen({super.key, this.onProfileTap});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  int _selectedCategory = 0;
  String _searchQuery = '';
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  late AnimationController _entryController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  late Animation<double> _headerFade, _searchFade, _aiFade, _catFade;
  late Animation<Offset> _headerSlide, _searchSlide, _aiSlide, _catSlide;
  late Animation<double> _sectionFade;
  late Animation<Offset> _sectionSlide;
  late Animation<double> _fabFade;

  final _categories = const [
    _Cat(Icons.hotel_rounded, 'Hotels', '/hotels'),
    _Cat(Icons.directions_car_rounded, 'Vehicles', '/vehicules'),
    _Cat(Icons.explore_rounded, 'Experiences', '/experiences'),
    _Cat(Icons.restaurant_rounded, 'Restaurants', '/restaurants'),
    _Cat(Icons.storefront_rounded, 'Artisan Shop', '/boutiques'),
  ];

  // ── Data ──
  static const _hotels = [
    _Item('La Mamounia', 'Hivernage', 350, 4.9, 'assets/images/hotels/la_mamounia/1.png', '/hotel/hotel_002', 'hotel'),
    _Item('Riad Yasmine', 'Medina', 95, 4.6, 'assets/images/hotels/riad_yasmine/1.png', '/hotel/hotel_003', 'hotel'),
    _Item('La Sultana', 'Kasbah', 280, 4.8, 'assets/images/hotels/la_sultana/1.png', '/hotel/hotel_005', 'hotel'),
    _Item('Royal Mansour', 'Médina', 550, 4.9, 'assets/images/hotels/royal_mansour/1.png', '/hotel/hotel_008', 'hotel'),
  ];
  static const _vehicles = [
    _Item('Dacia Duster 2024', 'SUV · Diesel', 45, 4.6, 'assets/images/vehicules/dacia_duster/1.png', '/vehicule/vehicule_001', 'vehicle'),
    _Item('Renault Clio 5', 'Citadine · Essence', 22, 4.4, 'assets/images/vehicules/renault_clio/1.png', '/vehicule/vehicule_002', 'vehicle'),
    _Item('Mercedes Classe E', 'Berline · Luxe', 150, 4.9, 'assets/images/vehicules/mercedes_classe_e/1.png', '/vehicule/vehicule_003', 'vehicle'),
    _Item('Peugeot 3008', 'SUV · Familial', 65, 4.7, 'assets/images/vehicules/peugeot_3008/1.png', '/vehicule/vehicule_005', 'vehicle'),
  ];
  static const _experiences = [
    _Item('Safari Désert d\'Agafay', 'Aventure · 6h', 85, 4.8, 'assets/images/experiences/safari_agafay/1.png', '/experience/exp_001', 'experience'),
    _Item('Visite de la Médina', 'Culture · 3h', 35, 4.7, 'assets/images/experiences/medina_visite/1.png', '/experience/exp_002', 'experience'),
    _Item('Randonnée Atlas', 'Nature · 8h', 60, 4.9, 'assets/images/experiences/randonnee_atlas/1.png', '/experience/exp_003', 'experience'),
    _Item('Vol Montgolfière', 'Aventure · 2h', 180, 4.9, 'assets/images/experiences/vol_montgolfiere/1.png', '/experience/exp_005', 'experience'),
  ];
  static const _restaurants = [
    _Item('Le Jardin', 'Méditerranéen', 25, 4.7, 'assets/images/restaurants/le_jardin/1.png', '/restaurant/resto_001', 'restaurant'),
    _Item('Nomad', 'Marocain Moderne', 30, 4.8, 'assets/images/restaurants/nomad/1.png', '/restaurant/resto_002', 'restaurant'),
    _Item('Al Fassia', 'Cuisine Fassi', 35, 4.9, 'assets/images/restaurants/al_fassia/1.png', '/restaurant/resto_003', 'restaurant'),
    _Item('La Table du Palais', 'Français-Marocain', 120, 4.9, 'assets/images/restaurants/la_table_du_palais/1.png', '/restaurant/resto_005', 'restaurant'),
  ];
  static const _boutiques = [
    _Item('Tapis Berbères El Badi', 'Tapis · Fait main', 0, 4.8, 'assets/images/boutiques/tapis_berberes/1.png', '/boutique/boutique_001', 'boutique'),
    _Item('Céramique Safi', 'Poterie · Zellige', 0, 4.7, 'assets/images/boutiques/ceramique_safi/1.png', '/boutique/boutique_002', 'boutique'),
    _Item('Maroquinerie Youssef', 'Cuir · Babouches', 0, 4.6, 'assets/images/boutiques/maroquinerie_youssef/1.png', '/boutique/boutique_003', 'boutique'),
    _Item('Bijoux Touareg Amina', 'Bijoux · Argent', 0, 4.9, 'assets/images/boutiques/bijoux_touareg/1.png', '/boutique/boutique_004', 'boutique'),
  ];

  List<_Item> get _allItems => [..._hotels, ..._vehicles, ..._experiences, ..._restaurants, ..._boutiques];

  List<_Item> get _searchResults {
    if (_searchQuery.isEmpty) return [];
    final q = _searchQuery.toLowerCase();
    return _allItems.where((i) => i.name.toLowerCase().contains(q) || i.subtitle.toLowerCase().contains(q)).toList();
  }

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..forward();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.3, end: 0.6).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
    _headerFade = _f(0.0, 0.25); _headerSlide = _s(0.0, 0.25);
    _searchFade = _f(0.1, 0.35); _searchSlide = _s(0.1, 0.35);
    _aiFade = _f(0.15, 0.45); _aiSlide = _s(0.15, 0.45);
    _catFade = _f(0.25, 0.55); _catSlide = _s(0.25, 0.55);
    _sectionFade = _f(0.35, 0.7); _sectionSlide = _s(0.35, 0.7);
    _fabFade = _f(0.7, 1.0);
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text);
    });
  }

  Animation<double> _f(double a, double b) => Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _entryController, curve: Interval(a, b, curve: Curves.easeOut)));
  Animation<Offset> _s(double a, double b) => Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(CurvedAnimation(parent: _entryController, curve: Interval(a, b, curve: Curves.easeOutCubic)));

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _carouselController.dispose();
    _entryController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  final PageController _carouselController = PageController(viewportFraction: 0.85);

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 18) return 'Good afternoon';
    return 'Good evening';
  }

  String _firstName() {
    final user = ref.read(authProvider).currentUser;
    if (user != null && user.nom.isNotEmpty) return user.nom.split(' ').first;
    return 'Traveler';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(top: -80, right: -60, child: RepaintBoundary(
          child: AnimatedBuilder(animation: _pulseAnim, builder: (c, _) => _orb(240, _pulseAnim.value * 0.08)),
        )),
        AnimatedBuilder(
          animation: _entryController,
          builder: (context, _) => SafeArea(
            child: _searchQuery.isNotEmpty ? _buildSearchResults() : _buildMainContent(),
          ),
        ),
        Positioned(bottom: 24, right: 20, child: FadeTransition(opacity: _fabFade, child: _buildFab())),
      ],
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildHeader(),
          const SizedBox(height: 18),
          _buildSearchBar(),
          const SizedBox(height: 16),
          _buildAiBanner(),
          const SizedBox(height: 24),
          _buildCategories(),
          const SizedBox(height: 24),
          FadeTransition(opacity: _sectionFade, child: SlideTransition(position: _sectionSlide, child: Column(children: [
            _buildSection('🏨  Popular Hotels', '/hotels', _hotels, '/night'),
            const SizedBox(height: 24),
            _buildSection('🚗  Rent a Car', '/vehicules', _vehicles, '/day'),
            const SizedBox(height: 24),
            _buildSection('🌟  Top Experiences', '/experiences', _experiences, '/pers'),
            const SizedBox(height: 24),
            _buildSection('🍽️  Restaurants', '/restaurants', _restaurants, '/avg'),
            const SizedBox(height: 24),
            _buildSection('🛍️  Artisan Shops', '/boutiques', _boutiques, ''),
          ]))),
        ]),
      ),
    );
  }

  Widget _buildSearchResults() {
    final results = _searchResults;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildHeader(),
      const SizedBox(height: 18),
      _buildSearchBar(),
      const SizedBox(height: 16),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text(
        results.isEmpty ? 'No results for "$_searchQuery"' : '${results.length} results',
        style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.5), fontSize: 14, fontWeight: FontWeight.w500),
      )),
      const SizedBox(height: 12),
      Expanded(child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
        itemCount: results.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (ctx, i) {
          final item = results[i];
          return GestureDetector(
            onTap: () { _searchFocusNode.unfocus(); context.push(item.route); },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withValues(alpha: 0.06))),
              child: Row(children: [
                ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset(item.image, width: 56, height: 56, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 56, height: 56, color: const Color(0xFF2A2A2A), child: const Icon(Icons.image, color: Color(0xFF555555))))),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item.name, style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(item.subtitle, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.4), fontSize: 13)),
                ])),
                if (item.price > 0) Text('\$${item.price.toInt()}', style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Color(0xFFFF8C00), fontSize: 16, fontWeight: FontWeight.w800)),
                Icon(Icons.chevron_right_rounded, color: Colors.white.withValues(alpha: 0.2), size: 20),
              ]),
            ),
          );
        },
      )),
    ]);
  }

  // ── Header ──
  Widget _buildHeader() {
    return FadeTransition(opacity: _headerFade, child: SlideTransition(position: _headerSlide, child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_greeting(), style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.45), fontSize: 14, fontWeight: FontWeight.w400)),
          Text('Hello, ${_firstName()}', style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, height: 1.2)),
        ])),
        // Marrakech badge — tappable → destinations
        GestureDetector(
          onTap: () => context.push('/destinations'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFFFF8C00).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFFF8C00).withValues(alpha: 0.3))),
            child: const Row(mainAxisSize: MainAxisSize.min, children: [
              DecoratedBox(decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFF8C00)), child: SizedBox(width: 6, height: 6)),
              SizedBox(width: 6),
              Text('Marrakech', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Color(0xFFFF8C00), fontSize: 12, fontWeight: FontWeight.w700)),
              SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFFFF8C00), size: 16),
            ]),
          ),
        ),
        const SizedBox(width: 10),
        // Profile avatar — tappable → profile tab
        GestureDetector(
          onTap: widget.onProfileTap,
          child: Container(
            width: 38, height: 38,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1.5), color: Colors.white.withValues(alpha: 0.08)),
            child: Icon(Icons.person_rounded, color: Colors.white.withValues(alpha: 0.5), size: 20),
          ),
        ),
      ]),
    )));
  }

  // ── Search ──
  Widget _buildSearchBar() {
    return FadeTransition(opacity: _searchFade, child: SlideTransition(position: _searchSlide, child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 48,
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withValues(alpha: 0.08))),
        child: Row(children: [
          const SizedBox(width: 14),
          Icon(Icons.search_rounded, color: Colors.white.withValues(alpha: 0.3), size: 20),
          const SizedBox(width: 10),
          Expanded(child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search hotels, experiences, crafts...',
              hintStyle: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.25), fontSize: 14),
              border: InputBorder.none, contentPadding: EdgeInsets.zero, isDense: true,
            ),
            cursorColor: const Color(0xFFFF8C00),
          )),
          if (_searchQuery.isNotEmpty) GestureDetector(
            onTap: () { _searchController.clear(); _searchFocusNode.unfocus(); },
            child: Padding(padding: const EdgeInsets.all(12), child: Icon(Icons.close_rounded, color: Colors.white.withValues(alpha: 0.4), size: 18)),
          ),
        ]),
      ),
    )));
  }

  // ── AI Banner ──
  Widget _buildAiBanner() {
    return FadeTransition(opacity: _aiFade, child: SlideTransition(position: _aiSlide, child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [const Color(0xFFFF8C00).withValues(alpha: 0.18), const Color(0xFFE77728).withValues(alpha: 0.08)]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFF8C00).withValues(alpha: 0.2)),
        ),
        child: Row(children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFFFF8C00).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.auto_awesome_rounded, color: Color(0xFFFF8C00), size: 22)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Ask our AI Travel Assistant', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
            Text('Get personalized recommendations instantly', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.45), fontSize: 12, fontWeight: FontWeight.w400)),
          ])),
          Icon(Icons.chat_bubble_outline_rounded, color: Colors.white.withValues(alpha: 0.3), size: 20),
        ]),
      ),
    )));
  }

  // ── Categories ──
  Widget _buildCategories() {
    return FadeTransition(opacity: _catFade, child: SlideTransition(position: _catSlide, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text('Categories', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800))),
      const SizedBox(height: 14),
      SizedBox(height: 80, child: ListView.builder(
        scrollDirection: Axis.horizontal, physics: const BouncingScrollPhysics(), padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, i) {
          final cat = _categories[i];
          final active = i == _selectedCategory;
          return GestureDetector(
            onTap: () { setState(() => _selectedCategory = i); context.push(cat.route); },
            child: AnimatedContainer(duration: const Duration(milliseconds: 250), width: 72, margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                AnimatedContainer(duration: const Duration(milliseconds: 250), width: 48, height: 48,
                  decoration: BoxDecoration(color: active ? const Color(0xFFFF8C00) : Colors.white.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: active ? const Color(0xFFFF8C00) : Colors.white.withValues(alpha: 0.08))),
                  child: Icon(cat.icon, color: active ? Colors.black : Colors.white.withValues(alpha: 0.45), size: 22)),
                const SizedBox(height: 6),
                Text(cat.label, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontFamily: 'DarkerGrotesque', color: active ? const Color(0xFFFF8C00) : Colors.white.withValues(alpha: 0.4), fontSize: 11, fontWeight: active ? FontWeight.w700 : FontWeight.w500)),
              ])),
          );
        },
      )),
    ])));
  }

  // ── Section with horizontal scroll ──
  Widget _buildSection(String title, String seeAllRoute, List<_Item> items, String priceSuffix) {
    return Column(children: [
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(child: Text(title, style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800))),
        GestureDetector(onTap: () => context.push(seeAllRoute), child: Text('See all', style: TextStyle(fontFamily: 'DarkerGrotesque', color: const Color(0xFFFF8C00).withValues(alpha: 0.85), fontSize: 14, fontWeight: FontWeight.w600))),
      ])),
      const SizedBox(height: 14),
      SizedBox(height: 200, child: ListView.builder(
        scrollDirection: Axis.horizontal, physics: const BouncingScrollPhysics(), padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        itemBuilder: (ctx, i) {
          final item = items[i];
          return GestureDetector(
            onTap: () => context.push(item.route),
            child: Container(
              width: 160, margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withValues(alpha: 0.06))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Image
                ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: SizedBox(height: 110, width: double.infinity, child: Stack(fit: StackFit.expand, children: [
                    Image.asset(item.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: const Color(0xFF2A2A2A), child: const Center(child: Icon(Icons.image, size: 30, color: Color(0xFF555555))))),
                    Positioned(top: 8, right: 8, child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(8)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.star_rounded, color: Color(0xFFFF8C00), size: 12),
                        const SizedBox(width: 2),
                        Text(item.rating.toString(), style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                      ]),
                    )),
                  ]))),
                // Info
                Padding(padding: const EdgeInsets.fromLTRB(10, 8, 10, 10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(item.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.35), fontSize: 11)),
                  if (item.price > 0) ...[
                    const SizedBox(height: 4),
                    RichText(text: TextSpan(children: [
                      TextSpan(text: '\$${item.price.toInt()}', style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Color(0xFFFF8C00), fontSize: 15, fontWeight: FontWeight.w800)),
                      TextSpan(text: priceSuffix, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.3), fontSize: 11)),
                    ])),
                  ],
                ])),
              ]),
            ),
          );
        },
      )),
    ]);
  }

  // ── FAB ──
  Widget _buildFab() {
    return Container(width: 56, height: 56,
      decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFF8C00), Color(0xFFE77728)], begin: Alignment.topLeft, end: Alignment.bottomRight), shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: const Color(0xFFFF8C00).withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 6))]),
      child: Material(color: Colors.transparent, child: InkWell(borderRadius: BorderRadius.circular(28), onTap: () {}, child: const Icon(Icons.auto_awesome_rounded, color: Colors.black, size: 26))),
    );
  }

  Widget _orb(double size, double alpha) => Container(width: size, height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [const Color(0xFFFF8C00).withValues(alpha: alpha), Colors.transparent])));
}

// ── Data classes ──
class _Cat {
  final IconData icon;
  final String label;
  final String route;
  const _Cat(this.icon, this.label, this.route);
}

class _Item {
  final String name, subtitle, image, route, type;
  final double price, rating;
  const _Item(this.name, this.subtitle, this.price, this.rating, this.image, this.route, this.type);
}
