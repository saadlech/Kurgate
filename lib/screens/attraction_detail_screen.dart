import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';

class AttractionDetailScreen extends StatefulWidget {
  final String attractionId;
  const AttractionDetailScreen({super.key, required this.attractionId});
  @override
  State<AttractionDetailScreen> createState() => _AttractionDetailScreenState();
}

class _AttractionDetailScreenState extends State<AttractionDetailScreen> {
  int _currentPage = 0;

  static List<String> _imgs(String base, int count) =>
      List.generate(count, (i) => '$base/${i + 1}.jpg');

  static final _dataMap = {
    // ── Marrakech ──
    'attr_002': _AttrData(
      nom: 'Jardin Majorelle', type: 'Jardin', location: 'Guéliz, Marrakech',
      note: 4.7, description: 'Créé en 1923 par Jacques Majorelle et restauré par Yves Saint Laurent, ce jardin enchanteur abrite plus de 300 espèces végétales. Le bleu Majorelle iconique contraste avec les bambous géants, les cactus et les bougainvilliers.',
      images: _imgs('assets/images/marrakech/attractions/jardin_majorelle', 13),
      horaires: '8h00 - 18h00', entree: '700 MAD',
      conseils: ['Arrivez tôt le matin pour éviter la foule', 'Le musée berbère vaut le détour', 'Photographiez le bleu Majorelle unique'],
      histoire: 'Jacques Majorelle a passé 40 ans à créer ce jardin botanique. Après sa mort, Yves Saint Laurent et Pierre Bergé l\'ont racheté en 1980 pour le sauver de la démolition.',
    ),
    'attr_003': _AttrData(
      nom: 'Palais Bahia', type: 'Monument', location: 'Mellah, Marrakech',
      note: 4.6, description: 'Chef-d\'œuvre de l\'architecture marocaine du XIXe siècle, le Palais Bahia s\'étend sur 8 hectares. Ses 150 pièces décorées de zellige, bois de cèdre sculpté et stuc ciselé.',
      images: _imgs('assets/images/marrakech/attractions/bahia_palace', 13),
      horaires: '9h00 - 17h00', entree: '700 MAD',
      conseils: ['Prenez un guide pour comprendre l\'histoire', 'Les jardins intérieurs sont magnifiques', 'Visitez le matin pour la lumière'],
      histoire: 'Construit entre 1866 et 1900 par le grand vizir Ba Ahmed pour sa concubine favorite, le palais signifie "la belle" en arabe.',
    ),
    'attr_004': _AttrData(
      nom: 'Mosquée Koutoubia', type: 'Monument', location: 'Médina, Marrakech',
      note: 4.9, description: 'Symbole emblématique de Marrakech, la Koutoubia domine la ville avec son minaret de 77 mètres. Édifiée au XIIe siècle par les Almohades, elle a inspiré la Giralda de Séville.',
      images: _imgs('assets/images/marrakech/attractions/koutoubia', 8),
      horaires: 'Extérieur: 24h/24', entree: 'Gratuit (extérieur)',
      conseils: ['L\'intérieur est réservé aux musulmans', 'Les jardins sont parfaits au coucher du soleil', 'Visible de presque partout à Marrakech'],
      histoire: 'La mosquée Koutoubia, dont le nom dérive du mot "kutub" (livres), était autrefois entourée de libraires. Son minaret de 77m a servi de modèle architectural.',
    ),
    'attr_005': _AttrData(
      nom: 'Tombeaux Saadiens', type: 'Patrimoine', location: 'Kasbah, Marrakech',
      note: 4.5, description: 'Redécouverts en 1917 après avoir été murés pendant des siècles. La Salle des Douze Colonnes est ornée de marbre de Carrare et de stuc doré.',
      images: _imgs('assets/images/marrakech/attractions/tombeaux_saadiens', 7),
      horaires: '9h00 - 17h00', entree: '700 MAD',
      conseils: ['File d\'attente fréquente — arrivez tôt', 'La Salle des Douze Colonnes est incontournable'],
      histoire: 'Le sultan Moulay Ismaïl a fait murer les tombeaux pour effacer la mémoire des Saadiens. Ils sont restés cachés pendant plus de 200 ans.',
    ),
    'attr_008': _AttrData(
      nom: 'Jardins de la Ménara', type: 'Jardin', location: 'Hivernage, Marrakech',
      note: 4.3, description: 'Vaste oliveraie de 100 hectares avec un bassin artificiel du XIIe siècle. Le pavillon saadien se reflète dans les eaux calmes avec l\'Atlas en toile de fond.',
      images: _imgs('assets/images/marrakech/attractions/menara', 5),
      horaires: '8h00 - 17h00', entree: 'Gratuit',
      conseils: ['Idéal au coucher du soleil', 'Le pavillon est le spot photo iconique', 'Emportez un pique-nique'],
      histoire: 'Les jardins ont été créés au XIIe siècle par les Almohades. Le bassin servait à irriguer les oliveraies et les cultures environnantes.',
    ),

    // ── Casablanca ──
    'attr_casa_001': _AttrData(
      nom: 'Mosquée Hassan II', type: 'Monument', location: 'Corniche, Casablanca',
      note: 4.9, description: 'Troisième plus grande mosquée du monde avec son minaret de 210 mètres. Chef-d\'œuvre architectural surplombant l\'océan Atlantique, pouvant accueillir 25 000 fidèles.',
      images: _imgs('assets/images/casablanca/attractions/hassan_ii', 9),
      horaires: '9h00 - 14h00 (visites guidées)', entree: '1300 MAD',
      conseils: ['Réservez la visite guidée à l\'avance', 'Tenue respectueuse obligatoire', 'Le toit ouvrant est spectaculaire'],
      histoire: 'Inaugurée en 1993, construite en 6 ans par 10 000 artisans. Le roi Hassan II souhaitait un phare de l\'Islam sur l\'eau, inspiré du verset "Le trône de Dieu était sur l\'eau".',
    ),
    'attr_casa_002': _AttrData(
      nom: 'Place Mohammed V', type: 'Place', location: 'Centre-ville, Casablanca',
      note: 4.5, description: 'Place emblématique entourée de bâtiments art déco et néo-mauresques. Centre administratif et culturel de la ville avec fontaines et jardins.',
      images: _imgs('assets/images/casablanca/attractions/mohammed_v', 8),
      horaires: '24h/24', entree: 'Gratuit',
      conseils: ['Admirez l\'architecture art déco environnante', 'Belle le soir avec les fontaines illuminées', 'Point de départ idéal pour explorer le centre'],
      histoire: 'Anciennement Place des Nations Unies, elle a été renommée en l\'honneur du roi Mohammed V. Les bâtiments alentour datent des années 1920-1930.',
    ),
    'attr_casa_003': _AttrData(
      nom: 'Morocco Mall', type: 'Place', location: 'Corniche, Casablanca',
      note: 4.4, description: 'Le plus grand centre commercial d\'Afrique avec aquarium géant de 1 million de litres, patinoire olympique et plus de 600 boutiques internationales.',
      images: _imgs('assets/images/casablanca/attractions/morocco_mall', 6),
      horaires: '10h00 - 22h00', entree: 'Gratuit',
      conseils: ['L\'aquarium vaut le détour', 'Le food court offre une vue mer', 'Prévoyez 3-4h minimum pour tout voir'],
      histoire: 'Inauguré en 2011, le Morocco Mall a été conçu comme un espace de vie mêlant shopping, loisirs et culture, avec une architecture inspirée de l\'art islamique.',
    ),
    'attr_casa_004': _AttrData(
      nom: 'Église Notre-Dame de Lourdes', type: 'Monument', location: 'Quartier des Hôpitaux, Casablanca',
      note: 4.3, description: 'Église catholique remarquable pour ses immenses vitraux colorés de Gabriel Loire couvrant 800m². Architecture moderniste unique au Maroc.',
      images: _imgs('assets/images/casablanca/attractions/notre_dame', 9),
      horaires: '9h00 - 18h00', entree: 'Gratuit',
      conseils: ['Les vitraux sont époustouflants le matin', 'Architecture brutaliste rare au Maroc', 'Endroit calme pour une pause culturelle'],
      histoire: 'Construite en 1956 par l\'architecte Achille Dangleterre, cette église est célèbre pour ses 800m² de vitraux réalisés par le maître-verrier français Gabriel Loire.',
    ),
    'attr_casa_005': _AttrData(
      nom: 'Quartier Habous', type: 'Patrimoine', location: 'Habous, Casablanca',
      note: 4.6, description: 'Nouvelle médina construite dans les années 1930, mêlant urbanisme français et architecture marocaine. Artisanat authentique et pâtisseries traditionnelles.',
      images: _imgs('assets/images/casablanca/attractions/quartier_habous', 8),
      horaires: '9h00 - 20h00', entree: 'Gratuit',
      conseils: ['Goûtez les cornes de gazelle', 'Marchandage attendu dans les boutiques', 'Le Palais Royal est juste à côté'],
      histoire: 'Conçu dans les années 1930 par les architectes français Laprade et Cadet, ce quartier est un exemple unique de médina planifiée, respectant l\'architecture traditionnelle marocaine.',
    ),
    'attr_casa_006': _AttrData(
      nom: 'Palais Royal', type: 'Monument', location: 'Mechouar, Casablanca',
      note: 4.2, description: 'Résidence royale aux portes majestueusement ornées et jardins verdoyants. Exemple remarquable de l\'architecture palatiale marocaine moderne.',
      images: _imgs('assets/images/casablanca/attractions/royal_palace', 5),
      horaires: 'Extérieur uniquement', entree: 'Gratuit (extérieur)',
      conseils: ['Admirez les portes ornées de l\'extérieur', 'Intérieur fermé au public', 'Combinez avec la visite du Quartier Habous'],
      histoire: 'Le Palais Royal de Casablanca fait partie du réseau de résidences royales marocaines. Il sert de siège officiel lors des visites royales dans la capitale économique.',
    ),

    // ── Agadir ──
    'attr_aga_001': _AttrData(
      nom: 'Kasbah Oufella', type: 'Monument', location: 'Colline Oufella, Agadir',
      note: 4.6, description: 'Forteresse historique perchée à 236 mètres au-dessus d\'Agadir offrant une vue panoramique spectaculaire sur toute la baie et la ville. Reconstruite après le séisme de 1960.',
      images: _imgs('assets/images/agadir/attractions/kasbah_oufella', 4),
      horaires: '8h00 - 20h00', entree: 'Gratuit',
      conseils: ['Montez au coucher du soleil', 'Vue à 360° sur la ville et l\'océan', 'Inscription historique "Dieu, la Patrie, le Roi"'],
      histoire: 'Construite en 1540 par Mohammed ech-Cheikh, la Kasbah a été partiellement détruite par le séisme de 1960. Seuls les murs d\'enceinte et l\'inscription historique subsistent.',
    ),
    'attr_aga_002': _AttrData(
      nom: 'Marina d\'Agadir', type: 'Place', location: 'Front de Mer, Agadir',
      note: 4.5, description: 'Port de plaisance moderne avec promenade piétonne, restaurants, boutiques de luxe et vue imprenable sur l\'océan Atlantique. Lieu de vie animé.',
      images: _imgs('assets/images/agadir/attractions/marina_agadir', 4),
      horaires: '24h/24', entree: 'Gratuit',
      conseils: ['Dîner en terrasse face aux yachts', 'Promenade agréable le soir', 'Location de bateaux disponible'],
      histoire: 'Inaugurée en 2007, la Marina d\'Agadir est un projet pharaonique qui a transformé le port de pêche en destination touristique de premier plan.',
    ),

    // ── Tanger ──
    'attr_tan_001': _AttrData(
      nom: 'Cap Spartel', type: 'Monument', location: 'Cap Spartel, Tanger',
      note: 4.8, description: 'Point le plus au nord-ouest de l\'Afrique où l\'océan Atlantique rencontre la mer Méditerranée. Le phare historique du XIXe siècle offre une vue époustouflante.',
      images: _imgs('assets/images/tanger/attractions/cap_spartel', 4),
      horaires: '9h00 - 18h00', entree: '200 MAD',
      conseils: ['Vue spectaculaire où deux mers se rencontrent', 'Idéal par temps clair pour voir l\'Espagne', 'Combinez avec les Grottes d\'Hercule'],
      histoire: 'Le phare du Cap Spartel a été construit en 1864, financé conjointement par plusieurs nations européennes. Il marque l\'entrée du détroit de Gibraltar.',
    ),
    'attr_tan_002': _AttrData(
      nom: 'Grottes d\'Hercule', type: 'Patrimoine', location: 'Cap Spartel, Tanger',
      note: 4.7, description: 'Grottes naturelles mythiques où, selon la légende, Hercule se reposa après ses douze travaux. L\'ouverture vers la mer ressemble à la carte de l\'Afrique inversée.',
      images: _imgs('assets/images/tanger/attractions/caves_hercules', 7),
      horaires: '9h00 - 18h00', entree: '100 MAD',
      conseils: ['Photographiez l\'ouverture en forme d\'Afrique', 'Visitez à marée basse pour plus d\'espace', 'Guide recommandé pour l\'histoire'],
      histoire: 'Habitées depuis la préhistoire, ces grottes ont été utilisées comme carrière de meules par les Berbères. Les Romains y voyaient le lieu de repos d\'Hercule.',
    ),
    'attr_tan_003': _AttrData(
      nom: 'Musée de la Légation Américaine', type: 'Musée', location: 'Médina, Tanger',
      note: 4.5, description: 'Premier bâtiment américain à l\'étranger, ce musée retrace les relations diplomatiques entre le Maroc et les États-Unis depuis le XVIIIe siècle.',
      images: _imgs('assets/images/tanger/attractions/legation_museum', 14),
      horaires: '10h00 - 17h00', entree: '200 MAD',
      conseils: ['Collection d\'art marocain et américain', 'Architecture traditionnelle bien préservée', 'Fermé le week-end'],
      histoire: 'Le Maroc a été le premier pays à reconnaître l\'indépendance des États-Unis en 1777. Ce bâtiment, offert par le sultan en 1821, est le plus ancien bien immobilier américain à l\'étranger.',
    ),
    'attr_tan_004': _AttrData(
      nom: 'Parc Perdicaris', type: 'Jardin', location: 'Cap Spartel, Tanger',
      note: 4.4, description: 'Forêt luxuriante de 70 hectares avec sentiers de randonnée, eucalyptus et pins. Vue magnifique sur le détroit de Gibraltar et la côte espagnole.',
      images: _imgs('assets/images/tanger/attractions/parc_perdicaris', 5),
      horaires: '8h00 - 18h00', entree: 'Gratuit',
      conseils: ['Idéal pour la randonnée et le VTT', 'Pique-nique recommandé', 'Vue sur l\'Espagne par temps clair'],
      histoire: 'Nommé d\'après Ion Perdicaris, citoyen gréco-américain kidnappé en 1904 par le chef rifain Raissouli, provoquant un incident diplomatique international.',
    ),
    'attr_tan_005': _AttrData(
      nom: 'Église Saint-André', type: 'Patrimoine', location: 'Centre-ville, Tanger',
      note: 4.3, description: 'Église anglicane du XIXe siècle mêlant architecture mauresque et européenne. Son cimetière abrite les tombes de personnalités internationales.',
      images: _imgs('assets/images/tanger/attractions/st_andrew', 9),
      horaires: '9h00 - 17h30', entree: 'Don libre',
      conseils: ['Architecture mauresque-anglicane unique', 'Le cimetière raconte l\'histoire cosmopolite de Tanger', 'Le Seigneur est Mon Berger inscrit en arabe'],
      histoire: 'Construite en 1894 sur un terrain offert par le sultan Hassan Ier, elle témoigne du Tanger international cosmopolite du début du XXe siècle.',
    ),
  };

  _AttrData get _attr => _dataMap[widget.attractionId] ?? _dataMap['attr_002']!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Image header
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: const Color(0xFF1A1A1A),
            leading: _circleBtn(Icons.arrow_back_ios_rounded, () => context.pop()),
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
                    itemCount: _attr.images.length,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemBuilder: (context, i) => Image.asset(
                      _attr.images[i], fit: BoxFit.cover, cacheWidth: 500, gaplessPlayback: true,
                      errorBuilder: (_, _, _) => Container(color: const Color(0xFF2A2A2A)),
                    ),
                  ),
                  Positioned(bottom: 0, left: 0, right: 0, height: 80,
                    child: Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [const Color(0xFF1A1A1A).withValues(alpha: 0.8), Colors.transparent])))),
                  if (_attr.images.length > 1)
                    Positioned(bottom: 12, left: 0, right: 0,
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_attr.images.length, (i) => AnimatedContainer(duration: const Duration(milliseconds: 250), margin: const EdgeInsets.symmetric(horizontal: 3), width: _currentPage == i ? 20 : 6, height: 6,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: _currentPage == i ? const Color(0xFFFF8C00) : Colors.white.withValues(alpha: 0.35)))))),
                ],
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name & rating
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(_attr.nom, style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
                      const SizedBox(height: 4),
                      Row(children: [
                        Icon(Icons.location_on_outlined, color: Colors.white.withValues(alpha: 0.4), size: 15),
                        const SizedBox(width: 4),
                        Expanded(child: Text(_attr.location, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.4), fontSize: 14), overflow: TextOverflow.ellipsis)),
                      ]),
                      const SizedBox(height: 8),
                      // Navigation button
                      GestureDetector(
                        onTap: () => launchUrl(Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent('${_attr.nom}, Marrakech')}'), mode: LaunchMode.externalApplication),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white.withValues(alpha: 0.1))),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(Icons.navigation_rounded, size: 14, color: Color(0xFFFF8C00)),
                            const SizedBox(width: 6),
                            const Text('Itinéraire', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Color(0xFFFF8C00), fontSize: 13, fontWeight: FontWeight.w700)),
                          ]),
                        ),
                      ),
                    ])),
                    // Rating badge + type
                    Column(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: const Color(0xFFFF8C00).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFFF8C00), size: 18),
                          const SizedBox(width: 4),
                          Text(_attr.note.toString(), style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Color(0xFFFF8C00), fontSize: 15, fontWeight: FontWeight.w800)),
                        ]),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFF2ECC71).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                        child: Text(_attr.type, style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Color(0xFF2ECC71), fontSize: 11, fontWeight: FontWeight.w700)),
                      ),
                    ]),
                  ]),
                  const SizedBox(height: 24),

                  // Description
                  Text(_attr.description, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.6), fontSize: 14, height: 1.6)),
                  const SizedBox(height: 24),

                  // Info cards
                  Row(children: [
                    Expanded(child: _infoCard(Icons.access_time_rounded, 'Horaires', _attr.horaires)),
                    const SizedBox(width: 12),
                    Expanded(child: _infoCard(Icons.confirmation_number_rounded, 'Entrée', _attr.entree)),
                  ]),
                  const SizedBox(height: 24),

                  // History section
                  _sectionCard('Histoire', Icons.history_edu_rounded, _attr.histoire),
                  const SizedBox(height: 20),

                  // Tips section
                  _buildTips(),
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
    child: Container(width: 38, height: 38, margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withValues(alpha: 0.4)),
      child: Icon(icon, color: Colors.white, size: 20)),
  );

  Widget _infoCard(IconData icon, String label, String value) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withValues(alpha: 0.06))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icon, color: const Color(0xFFFF8C00).withValues(alpha: 0.7), size: 16),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.4), fontSize: 11, fontWeight: FontWeight.w600)),
      ]),
      const SizedBox(height: 6),
      Text(value, style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
    ]),
  );

  Widget _sectionCard(String title, IconData icon, String content) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withValues(alpha: 0.06))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icon, color: const Color(0xFFFF8C00), size: 18),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
      ]),
      const SizedBox(height: 10),
      Text(content, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.55), fontSize: 13, height: 1.5)),
    ]),
  );

  Widget _buildTips() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withValues(alpha: 0.06))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const Icon(Icons.lightbulb_rounded, color: Color(0xFFFF8C00), size: 18),
        const SizedBox(width: 8),
        const Text('Conseils', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
      ]),
      const SizedBox(height: 12),
      ..._attr.conseils.map((tip) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.check_circle_rounded, color: Color(0xFF2ECC71), size: 16),
          const SizedBox(width: 10),
          Expanded(child: Text(tip, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.55), fontSize: 13))),
        ]),
      )),
    ]),
  );
}

class _AttrData {
  final String nom, type, location, description, horaires, entree, histoire;
  final double note;
  final List<String> images, conseils;
  const _AttrData({required this.nom, required this.type, required this.location, required this.note, required this.description, required this.images, required this.horaires, required this.entree, required this.conseils, required this.histoire});
}
