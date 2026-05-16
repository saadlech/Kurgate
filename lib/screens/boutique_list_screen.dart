import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/destination_provider.dart';

class BoutiqueListScreen extends ConsumerStatefulWidget {
  const BoutiqueListScreen({super.key});
  @override
  ConsumerState<BoutiqueListScreen> createState() => _BoutiqueListScreenState();
}

class _BoutiqueListScreenState extends ConsumerState<BoutiqueListScreen>
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
    'Tapis',
    'Poterie',
    'Cuir',
    'Bijoux',
    'Textile',
  ];

  final _boutiques = const [
    _BoutiqueData(
      id: 'boutique_001',
      name: 'Tapis Berbères El Badi',
      artisan: 'Maître Hassan El Badi',
      location: 'Souk des Tapis, Médina',
      rating: 4.8,
      reviews: 312,
      imageUrl: 'assets/images/marrakech/boutiques/tapis_berberes/1.png',
      tags: ['Fait main', 'Berbère', 'Laine'],
      category: 'Tapis',
      prixMoyen: '150-2000',
    ),
    _BoutiqueData(
      id: 'boutique_002',
      name: 'Atelier Céramique Safi',
      artisan: 'Fatima Zahra Bennani',
      location: 'Derb Dabachi, Médina',
      rating: 4.7,
      reviews: 198,
      imageUrl: 'assets/images/marrakech/boutiques/ceramique_safi/1.png',
      tags: ['Zellige', 'Assiettes', 'Vases'],
      category: 'Poterie',
      prixMoyen: '20-300',
    ),
    _BoutiqueData(
      id: 'boutique_003',
      name: 'Maroquinerie Artisanale Youssef',
      artisan: 'Youssef Amrani',
      location: 'Souk Cherratine, Médina',
      rating: 4.6,
      reviews: 456,
      imageUrl: 'assets/images/marrakech/boutiques/maroquinerie_youssef/1.png',
      tags: ['Babouches', 'Sacs', 'Ceintures'],
      category: 'Cuir',
      prixMoyen: '30-500',
    ),
    _BoutiqueData(
      id: 'boutique_004',
      name: 'Bijoux Touareg Amina',
      artisan: 'Amina Ait Brahim',
      location: 'Place des Ferblantiers',
      rating: 4.9,
      reviews: 167,
      imageUrl: 'assets/images/marrakech/boutiques/bijoux_touareg/1.png',
      tags: ['Argent', 'Touareg', 'Pierres'],
      category: 'Bijoux',
      prixMoyen: '50-800',
    ),
    _BoutiqueData(
      id: 'boutique_005',
      name: 'Tissages Tradition Amazigh',
      artisan: 'Khadija Oulhaj',
      location: 'Souk Haddadine, Médina',
      rating: 4.7,
      reviews: 234,
      imageUrl: 'assets/images/marrakech/boutiques/tissages_amazigh/1.png',
      tags: ['Caftans', 'Foulards', 'Coussins'],
      category: 'Textile',
      prixMoyen: '40-600',
    ),
    _BoutiqueData(
      id: 'boutique_006',
      name: 'Poterie d\'Art Tamegroute',
      artisan: 'Ahmed Bel Kacem',
      location: 'Quartier des Potiers',
      rating: 4.5,
      reviews: 289,
      imageUrl: 'assets/images/marrakech/boutiques/poterie_tamegroute/1.png',
      tags: ['Tamegroute', 'Vert', 'Traditionnel'],
      category: 'Poterie',
      prixMoyen: '15-200',
    ),
  ];

  // Casablanca boutiques
  final _boutiquesCasa = const [
    _BoutiqueData(
      id: 'boutique_casa_001', name: 'Derb Ghallef Vintage', artisan: 'Collectif Derb Ghallef',
      location: 'Derb Ghallef, Casablanca', rating: 4.5, reviews: 234,
      imageUrl: 'assets/images/casablanca/boutiques/derb_ghallef/1.png',
      tags: ['Vintage', 'Upcycle', 'Unique'], category: 'Textile', prixMoyen: '20-300',
    ),
    _BoutiqueData(
      id: 'boutique_casa_002', name: 'Quartier Habous Artisanat', artisan: 'Artisans du Habous',
      location: 'Quartier Habous, Casablanca', rating: 4.8, reviews: 456,
      imageUrl: 'assets/images/casablanca/boutiques/habous_artisanat/1.png',
      tags: ['Traditionnel', 'Babouches', 'Théières'], category: 'Cuir', prixMoyen: '30-500',
    ),
    _BoutiqueData(
      id: 'boutique_casa_003', name: 'Trésor des Arts Marocains', artisan: 'Karim El Mansouri',
      location: 'Rue Mohammed V, Casablanca', rating: 4.7, reviews: 312,
      imageUrl: 'assets/images/casablanca/boutiques/tresor_arts/1.png',
      tags: ['Tableaux', 'Sculptures', 'Déco'], category: 'Bijoux', prixMoyen: '50-1500',
    ),
    _BoutiqueData(
      id: 'boutique_casa_004', name: 'Maroquinerie Hassan', artisan: 'Hassan Berrada',
      location: 'Derb Omar, Casablanca', rating: 4.6, reviews: 378,
      imageUrl: 'assets/images/casablanca/boutiques/maroquinerie_casa/1.png',
      tags: ['Cuir', 'Sacs', 'Ceintures'], category: 'Cuir', prixMoyen: '40-600',
    ),
    _BoutiqueData(
      id: 'boutique_casa_005', name: 'Parfumerie Senteurs du Maroc', artisan: 'Fatima El Alami',
      location: 'Quartier Gauthier, Casablanca', rating: 4.8, reviews: 267,
      imageUrl: 'assets/images/casablanca/boutiques/parfumerie_casa/1.png',
      tags: ['Parfums', 'Huiles', 'Encens'], category: 'Bijoux', prixMoyen: '20-400',
    ),
    _BoutiqueData(
      id: 'boutique_casa_006', name: 'Atelier Zellige Casa', artisan: 'Maître Abdellah Zellige',
      location: 'Aïn Sebaâ, Casablanca', rating: 4.9, reviews: 189,
      imageUrl: 'assets/images/casablanca/boutiques/atelier_zellige/1.png',
      tags: ['Zellige', 'Mosaïque', 'Sur mesure'], category: 'Poterie', prixMoyen: '30-800',
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
    for (int i = 0; i < _boutiques.length; i++) {
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

  List<_BoutiqueData> get _activeBoutiques {
    final isCasa = ref.watch(selectedDestinationProvider).idDestination == 'dest_002';
    return isCasa ? _boutiquesCasa : _boutiques;
  }

  List<_BoutiqueData> get _filtered {
    final base = _activeBoutiques;
    if (_selectedFilter == 0) return base;
    return base.where((b) => b.category == _filters[_selectedFilter]).toList();
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
                                'Boutiques Artisanales',
                                style: TextStyle(
                                  fontFamily: 'DarkerGrotesque',
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              Text(
                                '${ref.watch(selectedDestinationProvider).nom} · ${_filtered.length} boutiques',
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
                                hintText: 'Rechercher une boutique...',
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
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final b = _filtered[index];
                      final fi = index.clamp(0, _cardFades.length - 1);
                      return FadeTransition(
                        opacity: _cardFades[fi],
                        child: SlideTransition(
                          position: _cardSlides[fi],
                          child: _BoutiqueCard(
                            boutique: b,
                            onTap: () => context.push('/boutique/${b.id}'),
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

class _BoutiqueCard extends StatelessWidget {
  const _BoutiqueCard({required this.boutique, required this.onTap});
  final _BoutiqueData boutique;
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
                      boutique.imageUrl,
                      fit: BoxFit.cover,
                      cacheWidth: 600,
                      gaplessPlayback: true,
                      errorBuilder: (_, _, _) => Container(
                        color: const Color(0xFF2A2A2A),
                        child: const Center(
                          child: Icon(
                            Icons.storefront_rounded,
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
                      boutique.category,
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
                          boutique.rating.toString(),
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
                          boutique.name,
                          style: const TextStyle(
                            fontFamily: 'DarkerGrotesque',
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      Text(
                        '\$${boutique.prixMoyen}',
                        style: const TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          color: Color(0xFFFF8C00),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.person_rounded,
                        color: Colors.white.withValues(alpha: 0.4),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        boutique.artisan,
                        style: TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
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
                          boutique.location,
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
                      ...List.generate(
                        5,
                        (i) => Icon(
                          i < boutique.rating.floor()
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: const Color(0xFFFF8C00),
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '(${boutique.reviews} avis)',
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
                    children: boutique.tags
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
}

class _BoutiqueData {
  final String id, name, artisan, location, imageUrl, category, prixMoyen;
  final int reviews;
  final double rating;
  final List<String> tags;
  const _BoutiqueData({
    required this.id,
    required this.name,
    required this.artisan,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
    required this.tags,
    required this.category,
    required this.prixMoyen,
  });
}
