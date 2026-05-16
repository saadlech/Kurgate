import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/destination_provider.dart';

class ExperienceListScreen extends ConsumerStatefulWidget {
  const ExperienceListScreen({super.key});

  @override
  ConsumerState<ExperienceListScreen> createState() => _ExperienceListScreenState();
}

class _ExperienceListScreenState extends ConsumerState<ExperienceListScreen>
    with TickerProviderStateMixin {
  int _selectedFilter = 0;
  final _searchController = TextEditingController();

  late AnimationController _entryController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _searchFade;
  late Animation<double> _filterFade;
  final List<Animation<double>> _cardFades = [];
  final List<Animation<Offset>> _cardSlides = [];

  final _filters = const [
    'Tous',
    'Aventure',
    'Culture',
    'Nature',
    'Gastronomie',
  ];

  final _experiences = const [
    _ExperienceData(
      id: 'exp_001',
      name: 'Safari dans le Désert d\'Agafay',
      location: 'Désert d\'Agafay, Marrakech',
      price: 85,
      rating: 4.8,
      reviews: 342,
      imageUrl: 'assets/images/marrakech/experiences/safari_agafay/1.png',
      tags: ['Quad', 'Coucher de soleil', 'Dîner'],
      category: 'Aventure',
      duree: '6h',
      capacite: 12,
    ),
    _ExperienceData(
      id: 'exp_002',
      name: 'Visite Guidée de la Médina',
      location: 'Médina, Marrakech',
      price: 35,
      rating: 4.7,
      reviews: 528,
      imageUrl: 'assets/images/marrakech/experiences/medina_visite/1.png',
      tags: ['Guide local', 'Souks', 'Histoire'],
      category: 'Culture',
      duree: '3h',
      capacite: 15,
    ),
    _ExperienceData(
      id: 'exp_003',
      name: 'Randonnée dans l\'Atlas',
      location: 'Vallée de l\'Ourika',
      price: 60,
      rating: 4.9,
      reviews: 189,
      imageUrl: 'assets/images/marrakech/experiences/randonnee_atlas/1.png',
      tags: ['Trekking', 'Cascades', 'Montagne'],
      category: 'Nature',
      duree: '8h',
      capacite: 10,
    ),
    _ExperienceData(
      id: 'exp_004',
      name: 'Cours de Cuisine Marocaine',
      location: 'Riad Cooking, Médina',
      price: 50,
      rating: 4.8,
      reviews: 267,
      imageUrl: 'assets/images/marrakech/experiences/cours_cuisine/1.png',
      tags: ['Tajine', 'Couscous', 'Pâtisseries'],
      category: 'Gastronomie',
      duree: '4h',
      capacite: 8,
    ),
    _ExperienceData(
      id: 'exp_005',
      name: 'Vol en Montgolfière',
      location: 'Palmeraie, Marrakech',
      price: 180,
      rating: 4.9,
      reviews: 124,
      imageUrl: 'assets/images/marrakech/experiences/vol_montgolfiere/1.png',
      tags: ['Vue panoramique', 'Lever du soleil', 'Photos'],
      category: 'Aventure',
      duree: '2h',
      capacite: 6,
    ),
    _ExperienceData(
      id: 'exp_006',
      name: 'Jardin Majorelle & YSL',
      location: 'Guéliz, Marrakech',
      price: 15,
      rating: 4.7,
      reviews: 892,
      imageUrl: 'assets/images/marrakech/experiences/jardin_majorelle/1.png',
      tags: ['Jardin', 'Musée', 'Art'],
      category: 'Culture',
      duree: '2h',
      capacite: 20,
    ),
  ];

  // Casablanca experiences
  final _experiencesCasa = const [
    _ExperienceData(
      id: 'exp_casa_001', name: 'Visite de la Mosquée Hassan II',
      location: 'Boulevard de la Corniche, Casablanca', price: 12, rating: 4.9, reviews: 1245,
      imageUrl: 'assets/images/casablanca/experiences/mosquee_hassan/1.png',
      tags: ['Monument', 'Architecture', 'Spirituel'], category: 'Culture', duree: '2h', capacite: 30,
    ),
    _ExperienceData(
      id: 'exp_casa_002', name: 'Promenade Corniche Ain Diab',
      location: 'Ain Diab, Casablanca', price: 0, rating: 4.6, reviews: 678,
      imageUrl: 'assets/images/casablanca/experiences/corniche_casa/1.png',
      tags: ['Bord de mer', 'Plage', 'Sunset'], category: 'Nature', duree: '3h', capacite: 20,
    ),
    _ExperienceData(
      id: 'exp_casa_003', name: 'Tour de l\'Ancienne Médina',
      location: 'Ancienne Médina, Casablanca', price: 25, rating: 4.7, reviews: 423,
      imageUrl: 'assets/images/casablanca/experiences/medina_casa/1.png',
      tags: ['Guide local', 'Histoire', 'Marchés'], category: 'Culture', duree: '3h', capacite: 15,
    ),
    _ExperienceData(
      id: 'exp_casa_004', name: 'Morocco Mall & Shopping',
      location: 'Morocco Mall, Casablanca', price: 0, rating: 4.5, reviews: 892,
      imageUrl: 'assets/images/casablanca/experiences/morocco_mall/1.png',
      tags: ['Shopping', 'Aquarium', 'Loisirs'], category: 'Aventure', duree: '4h', capacite: 20,
    ),
    _ExperienceData(
      id: 'exp_casa_005', name: 'Quartier Art Déco & Habous',
      location: 'Quartier Habous, Casablanca', price: 20, rating: 4.8, reviews: 312,
      imageUrl: 'assets/images/casablanca/experiences/art_deco_tour/1.png',
      tags: ['Architecture', 'Pâtisseries', 'Artisanat'], category: 'Culture', duree: '3h', capacite: 12,
    ),
    _ExperienceData(
      id: 'exp_casa_006', name: 'Coucher de soleil en Yacht',
      location: 'Marina, Casablanca', price: 200, rating: 4.9, reviews: 156,
      imageUrl: 'assets/images/casablanca/experiences/yacht_casa/1.png',
      tags: ['Yacht', 'Sunset', 'Champagne'], category: 'Aventure', duree: '3h', capacite: 8,
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
    for (int i = 0; i < _experiences.length; i++) {
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

  List<_ExperienceData> get _activeExperiences {
    final isCasa = ref.watch(selectedDestinationProvider).idDestination == 'dest_002';
    return isCasa ? _experiencesCasa : _experiences;
  }

  List<_ExperienceData> get _filteredExperiences {
    final base = _activeExperiences;
    if (_selectedFilter == 0) return base;
    final filterName = _filters[_selectedFilter];
    return base.where((e) => e.category == filterName).toList();
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
                                'Expériences',
                                style: TextStyle(
                                  fontFamily: 'DarkerGrotesque',
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              Text(
                                '${ref.watch(selectedDestinationProvider).nom} · ${_filteredExperiences.length} activités',
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
                                hintText: 'Rechercher une expérience...',
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
                // Experience list
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    itemCount: _filteredExperiences.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final exp = _filteredExperiences[index];
                      final fadeIdx = index.clamp(0, _cardFades.length - 1);
                      return FadeTransition(
                        opacity: _cardFades[fadeIdx],
                        child: SlideTransition(
                          position: _cardSlides[fadeIdx],
                          child: _ExperienceCard(
                            experience: exp,
                            onTap: () => context.push('/experience/${exp.id}'),
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

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({required this.experience, required this.onTap});
  final _ExperienceData experience;
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
                      experience.imageUrl,
                      fit: BoxFit.cover,
                      cacheWidth: 600,
                      gaplessPlayback: true,
                      errorBuilder: (ctx, e, s) => Container(
                        color: const Color(0xFF2A2A2A),
                        child: const Center(
                          child: Icon(
                            Icons.explore_rounded,
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
                      experience.category,
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
                          experience.rating.toString(),
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
                          experience.name,
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
                              text: '\$${experience.price}',
                              style: const TextStyle(
                                fontFamily: 'DarkerGrotesque',
                                color: Color(0xFFFF8C00),
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: '/pers',
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
                      Expanded(
                        child: Text(
                          experience.location,
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
                      _specChip(Icons.access_time_rounded, experience.duree),
                      const SizedBox(width: 8),
                      _specChip(
                        Icons.people_rounded,
                        '${experience.capacite} max',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (i) => Icon(
                          i < experience.rating.floor()
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: const Color(0xFFFF8C00),
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '(${experience.reviews} avis)',
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
                    children: experience.tags
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
        Text(
          label,
          style: TextStyle(
            fontFamily: 'DarkerGrotesque',
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

class _ExperienceData {
  final String id, name, location, imageUrl, category, duree;
  final int price, reviews, capacite;
  final double rating;
  final List<String> tags;
  const _ExperienceData({
    required this.id,
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
    required this.tags,
    required this.category,
    required this.duree,
    required this.capacite,
  });
}
