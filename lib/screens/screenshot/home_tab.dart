import 'package:flutter/material.dart';

const _o = Color(0xFFFF8C00);
const _f = 'DarkerGrotesque';

class HomeTab extends StatelessWidget {
  final VoidCallback? onProfile;
  const HomeTab({super.key, this.onProfile});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(padding: const EdgeInsets.only(bottom: 100), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        Padding(padding: const EdgeInsets.fromLTRB(20,16,20,0), child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Good evening', style: TextStyle(fontFamily: _f, color: Colors.white.withValues(alpha:.45), fontSize: 14)),
            const Text('Hello, Mohammed', style: TextStyle(fontFamily: _f, color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, height: 1.2)),
          ])),
          Container(padding: const EdgeInsets.symmetric(horizontal:12,vertical:6),
            decoration: BoxDecoration(color: _o.withValues(alpha:.15), borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _o.withValues(alpha:.3))),
            child: const Row(mainAxisSize: MainAxisSize.min, children: [
              DecoratedBox(decoration: BoxDecoration(shape: BoxShape.circle, color: _o), child: SizedBox(width:6,height:6)),
              SizedBox(width:6),
              Text('Marrakech', style: TextStyle(fontFamily: _f, color: _o, fontSize:12, fontWeight: FontWeight.w700)),
              SizedBox(width:4),
              Icon(Icons.keyboard_arrow_down_rounded, color: _o, size:16),
            ])),
          const SizedBox(width:10),
          GestureDetector(onTap: onProfile, child: Container(width:38,height:38,
            decoration: BoxDecoration(shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha:.15), width:1.5),
              color: Colors.white.withValues(alpha:.08)),
            child: Icon(Icons.person_rounded, color: Colors.white.withValues(alpha:.5), size:20))),
        ])),
        const SizedBox(height:18),
        // Search
        Padding(padding: const EdgeInsets.symmetric(horizontal:20), child: Container(height:48,
          decoration: BoxDecoration(color: Colors.white.withValues(alpha:.05), borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha:.08))),
          child: Row(children: [
            const SizedBox(width:14),
            Icon(Icons.search_rounded, color: Colors.white.withValues(alpha:.3), size:20),
            const SizedBox(width:10),
            Text('Search hotels, experiences, crafts...', style: TextStyle(fontFamily: _f, color: Colors.white.withValues(alpha:.25), fontSize:14)),
          ]))),
        const SizedBox(height:24),
        // Categories
        SizedBox(height:80, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal:16),
          children: const [
            _Cat(Icons.hotel_rounded, 'Hôtels'),
            _Cat(Icons.directions_car_rounded, 'Véhicules'),
            _Cat(Icons.explore_rounded, 'Expériences'),
            _Cat(Icons.restaurant_rounded, 'Restaurants'),
            _Cat(Icons.storefront_rounded, 'Artisanat'),
            _Cat(Icons.account_balance_rounded, 'Attractions'),
          ])),
        const SizedBox(height:24),
        // Hotels section
        _section('Hôtels populaires', 'Voir tout'),
        const SizedBox(height:12),
        SizedBox(height:200, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal:20),
          children: const [
            _OfferCard('La Mamounia', 'Hivernage · Marrakech', '3,500 MAD', 4.9, 'assets/images/marrakech/hotels/la_mamounia/1.png'),
            _OfferCard('Riad Yasmine', 'Medina · Marrakech', '950 MAD', 4.6, 'assets/images/marrakech/hotels/riad_yasmine/1.png'),
            _OfferCard('Royal Mansour', 'Médina · Marrakech', '5,500 MAD', 4.9, 'assets/images/marrakech/hotels/royal_mansour/1.png'),
          ])),
        const SizedBox(height:24),
        // Vehicles
        _section('Location de véhicules', 'Voir tout'),
        const SizedBox(height:12),
        SizedBox(height:200, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal:20),
          children: const [
            _OfferCard('Dacia Duster 2024', 'SUV · Diesel', '450 MAD/j', 4.6, 'assets/images/vehicules/dacia_duster/1.png'),
            _OfferCard('Mercedes Classe E', 'Berline · Luxe', '1,500 MAD/j', 4.9, 'assets/images/vehicules/mercedes_classe_e/1.png'),
            _OfferCard('Peugeot 3008', 'SUV · Familial', '650 MAD/j', 4.7, 'assets/images/vehicules/peugeot_3008/1.png'),
          ])),
        const SizedBox(height:24),
        // Experiences
        _section('Expériences uniques', 'Voir tout'),
        const SizedBox(height:12),
        SizedBox(height:200, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal:20),
          children: const [
            _OfferCard('Safari Désert d\'Agafay', 'Aventure · 6h', '850 MAD', 4.8, 'assets/images/marrakech/experiences/safari_agafay/1.png'),
            _OfferCard('Vol Montgolfière', 'Aventure · 2h', '1,800 MAD', 4.9, 'assets/images/marrakech/experiences/vol_montgolfiere/1.png'),
            _OfferCard('Randonnée Atlas', 'Nature · 8h', '600 MAD', 4.9, 'assets/images/marrakech/experiences/randonnee_atlas/1.png'),
          ])),
      ]))));
  }

  Widget _section(String t, String a) => Padding(
    padding: const EdgeInsets.symmetric(horizontal:20),
    child: Row(children: [
      Text(t, style: const TextStyle(fontFamily: _f, color: Colors.white, fontSize:18, fontWeight: FontWeight.w800)),
      const Spacer(),
      Text(a, style: TextStyle(fontFamily: _f, color: _o, fontSize:13, fontWeight: FontWeight.w600)),
    ]));
}

class _Cat extends StatelessWidget {
  final IconData icon; final String label;
  const _Cat(this.icon, this.label);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal:6),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width:52, height:52,
        decoration: BoxDecoration(color: _o.withValues(alpha:.1), borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _o.withValues(alpha:.15))),
        child: Icon(icon, color: _o, size:24)),
      const SizedBox(height:6),
      Text(label, style: TextStyle(fontFamily: _f, color: Colors.white.withValues(alpha:.6), fontSize:11, fontWeight: FontWeight.w600)),
    ]));
}

class _OfferCard extends StatelessWidget {
  final String name, sub, price; final double rating; final String img;
  const _OfferCard(this.name, this.sub, this.price, this.rating, this.img);
  @override
  Widget build(BuildContext context) => Container(
    width:170, margin: const EdgeInsets.only(right:12),
    decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withValues(alpha:.06)),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:.3), blurRadius:8, offset: const Offset(0,3))]),
    clipBehavior: Clip.antiAlias,
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height:105, width: double.infinity,
        child: Image.asset(img, fit: BoxFit.cover, errorBuilder: (_, _, _) =>
          Container(color: const Color(0xFF2A2A2A), child: const Center(child: Icon(Icons.image, color: Color(0xFF555555)))))),
      Padding(padding: const EdgeInsets.fromLTRB(10,8,10,8), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name, maxLines:1, overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontFamily: _f, color: Colors.white, fontSize:14, fontWeight: FontWeight.w700)),
        const SizedBox(height:2),
        Text(sub, style: TextStyle(fontFamily: _f, color: Colors.white.withValues(alpha:.4), fontSize:11)),
        const SizedBox(height:6),
        Row(children: [
          const Icon(Icons.star_rounded, color: Color(0xFFFFB800), size:14),
          const SizedBox(width:2),
          Text(rating.toString(), style: TextStyle(fontFamily: _f, color: Colors.white.withValues(alpha:.6), fontSize:12, fontWeight: FontWeight.w600)),
          const Spacer(),
          Container(padding: const EdgeInsets.symmetric(horizontal:6, vertical:2),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [_o, Color(0xFFE07020)]),
              borderRadius: BorderRadius.circular(6)),
            child: Text(price, style: const TextStyle(fontFamily: _f, color: Colors.white, fontSize:10, fontWeight: FontWeight.w700))),
        ]),
      ])),
    ]));
}
