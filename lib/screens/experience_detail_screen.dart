import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import '../widgets/kurgate_button.dart';
import '../widgets/reviews_section.dart';

class ExperienceDetailScreen extends StatefulWidget {
  final String experienceId;
  const ExperienceDetailScreen({super.key, required this.experienceId});
  @override
  State<ExperienceDetailScreen> createState() => _ExperienceDetailScreenState();
}

class _ExperienceDetailScreenState extends State<ExperienceDetailScreen> {
  bool _bookingExpanded = false;
  late DateTime _date;
  int _participants = 2;
  bool _isConfirming = false;
  int _currentPage = 0;

  static const _expDataMap = {
    'exp_001': _ExpInfo(
      name: 'Safari dans le Désert d\'Agafay',
      location: 'Désert d\'Agafay, Marrakech',
      rating: 4.8,
      reviews: 342,
      description:
          'Vivez une aventure inoubliable dans le désert d\'Agafay. Balade en quad à travers les dunes de pierre, pause thé berbère, et dîner sous les étoiles avec spectacle de musique traditionnelle. Une expérience magique aux portes de Marrakech.',
      imageUrl: 'assets/images/experiences/safari_agafay/1.png',
      images: [
        'assets/images/experiences/safari_agafay/1.png',
        'assets/images/experiences/safari_agafay/2.png',
        'assets/images/experiences/safari_agafay/3.png',
      ],
      price: 85,
      duree: '6h',
      capacite: 12,
      category: 'Aventure',
    ),
    'exp_002': _ExpInfo(
      name: 'Visite Guidée de la Médina',
      location: 'Médina, Marrakech',
      rating: 4.7,
      reviews: 528,
      description:
          'Explorez les ruelles labyrinthiques de la Médina avec un guide local passionné. Découvrez les souks colorés, les monuments historiques, les fontaines cachées et les secrets d\'un patrimoine millénaire classé à l\'UNESCO.',
      imageUrl: 'assets/images/experiences/medina_visite/1.png',
      images: [
        'assets/images/experiences/medina_visite/1.png',
        'assets/images/experiences/medina_visite/2.png',
        'assets/images/experiences/medina_visite/3.png',
      ],
      price: 35,
      duree: '3h',
      capacite: 15,
      category: 'Culture',
    ),
    'exp_003': _ExpInfo(
      name: 'Randonnée dans l\'Atlas',
      location: 'Vallée de l\'Ourika',
      rating: 4.9,
      reviews: 189,
      description:
          'Randonnée guidée à travers les paysages spectaculaires du Haut Atlas. Traversez des villages berbères authentiques, découvrez des cascades rafraîchissantes et savourez un déjeuner traditionnel avec vue panoramique sur la vallée.',
      imageUrl: 'assets/images/experiences/randonnee_atlas/1.png',
      images: [
        'assets/images/experiences/randonnee_atlas/1.png',
        'assets/images/experiences/randonnee_atlas/2.png',
        'assets/images/experiences/randonnee_atlas/3.png',
      ],
      price: 60,
      duree: '8h',
      capacite: 10,
      category: 'Nature',
    ),
    'exp_004': _ExpInfo(
      name: 'Cours de Cuisine Marocaine',
      location: 'Riad Cooking, Médina',
      rating: 4.8,
      reviews: 267,
      description:
          'Apprenez à préparer les plats emblématiques de la cuisine marocaine dans un riad traditionnel. Du marché aux fourneaux, maîtrisez les secrets du tajine, du couscous et des pâtisseries aux amandes et miel.',
      imageUrl: 'assets/images/experiences/cours_cuisine/1.png',
      images: [
        'assets/images/experiences/cours_cuisine/1.png',
        'assets/images/experiences/cours_cuisine/2.png',
        'assets/images/experiences/cours_cuisine/3.png',
      ],
      price: 50,
      duree: '4h',
      capacite: 8,
      category: 'Gastronomie',
    ),
    'exp_005': _ExpInfo(
      name: 'Vol en Montgolfière',
      location: 'Palmeraie, Marrakech',
      rating: 4.9,
      reviews: 124,
      description:
          'Envolez-vous au lever du soleil pour une vue époustouflante sur Marrakech, la Palmeraie et les sommets enneigés de l\'Atlas. Un moment magique suivi d\'un petit-déjeuner champêtre au milieu de la nature.',
      imageUrl: 'assets/images/experiences/vol_montgolfiere/1.png',
      images: [
        'assets/images/experiences/vol_montgolfiere/1.png',
        'assets/images/experiences/vol_montgolfiere/2.png',
        'assets/images/experiences/vol_montgolfiere/3.png',
      ],
      price: 180,
      duree: '2h',
      capacite: 6,
      category: 'Aventure',
    ),
    'exp_006': _ExpInfo(
      name: 'Jardin Majorelle & YSL',
      location: 'Guéliz, Marrakech',
      rating: 4.7,
      reviews: 892,
      description:
          'Visitez le célèbre Jardin Majorelle, oasis de bleu cobalt et de végétation luxuriante créé par Jacques Majorelle et restauré par Yves Saint Laurent. Inclut l\'accès au Musée Berbère et au Musée YSL.',
      imageUrl: 'assets/images/experiences/jardin_majorelle/1.png',
      images: [
        'assets/images/experiences/jardin_majorelle/1.png',
        'assets/images/experiences/jardin_majorelle/2.png',
        'assets/images/experiences/jardin_majorelle/3.png',
      ],
      price: 15,
      duree: '2h',
      capacite: 20,
      category: 'Culture',
    ),
  };

  _ExpInfo get _exp =>
      _expDataMap[widget.experienceId] ?? _expDataMap['exp_001']!;
  int get _totalPrice => _exp.price * _participants;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _date = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: today.add(const Duration(days: 1)),
      lastDate: today.add(const Duration(days: 365)),
      helpText: 'Date de l\'expérience',
      cancelText: 'Annuler',
      confirmText: 'Confirmer',
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFFF8C00),
            onPrimary: Colors.black,
            surface: Color(0xFF2A2A2A),
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _date = picked);
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  void _confirmReservation() {
    if (_isConfirming) return;
    setState(() => _isConfirming = true);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _ReservationSheet(
        expName: _exp.name,
        date: _date,
        participants: _participants,
        totalPrice: _totalPrice,
      ),
    ).then((_) => setState(() => _isConfirming = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                backgroundColor: const Color(0xFF1A1A1A),
                leading: _circleBtn(
                  Icons.arrow_back_ios_rounded,
                  () => context.pop(),
                ),
                actions: [
                  _circleBtn(Icons.share_rounded, () {}),
                  const SizedBox(width: 4),
                  _circleBtn(Icons.favorite_border_rounded, () {}),
                  const SizedBox(width: 12),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      PageView.builder(
                        itemCount: _exp.images.length,
                        onPageChanged: (i) => setState(() => _currentPage = i),
                        itemBuilder: (context, i) => Image.asset(
                          _exp.images[i],
                          fit: BoxFit.cover,
                          cacheWidth: 800,
                          gaplessPlayback: true,
                          errorBuilder: (_, _, _) =>
                              Container(color: const Color(0xFF2A2A2A)),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 80,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                const Color(0xFF1A1A1A).withValues(alpha: 0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Dot indicators
                      Positioned(
                        bottom: 12,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _exp.images.length,
                            (i) => AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: _currentPage == i ? 20 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: _currentPage == i
                                    ? const Color(0xFFFF8C00)
                                    : Colors.white.withValues(alpha: 0.35),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Counter badge
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_currentPage + 1}/${_exp.images.length}',
                            style: const TextStyle(
                              fontFamily: 'DarkerGrotesque',
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name & rating
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _exp.name,
                                  style: const TextStyle(
                                    fontFamily: 'DarkerGrotesque',
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.white.withValues(
                                        alpha: 0.4,
                                      ),
                                      size: 15,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        _exp.location,
                                        style: TextStyle(
                                          fontFamily: 'DarkerGrotesque',
                                          color: Colors.white.withValues(
                                            alpha: 0.4,
                                          ),
                                          fontSize: 14,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () => launchUrl(
                                    Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(_exp.name + ', Marrakech')}'),
                                    mode: LaunchMode.externalApplication,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.06),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.navigation_rounded, size: 14, color: const Color(0xFFFF8C00)),
                                        const SizedBox(width: 6),
                                        Text('Itinéraire', style: TextStyle(fontFamily: 'DarkerGrotesque', color: const Color(0xFFFF8C00), fontSize: 13, fontWeight: FontWeight.w700)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFFF8C00,
                              ).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Color(0xFFFF8C00),
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _exp.rating.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'DarkerGrotesque',
                                    color: Color(0xFFFF8C00),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  ' (${_exp.reviews})',
                                  style: const TextStyle(
                                    fontFamily: 'DarkerGrotesque',
                                    color: Color(0xFFFF8C00),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _exp.description,
                        style: TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Specs
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSpec(Icons.access_time_rounded, _exp.duree),
                          _buildSpec(
                            Icons.people_rounded,
                            '${_exp.capacite} max',
                          ),
                          _buildSpec(Icons.category_rounded, _exp.category),
                          _buildSpec(Icons.translate_rounded, 'FR/EN'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Inclus
                      _buildIncludes(),
                      const SizedBox(height: 24),
                      _buildBookingSection(),
                      const SizedBox(height: 28),
                      ReviewsSection(
                        itemId: widget.experienceId,
                        itemName: _exp.name,
                        itemType: 'Expérience',
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Bottom bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                border: Border(
                  top: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
                ),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$$_totalPrice',
                        style: const TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          color: Color(0xFFFF8C00),
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '$_participants pers.',
                        style: TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          color: Colors.white.withValues(alpha: 0.35),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  KurgateButton(
                    label: 'Réserver',
                    onPressed: _confirmReservation,
                    height: 48,
                    width: 160,
                    fontSize: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 38,
      height: 38,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withValues(alpha: 0.4),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    ),
  );

  Widget _buildSpec(IconData icon, String label) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Icon(icon, color: Colors.white.withValues(alpha: 0.5), size: 22),
      ),
      const SizedBox(height: 6),
      Text(
        label,
        style: TextStyle(
          fontFamily: 'DarkerGrotesque',
          color: Colors.white.withValues(alpha: 0.4),
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );

  Widget _buildIncludes() {
    final includes = [
      ('Guide professionnel', Icons.person_rounded),
      ('Transport inclus', Icons.directions_bus_rounded),
      ('Déjeuner/Dîner', Icons.restaurant_rounded),
      ('Équipement fourni', Icons.backpack_rounded),
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ce qui est inclus',
            style: TextStyle(
              fontFamily: 'DarkerGrotesque',
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          ...includes.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: const Color(0xFF2ECC71),
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    item.$2,
                    color: Colors.white.withValues(alpha: 0.4),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.$1,
                    style: TextStyle(
                      fontFamily: 'DarkerGrotesque',
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingSection() => Container(
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.03),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
    ),
    child: Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _bookingExpanded = !_bookingExpanded),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF8C00).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.calendar_month_rounded,
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
                        'Réserver maintenant',
                        style: TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Choisir date et participants',
                        style: TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          color: Colors.white.withValues(alpha: 0.35),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _bookingExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_bookingExpanded) ...[
          Divider(color: Colors.white.withValues(alpha: 0.06), height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date
                Text(
                  'Date',
                  style: TextStyle(
                    fontFamily: 'DarkerGrotesque',
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _fmtDate(_date),
                          style: const TextStyle(
                            fontFamily: 'DarkerGrotesque',
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.calendar_today_rounded,
                          color: const Color(0xFFFF8C00).withValues(alpha: 0.6),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Participants
                Row(
                  children: [
                    Icon(
                      Icons.people_outline_rounded,
                      color: Colors.white.withValues(alpha: 0.4),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Participants',
                        style: TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nombre de personnes',
                            style: TextStyle(
                              fontFamily: 'DarkerGrotesque',
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Prix par personne',
                            style: TextStyle(
                              fontFamily: 'DarkerGrotesque',
                              color: Color(0xFF666666),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _counterBtn(
                      Icons.remove_rounded,
                      _participants > 1,
                      () => setState(() => _participants--),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '$_participants',
                        style: const TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _counterBtn(
                      Icons.add_rounded,
                      _participants < _exp.capacite,
                      () => setState(() => _participants++),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Récapitulatif',
                        style: TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _summaryRow('Expérience', _exp.name),
                      _summaryRow('Date', _fmtDate(_date)),
                      _summaryRow('Participants', '$_participants'),
                      _summaryRow('Prix unitaire', '\$${_exp.price}'),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontFamily: 'DarkerGrotesque',
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            '\$$_totalPrice',
                            style: const TextStyle(
                              fontFamily: 'DarkerGrotesque',
                              color: Color(0xFFFF8C00),
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    ),
  );

  Widget _counterBtn(IconData icon, bool enabled, VoidCallback onTap) =>
      GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: enabled
                ? const Color(0xFFFF8C00)
                : Colors.white.withValues(alpha: 0.05),
            border: Border.all(
              color: enabled
                  ? const Color(0xFFFF8C00)
                  : Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Icon(
            icon,
            color: enabled ? Colors.black : Colors.white.withValues(alpha: 0.2),
            size: 18,
          ),
        ),
      );

  Widget _summaryRow(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'DarkerGrotesque',
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 14,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'DarkerGrotesque',
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

class _ReservationSheet extends StatefulWidget {
  final String expName;
  final DateTime date;
  final int participants, totalPrice;
  const _ReservationSheet({
    required this.expName,
    required this.date,
    required this.participants,
    required this.totalPrice,
  });
  @override
  State<_ReservationSheet> createState() => _ReservationSheetState();
}

class _ReservationSheetState extends State<_ReservationSheet>
    with SingleTickerProviderStateMixin {
  bool _confirmed = false;
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  void _confirm() {
    setState(() => _confirmed = true);
    _animCtrl.forward();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF222222),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          if (_confirmed) ...[
            const SizedBox(height: 20),
            ScaleTransition(
              scale: _scaleAnim,
              child: Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF2ECC71),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 44,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Réservation confirmée !',
              style: TextStyle(
                fontFamily: 'DarkerGrotesque',
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Votre expérience "${widget.expName}" est réservée.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'DarkerGrotesque',
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
          ] else ...[
            const Text(
              'Confirmer la réservation',
              style: TextStyle(
                fontFamily: 'DarkerGrotesque',
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Column(
                children: [
                  _row(Icons.explore_rounded, widget.expName),
                  _row(Icons.calendar_today_rounded, _fmtDate(widget.date)),
                  _row(
                    Icons.people_rounded,
                    '${widget.participants} participants',
                  ),
                  const Divider(height: 20, color: Color(0xFF444444)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '\$${widget.totalPrice}',
                        style: const TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          color: Color(0xFFFF8C00),
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Annuler',
                          style: TextStyle(
                            fontFamily: 'DarkerGrotesque',
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: _confirm,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF8C00), Color(0xFFFF6B00)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text(
                          'Confirmer',
                          style: TextStyle(
                            fontFamily: 'DarkerGrotesque',
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _row(IconData icon, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Icon(icon, color: const Color(0xFFFF8C00), size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'DarkerGrotesque',
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

class _ExpInfo {
  final String name, location, description, imageUrl, duree, category;
  final List<String> images;
  final double rating;
  final int reviews, price, capacite;
  const _ExpInfo({
    required this.name,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.description,
    required this.imageUrl,
    required this.images,
    required this.price,
    required this.duree,
    required this.capacite,
    required this.category,
  });
}
