import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/kurgate_button.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final String restaurantId;
  const RestaurantDetailScreen({super.key, required this.restaurantId});
  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  bool _bookingExpanded = false;
  late DateTime _date;
  int _guests = 2;
  int _selectedTime = 1;
  bool _isConfirming = false;

  static const _dataMap = {
    'resto_001': _Info(name: 'Le Jardin', location: 'Souk Sidi Abdelaziz, Médina', rating: 4.7, reviews: 487, description: 'Un havre de paix caché au cœur de la Médina. Le Jardin propose une cuisine méditerranéenne bio dans un cadre verdoyant et apaisant. Salades fraîches, plats du jour créatifs et jus pressés sous les bananiers et les bougainvilliers.', imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&q=80', price: 25, specialite: 'Méditerranéen', horaires: '12h-23h', capacite: 60),
    'resto_002': _Info(name: 'Nomad', location: 'Derb Aarjan, Médina', rating: 4.8, reviews: 623, description: 'Restaurant rooftop emblématique offrant une vue panoramique sur la Médina et les montagnes de l\'Atlas. Cuisine marocaine revisitée avec des touches contemporaines, cocktails signature et ambiance cosmopolite.', imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800&q=80', price: 30, specialite: 'Marocain Moderne', horaires: '10h-23h', capacite: 80),
    'resto_003': _Info(name: 'Al Fassia', location: 'Guéliz, Marrakech', rating: 4.9, reviews: 389, description: 'Institution culinaire dirigée exclusivement par des femmes, Al Fassia est réputé pour sa cuisine fassi authentique. Tajines mijotés, pastilla croustillante et couscous du vendredi préparés selon des recettes transmises de génération en génération.', imageUrl: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800&q=80', price: 35, specialite: 'Cuisine Fassi', horaires: '12h-14h30 · 19h-23h', capacite: 100),
    'resto_004': _Info(name: 'CAFE CLOCK', location: 'Derb Chtouka, Kasbah', rating: 4.5, reviews: 712, description: 'Café culturel iconique de la Kasbah, célèbre pour son burger au chameau et ses événements culturels. Musique live, contes traditionnels et ateliers artistiques dans un riad historique sur plusieurs niveaux avec terrasse panoramique.', imageUrl: 'https://images.unsplash.com/photo-1466978913421-dad2ebd01d17?w=800&q=80', price: 12, specialite: 'Fusion', horaires: '9h-22h', capacite: 120),
    'resto_005': _Info(name: 'La Table du Palais', location: 'Royal Mansour, Médina', rating: 4.9, reviews: 234, description: 'Restaurant gastronomique étoilé du Royal Mansour, orchestré par le chef Yannick Alléno. Une expérience culinaire d\'exception mêlant haute cuisine française et saveurs marocaines dans un cadre palatial d\'une beauté à couper le souffle.', imageUrl: 'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800&q=80', price: 120, specialite: 'Français-Marocain', horaires: '19h-23h', capacite: 40),
    'resto_006': _Info(name: 'Chez Lamine Hadj Mustapha', location: 'Place Jemaa el-Fna', rating: 4.6, reviews: 1024, description: 'Le stand le plus célèbre de la Place Jemaa el-Fna depuis 1942. Spécialiste incontesté de la tanjia marrakchia, ce plat emblématique cuit lentement dans les cendres du hammam. Une expérience gustative authentique et populaire.', imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&q=80', price: 8, specialite: 'Tanjia Marrakchia', horaires: '11h-22h', capacite: 50),
  };

  final _timeSlots = const ['12:00', '12:30', '13:00', '13:30', '19:00', '19:30', '20:00', '20:30', '21:00'];

  _Info get _resto => _dataMap[widget.restaurantId] ?? _dataMap['resto_001']!;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _date = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(context: context, initialDate: _date, firstDate: today.add(const Duration(days: 1)), lastDate: today.add(const Duration(days: 90)), helpText: 'Date de réservation', cancelText: 'Annuler', confirmText: 'Confirmer',
      builder: (context, child) => Theme(data: ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark(primary: Color(0xFFFF8C00), onPrimary: Colors.black, surface: Color(0xFF2A2A2A), onSurface: Colors.white)), child: child!));
    if (picked != null) setState(() => _date = picked);
  }

  String _fmtDate(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  void _confirmReservation() {
    if (_isConfirming) return;
    setState(() => _isConfirming = true);
    showModalBottomSheet(context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
      builder: (ctx) => _ReservationSheet(restoName: _resto.name, date: _date, time: _timeSlots[_selectedTime], guests: _guests),
    ).then((_) => setState(() => _isConfirming = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Stack(children: [
        CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
          SliverAppBar(expandedHeight: 320, pinned: true, backgroundColor: const Color(0xFF1A1A1A),
            leading: _circleBtn(Icons.arrow_back_ios_rounded, () => context.pop()),
            actions: [_circleBtn(Icons.share_rounded, () {}), const SizedBox(width: 4), _circleBtn(Icons.favorite_border_rounded, () {}), const SizedBox(width: 12)],
            flexibleSpace: FlexibleSpaceBar(background: Stack(fit: StackFit.expand, children: [
              Image.network(_resto.imageUrl, fit: BoxFit.cover, cacheWidth: 800, errorBuilder: (_, __, ___) => Container(color: const Color(0xFF2A2A2A))),
              Positioned(bottom: 0, left: 0, right: 0, height: 80, child: Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [const Color(0xFF1A1A1A).withValues(alpha: 0.8), Colors.transparent])))),
            ])),
          ),
          SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(20, 20, 20, 120), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_resto.name, style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
                const SizedBox(height: 4),
                Row(children: [Icon(Icons.location_on_outlined, color: Colors.white.withValues(alpha: 0.4), size: 15), const SizedBox(width: 4), Expanded(child: Text(_resto.location, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.4), fontSize: 14), overflow: TextOverflow.ellipsis))]),
              ])),
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: const Color(0xFFFF8C00).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.star_rounded, color: Color(0xFFFF8C00), size: 18), const SizedBox(width: 4), Text(_resto.rating.toString(), style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Color(0xFFFF8C00), fontSize: 15, fontWeight: FontWeight.w800)), Text(' (${_resto.reviews})', style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Color(0xFFFF8C00), fontSize: 12))])),
            ]),
            const SizedBox(height: 20),
            Text(_resto.description, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.6), fontSize: 14, height: 1.6)),
            const SizedBox(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _buildSpec(Icons.restaurant_menu_rounded, _resto.specialite),
              _buildSpec(Icons.access_time_rounded, _resto.horaires),
              _buildSpec(Icons.people_rounded, '${_resto.capacite} places'),
              _buildSpec(Icons.attach_money_rounded, '\$${_resto.price}/moy'),
            ]),
            const SizedBox(height: 24),
            // Menu highlights
            _buildMenuHighlights(),
            const SizedBox(height: 24),
            _buildBookingSection(),
          ]))),
        ]),
        Positioned(left: 0, right: 0, bottom: 0, child: Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
          decoration: BoxDecoration(color: const Color(0xFF1A1A1A), border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.06)))),
          child: Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text('~\$${_resto.price}', style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Color(0xFFFF8C00), fontSize: 24, fontWeight: FontWeight.w800)),
              Text('par personne', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.35), fontSize: 12)),
            ]),
            const Spacer(),
            KurgateButton(label: 'Réserver', onPressed: _confirmReservation, height: 48, width: 160, fontSize: 16),
          ]),
        )),
      ]),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) => GestureDetector(onTap: onTap, child: Container(width: 38, height: 38, margin: const EdgeInsets.all(4), decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withValues(alpha: 0.4)), child: Icon(icon, color: Colors.white, size: 20)));

  Widget _buildSpec(IconData icon, String label) => Column(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 50, height: 50, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withValues(alpha: 0.08))), child: Icon(icon, color: Colors.white.withValues(alpha: 0.5), size: 22)),
    const SizedBox(height: 6),
    SizedBox(width: 70, child: Text(label, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.4), fontSize: 11, fontWeight: FontWeight.w500), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis)),
  ]);

  Widget _buildMenuHighlights() {
    final items = [('Entrées', '3 choix', Icons.soup_kitchen_rounded), ('Plats', '5 choix', Icons.dining_rounded), ('Desserts', '3 choix', Icons.cake_rounded), ('Boissons', 'Carte variée', Icons.local_bar_rounded)];
    return Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withValues(alpha: 0.06))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('La Carte', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: items.map((item) => Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(color: const Color(0xFFFF8C00).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(item.$3, color: const Color(0xFFFF8C00), size: 22)),
          const SizedBox(height: 6),
          Text(item.$1, style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
          Text(item.$2, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.3), fontSize: 10)),
        ])).toList()),
      ]),
    );
  }

  Widget _buildBookingSection() => Container(
    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withValues(alpha: 0.06))),
    child: Column(children: [
      GestureDetector(onTap: () => setState(() => _bookingExpanded = !_bookingExpanded), child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [
        Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0xFFFF8C00).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.table_restaurant_rounded, color: Color(0xFFFF8C00), size: 22)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Réserver une table', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          Text('Choisir date, heure et convives', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.35), fontSize: 12)),
        ])),
        AnimatedRotation(turns: _bookingExpanded ? 0.5 : 0, duration: const Duration(milliseconds: 200), child: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white.withValues(alpha: 0.4))),
      ]))),
      if (_bookingExpanded) ...[
        Divider(color: Colors.white.withValues(alpha: 0.06), height: 1),
        Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Date
          Text('Date', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.4), fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          GestureDetector(onTap: _pickDate, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white.withValues(alpha: 0.08))),
            child: Row(children: [Text(_fmtDate(_date), style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)), const Spacer(), Icon(Icons.calendar_today_rounded, color: const Color(0xFFFF8C00).withValues(alpha: 0.6), size: 16)]))),
          const SizedBox(height: 20),
          // Time slots
          Text('Heure', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.4), fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: List.generate(_timeSlots.length, (i) {
            final active = i == _selectedTime;
            return GestureDetector(onTap: () => setState(() => _selectedTime = i), child: AnimatedContainer(duration: const Duration(milliseconds: 200), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: active ? const Color(0xFFFF8C00) : Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(10), border: Border.all(color: active ? const Color(0xFFFF8C00) : Colors.white.withValues(alpha: 0.08))),
              child: Text(_timeSlots[i], style: TextStyle(fontFamily: 'DarkerGrotesque', color: active ? Colors.black : Colors.white.withValues(alpha: 0.6), fontSize: 13, fontWeight: active ? FontWeight.w700 : FontWeight.w500))));
          })),
          const SizedBox(height: 20),
          // Guests
          Row(children: [const Expanded(child: Text('Convives', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700))),
            _counterBtn(Icons.remove_rounded, _guests > 1, () => setState(() => _guests--)),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('$_guests', style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700))),
            _counterBtn(Icons.add_rounded, _guests < 12, () => setState(() => _guests++)),
          ]),
          const SizedBox(height: 20),
          // Summary
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withValues(alpha: 0.06))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Récapitulatif', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              _summaryRow('Restaurant', _resto.name), _summaryRow('Date', _fmtDate(_date)), _summaryRow('Heure', _timeSlots[_selectedTime]), _summaryRow('Convives', '$_guests'),
            ])),
        ])),
      ],
    ]),
  );

  Widget _counterBtn(IconData icon, bool enabled, VoidCallback onTap) => GestureDetector(onTap: enabled ? onTap : null, child: Container(width: 32, height: 32, decoration: BoxDecoration(shape: BoxShape.circle, color: enabled ? const Color(0xFFFF8C00) : Colors.white.withValues(alpha: 0.05), border: Border.all(color: enabled ? const Color(0xFFFF8C00) : Colors.white.withValues(alpha: 0.1))), child: Icon(icon, color: enabled ? Colors.black : Colors.white.withValues(alpha: 0.2), size: 18)));

  Widget _summaryRow(String label, String value) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(label, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.4), fontSize: 14)),
    Flexible(child: Text(value, style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
  ]));
}

class _ReservationSheet extends StatefulWidget {
  final String restoName, time; final DateTime date; final int guests;
  const _ReservationSheet({required this.restoName, required this.date, required this.time, required this.guests});
  @override
  State<_ReservationSheet> createState() => _ReservationSheetState();
}

class _ReservationSheetState extends State<_ReservationSheet> with SingleTickerProviderStateMixin {
  bool _confirmed = false;
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;
  @override
  void initState() { super.initState(); _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600)); _scaleAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.elasticOut)); }
  @override
  void dispose() { _animCtrl.dispose(); super.dispose(); }
  String _fmtDate(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  void _confirm() { setState(() => _confirmed = true); _animCtrl.forward(); Future.delayed(const Duration(seconds: 2), () { if (mounted) Navigator.of(context).pop(); }); }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFF222222), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2))),
        if (_confirmed) ...[
          const SizedBox(height: 20),
          ScaleTransition(scale: _scaleAnim, child: Container(width: 80, height: 80, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF2ECC71)), child: const Icon(Icons.check_rounded, color: Colors.white, size: 44))),
          const SizedBox(height: 20),
          const Text('Table réservée !', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('Votre table chez ${widget.restoName} est confirmée.', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.5), fontSize: 14)),
          const SizedBox(height: 24),
        ] else ...[
          const Text('Confirmer la réservation', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 20),
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withValues(alpha: 0.08))),
            child: Column(children: [
              _row(Icons.restaurant_rounded, widget.restoName),
              _row(Icons.calendar_today_rounded, '${_fmtDate(widget.date)} à ${widget.time}'),
              _row(Icons.people_rounded, '${widget.guests} convives'),
            ])),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(child: GestureDetector(onTap: () => Navigator.of(context).pop(), child: Container(height: 50, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withValues(alpha: 0.1))), child: const Center(child: Text('Annuler', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)))))),
            const SizedBox(width: 12),
            Expanded(flex: 2, child: GestureDetector(onTap: _confirm, child: Container(height: 50, decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFF8C00), Color(0xFFFF6B00)]), borderRadius: BorderRadius.circular(14)), child: const Center(child: Text('Confirmer', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.black, fontSize: 16, fontWeight: FontWeight.w800)))))),
          ]),
        ],
      ]),
    );
  }
  Widget _row(IconData icon, String text) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(children: [Icon(icon, color: const Color(0xFFFF8C00), size: 18), const SizedBox(width: 10), Expanded(child: Text(text, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.7), fontSize: 14, fontWeight: FontWeight.w500)))]));
}

class _Info {
  final String name, location, description, imageUrl, specialite, horaires;
  final double rating; final int reviews, price, capacite;
  const _Info({required this.name, required this.location, required this.rating, required this.reviews, required this.description, required this.imageUrl, required this.price, required this.specialite, required this.horaires, required this.capacite});
}
