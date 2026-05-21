import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/attraction.dart';
import '../providers/destination_provider.dart';

class AttractionListScreen extends ConsumerStatefulWidget {
  const AttractionListScreen({super.key});

  @override
  ConsumerState<AttractionListScreen> createState() => _AttractionListScreenState();
}

class _AttractionListScreenState extends ConsumerState<AttractionListScreen>
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
    'Monument',
    'Jardin',
    'Place',
    'Musée',
    'Patrimoine',
  ];

  // ── Marrakech Attractions ──
  static final _attractionsMarrakech = [
    Attraction(
      idAttraction: 'attr_002',
      nom: 'Jardin Majorelle',
      type: 'Jardin',
      description: 'Créé en 1923 par Jacques Majorelle et restauré par Yves Saint Laurent, ce jardin enchanteur abrite plus de 300 espèces végétales. Le bleu Majorelle iconique contraste avec les bambous géants et les bougainvilliers.',
      imageUrl: 'assets/images/marrakech/attractions/jardin_majorelle/1.jpg',
      note: 4.7,
      location: 'Guéliz, Marrakech',
      lat: 31.6418, lon: -8.0032,
    ),
    Attraction(
      idAttraction: 'attr_003',
      nom: 'Palais Bahia',
      type: 'Monument',
      description: 'Chef-d\'œuvre de l\'architecture marocaine du XIXe siècle, le Palais Bahia s\'étend sur 8 hectares. Ses 150 pièces décorées de zellige, bois de cèdre sculpté et stuc ciselé.',
      imageUrl: 'assets/images/marrakech/attractions/bahia_palace/1.jpg',
      note: 4.6,
      location: 'Mellah, Marrakech',
      lat: 31.6217, lon: -7.9823,
    ),
    Attraction(
      idAttraction: 'attr_004',
      nom: 'Mosquée Koutoubia',
      type: 'Monument',
      description: 'Symbole emblématique de Marrakech, la Koutoubia domine la ville avec son minaret de 77 mètres. Édifiée au XIIe siècle par les Almohades, elle a inspiré la Giralda de Séville.',
      imageUrl: 'assets/images/marrakech/attractions/koutoubia/1.jpg',
      note: 4.9,
      location: 'Médina, Marrakech',
      lat: 31.6237, lon: -7.9939,
    ),
    Attraction(
      idAttraction: 'attr_005',
      nom: 'Tombeaux Saadiens',
      type: 'Patrimoine',
      description: 'Redécouverts en 1917 après avoir été murés pendant des siècles. La Salle des Douze Colonnes est ornée de marbre de Carrare et de stuc doré.',
      imageUrl: 'assets/images/marrakech/attractions/tombeaux_saadiens/1.jpg',
      note: 4.5,
      location: 'Kasbah, Marrakech',
      lat: 31.6178, lon: -7.9901,
    ),
    Attraction(
      idAttraction: 'attr_008',
      nom: 'Jardins de la Ménara',
      type: 'Jardin',
      description: 'Vaste oliveraie de 100 hectares avec un bassin artificiel du XIIe siècle. Le pavillon saadien se reflète dans les eaux calmes avec l\'Atlas en toile de fond.',
      imageUrl: 'assets/images/marrakech/attractions/menara/1.jpg',
      note: 4.3,
      location: 'Hivernage, Marrakech',
      lat: 31.6138, lon: -8.0225,
    ),
  ];

  // ── Agadir Attractions ──
  static final _attractionsAgadir = [
    Attraction(
      idAttraction: 'attr_aga_001',
      nom: 'Kasbah Oufella',
      type: 'Monument',
      description: 'Forteresse historique perchée à 236 mètres au-dessus d\'Agadir, offrant une vue panoramique spectaculaire sur toute la baie. Reconstruite après le séisme de 1960.',
      imageUrl: 'assets/images/agadir/attractions/kasbah_oufella/1.jpg',
      note: 4.6,
      location: 'Colline Oufella, Agadir',
      lat: 30.4338, lon: -9.6168,
    ),
    Attraction(
      idAttraction: 'attr_aga_002',
      nom: 'Marina d\'Agadir',
      type: 'Place',
      description: 'Port de plaisance moderne avec promenade piétonne, restaurants, boutiques et vue sur l\'océan Atlantique. Lieu de vie animé de la ville.',
      imageUrl: 'assets/images/agadir/attractions/marina_agadir/1.jpg',
      note: 4.5,
      location: 'Front de Mer, Agadir',
      lat: 30.4167, lon: -9.5989,
    ),
  ];

  // ── Tanger Attractions ──
  static final _attractionsTanger = [
    Attraction(
      idAttraction: 'attr_tan_001',
      nom: 'Cap Spartel',
      type: 'Monument',
      description: 'Point le plus au nord-ouest de l\'Afrique où l\'océan Atlantique rencontre la mer Méditerranée. Le phare historique du XIXe siècle offre une vue époustouflante.',
      imageUrl: 'assets/images/tanger/attractions/cap_spartel/1.jpg',
      note: 4.8,
      location: 'Cap Spartel, Tanger',
      lat: 35.7925, lon: -5.9267,
    ),
    Attraction(
      idAttraction: 'attr_tan_002',
      nom: 'Grottes d\'Hercule',
      type: 'Patrimoine',
      description: 'Grottes naturelles mythiques où, selon la légende, Hercule se reposa après ses douze travaux. L\'ouverture ressemble à la carte de l\'Afrique inversée.',
      imageUrl: 'assets/images/tanger/attractions/caves_hercules/1.jpg',
      note: 4.7,
      location: 'Cap Spartel, Tanger',
      lat: 35.7617, lon: -5.9386,
    ),
    Attraction(
      idAttraction: 'attr_tan_003',
      nom: 'Musée de la Légation Américaine',
      type: 'Musée',
      description: 'Premier bâtiment américain à l\'étranger, ce musée retrace les relations diplomatiques entre le Maroc et les États-Unis depuis le XVIIIe siècle.',
      imageUrl: 'assets/images/tanger/attractions/legation_museum/1.jpg',
      note: 4.5,
      location: 'Médina, Tanger',
      lat: 35.7867, lon: -5.8117,
    ),
    Attraction(
      idAttraction: 'attr_tan_004',
      nom: 'Parc Perdicaris',
      type: 'Jardin',
      description: 'Forêt luxuriante de 70 hectares avec sentiers de randonnée, eucalyptus et pins. Vue magnifique sur le détroit de Gibraltar et la côte espagnole.',
      imageUrl: 'assets/images/tanger/attractions/parc_perdicaris/1.jpg',
      note: 4.4,
      location: 'Cap Spartel, Tanger',
      lat: 35.7722, lon: -5.9142,
    ),
    Attraction(
      idAttraction: 'attr_tan_005',
      nom: 'Église Saint-André',
      type: 'Patrimoine',
      description: 'Église anglicane du XIXe siècle mêlant architecture mauresque et européenne. Son cimetière abrite les tombes de personnalités internationales.',
      imageUrl: 'assets/images/tanger/attractions/st_andrew/1.jpg',
      note: 4.3,
      location: 'Centre-ville, Tanger',
      lat: 35.7764, lon: -5.8097,
    ),
  ];

  // ── Casablanca Attractions ──
  static final _attractionsCasablanca = [
    Attraction(
      idAttraction: 'attr_casa_001',
      nom: 'Mosquée Hassan II',
      type: 'Monument',
      description: 'Troisième plus grande mosquée du monde avec son minaret de 210 mètres. Chef-d\'œuvre architectural surplombant l\'océan Atlantique.',
      imageUrl: 'assets/images/casablanca/attractions/hassan_ii/1.jpg',
      note: 4.9,
      location: 'Boulevard de la Corniche, Casablanca',
      lat: 33.6087, lon: -7.6322,
    ),
    Attraction(
      idAttraction: 'attr_casa_002',
      nom: 'Place Mohammed V',
      type: 'Place',
      description: 'Place emblématique de Casablanca entourée de bâtiments art déco et néo-mauresques. Centre administratif et culturel de la ville.',
      imageUrl: 'assets/images/casablanca/attractions/mohammed_v/1.jpg',
      note: 4.5,
      location: 'Centre-ville, Casablanca',
      lat: 33.5912, lon: -7.6186,
    ),
    Attraction(
      idAttraction: 'attr_casa_003',
      nom: 'Morocco Mall',
      type: 'Place',
      description: 'Le plus grand centre commercial d\'Afrique avec aquarium géant, patinoire, et plus de 600 boutiques de marques internationales.',
      imageUrl: 'assets/images/casablanca/attractions/morocco_mall/1.jpg',
      note: 4.4,
      location: 'Corniche, Casablanca',
      lat: 33.5767, lon: -7.6608,
    ),
    Attraction(
      idAttraction: 'attr_casa_004',
      nom: 'Église Notre-Dame de Lourdes',
      type: 'Monument',
      description: 'Église catholique du XXe siècle remarquable pour ses immenses vitraux colorés de Gabriel Loire. Architecture moderniste unique.',
      imageUrl: 'assets/images/casablanca/attractions/notre_dame/1.jpg',
      note: 4.3,
      location: 'Quartier des Hôpitaux, Casablanca',
      lat: 33.5876, lon: -7.6254,
    ),
    Attraction(
      idAttraction: 'attr_casa_005',
      nom: 'Quartier Habous',
      type: 'Patrimoine',
      description: 'Nouvelle médina construite dans les années 1930, mêlant urbanisme français et architecture marocaine traditionnelle. Artisanat et pâtisseries.',
      imageUrl: 'assets/images/casablanca/attractions/quartier_habous/1.jpg',
      note: 4.6,
      location: 'Habous, Casablanca',
      lat: 33.5751, lon: -7.6078,
    ),
    Attraction(
      idAttraction: 'attr_casa_006',
      nom: 'Palais Royal',
      type: 'Monument',
      description: 'Résidence royale aux portes ornées et jardins majestueux. Exemple remarquable de l\'architecture palatiale marocaine moderne.',
      imageUrl: 'assets/images/casablanca/attractions/royal_palace/1.jpg',
      note: 4.2,
      location: 'Mechouar, Casablanca',
      lat: 33.5839, lon: -7.6175,
    ),
  ];

  List<Attraction> _attractionsForDest() {
    final destId = ref.watch(selectedDestinationProvider).idDestination;
    switch (destId) {
      case 'dest_002': return _attractionsCasablanca;
      case 'dest_003': return _attractionsAgadir;
      case 'dest_004': return _attractionsTanger;
      default: return _attractionsMarrakech;
    }
  }

  String get _destName => ref.watch(selectedDestinationProvider).nom;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
    _headerFade = _makeFade(0.0, 0.3);
    _headerSlide = _makeSlide(0.0, 0.3);
    _searchFade = _makeFade(0.1, 0.4);
    _filterFade = _makeFade(0.15, 0.5);
    for (int i = 0; i < 12; i++) {
      final delay = 0.2 + (i * 0.08);
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

  List<Attraction> _filterAttractions() {
    var base = _attractionsForDest();
    if (_selectedFilter != 0) {
      final filterName = _filters[_selectedFilter];
      base = base.where((a) => a.type == filterName).toList();
    }
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) return base;
    return base.where((a) => a.nom.toLowerCase().contains(q) || a.location.toLowerCase().contains(q) || a.type.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filterAttractions();

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
                                'Attractions',
                                style: TextStyle(
                                  fontFamily: 'DarkerGrotesque',
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              Text(
                                _destName,
                                style: TextStyle(
                                  fontFamily: 'DarkerGrotesque',
                                  color: Colors.white.withValues(alpha: 0.4),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF8C00).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.place_rounded, color: const Color(0xFFFF8C00), size: 14),
                                const SizedBox(width: 4),
                                Text('${filtered.length}', style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Color(0xFFFF8C00), fontSize: 13, fontWeight: FontWeight.w800)),
                              ],
                            ),
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
                        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 14),
                          Icon(Icons.search_rounded, color: Colors.white.withValues(alpha: 0.3), size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 14),
                              decoration: InputDecoration(
                                hintText: 'Rechercher une attraction...',
                                hintStyle: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.25), fontSize: 14),
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
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: active ? const Color(0xFFFF8C00) : Colors.white.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: active ? const Color(0xFFFF8C00) : Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                              child: Text(
                                _filters[i],
                                style: TextStyle(
                                  fontFamily: 'DarkerGrotesque',
                                  color: active ? Colors.black : Colors.white.withValues(alpha: 0.6),
                                  fontSize: 13,
                                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
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
                // Attraction list
                Expanded(
                  child: filtered.isEmpty
                      ? Center(child: Text('Aucune attraction trouvée', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.4), fontSize: 16)))
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                          itemCount: filtered.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 20),
                          itemBuilder: (context, index) {
                            final attr = filtered[index];
                            final fadeIdx = index.clamp(0, _cardFades.length - 1);
                            return FadeTransition(
                              opacity: _cardFades[fadeIdx],
                              child: SlideTransition(
                                position: _cardSlides[fadeIdx],
                                child: _AttractionCard(
                                  attraction: attr,
                                  onTap: () => context.push('/attraction/${attr.idAttraction}'),
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

class _AttractionCard extends StatelessWidget {
  const _AttractionCard({required this.attraction, required this.onTap});
  final Attraction attraction;
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
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      attraction.imageUrl,
                      fit: BoxFit.cover,
                      cacheWidth: 400,
                      gaplessPlayback: true,
                      errorBuilder: (_, _, _) => Container(
                        color: const Color(0xFF2A2A2A),
                        child: const Center(
                          child: Icon(Icons.photo_camera_rounded, size: 40, color: Color(0xFF555555)),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF8C00).withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      attraction.type,
                      style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.black, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded, color: Color(0xFFFF8C00), size: 16),
                        const SizedBox(width: 4),
                        Text(
                          attraction.note.toString(),
                          style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
                // Free badge
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2ECC71).withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'GRATUIT',
                      style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5),
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
                  Text(
                    attraction.nom,
                    style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.3),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: Colors.white.withValues(alpha: 0.4), size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          attraction.location,
                          style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.4), fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    attraction.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.35), fontSize: 12, height: 1.4),
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
