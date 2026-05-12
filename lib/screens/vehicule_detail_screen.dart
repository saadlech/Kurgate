import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/kurgate_button.dart';
import '../providers/booking_provider.dart';
import '../widgets/reviews_section.dart';

class VehiculeDetailScreen extends ConsumerStatefulWidget {
  final String vehiculeId;
  const VehiculeDetailScreen({super.key, required this.vehiculeId});

  @override
  ConsumerState<VehiculeDetailScreen> createState() =>
      _VehiculeDetailScreenState();
}

class _VehiculeDetailScreenState extends ConsumerState<VehiculeDetailScreen> {
  bool _bookingExpanded = false;
  late DateTime _pickupDate;
  late DateTime _returnDate;
  bool _withDriver = false;
  bool _withInsurance = true;
  bool _isConfirming = false;
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();
  final _addressController = TextEditingController();

  static const _vehiculeDataMap = {
    'vehicule_001': _VehiculeInfo(
      name: 'Dacia Duster 2024',
      agence: 'Marrakech Auto Location',
      rating: 4.6,
      reviews: 234,
      description:
          'Le SUV le plus populaire au Maroc. Le Dacia Duster 2024 combine robustesse, confort et économie. Parfait pour les routes de l\'Atlas et les pistes du désert, il offre une garde au sol élevée, un moteur diesel fiable et un habitacle spacieux pour 5 passagers.',
      imageUrl: 'assets/images/vehicules/dacia_duster/1.png',
      price: 45,
      transmission: 'Manuelle',
      carburant: 'Diesel',
      places: 5,
      category: 'SUV',
      images: [
        'assets/images/vehicules/dacia_duster/1.png',
        'assets/images/vehicules/dacia_duster/2.png',
        'assets/images/vehicules/dacia_duster/3.png',
        'assets/images/vehicules/dacia_duster/4.png',
      ],
    ),
    'vehicule_002': _VehiculeInfo(
      name: 'Renault Clio 5',
      agence: 'Eco Rent Marrakech',
      rating: 4.4,
      reviews: 512,
      description:
          'La citadine idéale pour Marrakech. Agile dans les ruelles de la Médina, économique en carburant et dotée d\'un intérieur moderne avec écran tactile et climatisation automatique. Le choix malin pour explorer la ville et ses environs sans se ruiner.',
      imageUrl: 'assets/images/vehicules/renault_clio/1.png',
      price: 22,
      transmission: 'Manuelle',
      carburant: 'Essence',
      places: 5,
      category: 'Citadine',
      images: [
        'assets/images/vehicules/renault_clio/1.png',
        'assets/images/vehicules/renault_clio/2.png',
        'assets/images/vehicules/renault_clio/3.png',
        'assets/images/vehicules/renault_clio/4.png',
      ],
    ),
    'vehicule_003': _VehiculeInfo(
      name: 'Mercedes Classe E',
      agence: 'Premium Cars Marrakech',
      rating: 4.9,
      reviews: 156,
      description:
          'L\'excellence allemande à Marrakech. La Mercedes Classe E vous offre un voyage luxueux avec ses sièges en cuir Nappa, son système MBUX intelligent et sa suspension pneumatique. Idéale pour les transferts VIP et les occasions spéciales dans la ville ocre.',
      imageUrl: 'assets/images/vehicules/mercedes_classe_e/1.png',
      price: 150,
      transmission: 'Automatique',
      carburant: 'Essence',
      places: 5,
      category: 'Berline',
      images: [
        'assets/images/vehicules/mercedes_classe_e/1.png',
        'assets/images/vehicules/mercedes_classe_e/2.png',
        'assets/images/vehicules/mercedes_classe_e/3.png',
        'assets/images/vehicules/mercedes_classe_e/4.png',
      ],
    ),
    'vehicule_004': _VehiculeInfo(
      name: 'Toyota Hilux 4x4',
      agence: 'Desert Drive Location',
      rating: 4.8,
      reviews: 189,
      description:
          'Le pick-up légendaire, indestructible et tout-terrain. Le Toyota Hilux 4x4 est le véhicule de choix pour les expéditions dans le désert du Sahara et les pistes de montagne de l\'Atlas. Puissant, fiable et équipé de tous les dispositifs de sécurité.',
      imageUrl: 'assets/images/vehicules/toyota_hilux/1.png',
      price: 120,
      transmission: 'Automatique',
      carburant: 'Diesel',
      places: 5,
      category: 'SUV',
      images: [
        'assets/images/vehicules/toyota_hilux/1.png',
        'assets/images/vehicules/toyota_hilux/2.png',
        'assets/images/vehicules/toyota_hilux/3.png',
        'assets/images/vehicules/toyota_hilux/4.png',
      ],
    ),
    'vehicule_005': _VehiculeInfo(
      name: 'Peugeot 3008',
      agence: 'City Cars Marrakech',
      rating: 4.7,
      reviews: 298,
      description:
          'Le SUV familial par excellence. Le Peugeot 3008 séduit par son i-Cockpit futuriste, son confort de conduite exceptionnel et son coffre généreux. Un compagnon polyvalent pour les familles souhaitant explorer Marrakech et ses alentours avec style.',
      imageUrl: 'assets/images/vehicules/peugeot_3008/1.png',
      price: 65,
      transmission: 'Automatique',
      carburant: 'Diesel',
      places: 5,
      category: 'SUV',
      images: [
        'assets/images/vehicules/peugeot_3008/1.png',
        'assets/images/vehicules/peugeot_3008/2.png',
        'assets/images/vehicules/peugeot_3008/3.png',
        'assets/images/vehicules/peugeot_3008/4.png',
      ],
    ),
    'vehicule_006': _VehiculeInfo(
      name: 'Citroën Berlingo',
      agence: 'Marrakech Van Rental',
      rating: 4.3,
      reviews: 167,
      description:
          'Le véhicule utilitaire idéal pour les groupes et les familles nombreuses. Avec ses 7 places et son volume de chargement impressionnant, le Berlingo vous permet de transporter tout le monde et tous les bagages dans un confort surprenant.',
      imageUrl: 'assets/images/vehicules/citroen_berlingo/1.png',
      price: 40,
      transmission: 'Manuelle',
      carburant: 'Diesel',
      places: 7,
      category: 'Utilitaire',
      images: [
        'assets/images/vehicules/citroen_berlingo/1.png',
        'assets/images/vehicules/citroen_berlingo/2.png',
        'assets/images/vehicules/citroen_berlingo/3.png',
        'assets/images/vehicules/citroen_berlingo/4.png',
      ],
    ),
  };

  _VehiculeInfo get _vehicule =>
      _vehiculeDataMap[widget.vehiculeId] ?? _vehiculeDataMap['vehicule_001']!;

  int get _days => _returnDate.difference(_pickupDate).inDays;
  int get _basePrice => _vehicule.price * _days;
  int get _driverPrice => _withDriver ? 30 * _days : 0;
  int get _insurancePrice => _withInsurance ? 10 * _days : 0;
  int get _totalPrice => _basePrice + _driverPrice + _insurancePrice;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _pickupDate = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(const Duration(days: 1));
    _returnDate = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(const Duration(days: 4));
  }

  Future<void> _pickDate(bool isPickup) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final initial = isPickup ? _pickupDate : _returnDate;
    final first = isPickup
        ? today.add(const Duration(days: 1))
        : _pickupDate.add(const Duration(days: 1));
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(first) ? first : initial,
      firstDate: first,
      lastDate: today.add(const Duration(days: 365)),
      helpText: isPickup ? 'Date de prise en charge' : 'Date de retour',
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
          dialogTheme: DialogThemeData(
            backgroundColor: const Color(0xFF1A1A1A),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isPickup) {
          _pickupDate = picked;
          if (_returnDate.isBefore(_pickupDate.add(const Duration(days: 1))))
            _returnDate = _pickupDate.add(const Duration(days: 1));
        } else {
          _returnDate = picked;
        }
      });
    }
  }

  void _confirmReservation() {
    if (_isConfirming) return;
    setState(() => _isConfirming = true);
    final address = _addressController.text.trim();
    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Veuillez saisir une adresse de livraison.', style: TextStyle(fontFamily: 'DarkerGrotesque')),
        backgroundColor: const Color(0xFFFF5252),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
      setState(() => _isConfirming = false);
      return;
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _ReservationSheet(
        vehiculeName: _vehicule.name,
        pickupDate: _pickupDate,
        returnDate: _returnDate,
        days: _days,
        totalPrice: _totalPrice,
        withDriver: _withDriver,
        withInsurance: _withInsurance,
        deliveryAddress: address,
        onConfirmed: () {
          ref
              .read(bookingProvider.notifier)
              .addBooking(
                Reservation(
                  idReservation: 'vehicule_${DateTime.now().millisecondsSinceEpoch}',
                  itemId: widget.vehiculeId,
                  typeOffre: 'vehicule',
                  nom: _vehicule.name,
                  sousTitre: '${_vehicule.agence} · ${_vehicule.category}',
                  imageUrl: _vehicule.images.first,
                  nbPersonnes: 1,
                  dateDebut: _pickupDate,
                  dateFin: _returnDate,
                  prixTotal: _totalPrice,
                  details: {
                    'Début': _fmtDate(_pickupDate),
                    'Retour': _fmtDate(_returnDate),
                    'Jours': '$_days',
                    if (_withDriver) 'Chauffeur': 'Oui',
                    if (_withInsurance) 'Assurance': 'Oui',
                    'Adresse de livraison': address,
                  },
                ),
              );
        },
      ),
    ).then((_) => setState(() => _isConfirming = false));
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

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
                        controller: _pageController,
                        itemCount: _vehicule.images.length,
                        onPageChanged: (i) =>
                            setState(() => _currentImageIndex = i),
                        itemBuilder: (context, i) => Image.asset(
                          _vehicule.images[i],
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
                      // Page indicator dots
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _vehicule.images.length,
                            (i) => AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: i == _currentImageIndex ? 20 : 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: i == _currentImageIndex
                                    ? const Color(0xFFFF8C00)
                                    : Colors.white.withValues(alpha: 0.4),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Image counter badge
                      Positioned(
                        top: 60,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_currentImageIndex + 1}/${_vehicule.images.length}',
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
                                  _vehicule.name,
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
                                      Icons.store_rounded,
                                      color: Colors.white.withValues(
                                        alpha: 0.4,
                                      ),
                                      size: 15,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _vehicule.agence,
                                      style: TextStyle(
                                        fontFamily: 'DarkerGrotesque',
                                        color: Colors.white.withValues(
                                          alpha: 0.4,
                                        ),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
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
                                  _vehicule.rating.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'DarkerGrotesque',
                                    color: Color(0xFFFF8C00),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  ' (${_vehicule.reviews})',
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
                      // Description
                      Text(
                        _vehicule.description,
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
                          _buildSpec(
                            Icons.settings_rounded,
                            _vehicule.transmission,
                          ),
                          _buildSpec(
                            Icons.local_gas_station_rounded,
                            _vehicule.carburant,
                          ),
                          _buildSpec(
                            Icons.people_rounded,
                            '${_vehicule.places} places',
                          ),
                          _buildSpec(
                            Icons.category_rounded,
                            _vehicule.category,
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      // Booking section
                      _buildBookingSection(),
                      const SizedBox(height: 28),
                      ReviewsSection(
                        itemId: widget.vehiculeId,
                        itemName: _vehicule.name,
                        itemType: 'Véhicule',
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
                        '$_days jours',
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
                        'Configurer votre location',
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
                // Dates
                Row(
                  children: [
                    Expanded(
                      child: _dateBox(
                        'Prise en charge',
                        _pickupDate,
                        () => _pickDate(true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _dateBox(
                        'Retour',
                        _returnDate,
                        () => _pickDate(false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Options
                _optionToggle(
                  'Avec chauffeur',
                  'Chauffeur professionnel (+\$30/jour)',
                  _withDriver,
                  (v) => setState(() => _withDriver = v),
                ),
                const SizedBox(height: 12),
                _optionToggle(
                  'Assurance complète',
                  'Couverture tous risques (+\$10/jour)',
                  _withInsurance,
                  (v) => setState(() => _withInsurance = v),
                ),
                const SizedBox(height: 20),
                // Delivery address
                Text(
                  'Adresse de livraison',
                  style: TextStyle(
                    fontFamily: 'DarkerGrotesque',
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: TextField(
                    controller: _addressController,
                    style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                    maxLines: 2,
                    minLines: 1,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_on_rounded, color: const Color(0xFFFF8C00).withValues(alpha: 0.6), size: 18),
                      hintText: 'Ex: 123 Rue Mohamed V, Guéliz, Marrakech',
                      hintStyle: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.15), fontSize: 13),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Summary
                _buildSummary(),
              ],
            ),
          ),
        ],
      ],
    ),
  );

  Widget _dateBox(String label, DateTime date, VoidCallback onTap) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontFamily: 'DarkerGrotesque',
          color: Colors.white.withValues(alpha: 0.4),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 6),
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Row(
            children: [
              Text(
                _fmtDate(date),
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
    ],
  );

  Widget _optionToggle(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: value ? 0.06 : 0.02),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: value
            ? const Color(0xFFFF8C00).withValues(alpha: 0.5)
            : Colors.white.withValues(alpha: 0.06),
      ),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'DarkerGrotesque',
                  color: value
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.6),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'DarkerGrotesque',
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: const Color(0xFFFF8C00),
          activeTrackColor: const Color(0xFFFF8C00).withValues(alpha: 0.3),
          inactiveThumbColor: Colors.white.withValues(alpha: 0.3),
          inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
        ),
      ],
    ),
  );

  Widget _buildSummary() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.04),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
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
        _summaryRow('Véhicule', _vehicule.name),
        _summaryRow('Durée', '$_days jours'),
        _summaryRow('Location', '\$$_basePrice'),
        if (_withDriver) _summaryRow('Chauffeur', '\$$_driverPrice'),
        if (_withInsurance) _summaryRow('Assurance', '\$$_insurancePrice'),
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
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'DarkerGrotesque',
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

// ── Reservation Sheet ──
class _ReservationSheet extends StatefulWidget {
  final String vehiculeName;
  final DateTime pickupDate, returnDate;
  final int days, totalPrice;
  final bool withDriver, withInsurance;
  final String deliveryAddress;
  final VoidCallback onConfirmed;
  const _ReservationSheet({
    required this.vehiculeName,
    required this.pickupDate,
    required this.returnDate,
    required this.days,
    required this.totalPrice,
    required this.withDriver,
    required this.withInsurance,
    required this.deliveryAddress,
    required this.onConfirmed,
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
    widget.onConfirmed();
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
              'Votre ${widget.vehiculeName} est réservé.',
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
                  _row(Icons.directions_car_rounded, widget.vehiculeName),
                  _row(
                    Icons.calendar_today_rounded,
                    '${_fmtDate(widget.pickupDate)} → ${_fmtDate(widget.returnDate)}  (${widget.days} jours)',
                  ),
                  if (widget.withDriver)
                    _row(Icons.person_rounded, 'Avec chauffeur'),
                  if (widget.withInsurance)
                    _row(Icons.security_rounded, 'Assurance complète'),
                  _row(Icons.location_on_rounded, widget.deliveryAddress),
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

class _VehiculeInfo {
  final String name,
      agence,
      description,
      imageUrl,
      transmission,
      carburant,
      category;
  final double rating;
  final int reviews, price, places;
  final List<String> images;
  const _VehiculeInfo({
    required this.name,
    required this.agence,
    required this.rating,
    required this.reviews,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.transmission,
    required this.carburant,
    required this.places,
    required this.category,
    required this.images,
  });
}
