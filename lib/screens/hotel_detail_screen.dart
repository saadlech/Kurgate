import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/kurgate_button.dart';
import '../providers/booking_provider.dart';
import '../widgets/reviews_section.dart';

class HotelDetailScreen extends ConsumerStatefulWidget {
  final String hotelId;
  const HotelDetailScreen({super.key, required this.hotelId});

  @override
  ConsumerState<HotelDetailScreen> createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends ConsumerState<HotelDetailScreen> {
  bool _bookingExpanded = false;
  late DateTime _checkIn;
  late DateTime _checkOut;
  int _adults = 2;
  int _children = 0;
  int _selectedRoom = 0;
  bool _isConfirming = false;

  static const int _maxPersonsPerRoom = 4;
  int get _totalPersons => _adults + _children;
  int _selectedBed = 1;
  int _galleryPage = 0;
  final PageController _galleryController = PageController();

  // Hotel data lookup
  static const _hotelDataMap = {
    'hotel_002': _HotelInfo(
      name: 'La Mamounia',
      location: 'Hivernage, Marrakech',
      rating: 4.9,
      reviews: 512,
      description:
          'Le palace légendaire de Marrakech, alliant l\'Art Déco au raffinement marocain. Jardins centenaires, spa luxueux, restaurants étoilés et suites d\'exception avec vue sur l\'Atlas. Un séjour inoubliable au cœur de la ville ocre.',
      imageUrl:
          'https://images.unsplash.com/photo-1548018560-c7196e4f6bec?w=800&q=80',
      imageAssets: [
        'assets/images/hotels/la_mamounia/1.png',
        'assets/images/hotels/la_mamounia/2.png',
        'assets/images/hotels/la_mamounia/3.png',
        'assets/images/hotels/la_mamounia/4.png',
        'assets/images/hotels/la_mamounia/5.png',
        'assets/images/hotels/la_mamounia/6.png',
      ],
    ),
    'hotel_003': _HotelInfo(
      name: 'Riad Yasmine',
      location: 'Medina, Marrakech',
      rating: 4.6,
      reviews: 187,
      description:
          'Un riad charmant avec un jardin luxuriant et une terrasse offrant une vue imprenable. Son patio central avec piscine émeraude, entouré de cactus et de bananiers, est devenu l\'un des plus photographiés de Marrakech. Idéal pour une escapade romantique au cœur de la Medina.',
      imageUrl:
          'https://images.unsplash.com/photo-1591378603223-e15b45a81640?w=800&q=80',
      imageAssets: [
        'assets/images/hotels/riad_yasmine/1.png',
        'assets/images/hotels/riad_yasmine/2.png',
        'assets/images/hotels/riad_yasmine/3.png',
        'assets/images/hotels/riad_yasmine/4.png',
        'assets/images/hotels/riad_yasmine/5.png',
        'assets/images/hotels/riad_yasmine/6.png',
      ],
    ),
    'hotel_004': _HotelInfo(
      name: 'Atlas Medina & Spa',
      location: 'Guéliz, Marrakech',
      rating: 4.5,
      reviews: 320,
      description:
          'Un resort moderne combinant confort contemporain et touches marocaines. Piscine chauffée, spa complet et restaurant gastronomique.',
      imageUrl:
          'https://images.unsplash.com/photo-1597212618440-806262de4f6b?w=800&q=80',
    ),
    'hotel_005': _HotelInfo(
      name: 'La Sultana',
      location: 'Kasbah, Marrakech',
      rating: 4.8,
      reviews: 389,
      description:
          'Un bijou de la Kasbah, La Sultana est un hôtel boutique de luxe réunissant 5 riads historiques. Piscine chauffée sur le toit avec vue panoramique, spa intimiste, cuisine raffinée et 28 suites uniques décorées d\'antiquités marocaines.',
      imageUrl:
          'https://images.unsplash.com/photo-1548018560-c7196e4f6bec?w=800&q=80',
      imageAssets: [
        'assets/images/hotels/la_sultana/1.png',
        'assets/images/hotels/la_sultana/2.png',
        'assets/images/hotels/la_sultana/3.png',
        'assets/images/hotels/la_sultana/4.png',
        'assets/images/hotels/la_sultana/5.png',
        'assets/images/hotels/la_sultana/6.png',
      ],
    ),
    'hotel_006': _HotelInfo(
      name: 'Mandarin Oriental',
      location: 'Route de la Palmeraie, Marrakech',
      rating: 4.9,
      reviews: 456,
      description:
          'Un resort d\'exception niché dans 20 hectares de jardins luxuriants. Villas privées avec piscine, spa primé, restaurants gastronomiques et vue imprenable sur l\'Atlas. L\'alliance parfaite du luxe contemporain et de l\'art de vivre marocain.',
      imageUrl:
          'https://images.unsplash.com/photo-1597212618440-806262de4f6b?w=800&q=80',
      imageAssets: [
        'assets/images/hotels/mandarin_oriental/1.png',
        'assets/images/hotels/mandarin_oriental/2.png',
        'assets/images/hotels/mandarin_oriental/3.png',
        'assets/images/hotels/mandarin_oriental/4.png',
        'assets/images/hotels/mandarin_oriental/5.png',
        'assets/images/hotels/mandarin_oriental/6.png',
      ],
    ),
    'hotel_007': _HotelInfo(
      name: 'Riad Kniza',
      location: 'Medina, Marrakech',
      rating: 4.7,
      reviews: 278,
      description:
          'Un riad boutique d\'exception niché au cœur de la Médina. Riad Kniza séduit par sa collection privée d\'antiquités marocaines, ses 11 suites somptueusement décorées, son hammam traditionnel et sa cuisine gastronomique. Une adresse confidentielle prisée des connaisseurs.',
      imageUrl:
          'https://images.unsplash.com/photo-1590073242678-70ee3fc28e8e?w=800&q=80',
      imageAssets: [
        'assets/images/hotels/riad_kniza/1.png',
        'assets/images/hotels/riad_kniza/2.png',
        'assets/images/hotels/riad_kniza/3.png',
        'assets/images/hotels/riad_kniza/4.png',
        'assets/images/hotels/riad_kniza/5.png',
        'assets/images/hotels/riad_kniza/6.png',
      ],
    ),
    'hotel_008': _HotelInfo(
      name: 'Royal Mansour',
      location: 'Médina, Marrakech',
      rating: 4.9,
      reviews: 623,
      description:
          'Le joyau de la couronne de Marrakech, commandé par le Roi Mohammed VI. Ce palace d\'exception propose 53 riads privés sur trois étages, chacun décoré par des maîtres artisans marocains. Spa de 2 500 m², restaurants étoilés par Yannick Allaéno, jardins andalous et service d\'une perfection absolue.',
      imageUrl:
          'https://images.unsplash.com/photo-1548018560-c7196e4f6bec?w=800&q=80',
      imageAssets: [
        'assets/images/hotels/royal_mansour/1.png',
        'assets/images/hotels/royal_mansour/2.png',
        'assets/images/hotels/royal_mansour/3.png',
        'assets/images/hotels/royal_mansour/4.png',
        'assets/images/hotels/royal_mansour/5.png',
        'assets/images/hotels/royal_mansour/6.png',
      ],
    ),
  };

  _HotelInfo get _hotel =>
      _hotelDataMap[widget.hotelId] ?? _hotelDataMap['hotel_002']!;
  bool get _hasGallery => _hotel.imageAssets.isNotEmpty;
  int get _imageCount => _hasGallery ? _hotel.imageAssets.length : 1;

  final _rooms = const [
    _RoomType('Standard', 'Chambre confortable avec vue cour', 120),
    _RoomType('Supérieure', 'Plus spacieuse avec balcon privé', 168),
    _RoomType('Suite Royale', 'Salon séparé et terrasse privée', 240),
    _RoomType('Familiale', 'Grande chambre pour toute la famille', 216),
  ];

  final _beds = const [
    _BedType('Lit Simple', '1 lit 90×200 cm', Icons.single_bed_rounded),
    _BedType('Lit Double', '1 lit 160×200 cm', Icons.bed_rounded),
    _BedType('Lits Jumeaux', '2 lits 90×200 cm', Icons.single_bed_rounded),
    _BedType('Lit King Size', '1 lit 200×200 cm', Icons.king_bed_rounded),
    _BedType(
      'Matelas Traditionnel',
      'Matelas marocain au sol',
      Icons.weekend_rounded,
    ),
  ];

  final _amenities = const [
    _Amenity(Icons.wifi_rounded, 'Wi-Fi'),
    _Amenity(Icons.local_parking_rounded, 'Parking'),
    _Amenity(Icons.restaurant_rounded, 'Restaurant'),
    _Amenity(Icons.ac_unit_rounded, 'Climatisation'),
  ];

  int get _nights => _checkOut.difference(_checkIn).inDays;
  int get _totalPrice => _rooms[_selectedRoom].price * _nights;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _checkIn = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(const Duration(days: 1));
    _checkOut = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(const Duration(days: 3));
  }

  @override
  void dispose() {
    _galleryController.dispose();
    super.dispose();
  }

  Future<void> _pickCheckIn() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _checkIn.isBefore(today.add(const Duration(days: 1)))
          ? today.add(const Duration(days: 1))
          : _checkIn,
      firstDate: today.add(const Duration(days: 1)),
      lastDate: today.add(const Duration(days: 365)),
      helpText: 'Date d\'arrivée',
      cancelText: 'Annuler',
      confirmText: 'Confirmer',
      builder: (context, child) => _datePickerTheme(child!),
    );
    if (picked != null) {
      setState(() {
        _checkIn = picked;
        if (_checkOut.isBefore(_checkIn.add(const Duration(days: 1))) ||
            _checkOut.isAtSameMomentAs(_checkIn)) {
          _checkOut = _checkIn.add(const Duration(days: 1));
        }
      });
    }
  }

  Future<void> _pickCheckOut() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final minCheckOut = _checkIn.add(const Duration(days: 1));
    final picked = await showDatePicker(
      context: context,
      initialDate: _checkOut.isBefore(minCheckOut) ? minCheckOut : _checkOut,
      firstDate: minCheckOut,
      lastDate: today.add(const Duration(days: 365)),
      helpText: 'Date de départ',
      cancelText: 'Annuler',
      confirmText: 'Confirmer',
      builder: (context, child) => _datePickerTheme(child!),
    );
    if (picked != null) {
      setState(() => _checkOut = picked);
    }
  }

  Widget _datePickerTheme(Widget child) {
    return Theme(
      data: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF8C00),
          onPrimary: Colors.black,
          surface: Color(0xFF2A2A2A),
          onSurface: Colors.white,
        ),
        dialogTheme: DialogThemeData(backgroundColor: const Color(0xFF1A1A1A)),
      ),
      child: child,
    );
  }

  String _fmtDateShort(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  void _confirmReservation() {
    if (_isConfirming) return;
    setState(() => _isConfirming = true);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _ReservationConfirmationSheet(
        hotelName: _hotel.name,
        checkIn: _checkIn,
        checkOut: _checkOut,
        adults: _adults,
        children: _children,
        roomType: _rooms[_selectedRoom].name,
        bedType: _beds[_selectedBed].name,
        totalPrice: _totalPrice,
        nights: _nights,
        onConfirmed: () {
          ref.read(bookingProvider.notifier).addBooking(Reservation(
            idReservation: 'hotel_${DateTime.now().millisecondsSinceEpoch}',
            itemId: widget.hotelId,
            typeOffre: 'hotel',
            nom: _hotel.name,
            sousTitre: '${_hotel.location} · ${_rooms[_selectedRoom].name}',
            imageUrl: _hasGallery ? _hotel.imageAssets.first : '',
            nbPersonnes: _adults + _children,
            dateDebut: _checkIn,
            dateFin: _checkOut,
            prixTotal: _totalPrice,
            details: {
              'Arrivée': _fmtDateShort(_checkIn),
              'Départ': _fmtDateShort(_checkOut),
              'Nuits': '$_nights',
              'Chambre': _rooms[_selectedRoom].name,
              'Personnes': '$_adults adultes${_children > 0 ? ' + $_children enfants' : ''}',
            },
          ));
        },
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
              // Hero image gallery
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
                      _hasGallery
                          ? PageView.builder(
                              controller: _galleryController,
                              itemCount: _imageCount,
                              onPageChanged: (i) =>
                                  setState(() => _galleryPage = i),
                              itemBuilder: (ctx, i) => Image.asset(
                                _hotel.imageAssets[i],
                                fit: BoxFit.cover,
                                cacheWidth: 800,
                                gaplessPlayback: true,
                                errorBuilder: (_, _, _) =>
                                    Container(color: const Color(0xFF2A2A2A)),
                              ),
                            )
                          : Image.network(
                              _hotel.imageUrl,
                              fit: BoxFit.cover,
                              cacheWidth: 800,
                              errorBuilder: (_, _, _) =>
                                  Container(color: const Color(0xFF2A2A2A)),
                            ),
                      // Bottom gradient
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
                      if (_hasGallery)
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(_imageCount, (i) {
                              final active = i == _galleryPage;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                width: active ? 22 : 6,
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
                          bottom: 16,
                          right: 16,
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
                                  Icons.photo_library_rounded,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${_galleryPage + 1}/$_imageCount',
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
                                  _hotel.name,
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
                                    Text(
                                      _hotel.location,
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
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () => launchUrl(
                                    Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(_hotel.name + ', ' + _hotel.location)}'),
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
                                  _hotel.rating.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'DarkerGrotesque',
                                    color: Color(0xFFFF8C00),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  ' (${_hotel.reviews})',
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
                      const SizedBox(height: 8),
                      // Stars
                      Row(
                        children: [
                          ...List.generate(
                            5,
                            (i) => Icon(
                              i < _hotel.rating.floor()
                                  ? Icons.star_rounded
                                  : Icons.star_half_rounded,
                              color: const Color(0xFFFF8C00),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_hotel.rating}/5 · ${_hotel.reviews} avis',
                            style: TextStyle(
                              fontFamily: 'DarkerGrotesque',
                              color: Colors.white.withValues(alpha: 0.4),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Description
                      Text(
                        _hotel.description,
                        style: TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Amenities
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: _amenities
                            .map((a) => _buildAmenity(a))
                            .toList(),
                      ),
                      const SizedBox(height: 28),
                      // Booking section
                      _buildBookingSection(),
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
                        '$_nights nuits · $_adults pers.',
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
                    label: 'Confirmer',
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

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
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
  }

  Widget _buildAmenity(_Amenity a) {
    return Column(
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
          child: Icon(
            a.icon,
            color: Colors.white.withValues(alpha: 0.5),
            size: 22,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          a.label,
          style: TextStyle(
            fontFamily: 'DarkerGrotesque',
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBookingSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          // Header
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
                          'Configurer votre séjour',
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
                  _buildDates(),
                  const SizedBox(height: 20),
                  // Persons
                  _buildPersons(),
                  const SizedBox(height: 20),
                  // Room types
                  _buildRoomTypes(),
                  const SizedBox(height: 20),
                  // Bed types
                  _buildBedTypes(),
                  const SizedBox(height: 20),
                  // Summary
                  _buildSummary(),
                  const SizedBox(height: 28),
                  // Reviews section
                  ReviewsSection(
                    itemId: widget.hotelId,
                    itemName: _hotel.name,
                    itemType: 'Hôtel',
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDates() {
    return Row(
      children: [
        Expanded(child: _dateBox('Arrivée', _checkIn, _pickCheckIn)),
        const SizedBox(width: 12),
        Expanded(child: _dateBox('Départ', _checkOut, _pickCheckOut)),
      ],
    );
  }

  Widget _dateBox(String label, DateTime date, VoidCallback onTap) {
    return Column(
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
                  '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
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
  }

  Widget _buildPersons() {
    final maxAdults = _maxPersonsPerRoom - _children;
    final maxChildren = _maxPersonsPerRoom - _adults;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.people_outline_rounded,
              color: Colors.white.withValues(alpha: 0.4),
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nombre de personnes',
                    style: TextStyle(
                      fontFamily: 'DarkerGrotesque',
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _totalPersons >= _maxPersonsPerRoom
                          ? const Color(0xFFFF8C00).withValues(alpha: 0.15)
                          : Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$_totalPersons/$_maxPersonsPerRoom',
                      style: TextStyle(
                        fontFamily: 'DarkerGrotesque',
                        color: _totalPersons >= _maxPersonsPerRoom
                            ? const Color(0xFFFF8C00)
                            : Colors.white.withValues(alpha: 0.4),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _counterRow(
          'Adultes',
          '18+ ans',
          _adults,
          (v) => setState(() => _adults = v),
          1,
          maxAdults.clamp(1, _maxPersonsPerRoom),
        ),
        const SizedBox(height: 8),
        _counterRow(
          'Enfants',
          '0-17 ans',
          _children,
          (v) => setState(() => _children = v),
          0,
          maxChildren.clamp(0, _maxPersonsPerRoom - 1),
        ),
      ],
    );
  }

  Widget _counterRow(
    String label,
    String sub,
    int value,
    ValueChanged<int> onChanged,
    int min,
    int max,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'DarkerGrotesque',
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                sub,
                style: TextStyle(
                  fontFamily: 'DarkerGrotesque',
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        _counterBtn(
          Icons.remove_rounded,
          value > min,
          () => onChanged(value - 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '$value',
            style: const TextStyle(
              fontFamily: 'DarkerGrotesque',
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        _counterBtn(Icons.add_rounded, value < max, () => onChanged(value + 1)),
      ],
    );
  }

  Widget _counterBtn(IconData icon, bool enabled, VoidCallback onTap) {
    return GestureDetector(
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
  }

  Widget _buildRoomTypes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.bed_rounded,
              color: Colors.white.withValues(alpha: 0.4),
              size: 18,
            ),
            const SizedBox(width: 8),
            const Text(
              'Type de chambre',
              style: TextStyle(
                fontFamily: 'DarkerGrotesque',
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...List.generate(_rooms.length, (i) {
          final room = _rooms[i];
          final active = i == _selectedRoom;
          return GestureDetector(
            onTap: () => setState(() => _selectedRoom = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: active
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: active
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
                          room.name,
                          style: TextStyle(
                            fontFamily: 'DarkerGrotesque',
                            color: active
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.6),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          room.desc,
                          style: TextStyle(
                            fontFamily: 'DarkerGrotesque',
                            color: Colors.white.withValues(alpha: 0.3),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${room.price}',
                    style: TextStyle(
                      fontFamily: 'DarkerGrotesque',
                      color: active
                          ? const Color(0xFFFF8C00)
                          : Colors.white.withValues(alpha: 0.5),
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '/nuit',
                    style: TextStyle(
                      fontFamily: 'DarkerGrotesque',
                      color: Colors.white.withValues(alpha: 0.3),
                      fontSize: 11,
                    ),
                  ),
                  if (active) ...[
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFFFF8C00),
                      size: 20,
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBedTypes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.single_bed_rounded,
              color: Colors.white.withValues(alpha: 0.4),
              size: 18,
            ),
            const SizedBox(width: 8),
            const Text(
              'Type de matelas / lit',
              style: TextStyle(
                fontFamily: 'DarkerGrotesque',
                color: Color(0xFFFF8C00),
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(_beds.length, (i) {
            final bed = _beds[i];
            final active = i == _selectedBed;
            final isWide = i == _beds.length - 1;
            return GestureDetector(
              onTap: () => setState(() => _selectedBed = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isWide
                    ? double.infinity
                    : (MediaQuery.of(context).size.width - 70) / 2,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: active ? 0.08 : 0.03),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: active
                        ? const Color(0xFFFF8C00)
                        : Colors.white.withValues(alpha: 0.06),
                    width: active ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      bed.icon,
                      color: active
                          ? const Color(0xFFFF8C00)
                          : Colors.white.withValues(alpha: 0.3),
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bed.name,
                      style: TextStyle(
                        fontFamily: 'DarkerGrotesque',
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      bed.desc,
                      style: TextStyle(
                        fontFamily: 'DarkerGrotesque',
                        color: Colors.white.withValues(alpha: 0.3),
                        fontSize: 11,
                      ),
                    ),
                    if (active) ...[
                      const SizedBox(height: 4),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFFFF8C00),
                          size: 18,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSummary() {
    return Container(
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
          _summaryRow('Chambre', _rooms[_selectedRoom].name),
          _summaryRow('Lit', _beds[_selectedBed].name),
          _summaryRow(
            'Personnes',
            '$_adults adultes${_children > 0 ? ' + $_children enfants' : ''}',
          ),
          _summaryRow('Nuits', '$_nights'),
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
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
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
}

// ── Reservation Confirmation Sheet ──
class _ReservationConfirmationSheet extends StatefulWidget {
  final String hotelName;
  final DateTime checkIn, checkOut;
  final int adults, children, totalPrice, nights;
  final String roomType, bedType;
  final VoidCallback onConfirmed;

  const _ReservationConfirmationSheet({
    required this.hotelName,
    required this.checkIn,
    required this.checkOut,
    required this.adults,
    required this.children,
    required this.roomType,
    required this.bedType,
    required this.totalPrice,
    required this.nights,
    required this.onConfirmed,
  });

  @override
  State<_ReservationConfirmationSheet> createState() =>
      _ReservationConfirmationSheetState();
}

class _ReservationConfirmationSheetState
    extends State<_ReservationConfirmationSheet>
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
          // Handle bar
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
              'Votre séjour à ${widget.hotelName} est réservé.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'DarkerGrotesque',
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
          ] else ...[
            // Title
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

            // Details card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Column(
                children: [
                  _row(Icons.hotel_rounded, widget.hotelName),
                  _row(
                    Icons.calendar_today_rounded,
                    '${_fmtDate(widget.checkIn)} → ${_fmtDate(widget.checkOut)}  (${widget.nights} nuits)',
                  ),
                  _row(
                    Icons.people_rounded,
                    '${widget.adults} adultes${widget.children > 0 ? ' + ${widget.children} enfants' : ''}',
                  ),
                  _row(
                    Icons.bed_rounded,
                    '${widget.roomType} · ${widget.bedType}',
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

            // Buttons
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

  Widget _row(IconData icon, String text) {
    return Padding(
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
}

class _RoomType {
  final String name, desc;
  final int price;
  const _RoomType(this.name, this.desc, this.price);
}

class _BedType {
  final String name, desc;
  final IconData icon;
  const _BedType(this.name, this.desc, this.icon);
}

class _Amenity {
  final IconData icon;
  final String label;
  const _Amenity(this.icon, this.label);
}

class _HotelInfo {
  final String name;
  final String location;
  final double rating;
  final int reviews;
  final String description;
  final String imageUrl;
  final List<String> imageAssets;

  const _HotelInfo({
    required this.name,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.description,
    required this.imageUrl,
    this.imageAssets = const [],
  });
}
