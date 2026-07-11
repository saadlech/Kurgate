import 'package:flutter/material.dart';

const _o = Color(0xFFFF8C00);
const _f = 'DarkerGrotesque';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20,16,20,100),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Profil', style: TextStyle(fontFamily: _f, color: Colors.white, fontSize:26, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
        const SizedBox(height:32),
        // Avatar
        Center(child: Column(children: [
          Container(width:90, height:90,
            decoration: BoxDecoration(shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [_o, Color(0xFFE77728)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              boxShadow: [BoxShadow(color: _o.withValues(alpha:.3), blurRadius:20, offset: const Offset(0,8))]),
            child: const Center(child: Text('MH', style: TextStyle(fontFamily: _f, color: Colors.black, fontSize:32, fontWeight: FontWeight.w800)))),
          const SizedBox(height:14),
          const Text('Mohammed Hasnai', style: TextStyle(fontFamily: _f, color: Colors.white, fontSize:22, fontWeight: FontWeight.w800)),
          const SizedBox(height:4),
          Text('mohammed.hasnai@gmail.com', style: TextStyle(fontFamily: _f, color: Colors.white.withValues(alpha:.4), fontSize:14)),
        ])),
        const SizedBox(height:32),
        // Info tiles
        _infoTile(Icons.person_rounded, 'Nom complet', 'Mohammed Hasnai'),
        _infoTile(Icons.email_rounded, 'Email', 'mohammed.hasnai@gmail.com'),
        _infoTile(Icons.phone_rounded, 'Téléphone', '+212 6 12 34 56 78'),
        const SizedBox(height:20),
        // Edit button
        Container(height:52, width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [_o.withValues(alpha:.12), const Color(0xFFE77728).withValues(alpha:.06)],
              begin: Alignment.centerLeft, end: Alignment.centerRight),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _o.withValues(alpha:.2))),
          child: const Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.edit_rounded, color: _o, size:20),
            SizedBox(width:8),
            Text('Modifier le profil', style: TextStyle(fontFamily: _f, color: _o, fontSize:16, fontWeight: FontWeight.w700)),
          ]))),
        const SizedBox(height:28),
        // Reservations header
        const Text('Réservations actives', style: TextStyle(fontFamily: _f, color: Colors.white, fontSize:18, fontWeight: FontWeight.w800)),
        const SizedBox(height:14),
        _reservation(Icons.hotel_rounded, 'La Mamounia', '12-15 Juillet 2026', '3,500 MAD/nuit', 'Confirmée', const Color(0xFF2ECC71)),
        _reservation(Icons.directions_car_rounded, 'Mercedes Classe E', '12-18 Juillet 2026', '1,500 MAD/jour', 'En attente', const Color(0xFFFFB800)),
        _reservation(Icons.explore_rounded, 'Safari Désert d\'Agafay', '14 Juillet 2026', '850 MAD', 'Confirmée', const Color(0xFF2ECC71)),
        _reservation(Icons.restaurant_rounded, 'Le Jardin', '13 Juillet 2026 · 20h', '250 MAD', 'Confirmée', const Color(0xFF2ECC71)),
        const SizedBox(height:20),
        // Logout
        Container(height:52, width: double.infinity,
          decoration: BoxDecoration(color: const Color(0xFFFF5252).withValues(alpha:.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFF5252).withValues(alpha:.2))),
          child: const Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.logout_rounded, color: Color(0xFFFF5252), size:20),
            SizedBox(width:8),
            Text('Se déconnecter', style: TextStyle(fontFamily: _f, color: Color(0xFFFF5252), fontSize:16, fontWeight: FontWeight.w700)),
          ]))),
      ])));
  }

  Widget _infoTile(IconData ic, String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom:8),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal:16, vertical:14),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha:.03), borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha:.06))),
      child: Row(children: [
        Container(width:38, height:38,
          decoration: BoxDecoration(color: _o.withValues(alpha:.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(ic, color: _o, size:18)),
        const SizedBox(width:14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontFamily: _f, color: Colors.white.withValues(alpha:.35), fontSize:11, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontFamily: _f, color: Colors.white, fontSize:15, fontWeight: FontWeight.w600)),
        ])),
      ])));

  Widget _reservation(IconData ic, String name, String date, String price, String status, Color statusColor) => Padding(
    padding: const EdgeInsets.only(bottom:10),
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha:.03), borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha:.06))),
      child: Row(children: [
        Container(width:44, height:44,
          decoration: BoxDecoration(color: _o.withValues(alpha:.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(ic, color: _o, size:22)),
        const SizedBox(width:12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: const TextStyle(fontFamily: _f, color: Colors.white, fontSize:15, fontWeight: FontWeight.w700)),
          const SizedBox(height:2),
          Text(date, style: TextStyle(fontFamily: _f, color: Colors.white.withValues(alpha:.35), fontSize:12)),
          const SizedBox(height:4),
          Row(children: [
            Text(price, style: const TextStyle(fontFamily: _f, color: _o, fontSize:13, fontWeight: FontWeight.w700)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal:8, vertical:3),
              decoration: BoxDecoration(color: statusColor.withValues(alpha:.12), borderRadius: BorderRadius.circular(8)),
              child: Text(status, style: TextStyle(fontFamily: _f, color: statusColor, fontSize:11, fontWeight: FontWeight.w700))),
          ]),
        ])),
      ])));
}
