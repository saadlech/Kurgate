import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import '../models/boutique_artisanale.dart';
import '../widgets/reviews_section.dart';

class BoutiqueDetailScreen extends ConsumerStatefulWidget {
  final String boutiqueId;
  const BoutiqueDetailScreen({super.key, required this.boutiqueId});
  @override
  ConsumerState<BoutiqueDetailScreen> createState() =>
      _BoutiqueDetailScreenState();
}

class _BoutiqueDetailScreenState extends ConsumerState<BoutiqueDetailScreen> {
  int _selectedProduct = 0;
  int _quantity = 1;
  int _currentPage = 0;

  static final _dataMap = {
    'boutique_001': BoutiqueArtisanale(
      name: 'Tapis Berbères El Badi',
      artisan: 'Maître Hassan El Badi',
      location: 'Souk des Tapis, Médina',
      rating: 4.8,
      reviews: 312,
      description:
          'Depuis trois générations, la famille El Badi perpétue l\'art ancestral du tissage berbère. Chaque tapis est une œuvre unique, tissé à la main par des artisanes des villages de l\'Atlas, utilisant de la laine naturelle teinte avec des pigments végétaux traditionnels.',
      imageUrl: 'assets/images/marrakech/boutiques/tapis_berberes/1.png',
      images: [
        'assets/images/marrakech/boutiques/tapis_berberes/1.png',
        'assets/images/marrakech/boutiques/tapis_berberes/2.png',
        'assets/images/marrakech/boutiques/tapis_berberes/3.png',
      ],
      category: 'Tapis',
      horaires: '9h-19h',
      products: [
        Produit('Tapis Beni Ouarain', 450, 'Laine naturelle, 200×150 cm'),
        Produit('Tapis Azilal', 320, 'Multicolore, 180×120 cm'),
        Produit('Tapis Kilim', 180, 'Tissage plat, 150×100 cm'),
        Produit('Coussin Berbère', 45, 'Laine, motifs géométriques'),
      ],
    ),
    'boutique_002': BoutiqueArtisanale(
      name: 'Atelier Céramique Safi',
      artisan: 'Fatima Zahra Bennani',
      location: 'Derb Dabachi, Médina',
      rating: 4.7,
      reviews: 198,
      description:
          'Fatima Zahra a appris la céramique auprès des maîtres potiers de Safi. Son atelier propose des pièces uniques mêlant techniques ancestrales et designs contemporains. Chaque pièce est tournée, peinte et émaillée à la main avec des motifs géométriques traditionnels.',
      imageUrl: 'assets/images/marrakech/boutiques/ceramique_safi/1.png',
      images: [
        'assets/images/marrakech/boutiques/ceramique_safi/1.png',
        'assets/images/marrakech/boutiques/ceramique_safi/2.png',
        'assets/images/marrakech/boutiques/ceramique_safi/3.png',
      ],
      category: 'Poterie',
      horaires: '10h-18h',
      products: [
        Produit('Service à thé zellige', 85, '6 verres + théière'),
        Produit('Grand plat décoratif', 120, 'Peint main, 40 cm'),
        Produit('Set d\'assiettes', 65, '4 assiettes, motif fès'),
        Produit('Vase Tamegroute', 45, 'Émail vert, 30 cm'),
      ],
    ),
    'boutique_003': BoutiqueArtisanale(
      name: 'Maroquinerie Artisanale Youssef',
      artisan: 'Youssef Amrani',
      location: 'Souk Cherratine, Médina',
      rating: 4.6,
      reviews: 456,
      description:
          'Youssef travaille le cuir depuis l\'âge de 14 ans dans la tradition des maroquiniers de Marrakech. Cuir tanné naturellement dans les tanneries historiques de la Médina, chaque pièce est découpée, cousue et finissée entièrement à la main.',
      imageUrl: 'assets/images/marrakech/boutiques/maroquinerie_youssef/1.png',
      images: [
        'assets/images/marrakech/boutiques/maroquinerie_youssef/1.png',
        'assets/images/marrakech/boutiques/maroquinerie_youssef/2.png',
        'assets/images/marrakech/boutiques/maroquinerie_youssef/3.png',
      ],
      category: 'Cuir',
      horaires: '9h-20h',
      products: [
        Produit(
          'Babouches traditionnelles',
          35,
          'Cuir souple, pointure unique',
        ),
        Produit('Sac en cuir de chèvre', 120, 'Fait main, bandoulière'),
        Produit('Pouf marocain', 85, 'Cuir véritable, non rembourré'),
        Produit('Ceinture artisanale', 30, 'Cuir gravé, boucle laiton'),
      ],
    ),
    'boutique_004': BoutiqueArtisanale(
      name: 'Bijoux Touareg Amina',
      artisan: 'Amina Ait Brahim',
      location: 'Place des Ferblantiers',
      rating: 4.9,
      reviews: 167,
      description:
          'Amina crée des bijoux inspirés de l\'héritage touareg et amazigh. Chaque pièce en argent 925 est forgée et gravée à la main, ornée de pierres semi-précieuses du Sahara. Des créations uniques qui racontent l\'histoire du peuple nomade du désert.',
      imageUrl: 'assets/images/marrakech/boutiques/bijoux_touareg/1.png',
      images: [
        'assets/images/marrakech/boutiques/bijoux_touareg/1.png',
        'assets/images/marrakech/boutiques/bijoux_touareg/2.png',
        'assets/images/marrakech/boutiques/bijoux_touareg/3.png',
      ],
      category: 'Bijoux',
      horaires: '10h-19h',
      products: [
        Produit('Collier Touareg argent', 180, 'Argent 925, pendentif croix'),
        Produit('Bracelet Amazigh', 95, 'Argent ciselé, motifs'),
        Produit('Boucles d\'oreilles', 65, 'Argent et corail'),
        Produit('Bague Sahara', 50, 'Argent et turquoise'),
      ],
    ),
    'boutique_005': BoutiqueArtisanale(
      name: 'Tissages Tradition Amazigh',
      artisan: 'Khadija Oulhaj',
      location: 'Souk Haddadine, Médina',
      rating: 4.7,
      reviews: 234,
      description:
          'Khadija dirige une coopérative de femmes tisseuses des montagnes de l\'Atlas. Chaque pièce textile est réalisée sur des métiers à tisser traditionnels avec des fils de coton, soie et laine teints naturellement. Un savoir-faire transmis de mère en fille.',
      imageUrl: 'assets/images/marrakech/boutiques/tissages_amazigh/1.png',
      images: [
        'assets/images/marrakech/boutiques/tissages_amazigh/1.png',
        'assets/images/marrakech/boutiques/tissages_amazigh/2.png',
        'assets/images/marrakech/boutiques/tissages_amazigh/3.png',
      ],
      category: 'Textile',
      horaires: '9h-18h',
      products: [
        Produit('Caftan brodé', 250, 'Soie et coton, broderie'),
        Produit('Foulard en soie', 60, 'Teinture naturelle'),
        Produit('Housse de coussin', 35, 'Coton tissé, motifs'),
        Produit('Jeté de lit', 180, 'Coton bio, 200×150 cm'),
      ],
    ),
    'boutique_006': BoutiqueArtisanale(
      name: 'Poterie d\'Art Tamegroute',
      artisan: 'Ahmed Bel Kacem',
      location: 'Quartier des Potiers',
      rating: 4.5,
      reviews: 289,
      description:
          'Ahmed perpétue la tradition séculaire de la poterie de Tamegroute, reconnaissable à son émail vert unique obtenu grâce à un mélange secret de manganèse, cuivre et silice. Chaque pièce est façonnée au tour et cuite dans un four à bois traditionnel.',
      imageUrl: 'assets/images/marrakech/boutiques/poterie_tamegroute/1.png',
      images: [
        'assets/images/marrakech/boutiques/poterie_tamegroute/1.png',
        'assets/images/marrakech/boutiques/poterie_tamegroute/2.png',
        'assets/images/marrakech/boutiques/poterie_tamegroute/3.png',
      ],
      category: 'Poterie',
      horaires: '8h-17h',
      products: [
        Produit('Bol Tamegroute', 25, 'Émail vert, 15 cm'),
        Produit('Photophore', 35, 'Ajouré, bougie incluse'),
        Produit('Tajine décoratif', 55, 'Peint main, 25 cm'),
        Produit('Set de 6 tasses', 40, 'Émail vert traditionnel'),
      ],
    ),
    // Casablanca boutiques (same artisan items as Marrakech)
    'boutique_casa_001': BoutiqueArtisanale(
      name: 'Tapis Berbères El Badi', artisan: 'Maître Hassan El Badi',
      location: 'Quartier Habous, Casablanca', rating: 4.8, reviews: 312,
      description: 'Depuis trois générations, la famille El Badi perpétue l\'art ancestral du tissage berbère. Chaque tapis est une œuvre unique, tissé à la main par des artisanes des villages de l\'Atlas, utilisant de la laine naturelle teinte avec des pigments végétaux traditionnels.',
      imageUrl: 'assets/images/marrakech/boutiques/tapis_berberes/1.png',
      images: ['assets/images/marrakech/boutiques/tapis_berberes/1.png', 'assets/images/marrakech/boutiques/tapis_berberes/2.png', 'assets/images/marrakech/boutiques/tapis_berberes/3.png'],
      category: 'Tapis', horaires: '9h-19h',
      products: [
        Produit('Tapis Beni Ouarain', 450, 'Laine naturelle, 200×150 cm'),
        Produit('Tapis Azilal', 320, 'Multicolore, 180×120 cm'),
        Produit('Tapis Kilim', 180, 'Tissage plat, 150×100 cm'),
        Produit('Coussin Berbère', 45, 'Laine, motifs géométriques'),
      ],
    ),
    'boutique_casa_002': BoutiqueArtisanale(
      name: 'Atelier Céramique Safi', artisan: 'Fatima Zahra Bennani',
      location: 'Derb Omar, Casablanca', rating: 4.7, reviews: 198,
      description: 'Fatima Zahra a appris la céramique auprès des maîtres potiers de Safi. Son atelier propose des pièces uniques mêlant techniques ancestrales et designs contemporains. Chaque pièce est tournée, peinte et émaillée à la main avec des motifs géométriques traditionnels.',
      imageUrl: 'assets/images/marrakech/boutiques/ceramique_safi/1.png',
      images: ['assets/images/marrakech/boutiques/ceramique_safi/1.png', 'assets/images/marrakech/boutiques/ceramique_safi/2.png', 'assets/images/marrakech/boutiques/ceramique_safi/3.png'],
      category: 'Poterie', horaires: '10h-18h',
      products: [
        Produit('Service à thé zellige', 85, '6 verres + théière'),
        Produit('Grand plat décoratif', 120, 'Peint main, 40 cm'),
        Produit('Set d\'assiettes', 65, '4 assiettes, motif fès'),
        Produit('Vase Tamegroute', 45, 'Émail vert, 30 cm'),
      ],
    ),
    'boutique_casa_003': BoutiqueArtisanale(
      name: 'Maroquinerie Artisanale Youssef', artisan: 'Youssef Amrani',
      location: 'Quartier Habous, Casablanca', rating: 4.6, reviews: 456,
      description: 'Youssef travaille le cuir depuis l\'âge de 14 ans dans la tradition des maroquiniers de Marrakech. Cuir tanné naturellement dans les tanneries historiques de la Médina, chaque pièce est découpée, cousue et finissée entièrement à la main.',
      imageUrl: 'assets/images/marrakech/boutiques/maroquinerie_youssef/1.png',
      images: ['assets/images/marrakech/boutiques/maroquinerie_youssef/1.png', 'assets/images/marrakech/boutiques/maroquinerie_youssef/2.png', 'assets/images/marrakech/boutiques/maroquinerie_youssef/3.png'],
      category: 'Cuir', horaires: '9h-20h',
      products: [
        Produit('Babouches traditionnelles', 35, 'Cuir souple, pointure unique'),
        Produit('Sac en cuir de chèvre', 120, 'Fait main, bandoulière'),
        Produit('Pouf marocain', 85, 'Cuir véritable, non rembourré'),
        Produit('Ceinture artisanale', 30, 'Cuir gravé, boucle laiton'),
      ],
    ),
    'boutique_casa_004': BoutiqueArtisanale(
      name: 'Bijoux Touareg Amina', artisan: 'Amina Ait Brahim',
      location: 'Derb Omar, Casablanca', rating: 4.9, reviews: 167,
      description: 'Amina crée des bijoux inspirés de l\'héritage touareg et amazigh. Chaque pièce en argent 925 est forgée et gravée à la main, ornée de pierres semi-précieuses du Sahara. Des créations uniques qui racontent l\'histoire du peuple nomade du désert.',
      imageUrl: 'assets/images/marrakech/boutiques/bijoux_touareg/1.png',
      images: ['assets/images/marrakech/boutiques/bijoux_touareg/1.png', 'assets/images/marrakech/boutiques/bijoux_touareg/2.png', 'assets/images/marrakech/boutiques/bijoux_touareg/3.png'],
      category: 'Bijoux', horaires: '10h-19h',
      products: [
        Produit('Collier Touareg argent', 180, 'Argent 925, pendentif croix'),
        Produit('Bracelet Amazigh', 95, 'Argent ciselé, motifs'),
        Produit('Boucles d\'oreilles', 65, 'Argent et corail'),
        Produit('Bague Sahara', 50, 'Argent et turquoise'),
      ],
    ),
    'boutique_casa_005': BoutiqueArtisanale(
      name: 'Tissages Tradition Amazigh', artisan: 'Khadija Oulhaj',
      location: 'Aïn Sebaâ, Casablanca', rating: 4.7, reviews: 234,
      description: 'Khadija dirige une coopérative de femmes tisseuses des montagnes de l\'Atlas. Chaque pièce textile est réalisée sur des métiers à tisser traditionnels avec des fils de coton, soie et laine teints naturellement. Un savoir-faire transmis de mère en fille.',
      imageUrl: 'assets/images/marrakech/boutiques/tissages_amazigh/1.png',
      images: ['assets/images/marrakech/boutiques/tissages_amazigh/1.png', 'assets/images/marrakech/boutiques/tissages_amazigh/2.png', 'assets/images/marrakech/boutiques/tissages_amazigh/3.png'],
      category: 'Textile', horaires: '9h-18h',
      products: [
        Produit('Caftan brodé', 250, 'Soie et coton, broderie'),
        Produit('Foulard en soie', 60, 'Teinture naturelle'),
        Produit('Housse de coussin', 35, 'Coton tissé, motifs'),
        Produit('Jeté de lit', 180, 'Coton bio, 200×150 cm'),
      ],
    ),
    'boutique_casa_006': BoutiqueArtisanale(
      name: 'Poterie d\'Art Tamegroute', artisan: 'Ahmed Bel Kacem',
      location: 'Quartier Gauthier, Casablanca', rating: 4.5, reviews: 289,
      description: 'Ahmed perpétue la tradition séculaire de la poterie de Tamegroute, reconnaissable à son émail vert unique obtenu grâce à un mélange secret de manganèse, cuivre et silice. Chaque pièce est façonnée au tour et cuite dans un four à bois traditionnel.',
      imageUrl: 'assets/images/marrakech/boutiques/poterie_tamegroute/1.png',
      images: ['assets/images/marrakech/boutiques/poterie_tamegroute/1.png', 'assets/images/marrakech/boutiques/poterie_tamegroute/2.png', 'assets/images/marrakech/boutiques/poterie_tamegroute/3.png'],
      category: 'Poterie', horaires: '8h-17h',
      products: [
        Produit('Bol Tamegroute', 25, 'Émail vert, 15 cm'),
        Produit('Photophore', 35, 'Ajouré, bougie incluse'),
        Produit('Tajine décoratif', 55, 'Peint main, 25 cm'),
        Produit('Set de 6 tasses', 40, 'Émail vert traditionnel'),
      ],
    ),
  };

  BoutiqueArtisanale get _boutique =>
      _dataMap[widget.boutiqueId] ?? _dataMap['boutique_001']!;
  Produit get _currentProduct => _boutique.products[_selectedProduct];
  int get _totalPrice => _currentProduct.price * _quantity;

  void _showOrderConfirmation() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _OrderSheet(
        boutiqueName: _boutique.name,
        productName: _currentProduct.name,
        quantity: _quantity,
        totalPrice: _totalPrice,
        onConfirmed: () {
          ref
              .read(cartProvider.notifier)
              .addItem(
                CartItem(
                  id: 'cart_${DateTime.now().millisecondsSinceEpoch}',
                  boutiqueName: _boutique.name,
                  artisan: _boutique.artisan,
                  productName: _currentProduct.name,
                  productDesc: _currentProduct.desc,
                  imageUrl: _boutique.images.first,
                  unitPrice: _currentProduct.price,
                  quantity: _quantity,
                  addedAt: DateTime.now(),
                ),
              );
        },
      ),
    );
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
                        itemCount: _boutique.images.length,
                        onPageChanged: (i) => setState(() => _currentPage = i),
                        itemBuilder: (context, i) => Image.asset(
                          _boutique.images[i],
                          fit: BoxFit.cover,
                          cacheWidth: 500,
                          gaplessPlayback: true,
                          errorBuilder: (_, _, _) =>
                              Container(color: const Color(0xFF2A2A2A)),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _boutique.images.length,
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
                            '${_currentPage + 1}/${_boutique.images.length}',
                            style: const TextStyle(
                              fontFamily: 'DarkerGrotesque',
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _boutique.name,
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
                                      Icons.person_rounded,
                                      color: Colors.white.withValues(
                                        alpha: 0.4,
                                      ),
                                      size: 15,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _boutique.artisan,
                                      style: TextStyle(
                                        fontFamily: 'DarkerGrotesque',
                                        color: Colors.white.withValues(
                                          alpha: 0.5,
                                        ),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
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
                                        _boutique.location,
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
                                    Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(_boutique.name + ', ' + _boutique.location + ', Marrakech')}'),
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
                                  _boutique.rating.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'DarkerGrotesque',
                                    color: Color(0xFFFF8C00),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  ' (${_boutique.reviews})',
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
                        _boutique.description,
                        style: TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSpec(
                            Icons.storefront_rounded,
                            _boutique.category,
                          ),
                          _buildSpec(
                            Icons.access_time_rounded,
                            _boutique.horaires,
                          ),
                          _buildSpec(Icons.handshake_rounded, 'Fait main'),
                          _buildSpec(Icons.local_shipping_rounded, 'Livraison'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Products
                      const Text(
                        'Produits',
                        style: TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(_boutique.products.length, (i) {
                        final p = _boutique.products[i];
                        final active = i == _selectedProduct;
                        return GestureDetector(
                          onTap: () => setState(() {
                            _selectedProduct = i;
                            _quantity = 1;
                          }),
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
                                    ? const Color(
                                        0xFFFF8C00,
                                      ).withValues(alpha: 0.5)
                                    : Colors.white.withValues(alpha: 0.06),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.name,
                                        style: TextStyle(
                                          fontFamily: 'DarkerGrotesque',
                                          color: active
                                              ? Colors.white
                                              : Colors.white.withValues(
                                                  alpha: 0.6,
                                                ),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        p.desc,
                                        style: TextStyle(
                                          fontFamily: 'DarkerGrotesque',
                                          color: Colors.white.withValues(
                                            alpha: 0.3,
                                          ),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '\$${p.price}',
                                  style: TextStyle(
                                    fontFamily: 'DarkerGrotesque',
                                    color: active
                                        ? const Color(0xFFFF8C00)
                                        : Colors.white.withValues(alpha: 0.5),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
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
                      const SizedBox(height: 20),
                      // Quantity
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.06),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Quantité',
                                style: TextStyle(
                                  fontFamily: 'DarkerGrotesque',
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            _counterBtn(
                              Icons.remove_rounded,
                              _quantity > 1,
                              () => setState(() => _quantity--),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                '$_quantity',
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
                              _quantity < 10,
                              () => setState(() => _quantity++),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
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
                            _summaryRow('Article', _currentProduct.name),
                            _summaryRow(
                              'Prix unitaire',
                              '\$${_currentProduct.price}',
                            ),
                            _summaryRow('Quantité', '$_quantity'),
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
                      const SizedBox(height: 28),
                      ReviewsSection(
                        itemId: widget.boutiqueId,
                        itemName: _boutique.name,
                        itemType: 'Boutique',
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
                        '$_quantity × ${_currentProduct.name}',
                        style: TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          color: Colors.white.withValues(alpha: 0.35),
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _showOrderConfirmation,
                    child: Container(
                      height: 48,
                      width: 160,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF8C00), Color(0xFFE77728)],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFFF8C00,
                            ).withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Commander',
                          style: TextStyle(
                            fontFamily: 'DarkerGrotesque',
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
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
      SizedBox(
        width: 70,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'DarkerGrotesque',
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
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

class _OrderSheet extends StatefulWidget {
  final String boutiqueName, productName;
  final int quantity, totalPrice;
  final VoidCallback onConfirmed;
  const _OrderSheet({
    required this.boutiqueName,
    required this.productName,
    required this.quantity,
    required this.totalPrice,
    required this.onConfirmed,
  });
  @override
  State<_OrderSheet> createState() => _OrderSheetState();
}

class _OrderSheetState extends State<_OrderSheet>
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
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

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
              'Commande confirmée !',
              style: TextStyle(
                fontFamily: 'DarkerGrotesque',
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Votre commande chez ${widget.boutiqueName} est enregistrée.',
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
              'Confirmer la commande',
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
                  _row(Icons.storefront_rounded, widget.boutiqueName),
                  _row(
                    Icons.shopping_bag_rounded,
                    '${widget.productName} × ${widget.quantity}',
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
