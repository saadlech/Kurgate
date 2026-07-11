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

  static const String _azureMapsKey = 'DbWkJSbzVNaSrplE4yX0VQDDbt1VgBZW5KCoAG78I1evY51ql0Q7JQQJ99CFACYeBjFp4wt7AAAgAZMP2iFL';

  final _filters = const [
    _FilterItem(label: 'Tous', icon: Icons.layers_rounded),
    _FilterItem(label: 'Hôtels', icon: Icons.hotel_rounded),
    _FilterItem(label: 'Restaurants', icon: Icons.restaurant_rounded),
    _FilterItem(label: 'Expériences', icon: Icons.explore_rounded),
    _FilterItem(label: 'Attractions', icon: Icons.account_balance_rounded),
  ];

  static final _centerMarrakech = LatLng(31.6295, -7.9811);
  static final _centerCasa = LatLng(33.5731, -7.5898);
  static final _centerAgadir = LatLng(30.4278, -9.5981);
  static final _centerTangier = LatLng(35.7595, -5.8340);

  LatLng get _center {
    switch (ref.watch(selectedDestinationProvider).idDestination) {
      case 'dest_002': return _centerCasa;
      case 'dest_003': return _centerAgadir;
      case 'dest_004': return _centerTangier;
      default: return _centerMarrakech;
    }
  }

  final List<_MapPOI> _allPOIs = const [
    // Hotels
    _MapPOI(id: 'hotel_002', name: 'La Mamounia', category: 'Hôtels', location: 'Hivernage', rating: 4.9, price: '3500 MAD/nuit', lat: 31.6218, lng: -7.9973, icon: Icons.hotel_rounded, route: '/hotel/hotel_002', images: ['assets/images/marrakech/hotels/la_mamounia/1.png','assets/images/marrakech/hotels/la_mamounia/2.png','assets/images/marrakech/hotels/la_mamounia/3.png']),
    _MapPOI(id: 'hotel_003', name: 'Riad Yasmine', category: 'Hôtels', location: 'Médina', rating: 4.6, price: '950 MAD/nuit', lat: 31.6310, lng: -7.9870, icon: Icons.hotel_rounded, route: '/hotel/hotel_003', images: ['assets/images/marrakech/hotels/riad_yasmine/1.png','assets/images/marrakech/hotels/riad_yasmine/2.png','assets/images/marrakech/hotels/riad_yasmine/3.png']),
    _MapPOI(id: 'hotel_005', name: 'La Sultana', category: 'Hôtels', location: 'Kasbah', rating: 4.8, price: '2800 MAD/nuit', lat: 31.6175, lng: -7.9895, icon: Icons.hotel_rounded, route: '/hotel/hotel_005', images: ['assets/images/marrakech/hotels/la_sultana/1.png','assets/images/marrakech/hotels/la_sultana/2.png','assets/images/marrakech/hotels/la_sultana/3.png']),
    _MapPOI(id: 'hotel_006', name: 'Mandarin Oriental', category: 'Hôtels', location: 'Palmeraie', rating: 4.9, price: '4200 MAD/nuit', lat: 31.6680, lng: -8.0050, icon: Icons.hotel_rounded, route: '/hotel/hotel_006', images: ['assets/images/marrakech/hotels/mandarin_oriental/1.png','assets/images/marrakech/hotels/mandarin_oriental/2.png','assets/images/marrakech/hotels/mandarin_oriental/3.png']),
    _MapPOI(id: 'hotel_007', name: 'Riad Kniza', category: 'Hôtels', location: 'Médina', rating: 4.7, price: '2000 MAD/nuit', lat: 31.6280, lng: -7.9880, icon: Icons.hotel_rounded, route: '/hotel/hotel_007', images: ['assets/images/marrakech/hotels/riad_kniza/1.png','assets/images/marrakech/hotels/riad_kniza/2.png','assets/images/marrakech/hotels/riad_kniza/3.png']),
    _MapPOI(id: 'hotel_008', name: 'Royal Mansour', category: 'Hôtels', location: 'Médina', rating: 4.9, price: '5500 MAD/nuit', lat: 31.6230, lng: -7.9930, icon: Icons.hotel_rounded, route: '/hotel/hotel_008', images: ['assets/images/marrakech/hotels/royal_mansour/1.png','assets/images/marrakech/hotels/royal_mansour/2.png','assets/images/marrakech/hotels/royal_mansour/3.png']),
    // Restaurants
    _MapPOI(id: 'resto_001', name: 'Le Jardin', category: 'Restaurants', location: 'Souk Sidi Abdelaziz, Médina', rating: 4.7, price: '250 MAD/moy', lat: 31.6325, lng: -7.9855, icon: Icons.restaurant_rounded, route: '/restaurant/resto_001', images: ['assets/images/marrakech/restaurants/le_jardin/1.png','assets/images/marrakech/restaurants/le_jardin/2.png','assets/images/marrakech/restaurants/le_jardin/3.png']),
    _MapPOI(id: 'resto_002', name: 'Nomad', category: 'Restaurants', location: 'Derb Aarjan, Médina', rating: 4.8, price: '300 MAD/moy', lat: 31.6290, lng: -7.9860, icon: Icons.restaurant_rounded, route: '/restaurant/resto_002', images: ['assets/images/marrakech/restaurants/nomad/1.png','assets/images/marrakech/restaurants/nomad/2.png','assets/images/marrakech/restaurants/nomad/3.png']),
    _MapPOI(id: 'resto_003', name: 'Al Fassia', category: 'Restaurants', location: 'Guéliz, Marrakech', rating: 4.9, price: '350 MAD/moy', lat: 31.6370, lng: -8.0060, icon: Icons.restaurant_rounded, route: '/restaurant/resto_003', images: ['assets/images/marrakech/restaurants/al_fassia/1.png','assets/images/marrakech/restaurants/al_fassia/2.png','assets/images/marrakech/restaurants/al_fassia/3.png']),
    _MapPOI(id: 'resto_004', name: 'CAFE CLOCK', category: 'Restaurants', location: 'Derb Chtouka, Kasbah', rating: 4.5, price: '120 MAD/moy', lat: 31.6180, lng: -7.9910, icon: Icons.restaurant_rounded, route: '/restaurant/resto_004', images: ['assets/images/marrakech/restaurants/cafe_clock/1.png','assets/images/marrakech/restaurants/cafe_clock/2.png','assets/images/marrakech/restaurants/cafe_clock/3.png']),
    _MapPOI(id: 'resto_005', name: 'La Table du Palais', category: 'Restaurants', location: 'Royal Mansour, Médina', rating: 4.9, price: '1200 MAD/moy', lat: 31.6235, lng: -7.9925, icon: Icons.restaurant_rounded, route: '/restaurant/resto_005', images: ['assets/images/marrakech/restaurants/la_table_du_palais/1.png','assets/images/marrakech/restaurants/la_table_du_palais/2.png','assets/images/marrakech/restaurants/la_table_du_palais/3.png']),
    _MapPOI(id: 'resto_006', name: 'Chez Lamine Hadj Mustapha', category: 'Restaurants', location: 'Place Jemaa el-Fna', rating: 4.6, price: '80 MAD/moy', lat: 31.6258, lng: -7.9891, icon: Icons.restaurant_rounded, route: '/restaurant/resto_006', images: ['assets/images/marrakech/restaurants/chez_lamine/1.png','assets/images/marrakech/restaurants/chez_lamine/2.png','assets/images/marrakech/restaurants/chez_lamine/3.png']),
    // Experiences
    _MapPOI(id: 'exp_001', name: 'Safari dans le Désert d\'Agafay', category: 'Expériences', location: 'Désert d\'Agafay, Marrakech', rating: 4.8, price: '850 MAD/pers', lat: 31.4950, lng: -8.1350, icon: Icons.explore_rounded, route: '/experience/exp_001', images: ['assets/images/marrakech/experiences/safari_agafay/1.png','assets/images/marrakech/experiences/safari_agafay/2.png','assets/images/marrakech/experiences/safari_agafay/3.png']),
    _MapPOI(id: 'exp_002', name: 'Visite Guidée de la Médina', category: 'Expériences', location: 'Médina, Marrakech', rating: 4.7, price: '350 MAD/pers', lat: 31.6300, lng: -7.9865, icon: Icons.explore_rounded, route: '/experience/exp_002', images: ['assets/images/marrakech/experiences/medina_visite/1.png','assets/images/marrakech/experiences/medina_visite/2.png','assets/images/marrakech/experiences/medina_visite/3.png']),
    _MapPOI(id: 'exp_003', name: 'Randonnée dans l\'Atlas', category: 'Expériences', location: 'Vallée de l\'Ourika', rating: 4.9, price: '600 MAD/pers', lat: 31.3500, lng: -7.8500, icon: Icons.explore_rounded, route: '/experience/exp_003', images: ['assets/images/marrakech/experiences/randonnee_atlas/1.png','assets/images/marrakech/experiences/randonnee_atlas/2.png','assets/images/marrakech/experiences/randonnee_atlas/3.png']),
    _MapPOI(id: 'exp_004', name: 'Cours de Cuisine Marocaine', category: 'Expériences', location: 'Riad Cooking, Médina', rating: 4.8, price: '500 MAD/pers', lat: 31.6315, lng: -7.9875, icon: Icons.explore_rounded, route: '/experience/exp_004', images: ['assets/images/marrakech/experiences/cours_cuisine/1.png','assets/images/marrakech/experiences/cours_cuisine/2.png','assets/images/marrakech/experiences/cours_cuisine/3.png']),
    _MapPOI(id: 'exp_005', name: 'Vol en Montgolfière', category: 'Expériences', location: 'Palmeraie, Marrakech', rating: 4.9, price: '1800 MAD/pers', lat: 31.6700, lng: -8.0100, icon: Icons.explore_rounded, route: '/experience/exp_005', images: ['assets/images/marrakech/experiences/vol_montgolfiere/1.png','assets/images/marrakech/experiences/vol_montgolfiere/2.png','assets/images/marrakech/experiences/vol_montgolfiere/3.png']),
    _MapPOI(id: 'exp_006', name: 'Jardin Majorelle & YSL', category: 'Expériences', location: 'Guéliz, Marrakech', rating: 4.7, price: '150 MAD/pers', lat: 31.6418, lng: -8.0033, icon: Icons.explore_rounded, route: '/experience/exp_006', images: ['assets/images/marrakech/experiences/jardin_majorelle/1.png','assets/images/marrakech/experiences/jardin_majorelle/2.png','assets/images/marrakech/experiences/jardin_majorelle/3.png']),
    // Attractions
    _MapPOI(id: 'attr_002', name: 'Jardin Majorelle', category: 'Attractions', location: 'Guéliz, Marrakech', rating: 4.7, price: 'Gratuit', lat: 31.6418, lng: -8.0032, icon: Icons.account_balance_rounded, route: '/attraction/attr_002', images: ['assets/images/marrakech/attractions/jardin_majorelle/1.jpg','assets/images/marrakech/attractions/jardin_majorelle/2.jpg','assets/images/marrakech/attractions/jardin_majorelle/3.jpg']),
    _MapPOI(id: 'attr_003', name: 'Palais Bahia', category: 'Attractions', location: 'Mellah, Marrakech', rating: 4.6, price: 'Gratuit', lat: 31.6217, lng: -7.9823, icon: Icons.account_balance_rounded, route: '/attraction/attr_003', images: ['assets/images/marrakech/attractions/bahia_palace/1.jpg','assets/images/marrakech/attractions/bahia_palace/2.jpg','assets/images/marrakech/attractions/bahia_palace/3.jpg']),
    _MapPOI(id: 'attr_004', name: 'Mosquée Koutoubia', category: 'Attractions', location: 'Médina, Marrakech', rating: 4.9, price: 'Gratuit', lat: 31.6237, lng: -7.9939, icon: Icons.account_balance_rounded, route: '/attraction/attr_004', images: ['assets/images/marrakech/attractions/koutoubia/1.jpg','assets/images/marrakech/attractions/koutoubia/2.jpg','assets/images/marrakech/attractions/koutoubia/3.jpg']),
    _MapPOI(id: 'attr_005', name: 'Tombeaux Saadiens', category: 'Attractions', location: 'Kasbah, Marrakech', rating: 4.5, price: 'Gratuit', lat: 31.6178, lng: -7.9901, icon: Icons.account_balance_rounded, route: '/attraction/attr_005', images: ['assets/images/marrakech/attractions/tombeaux_saadiens/1.jpg','assets/images/marrakech/attractions/tombeaux_saadiens/2.jpg','assets/images/marrakech/attractions/tombeaux_saadiens/3.jpg']),
    _MapPOI(id: 'attr_008', name: 'Jardins de la Ménara', category: 'Attractions', location: 'Hivernage, Marrakech', rating: 4.3, price: 'Gratuit', lat: 31.6138, lng: -8.0225, icon: Icons.account_balance_rounded, route: '/attraction/attr_008', images: ['assets/images/marrakech/attractions/menara/1.jpg','assets/images/marrakech/attractions/menara/2.jpg','assets/images/marrakech/attractions/menara/3.jpg']),
  ];

  final List<_MapPOI> _casaPOIs = const [
    _MapPOI(id: 'hotel_casa_001', name: 'Four Seasons Casablanca', category: 'Hôtels', location: 'Corniche, Anfa', rating: 4.9, price: '4000 MAD/nuit', lat: 33.5890, lng: -7.6650, icon: Icons.hotel_rounded, route: '/hotel/hotel_casa_001', images: ['assets/images/casablanca/hotels/four_seasons_casa/1.jpg','assets/images/casablanca/hotels/four_seasons_casa/2.jpg','assets/images/casablanca/hotels/four_seasons_casa/3.jpg']),
    _MapPOI(id: 'hotel_casa_002', name: 'ONE Hotel Casablanca', category: 'Hôtels', location: 'Quartier Gauthier', rating: 4.7, price: '2000 MAD/nuit', lat: 33.5920, lng: -7.6200, icon: Icons.hotel_rounded, route: '/hotel/hotel_casa_002', images: ['assets/images/casablanca/hotels/le_doge_casa/1.jpg','assets/images/casablanca/hotels/le_doge_casa/2.jpg','assets/images/casablanca/hotels/le_doge_casa/3.jpg']),
    _MapPOI(id: 'hotel_casa_003', name: 'Marriott Casablanca', category: 'Hôtels', location: 'Place des Nations Unies', rating: 4.7, price: '2200 MAD/nuit', lat: 33.5980, lng: -7.6170, icon: Icons.hotel_rounded, route: '/hotel/hotel_casa_003', images: ['assets/images/casablanca/hotels/hyatt_casa/1.jpg','assets/images/casablanca/hotels/hyatt_casa/2.jpg','assets/images/casablanca/hotels/hyatt_casa/3.jpg']),
    _MapPOI(id: 'hotel_casa_004', name: 'Kenzi Tower', category: 'Hôtels', location: 'Twin Center, Maarif', rating: 4.6, price: '1500 MAD/nuit', lat: 33.5830, lng: -7.6310, icon: Icons.hotel_rounded, route: '/hotel/hotel_casa_004', images: ['assets/images/casablanca/hotels/kenzi_tower/1.jpg','assets/images/casablanca/hotels/kenzi_tower/2.jpg','assets/images/casablanca/hotels/kenzi_tower/3.jpg']),
    _MapPOI(id: 'resto_casa_001', name: 'Dar El Kaid', category: 'Restaurants', location: 'Quartier Habous', rating: 4.8, price: '350 MAD/moy', lat: 33.6030, lng: -7.6130, icon: Icons.restaurant_rounded, route: '/restaurant/resto_casa_001', images: ['assets/images/casablanca/restaurants/ricks_cafe/1.jpg','assets/images/casablanca/restaurants/ricks_cafe/2.jpg','assets/images/casablanca/restaurants/ricks_cafe/3.jpg']),
    _MapPOI(id: 'resto_casa_002', name: 'Riad 1930', category: 'Restaurants', location: 'Ancienne Médina', rating: 4.8, price: '350 MAD/moy', lat: 33.5970, lng: -7.6115, icon: Icons.restaurant_rounded, route: '/restaurant/resto_casa_002', images: ['assets/images/casablanca/restaurants/riad_1930/1.jpg','assets/images/casablanca/restaurants/riad_1930/2.jpg','assets/images/casablanca/restaurants/riad_1930/3.jpg']),
    _MapPOI(id: 'resto_casa_005', name: 'La Pergola', category: 'Restaurants', location: 'Boulevard d\'Anfa', rating: 4.8, price: '450 MAD/moy', lat: 33.5940, lng: -7.6180, icon: Icons.restaurant_rounded, route: '/restaurant/resto_casa_005', images: ['assets/images/casablanca/restaurants/la_bodega/1.jpg','assets/images/casablanca/restaurants/la_bodega/2.jpg','assets/images/casablanca/restaurants/la_bodega/3.jpg']),
    _MapPOI(id: 'exp_casa_001', name: 'Visite Privée Mosquée Hassan II', category: 'Expériences', location: 'Bd de la Corniche', rating: 4.9, price: '530 MAD/pers', lat: 33.6086, lng: -7.6327, icon: Icons.explore_rounded, route: '/experience/exp_casa_001', images: ['assets/images/casablanca/experiences/mosquee_hassan/1.jpg','assets/images/casablanca/experiences/mosquee_hassan/2.jpg','assets/images/casablanca/experiences/mosquee_hassan/3.jpg']),
    _MapPOI(id: 'exp_casa_002', name: 'Excursion Tanger en TGV', category: 'Expériences', location: 'Gare Casa Voyageurs', rating: 4.7, price: '950 MAD/pers', lat: 33.5880, lng: -7.6680, icon: Icons.explore_rounded, route: '/experience/exp_casa_002', images: ['assets/images/casablanca/experiences/corniche_casa/1.jpg','assets/images/casablanca/experiences/corniche_casa/2.jpg','assets/images/casablanca/experiences/corniche_casa/3.jpg']),
    _MapPOI(id: 'exp_casa_003', name: 'Session Surf Atlantique', category: 'Expériences', location: 'Côte Atlantique', rating: 4.8, price: '400 MAD/pers', lat: 33.6020, lng: -7.6120, icon: Icons.explore_rounded, route: '/experience/exp_casa_003', images: ['assets/images/casablanca/experiences/medina_casa/1.jpeg','assets/images/casablanca/experiences/medina_casa/2.jpg','assets/images/casablanca/experiences/medina_casa/3.jpg']),
    _MapPOI(id: 'exp_casa_006', name: 'Coucher de soleil en Yacht', category: 'Expériences', location: 'Marina', rating: 4.9, price: '2000 MAD/pers', lat: 33.5950, lng: -7.6350, icon: Icons.explore_rounded, route: '/experience/exp_casa_006', images: ['assets/images/casablanca/experiences/yacht_casa/1.png','assets/images/casablanca/experiences/yacht_casa/2.png','assets/images/casablanca/experiences/yacht_casa/3.png']),
    // Missing Hotels
    _MapPOI(id: 'hotel_casa_005', name: 'Sofitel Casablanca', category: 'Hôtels', location: 'Tour Blanche', rating: 4.8, price: '2500 MAD/nuit', lat: 33.5860, lng: -7.6250, icon: Icons.hotel_rounded, route: '/hotel/hotel_casa_005', images: ['assets/images/casablanca/hotels/sofitel_casa/1.jpg','assets/images/casablanca/hotels/sofitel_casa/2.jpg','assets/images/casablanca/hotels/sofitel_casa/3.jpg']),
    _MapPOI(id: 'hotel_casa_006', name: 'Barceló Anfa', category: 'Hôtels', location: 'Corniche', rating: 4.5, price: '1800 MAD/nuit', lat: 33.5810, lng: -7.6580, icon: Icons.hotel_rounded, route: '/hotel/hotel_casa_006', images: ['assets/images/casablanca/hotels/transatlantique/1.jpg','assets/images/casablanca/hotels/transatlantique/2.jpg','assets/images/casablanca/hotels/transatlantique/3.jpg']),
    // Missing Restaurants
    _MapPOI(id: 'resto_casa_004', name: 'Kyoto Sushi', category: 'Restaurants', location: 'Maarif', rating: 4.7, price: '400 MAD/moy', lat: 33.5850, lng: -7.6280, icon: Icons.restaurant_rounded, route: '/restaurant/resto_casa_004', images: ['assets/images/casablanca/restaurants/basmane/1.jpg','assets/images/casablanca/restaurants/basmane/2.jpg','assets/images/casablanca/restaurants/basmane/3.jpg']),
    _MapPOI(id: 'resto_casa_006', name: 'Le Doge Café & Tapas', category: 'Restaurants', location: 'Quartier Gauthier', rating: 4.6, price: '300 MAD/moy', lat: 33.5915, lng: -7.6210, icon: Icons.restaurant_rounded, route: '/restaurant/resto_casa_006', images: ['assets/images/casablanca/restaurants/blend/1.jpg','assets/images/casablanca/restaurants/blend/2.jpg','assets/images/casablanca/restaurants/blend/3.jpg']),
    // Attractions
    _MapPOI(id: 'attr_casa_001', name: 'Mosquée Hassan II', category: 'Attractions', location: 'Corniche, Casablanca', rating: 4.9, price: 'Gratuit', lat: 33.6087, lng: -7.6322, icon: Icons.account_balance_rounded, route: '/attraction/attr_casa_001', images: ['assets/images/casablanca/attractions/hassan_ii/1.jpg','assets/images/casablanca/attractions/hassan_ii/2.jpg','assets/images/casablanca/attractions/hassan_ii/3.jpg']),
    _MapPOI(id: 'attr_casa_002', name: 'Place Mohammed V', category: 'Attractions', location: 'Centre-ville, Casablanca', rating: 4.5, price: 'Gratuit', lat: 33.5912, lng: -7.6186, icon: Icons.account_balance_rounded, route: '/attraction/attr_casa_002', images: ['assets/images/casablanca/attractions/mohammed_v/1.jpg','assets/images/casablanca/attractions/mohammed_v/2.jpg','assets/images/casablanca/attractions/mohammed_v/3.jpg']),
    _MapPOI(id: 'attr_casa_003', name: 'Morocco Mall', category: 'Attractions', location: 'Corniche, Casablanca', rating: 4.4, price: 'Gratuit', lat: 33.5767, lng: -7.6608, icon: Icons.account_balance_rounded, route: '/attraction/attr_casa_003', images: ['assets/images/casablanca/attractions/morocco_mall/1.jpg','assets/images/casablanca/attractions/morocco_mall/2.jpg','assets/images/casablanca/attractions/morocco_mall/3.jpg']),
    _MapPOI(id: 'attr_casa_004', name: 'Église Notre-Dame de Lourdes', category: 'Attractions', location: 'Quartier des Hôpitaux', rating: 4.3, price: 'Gratuit', lat: 33.5876, lng: -7.6254, icon: Icons.account_balance_rounded, route: '/attraction/attr_casa_004', images: ['assets/images/casablanca/attractions/notre_dame/1.jpg','assets/images/casablanca/attractions/notre_dame/2.jpg','assets/images/casablanca/attractions/notre_dame/3.jpg']),
    _MapPOI(id: 'attr_casa_005', name: 'Quartier Habous', category: 'Attractions', location: 'Habous, Casablanca', rating: 4.6, price: 'Gratuit', lat: 33.5751, lng: -7.6078, icon: Icons.account_balance_rounded, route: '/attraction/attr_casa_005', images: ['assets/images/casablanca/attractions/quartier_habous/1.jpg','assets/images/casablanca/attractions/quartier_habous/2.jpg','assets/images/casablanca/attractions/quartier_habous/3.jpg']),
    _MapPOI(id: 'attr_casa_006', name: 'Palais Royal', category: 'Attractions', location: 'Mechouar, Casablanca', rating: 4.2, price: 'Gratuit', lat: 33.5839, lng: -7.6175, icon: Icons.account_balance_rounded, route: '/attraction/attr_casa_006', images: ['assets/images/casablanca/attractions/royal_palace/1.jpg','assets/images/casablanca/attractions/royal_palace/2.jpg','assets/images/casablanca/attractions/royal_palace/3.jpg']),
  ];

  // ── Agadir POIs ──
  final List<_MapPOI> _agadirPOIs = const [
    // Hotels
    _MapPOI(id: 'hotel_aga_001', name: 'Sofitel Royal Bay Resort', category: 'Hôtels', location: 'Baie d\'Agadir', rating: 4.8, price: '2800 MAD/nuit', lat: 30.4150, lng: -9.6050, icon: Icons.hotel_rounded, route: '/hotel/hotel_aga_001', images: ['assets/images/agadir/hotels/sofitel_royal_bay/1.jpg','assets/images/agadir/hotels/sofitel_royal_bay/2.jpg','assets/images/agadir/hotels/sofitel_royal_bay/3.jpg']),
    _MapPOI(id: 'hotel_aga_002', name: 'Sofitel Thalassa Sea & Spa', category: 'Hôtels', location: 'Bord de Mer', rating: 4.9, price: '3200 MAD/nuit', lat: 30.4200, lng: -9.6100, icon: Icons.hotel_rounded, route: '/hotel/hotel_aga_002', images: ['assets/images/agadir/hotels/sofitel_thalassa/1.jpg','assets/images/agadir/hotels/sofitel_thalassa/2.jpg','assets/images/agadir/hotels/sofitel_thalassa/3.jpg']),
    _MapPOI(id: 'hotel_aga_003', name: 'Riu Palace Tikida', category: 'Hôtels', location: 'Secteur Balnéaire', rating: 4.7, price: '1800 MAD/nuit', lat: 30.4120, lng: -9.5980, icon: Icons.hotel_rounded, route: '/hotel/hotel_aga_003', images: ['assets/images/agadir/hotels/riu_palace_tikida/1.jpg','assets/images/agadir/hotels/riu_palace_tikida/2.jpg','assets/images/agadir/hotels/riu_palace_tikida/3.jpg']),
    _MapPOI(id: 'hotel_aga_004', name: 'The View Agadir', category: 'Hôtels', location: 'Colline Oufella', rating: 4.6, price: '1500 MAD/nuit', lat: 30.4338, lng: -9.6168, icon: Icons.hotel_rounded, route: '/hotel/hotel_aga_004', images: ['assets/images/agadir/hotels/the_view/1.jpg','assets/images/agadir/hotels/the_view/2.jpg','assets/images/agadir/hotels/the_view/3.jpg']),
    _MapPOI(id: 'hotel_aga_005', name: 'Dunes d\'Or Ocean Club', category: 'Hôtels', location: 'Secteur Balnéaire', rating: 4.5, price: '1200 MAD/nuit', lat: 30.4080, lng: -9.5950, icon: Icons.hotel_rounded, route: '/hotel/hotel_aga_005', images: ['assets/images/agadir/hotels/dunes_dor/1.jpg','assets/images/agadir/hotels/dunes_dor/2.jpg','assets/images/agadir/hotels/dunes_dor/3.jpg']),
    // Restaurants
    _MapPOI(id: 'resto_aga_001', name: 'El Toro', category: 'Restaurants', location: 'Marina d\'Agadir', rating: 4.7, price: '450 MAD/moy', lat: 30.4167, lng: -9.5989, icon: Icons.restaurant_rounded, route: '/restaurant/resto_aga_001', images: ['assets/images/agadir/restaurants/el_toro/1.jpg','assets/images/agadir/restaurants/el_toro/2.jpg','assets/images/agadir/restaurants/el_toro/3.jpg']),
    _MapPOI(id: 'resto_aga_002', name: 'La Plage Restaurant', category: 'Restaurants', location: 'Corniche, Agadir', rating: 4.8, price: '550 MAD/moy', lat: 30.4220, lng: -9.6120, icon: Icons.restaurant_rounded, route: '/restaurant/resto_aga_002', images: ['assets/images/agadir/restaurants/la_plage/1.jpg','assets/images/agadir/restaurants/la_plage/2.jpg','assets/images/agadir/restaurants/la_plage/3.jpg']),
    _MapPOI(id: 'resto_aga_003', name: 'Le 20\' Restaurant', category: 'Restaurants', location: 'Secteur Touristique', rating: 4.9, price: '600 MAD/moy', lat: 30.4190, lng: -9.6030, icon: Icons.restaurant_rounded, route: '/restaurant/resto_aga_003', images: ['assets/images/agadir/restaurants/le_20/1.jpg','assets/images/agadir/restaurants/le_20/2.jpg','assets/images/agadir/restaurants/le_20/3.jpg']),
    _MapPOI(id: 'resto_aga_004', name: 'Little Italy', category: 'Restaurants', location: 'Nouveau Talborjt', rating: 4.6, price: '350 MAD/moy', lat: 30.4260, lng: -9.5970, icon: Icons.restaurant_rounded, route: '/restaurant/resto_aga_004', images: ['assets/images/agadir/restaurants/little_italy/1.jpg','assets/images/agadir/restaurants/little_italy/2.jpg','assets/images/agadir/restaurants/little_italy/3.jpg']),
    _MapPOI(id: 'resto_aga_005', name: 'Restaurant Rafiq', category: 'Restaurants', location: 'Centre-ville, Agadir', rating: 4.5, price: '300 MAD/moy', lat: 30.4300, lng: -9.5920, icon: Icons.restaurant_rounded, route: '/restaurant/resto_aga_005', images: ['assets/images/agadir/restaurants/rafiq/1.jpg','assets/images/agadir/restaurants/rafiq/2.jpg','assets/images/agadir/restaurants/rafiq/3.jpg']),
    // Experiences
    _MapPOI(id: 'exp_aga_001', name: 'City Tour Kasbah & Souk', category: 'Expériences', location: 'Centre, Agadir', rating: 4.7, price: '350 MAD/pers', lat: 30.4338, lng: -9.6168, icon: Icons.explore_rounded, route: '/experience/exp_aga_001', images: ['assets/images/agadir/experiences/city_tour/1.jpg','assets/images/agadir/experiences/city_tour/2.jpg','assets/images/agadir/experiences/city_tour/3.jpg']),
    _MapPOI(id: 'exp_aga_002', name: 'Sandboarding & Quad Bike', category: 'Expériences', location: 'Dunes, Agadir', rating: 4.8, price: '650 MAD/pers', lat: 30.3800, lng: -9.5500, icon: Icons.explore_rounded, route: '/experience/exp_aga_002', images: ['assets/images/agadir/experiences/sandboarding/1.jpg','assets/images/agadir/experiences/sandboarding/2.jpg','assets/images/agadir/experiences/sandboarding/3.jpg']),
    _MapPOI(id: 'exp_aga_003', name: 'Yacht Cruise & Fishing', category: 'Expériences', location: 'Marina, Agadir', rating: 4.9, price: '1200 MAD/pers', lat: 30.4167, lng: -9.5989, icon: Icons.explore_rounded, route: '/experience/exp_aga_003', images: ['assets/images/agadir/experiences/yacht_cruise/1.jpg','assets/images/agadir/experiences/yacht_cruise/2.jpg','assets/images/agadir/experiences/yacht_cruise/3.jpg']),
    _MapPOI(id: 'exp_aga_004', name: 'Téléphérique & City Tour', category: 'Expériences', location: 'Oufella, Agadir', rating: 4.6, price: '400 MAD/pers', lat: 30.4310, lng: -9.6140, icon: Icons.explore_rounded, route: '/experience/exp_aga_004', images: ['assets/images/agadir/experiences/cable_car/1.jpg','assets/images/agadir/experiences/cable_car/2.jpg','assets/images/agadir/experiences/cable_car/3.jpg']),
    _MapPOI(id: 'exp_aga_005', name: 'Paradise Valley & Atlas', category: 'Expériences', location: 'Vallée du Paradis', rating: 4.8, price: '550 MAD/pers', lat: 30.5200, lng: -9.4800, icon: Icons.explore_rounded, route: '/experience/exp_aga_005', images: ['assets/images/agadir/experiences/paradise_valley/1.jpg','assets/images/agadir/experiences/paradise_valley/2.jpg','assets/images/agadir/experiences/paradise_valley/3.jpg']),
    _MapPOI(id: 'exp_aga_006', name: 'Crocoparc Agadir', category: 'Expériences', location: 'Route de Drarga', rating: 4.5, price: '250 MAD/pers', lat: 30.3600, lng: -9.5300, icon: Icons.explore_rounded, route: '/experience/exp_aga_006', images: ['assets/images/agadir/experiences/crocoparc/1.jpg','assets/images/agadir/experiences/crocoparc/2.jpg','assets/images/agadir/experiences/crocoparc/3.jpg']),
    // Attractions
    _MapPOI(id: 'attr_aga_001', name: 'Kasbah Oufella', category: 'Attractions', location: 'Colline Oufella, Agadir', rating: 4.6, price: 'Gratuit', lat: 30.4338, lng: -9.6168, icon: Icons.account_balance_rounded, route: '/attraction/attr_aga_001', images: ['assets/images/agadir/attractions/kasbah_oufella/1.jpg','assets/images/agadir/attractions/kasbah_oufella/2.jpg','assets/images/agadir/attractions/kasbah_oufella/3.jpg']),
    _MapPOI(id: 'attr_aga_002', name: 'Marina d\'Agadir', category: 'Attractions', location: 'Front de Mer, Agadir', rating: 4.5, price: 'Gratuit', lat: 30.4167, lng: -9.5989, icon: Icons.account_balance_rounded, route: '/attraction/attr_aga_002', images: ['assets/images/agadir/attractions/marina_agadir/1.jpg','assets/images/agadir/attractions/marina_agadir/2.jpg','assets/images/agadir/attractions/marina_agadir/3.jpg']),
  ];

  // ── Tangier POIs ──
  final List<_MapPOI> _tangierPOIs = const [
    // Hotels
    _MapPOI(id: 'hotel_tan_001', name: 'Hilton Al Houara Resort', category: 'Hôtels', location: 'Al Houara', rating: 4.9, price: '3500 MAD/nuit', lat: 35.6673, lng: -5.9658, icon: Icons.hotel_rounded, route: '/hotel/hotel_tan_001', images: ['assets/images/tanger/hotels/hilton_al_houara/1.jpg','assets/images/tanger/hotels/hilton_al_houara/2.jpg','assets/images/tanger/hotels/hilton_al_houara/3.jpg']),
    _MapPOI(id: 'hotel_tan_002', name: 'Hilton Tangier City Center', category: 'Hôtels', location: 'Centre Ville', rating: 4.8, price: '2200 MAD/nuit', lat: 35.7729, lng: -5.7862, icon: Icons.hotel_rounded, route: '/hotel/hotel_tan_002', images: ['assets/images/tanger/hotels/hilton_city_center/1.jpg','assets/images/tanger/hotels/hilton_city_center/2.jpg','assets/images/tanger/hotels/hilton_city_center/3.jpg']),
    _MapPOI(id: 'hotel_tan_003', name: 'Barceló Tanger', category: 'Hôtels', location: 'Avenue Mohammed VI', rating: 4.7, price: '1800 MAD/nuit', lat: 35.7825, lng: -5.8058, icon: Icons.hotel_rounded, route: '/hotel/hotel_tan_003', images: ['assets/images/tanger/hotels/barcelo/1.jpg','assets/images/tanger/hotels/barcelo/2.jpg','assets/images/tanger/hotels/barcelo/3.jpg']),
    _MapPOI(id: 'hotel_tan_004', name: 'Hilton Garden Inn', category: 'Hôtels', location: 'Centre Ville', rating: 4.6, price: '1400 MAD/nuit', lat: 35.7738, lng: -5.7871, icon: Icons.hotel_rounded, route: '/hotel/hotel_tan_004', images: ['assets/images/tanger/hotels/hilton_garden_inn/1.jpg','assets/images/tanger/hotels/hilton_garden_inn/2.jpg','assets/images/tanger/hotels/hilton_garden_inn/3.jpg']),
    _MapPOI(id: 'hotel_tan_005', name: 'Pestana Tanger', category: 'Hôtels', location: 'Place du Maghreb Arabe', rating: 4.7, price: '1600 MAD/nuit', lat: 35.7778, lng: -5.7995, icon: Icons.hotel_rounded, route: '/hotel/hotel_tan_005', images: ['assets/images/tanger/hotels/pestana/1.jpg','assets/images/tanger/hotels/pestana/2.jpg','assets/images/tanger/hotels/pestana/3.jpg']),
    // Restaurants
    _MapPOI(id: 'resto_tan_001', name: 'El Morocco Club', category: 'Restaurants', location: 'Médina, Tanger', rating: 4.9, price: '550 MAD/moy', lat: 35.7867, lng: -5.8117, icon: Icons.restaurant_rounded, route: '/restaurant/resto_tan_001', images: ['assets/images/tanger/restaurants/el_morocco_club/1.jpg','assets/images/tanger/restaurants/el_morocco_club/2.jpg','assets/images/tanger/restaurants/el_morocco_club/3.jpg']),
    _MapPOI(id: 'resto_tan_002', name: 'L\'Olivier Restaurant', category: 'Restaurants', location: 'Boulevard Pasteur', rating: 4.7, price: '450 MAD/moy', lat: 35.7730, lng: -5.8130, icon: Icons.restaurant_rounded, route: '/restaurant/resto_tan_002', images: ['assets/images/tanger/restaurants/lolivier/1.jpg','assets/images/tanger/restaurants/lolivier/2.jpg','assets/images/tanger/restaurants/lolivier/3.jpg']),
    _MapPOI(id: 'resto_tan_003', name: 'Macondo', category: 'Restaurants', location: 'Place de la Kasbah', rating: 4.6, price: '400 MAD/moy', lat: 35.7890, lng: -5.8090, icon: Icons.restaurant_rounded, route: '/restaurant/resto_tan_003', images: ['assets/images/tanger/restaurants/macondo/1.jpg','assets/images/tanger/restaurants/macondo/2.jpg','assets/images/tanger/restaurants/macondo/3.jpg']),
    _MapPOI(id: 'resto_tan_004', name: 'Les Huîtres', category: 'Restaurants', location: 'Corniche, Tanger', rating: 4.8, price: '500 MAD/moy', lat: 35.7650, lng: -5.8200, icon: Icons.restaurant_rounded, route: '/restaurant/resto_tan_004', images: ['assets/images/tanger/restaurants/les_huitres/1.jpg','assets/images/tanger/restaurants/les_huitres/2.jpg','assets/images/tanger/restaurants/les_huitres/3.jpg']),
    _MapPOI(id: 'resto_tan_005', name: 'Palais Zahia', category: 'Restaurants', location: 'Ancienne Médina', rating: 4.8, price: '600 MAD/moy', lat: 35.7860, lng: -5.8100, icon: Icons.restaurant_rounded, route: '/restaurant/resto_tan_005', images: ['assets/images/tanger/restaurants/palais_zahia/1.jpg','assets/images/tanger/restaurants/palais_zahia/2.jpg','assets/images/tanger/restaurants/palais_zahia/3.jpg']),
    // Experiences
    _MapPOI(id: 'exp_tan_001', name: 'Luxury Tangier Tour', category: 'Expériences', location: 'Tanger Privé', rating: 4.9, price: '950 MAD/pers', lat: 35.7750, lng: -5.8100, icon: Icons.explore_rounded, route: '/experience/exp_tan_001', images: ['assets/images/tanger/experiences/luxury_tour/1.jpg','assets/images/tanger/experiences/luxury_tour/2.jpg','assets/images/tanger/experiences/luxury_tour/3.jpg']),
    _MapPOI(id: 'exp_tan_002', name: 'Grand Tour de Tanger', category: 'Expériences', location: 'Tanger Premium', rating: 4.8, price: '850 MAD/pers', lat: 35.7925, lng: -5.9267, icon: Icons.explore_rounded, route: '/experience/exp_tan_002', images: ['assets/images/tanger/experiences/grand_tour/1.jpg','assets/images/tanger/experiences/grand_tour/2.jpg','assets/images/tanger/experiences/grand_tour/3.jpg']),
    // Attractions
    _MapPOI(id: 'attr_tan_001', name: 'Cap Spartel', category: 'Attractions', location: 'Cap Spartel, Tanger', rating: 4.8, price: 'Gratuit', lat: 35.7925, lng: -5.9267, icon: Icons.account_balance_rounded, route: '/attraction/attr_tan_001', images: ['assets/images/tanger/attractions/cap_spartel/1.jpg','assets/images/tanger/attractions/cap_spartel/2.jpg','assets/images/tanger/attractions/cap_spartel/3.jpg']),
    _MapPOI(id: 'attr_tan_002', name: 'Grottes d\'Hercule', category: 'Attractions', location: 'Cap Spartel, Tanger', rating: 4.7, price: 'Gratuit', lat: 35.7617, lng: -5.9386, icon: Icons.account_balance_rounded, route: '/attraction/attr_tan_002', images: ['assets/images/tanger/attractions/caves_hercules/1.jpg','assets/images/tanger/attractions/caves_hercules/2.jpg','assets/images/tanger/attractions/caves_hercules/3.jpg']),
    _MapPOI(id: 'attr_tan_003', name: 'Musée Légation Américaine', category: 'Attractions', location: 'Médina, Tanger', rating: 4.5, price: 'Gratuit', lat: 35.7867, lng: -5.8117, icon: Icons.account_balance_rounded, route: '/attraction/attr_tan_003', images: ['assets/images/tanger/attractions/legation_museum/1.jpg','assets/images/tanger/attractions/legation_museum/2.jpg','assets/images/tanger/attractions/legation_museum/3.jpg']),
    _MapPOI(id: 'attr_tan_004', name: 'Parc Perdicaris', category: 'Attractions', location: 'Cap Spartel, Tanger', rating: 4.4, price: 'Gratuit', lat: 35.7722, lng: -5.9142, icon: Icons.account_balance_rounded, route: '/attraction/attr_tan_004', images: ['assets/images/tanger/attractions/parc_perdicaris/1.jpg','assets/images/tanger/attractions/parc_perdicaris/2.jpg','assets/images/tanger/attractions/parc_perdicaris/3.jpg']),
    _MapPOI(id: 'attr_tan_005', name: 'Église Saint-André', category: 'Attractions', location: 'Centre-ville, Tanger', rating: 4.3, price: 'Gratuit', lat: 35.7764, lng: -5.8097, icon: Icons.account_balance_rounded, route: '/attraction/attr_tan_005', images: ['assets/images/tanger/attractions/st_andrew/1.jpg','assets/images/tanger/attractions/st_andrew/2.jpg','assets/images/tanger/attractions/st_andrew/3.jpg']),
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
    switch (ref.watch(selectedDestinationProvider).idDestination) {
      case 'dest_002': return _casaPOIs;
      case 'dest_003': return _agadirPOIs;
      case 'dest_004': return _tangierPOIs;
      default: return _allPOIs;
    }
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
      case 'Attractions': return const Color(0xFF2196F3);
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
            TileLayer(
              urlTemplate: 'https://atlas.microsoft.com/map/tile?api-version=2022-08-01&tilesetId=microsoft.base.road&zoom={z}&x={x}&y={y}&tileSize=512&subscription-key=$_azureMapsKey',
              userAgentPackageName: 'com.kurgate.app',
              tileDimension: 512,
              zoomOffset: -1,
            ),
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
        Positioned(top: 0, right: 16, child: SafeArea(child: Padding(padding: const EdgeInsets.only(top: 118), child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFF2A2A2A).withValues(alpha: 0.92), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withValues(alpha: 0.08))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            for (final f in _filters.skip(1)) Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 10, height: 10, decoration: BoxDecoration(color: _catColor(f.label), shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text(f.label, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.6), fontSize: 11, fontWeight: FontWeight.w500)),
            ])),
          ]),
        )))),
        // Zoom controls
        Positioned(bottom: 76, left: 16, child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                final zoom = _mapController.camera.zoom + 1;
                _mapController.move(_mapController.camera.center, zoom.clamp(3.0, 18.0));
              },
              child: Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFF2A2A2A).withValues(alpha: 0.92), borderRadius: const BorderRadius.vertical(top: Radius.circular(12)), border: Border.all(color: Colors.white.withValues(alpha: 0.1))),
                child: Icon(Icons.add_rounded, color: Colors.white.withValues(alpha: 0.7), size: 22)),
            ),
            Container(height: 1, width: 40, color: Colors.white.withValues(alpha: 0.08)),
            GestureDetector(
              onTap: () {
                final zoom = _mapController.camera.zoom - 1;
                _mapController.move(_mapController.camera.center, zoom.clamp(3.0, 18.0));
              },
              child: Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFF2A2A2A).withValues(alpha: 0.92), borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)), border: Border.all(color: Colors.white.withValues(alpha: 0.1))),
                child: Icon(Icons.remove_rounded, color: Colors.white.withValues(alpha: 0.7), size: 22)),
            ),
          ],
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
