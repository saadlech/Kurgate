import 'package:flutter/material.dart';

const _o = Color(0xFFFF8C00);
const _f = 'DarkerGrotesque';

class ShopTab extends StatelessWidget {
  const ShopTab({super.key});

  @override
  Widget build(BuildContext context) {
    const products = [
      _P('Tapis de Taznakht', 'Tapis berbère fait main, laine naturelle', 2800, 'assets/images/boutiques/tapis_berberes/1.png', 4.8),
      _P('Poterie de Safi', 'Céramique artisanale émaillée', 350, 'assets/images/boutiques/ceramique_safi/1.png', 4.7),
      _P('Babouches en Cuir', 'Cuir tanné traditionnel, cousues main', 280, 'assets/images/boutiques/maroquinerie_youssef/1.png', 4.6),
      _P('Bijoux Touareg', 'Argent massif, motifs ancestraux', 950, 'assets/images/boutiques/bijoux_touareg/1.png', 4.9),
      _P('Tissage Amazigh', 'Textile berbère coloré, fait à la main', 1200, 'assets/images/boutiques/tissages_amazigh/1.png', 4.5),
      _P('Poterie Tamegroute', 'Poterie verte traditionnelle du sud', 420, 'assets/images/boutiques/poterie_tamegroute/1.png', 4.4),
    ];
    return SafeArea(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.fromLTRB(20,16,20,0), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Artisanat Marocain', style: TextStyle(fontFamily: _f, color: Colors.white, fontSize:26, fontWeight: FontWeight.w800)),
        const SizedBox(height:4),
        Text('Découvrez le savoir-faire local', style: TextStyle(fontFamily: _f, color: Colors.white.withValues(alpha:.4), fontSize:14)),
        const SizedBox(height:16),
        Container(height:44,
          decoration: BoxDecoration(color: Colors.white.withValues(alpha:.05), borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha:.08))),
          child: Row(children: [
            const SizedBox(width:14),
            Icon(Icons.search_rounded, color: Colors.white.withValues(alpha:.3), size:18),
            const SizedBox(width:10),
            Text('Rechercher un produit...', style: TextStyle(fontFamily: _f, color: Colors.white.withValues(alpha:.25), fontSize:13)),
          ])),
      ])),
      const SizedBox(height:16),
      Expanded(child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16,0,16,100),
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.62),
        itemCount: products.length,
        itemBuilder: (_, i) => _ProductCard(p: products[i]),
      )),
    ]));
  }
}

class _P {
  final String name, desc, img;
  final int price;
  final double rating;
  const _P(this.name, this.desc, this.price, this.img, this.rating);
}

class _ProductCard extends StatelessWidget {
  final _P p;
  const _ProductCard({required this.p});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withValues(alpha:.06)),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:.25), blurRadius:8, offset: const Offset(0,4))]),
    clipBehavior: Clip.antiAlias,
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(flex: 3, child: Stack(children: [
        SizedBox.expand(child: Image.asset(p.img, fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(color: const Color(0xFF2A2A2A),
            child: Center(child: Icon(Icons.shopping_bag_rounded, color: Colors.white.withValues(alpha:.15), size:32))))),
        Positioned(top:8, right:8, child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: Colors.black.withValues(alpha:.5), shape: BoxShape.circle),
          child: const Icon(Icons.favorite_border_rounded, color: Colors.white, size:16))),
        Positioned(top:8, left:8, child: Container(
          padding: const EdgeInsets.symmetric(horizontal:6, vertical:2),
          decoration: BoxDecoration(color: _o, borderRadius: BorderRadius.circular(6)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.star_rounded, color: Colors.white, size:12),
            const SizedBox(width:2),
            Text(p.rating.toString(), style: const TextStyle(fontFamily: _f, color: Colors.white, fontSize:10, fontWeight: FontWeight.w700)),
          ]))),
      ])),
      Expanded(flex: 2, child: Padding(padding: const EdgeInsets.fromLTRB(10,8,10,8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(p.name, maxLines:1, overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontFamily: _f, color: Colors.white, fontSize:14, fontWeight: FontWeight.w700)),
          const SizedBox(height:2),
          Text(p.desc, maxLines:2, overflow: TextOverflow.ellipsis,
            style: TextStyle(fontFamily: _f, color: Colors.white.withValues(alpha:.35), fontSize:10.5, height:1.3)),
          const Spacer(),
          Row(children: [
            Text('${p.price} MAD', style: const TextStyle(fontFamily: _f, color: _o, fontSize:15, fontWeight: FontWeight.w800)),
            const Spacer(),
            Container(width:32, height:32,
              decoration: BoxDecoration(gradient: const LinearGradient(colors: [_o, Color(0xFFE07020)]),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: _o.withValues(alpha:.3), blurRadius:6, offset: const Offset(0,2))]),
              child: const Icon(Icons.add_shopping_cart_rounded, color: Colors.white, size:16)),
          ]),
        ]))),
    ]));
}
