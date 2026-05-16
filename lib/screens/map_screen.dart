import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/destination_provider.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});
  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  int _selectedFilter = 0;
  _MapPOI? _selectedPOI;
  late AnimationController _sheetCtrl;
  late Animation<Offset> _sheetSlide;

  static const String _geoapifyKey = '8ea6bd7dfb8e4ff19946ba5b6cc14934';

  final _filters = const [
    _FilterItem(label: 'Tous', icon: Icons.layers_rounded),
    _FilterItem(label: 'Hôtels', icon: Icons.hotel_rounded),
    _FilterItem(label: 'Restaurants', icon: Icons.restaurant_rounded),
    _FilterItem(label: 'Expériences', icon: Icons.explore_rounded),
    _FilterItem(label: 'Boutiques', icon: Icons.storefront_rounded),
  ];

  static final _centerMarrakech = LatLng(31.6295, -7.9811);
  static final _centerCasa = LatLng(33.5731, -7.5898);

  LatLng get _center {
    final isCasa = ref.watch(selectedDestinationProvider).idDestination == 'dest_002';
    return isCasa ? _centerCasa : _centerMarrakech;
  }

  final List<_MapPOI> _allPOIs = const [
    // Hotels
    _MapPOI(id: 'hotel_002', name: 'La Mamounia', category: 'Hôtels', location: 'Hivernage', rating: 4.9, price: '350€/nuit', lat: 31.6218, lng: -7.9973, icon: Icons.hotel_rounded, route: '/hotel/hotel_002', images: ['assets/images/marrakech/hotels/la_mamounia/1.png','assets/images/marrakech/hotels/la_mamounia/2.png','assets/images/marrakech/hotels/la_mamounia/3.png']),
    _MapPOI(id: 'hotel_003', name: 'Riad Yasmine', category: 'Hôtels', location: 'Médina', rating: 4.6, price: '95€/nuit', lat: 31.6310, lng: -7.9870, icon: Icons.hotel_rounded, route: '/hotel/hotel_003', images: ['assets/images/marrakech/hotels/riad_yasmine/1.png','assets/images/marrakech/hotels/riad_yasmine/2.png','assets/images/marrakech/hotels/riad_yasmine/3.png']),
    _MapPOI(id: 'hotel_005', name: 'La Sultana', category: 'Hôtels', location: 'Kasbah', rating: 4.8, price: '280€/nuit', lat: 31.6175, lng: -7.9895, icon: Icons.hotel_rounded, route: '/hotel/hotel_005', images: ['assets/images/marrakech/hotels/la_sultana/1.png','assets/images/marrakech/hotels/la_sultana/2.png','assets/images/marrakech/hotels/la_sultana/3.png']),
    _MapPOI(id: 'hotel_006', name: 'Mandarin Oriental', category: 'Hôtels', location: 'Palmeraie', rating: 4.9, price: '420€/nuit', lat: 31.6680, lng: -8.0050, icon: Icons.hotel_rounded, route: '/hotel/hotel_006', images: ['assets/images/marrakech/hotels/mandarin_oriental/1.png','assets/images/marrakech/hotels/mandarin_oriental/2.png','assets/images/marrakech/hotels/mandarin_oriental/3.png']),
    _MapPOI(id: 'hotel_007', name: 'Riad Kniza', category: 'Hôtels', location: 'Médina', rating: 4.7, price: '200€/nuit', lat: 31.6280, lng: -7.9880, icon: Icons.hotel_rounded, route: '/hotel/hotel_007', images: ['assets/images/marrakech/hotels/riad_kniza/1.png','assets/images/marrakech/hotels/riad_kniza/2.png','assets/images/marrakech/hotels/riad_kniza/3.png']),
    _MapPOI(id: 'hotel_008', name: 'Royal Mansour', category: 'Hôtels', location: 'Médina', rating: 4.9, price: '550€/nuit', lat: 31.6230, lng: -7.9930, icon: Icons.hotel_rounded, route: '/hotel/hotel_008', images: ['assets/images/marrakech/hotels/royal_mansour/1.png','assets/images/marrakech/hotels/royal_mansour/2.png','assets/images/marrakech/hotels/royal_mansour/3.png']),
    // Restaurants
    _MapPOI(id: 'resto_001', name: 'Le Jardin', category: 'Restaurants', location: 'Souk Sidi Abdelaziz, Médina', rating: 4.7, price: '25€/moy', lat: 31.6325, lng: -7.9855, icon: Icons.restaurant_rounded, route: '/restaurant/resto_001', images: ['assets/images/marrakech/restaurants/le_jardin/1.png','assets/images/marrakech/restaurants/le_jardin/2.png','assets/images/marrakech/restaurants/le_jardin/3.png']),
    _MapPOI(id: 'resto_002', name: 'Nomad', category: 'Restaurants', location: 'Derb Aarjan, Médina', rating: 4.8, price: '30€/moy', lat: 31.6290, lng: -7.9860, icon: Icons.restaurant_rounded, route: '/restaurant/resto_002', images: ['assets/images/marrakech/restaurants/nomad/1.png','assets/images/marrakech/restaurants/nomad/2.png','assets/images/marrakech/restaurants/nomad/3.png']),
    _MapPOI(id: 'resto_003', name: 'Al Fassia', category: 'Restaurants', location: 'Guéliz, Marrakech', rating: 4.9, price: '35€/moy', lat: 31.6370, lng: -8.0060, icon: Icons.restaurant_rounded, route: '/restaurant/resto_003', images: ['assets/images/marrakech/restaurants/al_fassia/1.png','assets/images/marrakech/restaurants/al_fassia/2.png','assets/images/marrakech/restaurants/al_fassia/3.png']),
    _MapPOI(id: 'resto_004', name: 'CAFE CLOCK', category: 'Restaurants', location: 'Derb Chtouka, Kasbah', rating: 4.5, price: '12€/moy', lat: 31.6180, lng: -7.9910, icon: Icons.restaurant_rounded, route: '/restaurant/resto_004', images: ['assets/images/marrakech/restaurants/cafe_clock/1.png','assets/images/marrakech/restaurants/cafe_clock/2.png','assets/images/marrakech/restaurants/cafe_clock/3.png']),
    _MapPOI(id: 'resto_005', name: 'La Table du Palais', category: 'Restaurants', location: 'Royal Mansour, Médina', rating: 4.9, price: '120€/moy', lat: 31.6235, lng: -7.9925, icon: Icons.restaurant_rounded, route: '/restaurant/resto_005', images: ['assets/images/marrakech/restaurants/la_table_du_palais/1.png','assets/images/marrakech/restaurants/la_table_du_palais/2.png','assets/images/marrakech/restaurants/la_table_du_palais/3.png']),
    _MapPOI(id: 'resto_006', name: 'Chez Lamine Hadj Mustapha', category: 'Restaurants', location: 'Place Jemaa el-Fna', rating: 4.6, price: '8€/moy', lat: 31.6258, lng: -7.9891, icon: Icons.restaurant_rounded, route: '/restaurant/resto_006', images: ['assets/images/marrakech/restaurants/chez_lamine/1.png','assets/images/marrakech/restaurants/chez_lamine/2.png','assets/images/marrakech/restaurants/chez_lamine/3.png']),
    // Experiences
    _MapPOI(id: 'exp_001', name: 'Safari dans le Désert d\'Agafay', category: 'Expériences', location: 'Désert d\'Agafay, Marrakech', rating: 4.8, price: '85€/pers', lat: 31.4950, lng: -8.1350, icon: Icons.explore_rounded, route: '/experience/exp_001', images: ['assets/images/marrakech/experiences/safari_agafay/1.png','assets/images/marrakech/experiences/safari_agafay/2.png','assets/images/marrakech/experiences/safari_agafay/3.png']),
    _MapPOI(id: 'exp_002', name: 'Visite Guidée de la Médina', category: 'Expériences', location: 'Médina, Marrakech', rating: 4.7, price: '35€/pers', lat: 31.6300, lng: -7.9865, icon: Icons.explore_rounded, route: '/experience/exp_002', images: ['assets/images/marrakech/experiences/medina_visite/1.png','assets/images/marrakech/experiences/medina_visite/2.png','assets/images/marrakech/experiences/medina_visite/3.png']),
    _MapPOI(id: 'exp_003', name: 'Randonnée dans l\'Atlas', category: 'Expériences', location: 'Vallée de l\'Ourika', rating: 4.9, price: '60€/pers', lat: 31.3500, lng: -7.8500, icon: Icons.explore_rounded, route: '/experience/exp_003', images: ['assets/images/marrakech/experiences/randonnee_atlas/1.png','assets/images/marrakech/experiences/randonnee_atlas/2.png','assets/images/marrakech/experiences/randonnee_atlas/3.png']),
    _MapPOI(id: 'exp_004', name: 'Cours de Cuisine Marocaine', category: 'Expériences', location: 'Riad Cooking, Médina', rating: 4.8, price: '50€/pers', lat: 31.6315, lng: -7.9875, icon: Icons.explore_rounded, route: '/experience/exp_004', images: ['assets/images/marrakech/experiences/cours_cuisine/1.png','assets/images/marrakech/experiences/cours_cuisine/2.png','assets/images/marrakech/experiences/cours_cuisine/3.png']),
    _MapPOI(id: 'exp_005', name: 'Vol en Montgolfière', category: 'Expériences', location: 'Palmeraie, Marrakech', rating: 4.9, price: '180€/pers', lat: 31.6700, lng: -8.0100, icon: Icons.explore_rounded, route: '/experience/exp_005', images: ['assets/images/marrakech/experiences/vol_montgolfiere/1.png','assets/images/marrakech/experiences/vol_montgolfiere/2.png','assets/images/marrakech/experiences/vol_montgolfiere/3.png']),
    _MapPOI(id: 'exp_006', name: 'Jardin Majorelle & YSL', category: 'Expériences', location: 'Guéliz, Marrakech', rating: 4.7, price: '15€/pers', lat: 31.6418, lng: -8.0033, icon: Icons.explore_rounded, route: '/experience/exp_006', images: ['assets/images/marrakech/experiences/jardin_majorelle/1.png','assets/images/marrakech/experiences/jardin_majorelle/2.png','assets/images/marrakech/experiences/jardin_majorelle/3.png']),
    // Boutiques
    _MapPOI(id: 'boutique_001', name: 'Tapis Berbères El Badi', category: 'Boutiques', location: 'Souk des Tapis, Médina', rating: 4.8, price: '150-2000 DH', lat: 31.6320, lng: -7.9850, icon: Icons.storefront_rounded, route: '/boutique/boutique_001', images: ['assets/images/marrakech/boutiques/tapis_berberes/1.png','assets/images/marrakech/boutiques/tapis_berberes/2.png','assets/images/marrakech/boutiques/tapis_berberes/3.png']),
    _MapPOI(id: 'boutique_002', name: 'Atelier Céramique Safi', category: 'Boutiques', location: 'Derb Dabachi, Médina', rating: 4.7, price: '20-300 DH', lat: 31.6305, lng: -7.9845, icon: Icons.storefront_rounded, route: '/boutique/boutique_002', images: ['assets/images/marrakech/boutiques/ceramique_safi/1.png','assets/images/marrakech/boutiques/ceramique_safi/2.png','assets/images/marrakech/boutiques/ceramique_safi/3.png']),
    _MapPOI(id: 'boutique_003', name: 'Maroquinerie Artisanale Youssef', category: 'Boutiques', location: 'Souk Cherratine, Médina', rating: 4.6, price: '30-500 DH', lat: 31.6335, lng: -7.9840, icon: Icons.storefront_rounded, route: '/boutique/boutique_003', images: ['assets/images/marrakech/boutiques/maroquinerie_youssef/1.png','assets/images/marrakech/boutiques/maroquinerie_youssef/2.png','assets/images/marrakech/boutiques/maroquinerie_youssef/3.png']),
    _MapPOI(id: 'boutique_004', name: 'Bijoux Touareg Amina', category: 'Boutiques', location: 'Place des Ferblantiers', rating: 4.9, price: '50-800 DH', lat: 31.6195, lng: -7.9885, icon: Icons.storefront_rounded, route: '/boutique/boutique_004', images: ['assets/images/marrakech/boutiques/bijoux_touareg/1.png','assets/images/marrakech/boutiques/bijoux_touareg/2.png','assets/images/marrakech/boutiques/bijoux_touareg/3.png']),
    _MapPOI(id: 'boutique_005', name: 'Tissages Tradition Amazigh', category: 'Boutiques', location: 'Souk Haddadine, Médina', rating: 4.7, price: '40-600 DH', lat: 31.6330, lng: -7.9835, icon: Icons.storefront_rounded, route: '/boutique/boutique_005', images: ['assets/images/marrakech/boutiques/tissages_amazigh/1.png','assets/images/marrakech/boutiques/tissages_amazigh/2.png','assets/images/marrakech/boutiques/tissages_amazigh/3.png']),
    _MapPOI(id: 'boutique_006', name: 'Poterie d\'Art Tamegroute', category: 'Boutiques', location: 'Quartier des Potiers', rating: 4.5, price: '15-200 DH', lat: 31.6285, lng: -7.9900, icon: Icons.storefront_rounded, route: '/boutique/boutique_006', images: ['assets/images/marrakech/boutiques/poterie_tamegroute/1.png','assets/images/marrakech/boutiques/poterie_tamegroute/2.png','assets/images/marrakech/boutiques/poterie_tamegroute/3.png']),
  ];

  final List<_MapPOI> _casaPOIs = const [
    _MapPOI(id: 'hotel_casa_001', name: 'Four Seasons Casablanca', category: 'Hôtels', location: 'Corniche, Anfa', rating: 4.9, price: '400€/nuit', lat: 33.5890, lng: -7.6650, icon: Icons.hotel_rounded, route: '/hotel/hotel_casa_001', images: ['assets/images/casablanca/hotels/four_seasons_casa/1.jpg','assets/images/casablanca/hotels/four_seasons_casa/2.jpg','assets/images/casablanca/hotels/four_seasons_casa/3.jpg']),
    _MapPOI(id: 'hotel_casa_002', name: 'ONE Hotel Casablanca', category: 'Hôtels', location: 'Quartier Gauthier', rating: 4.7, price: '200€/nuit', lat: 33.5920, lng: -7.6200, icon: Icons.hotel_rounded, route: '/hotel/hotel_casa_002', images: ['assets/images/casablanca/hotels/le_doge_casa/1.jpg','assets/images/casablanca/hotels/le_doge_casa/2.jpg','assets/images/casablanca/hotels/le_doge_casa/3.jpg']),
    _MapPOI(id: 'hotel_casa_003', name: 'Marriott Casablanca', category: 'Hôtels', location: 'Place des Nations Unies', rating: 4.7, price: '220€/nuit', lat: 33.5980, lng: -7.6170, icon: Icons.hotel_rounded, route: '/hotel/hotel_casa_003', images: ['assets/images/casablanca/hotels/hyatt_casa/1.jpg','assets/images/casablanca/hotels/hyatt_casa/2.jpg','assets/images/casablanca/hotels/hyatt_casa/3.jpg']),
    _MapPOI(id: 'hotel_casa_004', name: 'Kenzi Tower', category: 'Hôtels', location: 'Twin Center, Maarif', rating: 4.6, price: '150€/nuit', lat: 33.5830, lng: -7.6310, icon: Icons.hotel_rounded, route: '/hotel/hotel_casa_004', images: ['assets/images/casablanca/hotels/kenzi_tower/1.jpg','assets/images/casablanca/hotels/kenzi_tower/2.jpg','assets/images/casablanca/hotels/kenzi_tower/3.jpg']),
    _MapPOI(id: 'resto_casa_001', name: 'Dar El Kaid', category: 'Restaurants', location: 'Quartier Habous', rating: 4.8, price: '35€/moy', lat: 33.6030, lng: -7.6130, icon: Icons.restaurant_rounded, route: '/restaurant/resto_casa_001', images: ['assets/images/casablanca/restaurants/ricks_cafe/1.jpg','assets/images/casablanca/restaurants/ricks_cafe/2.jpg','assets/images/casablanca/restaurants/ricks_cafe/3.jpg']),
    _MapPOI(id: 'resto_casa_002', name: 'Riad 1930', category: 'Restaurants', location: 'Ancienne Médina', rating: 4.8, price: '35€/moy', lat: 33.5970, lng: -7.6115, icon: Icons.restaurant_rounded, route: '/restaurant/resto_casa_002', images: ['assets/images/casablanca/restaurants/riad_1930/1.jpg','assets/images/casablanca/restaurants/riad_1930/2.jpg','assets/images/casablanca/restaurants/riad_1930/3.jpg']),
    _MapPOI(id: 'resto_casa_005', name: 'La Pergola', category: 'Restaurants', location: 'Boulevard d\'Anfa', rating: 4.8, price: '45€/moy', lat: 33.5940, lng: -7.6180, icon: Icons.restaurant_rounded, route: '/restaurant/resto_casa_005', images: ['assets/images/casablanca/restaurants/la_bodega/1.jpg','assets/images/casablanca/restaurants/la_bodega/2.jpg','assets/images/casablanca/restaurants/la_bodega/3.jpg']),
    _MapPOI(id: 'exp_casa_001', name: 'Visite Privée Mosquée Hassan II', category: 'Expériences', location: 'Bd de la Corniche', rating: 4.9, price: '53€/pers', lat: 33.6086, lng: -7.6327, icon: Icons.explore_rounded, route: '/experience/exp_casa_001', images: ['assets/images/casablanca/experiences/mosquee_hassan/1.jpg','assets/images/casablanca/experiences/mosquee_hassan/2.jpg','assets/images/casablanca/experiences/mosquee_hassan/3.jpg']),
    _MapPOI(id: 'exp_casa_002', name: 'Excursion Tanger en TGV', category: 'Expériences', location: 'Gare Casa Voyageurs', rating: 4.7, price: '95€/pers', lat: 33.5880, lng: -7.6680, icon: Icons.explore_rounded, route: '/experience/exp_casa_002', images: ['assets/images/casablanca/experiences/corniche_casa/1.jpg','assets/images/casablanca/experiences/corniche_casa/2.jpg','assets/images/casablanca/experiences/corniche_casa/3.jpg']),
    _MapPOI(id: 'exp_casa_003', name: 'Session Surf Atlantique', category: 'Expériences', location: 'Côte Atlantique', rating: 4.8, price: '40€/pers', lat: 33.6020, lng: -7.6120, icon: Icons.explore_rounded, route: '/experience/exp_casa_003', images: ['assets/images/casablanca/experiences/medina_casa/1.jpeg','assets/images/casablanca/experiences/medina_casa/2.jpg','assets/images/casablanca/experiences/medina_casa/3.jpg']),
    _MapPOI(id: 'exp_casa_006', name: 'Coucher de soleil en Yacht', category: 'Expériences', location: 'Marina', rating: 4.9, price: '200€/pers', lat: 33.5950, lng: -7.6350, icon: Icons.explore_rounded, route: '/experience/exp_casa_006', images: ['assets/images/casablanca/experiences/yacht_casa/1.png','assets/images/casablanca/experiences/yacht_casa/2.png','assets/images/casablanca/experiences/yacht_casa/3.png']),
    _MapPOI(id: 'boutique_casa_001', name: 'Tapis Berbères El Badi', category: 'Boutiques', location: 'Quartier Habous', rating: 4.8, price: '150-2000 DH', lat: 33.5760, lng: -7.6250, icon: Icons.storefront_rounded, route: '/boutique/boutique_casa_001', images: ['assets/images/marrakech/boutiques/tapis_berberes/1.png','assets/images/marrakech/boutiques/tapis_berberes/2.png','assets/images/marrakech/boutiques/tapis_berberes/3.png']),
    _MapPOI(id: 'boutique_casa_002', name: 'Atelier Céramique Safi', category: 'Boutiques', location: 'Derb Omar', rating: 4.7, price: '20-300 DH', lat: 33.5800, lng: -7.6100, icon: Icons.storefront_rounded, route: '/boutique/boutique_casa_002', images: ['assets/images/marrakech/boutiques/ceramique_safi/1.png','assets/images/marrakech/boutiques/ceramique_safi/2.png','assets/images/marrakech/boutiques/ceramique_safi/3.png']),
    _MapPOI(id: 'boutique_casa_003', name: 'Maroquinerie Youssef', category: 'Boutiques', location: 'Quartier Habous', rating: 4.6, price: '30-500 DH', lat: 33.5960, lng: -7.6190, icon: Icons.storefront_rounded, route: '/boutique/boutique_casa_003', images: ['assets/images/marrakech/boutiques/maroquinerie_youssef/1.png','assets/images/marrakech/boutiques/maroquinerie_youssef/2.png','assets/images/marrakech/boutiques/maroquinerie_youssef/3.png']),
    _MapPOI(id: 'boutique_casa_006', name: 'Bijoux Touareg Amina', category: 'Boutiques', location: 'Derb Omar', rating: 4.9, price: '50-800 DH', lat: 33.6100, lng: -7.5750, icon: Icons.storefront_rounded, route: '/boutique/boutique_casa_006', images: ['assets/images/marrakech/boutiques/bijoux_touareg/1.png','assets/images/marrakech/boutiques/bijoux_touareg/2.png','assets/images/marrakech/boutiques/bijoux_touareg/3.png']),
  ];

  @override
  void initState() {
    super.initState();
    _sheetCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _sheetSlide = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _sheetCtrl, curve: Curves.easeOutCubic));
  }

  String? _lastDestId;

  void _checkDestinationChange() {
    final currentId = ref.read(selectedDestinationProvider).idDestination;
    if (_lastDestId != null && _lastDestId != currentId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(_center, 13.0);
      });
    }
    _lastDestId = currentId;
  }

  @override
  void dispose() { _sheetCtrl.dispose(); super.dispose(); }

  List<_MapPOI> get _activePOIs {
    final isCasa = ref.watch(selectedDestinationProvider).idDestination == 'dest_002';
    return isCasa ? _casaPOIs : _allPOIs;
  }

  List<_MapPOI> get _filtered {
    final base = _activePOIs;
    if (_selectedFilter == 0) return base;
    return base.where((p) => p.category == _filters[_selectedFilter].label).toList();
  }

  Color _catColor(String c) {
    switch (c) {
      case 'Hôtels': return const Color(0xFFFF8C00);
      case 'Restaurants': return const Color(0xFFE91E63);
      case 'Expériences': return const Color(0xFF4CAF50);
      case 'Boutiques': return const Color(0xFF9C27B0);
      default: return const Color(0xFFFF8C00);
    }
  }

  void _selectPOI(_MapPOI poi) {
    setState(() => _selectedPOI = poi);
    _sheetCtrl.forward(from: 0);
  }

  void _dismiss() {
    _sheetCtrl.reverse().then((_) { if (mounted) setState(() => _selectedPOI = null); });
  }

  @override
  Widget build(BuildContext context) {
    _checkDestinationChange();
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Stack(children: [
        // Map
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(initialCenter: _center, initialZoom: 13.0, onTap: (_, _) => _dismiss(), backgroundColor: const Color(0xFF1A1A1A)),
          children: [
            TileLayer(urlTemplate: 'https://maps.geoapify.com/v1/tile/dark-matter/{z}/{x}/{y}.png?apiKey=$_geoapifyKey', userAgentPackageName: 'com.kurgate.app', retinaMode: true),
            MarkerLayer(markers: _filtered.map((poi) {
              final color = _catColor(poi.category);
              final sel = _selectedPOI?.id == poi.id;
              return Marker(
                point: LatLng(poi.lat, poi.lng), width: sel ? 48 : 40, height: sel ? 48 : 40,
                child: GestureDetector(
                  onTap: () => _selectPOI(poi),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: sel ? color : color.withValues(alpha: 0.9), shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: sel ? 3 : 2),
                      boxShadow: [BoxShadow(color: color.withValues(alpha: sel ? 0.6 : 0.3), blurRadius: sel ? 12 : 6, spreadRadius: sel ? 2 : 0)],
                    ),
                    child: Icon(poi.icon, color: Colors.white, size: sel ? 22 : 18),
                  ),
                ),
              );
            }).toList()),
          ],
        ),
        // Gradient
        Positioned(top: 0, left: 0, right: 0, child: Container(height: 140, decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [const Color(0xFF1A1A1A).withValues(alpha: 0.9), const Color(0xFF1A1A1A).withValues(alpha: 0.0)])))),
        // Header
        Positioned(top: 0, left: 0, right: 0, child: SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(20, 8, 20, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Explorer', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
          Text('${ref.watch(selectedDestinationProvider).nom} · ${_filtered.length} lieux', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.5), fontSize: 14)),
        ])))),
        // Filters
        Positioned(top: 0, left: 0, right: 0, child: SafeArea(child: Padding(padding: const EdgeInsets.only(top: 70), child: SizedBox(height: 40, child: ListView.builder(
          scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16), itemCount: _filters.length,
          itemBuilder: (ctx, i) {
            final a = i == _selectedFilter; final f = _filters[i];
            return Padding(padding: const EdgeInsets.only(right: 8), child: GestureDetector(
              onTap: () { setState(() => _selectedFilter = i); _dismiss(); },
              child: AnimatedContainer(duration: const Duration(milliseconds: 200), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(color: a ? const Color(0xFFFF8C00) : const Color(0xFF2A2A2A).withValues(alpha: 0.9), borderRadius: BorderRadius.circular(20), border: Border.all(color: a ? const Color(0xFFFF8C00) : Colors.white.withValues(alpha: 0.12)), boxShadow: a ? [BoxShadow(color: const Color(0xFFFF8C00).withValues(alpha: 0.3), blurRadius: 8)] : null),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(f.icon, size: 16, color: a ? Colors.black : Colors.white.withValues(alpha: 0.6)),
                  const SizedBox(width: 6),
                  Text(f.label, style: TextStyle(fontFamily: 'DarkerGrotesque', color: a ? Colors.black : Colors.white.withValues(alpha: 0.7), fontSize: 13, fontWeight: a ? FontWeight.w700 : FontWeight.w500)),
                ]),
              ),
            ));
          },
        ))))),
        // Legend
        Positioned(bottom: 16, left: 16, child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFF2A2A2A).withValues(alpha: 0.92), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withValues(alpha: 0.08))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            for (final f in _filters.skip(1)) Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 10, height: 10, decoration: BoxDecoration(color: _catColor(f.label), shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text(f.label, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.6), fontSize: 11, fontWeight: FontWeight.w500)),
            ])),
          ]),
        )),
        // Recenter
        Positioned(bottom: 16, right: 16, child: GestureDetector(
          onTap: () => _mapController.move(_center, 13.0),
          child: Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0xFF2A2A2A).withValues(alpha: 0.92), shape: BoxShape.circle, border: Border.all(color: Colors.white.withValues(alpha: 0.1))),
            child: Icon(Icons.my_location_rounded, color: Colors.white.withValues(alpha: 0.7), size: 20)),
        )),
        // Detail sheet
        if (_selectedPOI != null) Positioned(bottom: 0, left: 0, right: 0, child: SlideTransition(position: _sheetSlide, child: _DetailSheet(poi: _selectedPOI!, color: _catColor(_selectedPOI!.category), onClose: _dismiss))),
      ]),
    );
  }
}

// ── Detail Sheet with photos + booking button ──
class _DetailSheet extends StatefulWidget {
  final _MapPOI poi;
  final Color color;
  final VoidCallback onClose;
  const _DetailSheet({required this.poi, required this.color, required this.onClose});
  @override
  State<_DetailSheet> createState() => _DetailSheetState();
}

class _DetailSheetState extends State<_DetailSheet> {
  int _page = 0;
  final _pc = PageController();

  @override
  void dispose() { _pc.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final poi = widget.poi;
    final c = widget.color;
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF222222), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withValues(alpha: 0.08)), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 24, offset: const Offset(0, -6))]),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Photo gallery
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: SizedBox(
            height: 160,
            child: Stack(children: [
              PageView.builder(
                controller: _pc, itemCount: poi.images.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (ctx, i) => Image.asset(poi.images[i], fit: BoxFit.cover, width: double.infinity, cacheWidth: 400, gaplessPlayback: true,
                  errorBuilder: (_, _, _) => Container(color: const Color(0xFF2A2A2A), child: Center(child: Icon(poi.icon, size: 40, color: c.withValues(alpha: 0.3))))),
              ),
              // Dots
              Positioned(bottom: 10, left: 0, right: 0, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(poi.images.length, (i) {
                final a = i == _page;
                return AnimatedContainer(duration: const Duration(milliseconds: 250), margin: const EdgeInsets.symmetric(horizontal: 3), width: a ? 18 : 6, height: 6,
                  decoration: BoxDecoration(color: a ? const Color(0xFFFF8C00) : Colors.white.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(3)));
              }))),
              // Close
              Positioned(top: 10, right: 10, child: GestureDetector(onTap: widget.onClose, child: Container(width: 30, height: 30, decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.5), shape: BoxShape.circle), child: const Icon(Icons.close_rounded, color: Colors.white, size: 18)))),
              // Category badge
              Positioned(top: 10, left: 10, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(10)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(poi.icon, size: 13, color: Colors.white), const SizedBox(width: 4), Text(poi.category, style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))]))),
            ]),
          ),
        ),
        // Info + Book button
        Padding(padding: const EdgeInsets.all(16), child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(poi.name, style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
              const SizedBox(height: 2),
              Row(children: [
                Icon(Icons.location_on_outlined, size: 13, color: Colors.white.withValues(alpha: 0.4)), const SizedBox(width: 4),
                Expanded(child: Text(poi.location, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.4), fontSize: 13), overflow: TextOverflow.ellipsis)),
              ]),
            ])),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFFF8C00).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFF8C00)), const SizedBox(width: 3), Text('${poi.rating}', style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Color(0xFFFF8C00), fontSize: 13, fontWeight: FontWeight.w700))])),
          ]),
          const SizedBox(height: 4),
          Text(poi.price, style: TextStyle(fontFamily: 'DarkerGrotesque', color: c, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          // Buttons row
          Row(children: [
            // Navigate button
            Expanded(
              child: SizedBox(height: 44, child: OutlinedButton.icon(
                onPressed: () => launchUrl(Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${poi.lat},${poi.lng}'), mode: LaunchMode.externalApplication),
                icon: const Icon(Icons.navigation_rounded, size: 18),
                label: const Text('Itinéraire', style: TextStyle(fontFamily: 'DarkerGrotesque', fontSize: 14, fontWeight: FontWeight.w700)),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: BorderSide(color: Colors.white.withValues(alpha: 0.15)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              )),
            ),
            const SizedBox(width: 10),
            // Book button
            Expanded(
              child: SizedBox(height: 44, child: ElevatedButton.icon(
                onPressed: () => context.push(poi.route),
                icon: const Icon(Icons.bookmark_rounded, size: 18),
                label: const Text('Réserver', style: TextStyle(fontFamily: 'DarkerGrotesque', fontSize: 14, fontWeight: FontWeight.w800)),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF8C00), foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
              )),
            ),
          ]),
        ])),
      ]),
    );
  }
}

class _MapPOI {
  final String id, name, category, location, price, route;
  final double rating, lat, lng;
  final IconData icon;
  final List<String> images;
  const _MapPOI({required this.id, required this.name, required this.category, required this.location, required this.rating, required this.price, required this.lat, required this.lng, required this.icon, required this.route, required this.images});
}

class _FilterItem {
  final String label; final IconData icon;
  const _FilterItem({required this.label, required this.icon});
}
