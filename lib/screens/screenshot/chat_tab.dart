import 'package:flutter/material.dart';

const _o = Color(0xFFFF8C00);
const _f = 'DarkerGrotesque';

class ChatTab extends StatelessWidget {
  const ChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color(0xFF0F0F0F), body: Column(children: [
      // Header
      Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, bottom:12, left:16, right:16),
        decoration: BoxDecoration(color: const Color(0xFF1A1A1A),
          border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha:.07)))),
        child: Row(children: [
          _hIcon(Icons.arrow_back_rounded),
          const SizedBox(width:12),
          ClipRRect(borderRadius: BorderRadius.circular(13),
            child: Image.asset('assets/images/ai_assistant.png', width:40, height:40, fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(width:40, height:40, color: const Color(0xFF2A2A2A),
                child: const Icon(Icons.smart_toy_rounded, color: _o, size:20)))),
          const SizedBox(width:12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Assistant Kurgate', style: TextStyle(color: Colors.white, fontFamily: _f, fontSize:17, fontWeight: FontWeight.w800)),
            Row(children: [
              Container(width:7, height:7, decoration: const BoxDecoration(color: Color(0xFF2ECC71), shape: BoxShape.circle)),
              const SizedBox(width:5),
              Text('En ligne', style: TextStyle(color: Colors.white.withValues(alpha:.4), fontFamily: _f, fontSize:12)),
            ]),
          ])),
          _hIcon(Icons.refresh_rounded),
        ])),
      // Messages
      Expanded(child: ListView(padding: const EdgeInsets.fromLTRB(16,12,16,8), children: [
        // AI welcome
        _aiBubble('Bonjour Mohammed ! 👋 Je suis votre assistant de voyage Kurgate. Comment puis-je vous aider à planifier votre séjour au Maroc ?'),
        const SizedBox(height:10),
        // User message
        _userBubble('Trouve-moi un véhicule à louer à Marrakech'),
        const SizedBox(height:10),
        // AI response with card
        _aiBubble('Bien sûr ! Voici une excellente option disponible à Marrakech 🚗'),
        const SizedBox(height:10),
        // Rich vehicle card
        Padding(padding: const EdgeInsets.only(left:36), child: _vehicleCard()),
        const SizedBox(height:10),
        // User follow-up
        _userBubble('Super ! Et un hôtel pour ce weekend ?'),
        const SizedBox(height:10),
        // AI with hotel card
        _aiBubble('Voici une recommandation parfaite pour un weekend de luxe 🏨✨'),
        const SizedBox(height:10),
        Padding(padding: const EdgeInsets.only(left:36), child: _hotelCard()),
      ])),
      // Input bar
      Container(
        padding: EdgeInsets.only(left:16, right:10, top:10, bottom: MediaQuery.of(context).padding.bottom + 10),
        decoration: BoxDecoration(color: const Color(0xFF1A1A1A),
          border: Border(top: BorderSide(color: Colors.white.withValues(alpha:.07)))),
        child: Row(children: [
          Expanded(child: Container(
            padding: const EdgeInsets.symmetric(horizontal:16, vertical:13),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha:.06), borderRadius: BorderRadius.circular(26),
              border: Border.all(color: Colors.white.withValues(alpha:.09))),
            child: Text('Écrivez votre message...', style: TextStyle(color: Colors.white.withValues(alpha:.25), fontFamily: _f, fontSize:15)))),
          const SizedBox(width:8),
          Container(width:46, height:46,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [_o, Color(0xFFE07020)]),
              borderRadius: BorderRadius.circular(23),
              boxShadow: [BoxShadow(color: _o.withValues(alpha:.35), blurRadius:10, offset: const Offset(0,3))]),
            child: const Icon(Icons.send_rounded, color: Colors.white, size:20)),
        ])),
    ]));
  }

  static Widget _hIcon(IconData ic) => Container(padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(color: Colors.white.withValues(alpha:.07), borderRadius: BorderRadius.circular(10)),
    child: Icon(ic, color: Colors.white.withValues(alpha:.6), size:20));

  static Widget _aiBubble(String text) => Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
    ClipRRect(borderRadius: BorderRadius.circular(9),
      child: Image.asset('assets/images/ai_assistant.png', width:28, height:28, fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(width:28, height:28, decoration: BoxDecoration(
          color: _o.withValues(alpha:.2), borderRadius: BorderRadius.circular(9)),
          child: const Icon(Icons.smart_toy_rounded, color: _o, size:14)))),
    const SizedBox(width:8),
    Flexible(child: Container(
      padding: const EdgeInsets.symmetric(horizontal:14, vertical:11),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha:.08),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18),
          bottomRight: Radius.circular(18), bottomLeft: Radius.circular(4)),
        border: Border.all(color: Colors.white.withValues(alpha:.09))),
      child: Text(text, style: TextStyle(fontFamily: _f, color: Colors.white.withValues(alpha:.88), fontSize:14.5, height:1.45, fontWeight: FontWeight.w500)))),
  ]);

  static Widget _userBubble(String text) => Row(mainAxisAlignment: MainAxisAlignment.end, children: [
    Flexible(child: Container(
      padding: const EdgeInsets.symmetric(horizontal:14, vertical:11),
      decoration: const BoxDecoration(color: _o,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18),
          bottomLeft: Radius.circular(18), bottomRight: Radius.circular(4))),
      child: Text(text, style: const TextStyle(fontFamily: _f, color: Colors.white, fontSize:14.5, height:1.45, fontWeight: FontWeight.w500)))),
  ]);

  static Widget _vehicleCard() => Container(
    decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.white.withValues(alpha:.08)),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:.3), blurRadius:8, offset: const Offset(0,3))]),
    clipBehavior: Clip.antiAlias,
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height:120, width: double.infinity,
        child: Image.asset('assets/images/vehicules/mercedes_classe_e/1.png', fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(color: const Color(0xFF2A2A2A),
            child: Center(child: Icon(Icons.directions_car_rounded, color: Colors.white.withValues(alpha:.15), size:40))))),
      Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Expanded(child: Text('Mercedes Classe E', style: TextStyle(fontFamily: _f, color: Colors.white, fontSize:15, fontWeight: FontWeight.w700))),
          Container(padding: const EdgeInsets.symmetric(horizontal:8, vertical:3),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [_o, Color(0xFFE07020)]),
              borderRadius: BorderRadius.circular(8)),
            child: const Text('1,500 MAD/j', style: TextStyle(fontFamily: _f, color: Colors.white, fontSize:11, fontWeight: FontWeight.w700))),
        ]),
        const SizedBox(height:4),
        Row(children: [
          Icon(Icons.location_on_rounded, size:13, color: Colors.white.withValues(alpha:.4)),
          const SizedBox(width:4),
          Text('Marrakech · Berline · Luxe', style: TextStyle(fontFamily: _f, color: Colors.white.withValues(alpha:.4), fontSize:12)),
          const Spacer(),
          const Icon(Icons.star_rounded, color: Color(0xFFFFB800), size:14),
          const SizedBox(width:2),
          Text('4.9', style: TextStyle(fontFamily: _f, color: Colors.white.withValues(alpha:.6), fontSize:12, fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height:10),
        Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical:10),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [_o, Color(0xFFE07020)]),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: _o.withValues(alpha:.25), blurRadius:8, offset: const Offset(0,3))]),
          child: const Center(child: Text('Réserver maintenant', style: TextStyle(fontFamily: _f, color: Colors.white, fontSize:13, fontWeight: FontWeight.w700)))),
      ])),
    ]));

  static Widget _hotelCard() => Container(
    decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.white.withValues(alpha:.08)),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:.3), blurRadius:8, offset: const Offset(0,3))]),
    clipBehavior: Clip.antiAlias,
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height:120, width: double.infinity,
        child: Image.asset('assets/images/marrakech/hotels/la_mamounia/1.png', fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(color: const Color(0xFF2A2A2A),
            child: Center(child: Icon(Icons.hotel_rounded, color: Colors.white.withValues(alpha:.15), size:40))))),
      Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Expanded(child: Text('La Mamounia', style: TextStyle(fontFamily: _f, color: Colors.white, fontSize:15, fontWeight: FontWeight.w700))),
          Container(padding: const EdgeInsets.symmetric(horizontal:8, vertical:3),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [_o, Color(0xFFE07020)]),
              borderRadius: BorderRadius.circular(8)),
            child: const Text('3,500 MAD/n', style: TextStyle(fontFamily: _f, color: Colors.white, fontSize:11, fontWeight: FontWeight.w700))),
        ]),
        const SizedBox(height:4),
        Row(children: [
          Icon(Icons.location_on_rounded, size:13, color: Colors.white.withValues(alpha:.4)),
          const SizedBox(width:4),
          Text('Hivernage, Marrakech', style: TextStyle(fontFamily: _f, color: Colors.white.withValues(alpha:.4), fontSize:12)),
          const Spacer(),
          const Icon(Icons.star_rounded, color: Color(0xFFFFB800), size:14),
          const SizedBox(width:2),
          Text('4.9', style: TextStyle(fontFamily: _f, color: Colors.white.withValues(alpha:.6), fontSize:12, fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height:10),
        Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical:10),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [_o, Color(0xFFE07020)]),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: _o.withValues(alpha:.25), blurRadius:8, offset: const Offset(0,3))]),
          child: const Center(child: Text('Réserver maintenant', style: TextStyle(fontFamily: _f, color: Colors.white, fontSize:13, fontWeight: FontWeight.w700)))),
      ])),
    ]));
}
