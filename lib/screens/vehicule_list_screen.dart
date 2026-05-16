import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/destination_provider.dart';
import '../models/vehicule.dart';

class VehiculeListScreen extends ConsumerStatefulWidget {
  const VehiculeListScreen({super.key});

  @override
  ConsumerState<VehiculeListScreen> createState() => _VehiculeListScreenState();
}

class _VehiculeListScreenState extends ConsumerState<VehiculeListScreen>
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

  final _filters = const ['Tous', 'SUV', 'Berline', 'Citadine', 'Utilitaire'];

  // Real vehicle data — popular rental cars in Morocco
  final _vehicules = const [
    Vehicule(
      id: 'vehicule_001',
      name: 'Dacia Duster 2024',
      agence: 'Marrakech Auto Location',
      price: 45,
      rating: 4.6,
      reviews: 234,
      imageUrl: 'assets/images/vehicules/dacia_duster/1.png',
      tags: ['SUV', 'Diesel', 'Populaire'],
      category: 'SUV',
      transmission: 'Manuelle',
      carburant: 'Diesel',
      places: 5,
    ),
    Vehicule(
      id: 'vehicule_002',
      name: 'Renault Clio 5',
      agence: 'Eco Rent Marrakech',
      price: 22,
      rating: 4.4,
      reviews: 512,
      imageUrl: 'assets/images/vehicules/renault_clio/1.png',
      tags: ['Citadine', 'Essence', 'Économique'],
      category: 'Citadine',
      transmission: 'Manuelle',
      carburant: 'Essence',
      places: 5,
    ),
    Vehicule(
      id: 'vehicule_003',
      name: 'Mercedes Classe E',
      agence: 'Premium Cars Marrakech',
      price: 150,
      rating: 4.9,
      reviews: 156,
      imageUrl: 'assets/images/vehicules/mercedes_classe_e/1.png',
      tags: ['Berline', 'Automatique', 'Luxe'],
      category: 'Berline',
      transmission: 'Automatique',
      carburant: 'Essence',
      places: 5,
    ),
    Vehicule(
      id: 'vehicule_004',
      name: 'Toyota Hilux 4x4',
      agence: 'Desert Drive Location',
      price: 120,
      rating: 4.8,
      reviews: 189,
      imageUrl: 'assets/images/vehicules/toyota_hilux/1.png',
      tags: ['SUV', '4x4', 'Tout-terrain'],
      category: 'SUV',
      transmission: 'Automatique',
      carburant: 'Diesel',
      places: 5,
    ),
    Vehicule(
      id: 'vehicule_005',
      name: 'Peugeot 3008',
      agence: 'City Cars Marrakech',
      price: 65,
      rating: 4.7,
      reviews: 298,
      imageUrl: 'assets/images/vehicules/peugeot_3008/1.png',
      tags: ['SUV', 'Diesel', 'Familial'],
      category: 'SUV',
      transmission: 'Automatique',
      carburant: 'Diesel',
      places: 5,
    ),
    Vehicule(
      id: 'vehicule_006',
      name: 'Citroën Berlingo',
      agence: 'Marrakech Van Rental',
      price: 40,
      rating: 4.3,
      reviews: 167,
      imageUrl: 'assets/images/vehicules/citroen_berlingo/1.png',
      tags: ['Utilitaire', 'Diesel', '7 places'],
      category: 'Utilitaire',
      transmission: 'Manuelle',
      carburant: 'Diesel',
      places: 7,
    ),
  ];

  // Casablanca vehicles — same cars, local agencies
  final _vehiculesCasa = const [
    Vehicule(
      id: 'vehicule_casa_001', name: 'Dacia Duster 2024', agence: 'Casablanca Auto Location',
      price: 45, rating: 4.6, reviews: 198,
      imageUrl: 'assets/images/vehicules/dacia_duster/1.png',
      tags: ['SUV', 'Diesel', 'Populaire'], category: 'SUV',
      transmission: 'Manuelle', carburant: 'Diesel', places: 5,
    ),
    Vehicule(
      id: 'vehicule_casa_002', name: 'Renault Clio 5', agence: 'Eco Rent Casablanca',
      price: 22, rating: 4.4, reviews: 445,
      imageUrl: 'assets/images/vehicules/renault_clio/1.png',
      tags: ['Citadine', 'Essence', 'Économique'], category: 'Citadine',
      transmission: 'Manuelle', carburant: 'Essence', places: 5,
    ),
    Vehicule(
      id: 'vehicule_casa_003', name: 'Mercedes Classe E', agence: 'Premium Cars Casablanca',
      price: 150, rating: 4.9, reviews: 134,
      imageUrl: 'assets/images/vehicules/mercedes_classe_e/1.png',
      tags: ['Berline', 'Automatique', 'Luxe'], category: 'Berline',
      transmission: 'Automatique', carburant: 'Essence', places: 5,
    ),
    Vehicule(
      id: 'vehicule_casa_004', name: 'Toyota Hilux 4x4', agence: 'Casa 4x4 Rental',
      price: 120, rating: 4.8, reviews: 156,
      imageUrl: 'assets/images/vehicules/toyota_hilux/1.png',
      tags: ['SUV', '4x4', 'Tout-terrain'], category: 'SUV',
      transmission: 'Automatique', carburant: 'Diesel', places: 5,
    ),
    Vehicule(
      id: 'vehicule_casa_005', name: 'Peugeot 3008', agence: 'City Cars Casablanca',
      price: 65, rating: 4.7, reviews: 267,
      imageUrl: 'assets/images/vehicules/peugeot_3008/1.png',
      tags: ['SUV', 'Diesel', 'Familial'], category: 'SUV',
      transmission: 'Automatique', carburant: 'Diesel', places: 5,
    ),
    Vehicule(
      id: 'vehicule_casa_006', name: 'Citroën Berlingo', agence: 'Casablanca Van Rental',
      price: 40, rating: 4.3, reviews: 145,
      imageUrl: 'assets/images/vehicules/citroen_berlingo/1.png',
      tags: ['Utilitaire', 'Diesel', '7 places'], category: 'Utilitaire',
      transmission: 'Manuelle', carburant: 'Diesel', places: 7,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    // Pre-compute all animations once
    _headerFade = _makeFade(0.0, 0.3);
    _headerSlide = _makeSlide(0.0, 0.3);
    _searchFade = _makeFade(0.1, 0.4);
    _filterFade = _makeFade(0.15, 0.5);

    // Pre-compute card animations for all vehicles
    for (int i = 0; i < _vehicules.length; i++) {
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

  List<Vehicule> get _activeVehicules {
    final isCasa = ref.watch(selectedDestinationProvider).idDestination == 'dest_002';
    return isCasa ? _vehiculesCasa : _vehicules;
  }

  List<Vehicule> get _filteredVehicules {
    var base = _activeVehicules;
    if (_selectedFilter != 0) {
      final filterName = _filters[_selectedFilter];
      base = base.where((v) => v.category == filterName).toList();
    }
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) return base;
    return base.where((v) => v.name.toLowerCase().contains(q) || v.agence.toLowerCase().contains(q)).toList();
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
                                'Location de Véhicules',
                                style: TextStyle(
                                  fontFamily: 'DarkerGrotesque',
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              Text(
                                '${ref.watch(selectedDestinationProvider).nom} · ${_filteredVehicules.length} véhicules',
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
                                hintText: 'Rechercher un véhicule...',
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
                          if (_searchController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () => _searchController.clear(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(Icons.close_rounded, color: Colors.white.withValues(alpha: 0.4), size: 18),
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

                // Vehicle list
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    itemCount: _filteredVehicules.length,
                    addAutomaticKeepAlives: false,
                    separatorBuilder: (_, _) => const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final vehicule = _filteredVehicules[index];
                      final fadeIdx = index.clamp(0, _cardFades.length - 1);

                      return FadeTransition(
                        opacity: _cardFades[fadeIdx],
                        child: SlideTransition(
                          position: _cardSlides[fadeIdx],
                          child: _VehiculeCard(
                            vehicule: vehicule,
                            onTap: () =>
                                context.push('/vehicule/${vehicule.id}'),
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

// ── Vehicle Card ──
class _VehiculeCard extends StatelessWidget {
  const _VehiculeCard({required this.vehicule, required this.onTap});
  final Vehicule vehicule;
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
            // Image with rating badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      vehicule.imageUrl,
                      fit: BoxFit.cover,
                      cacheWidth: 400,
                      gaplessPlayback: true,
                      errorBuilder: (ctx, e, s) => Container(
                        color: const Color(0xFF2A2A2A),
                        child: const Center(
                          child: Icon(
                            Icons.directions_car_rounded,
                            size: 40,
                            color: Color(0xFF555555),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Category badge
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
                      vehicule.category,
                      style: const TextStyle(
                        fontFamily: 'DarkerGrotesque',
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
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
                          vehicule.rating.toString(),
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
                          vehicule.name,
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
                              text: '\$${vehicule.price}',
                              style: const TextStyle(
                                fontFamily: 'DarkerGrotesque',
                                color: Color(0xFFFF8C00),
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: '/jour',
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
                        Icons.store_rounded,
                        color: Colors.white.withValues(alpha: 0.4),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        vehicule.agence,
                        style: TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Vehicle specs row
                  Row(
                    children: [
                      _specChip(Icons.settings_rounded, vehicule.transmission),
                      const SizedBox(width: 8),
                      _specChip(
                        Icons.local_gas_station_rounded,
                        vehicule.carburant,
                      ),
                      const SizedBox(width: 8),
                      _specChip(
                        Icons.people_rounded,
                        '${vehicule.places} places',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (i) => Icon(
                          i < vehicule.rating.floor()
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: const Color(0xFFFF8C00),
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '(${vehicule.reviews} avis)',
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
                    children: vehicule.tags.map((tag) {
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

  Widget _specChip(IconData icon, String label) {
    return Container(
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
}
