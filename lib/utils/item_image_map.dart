/// Maps item IDs (from Supabase DB) to their local asset image paths.
/// Used to resolve correct images for reservations created by the AI agent,
/// since the DB `image_url` may be empty or an Unsplash URL that doesn't
/// match the actual bundled assets.
class ItemImageMap {
  ItemImageMap._();

  /// Returns the first local asset path for the given item ID, or empty string.
  static String getImageForItem(String itemId) =>
      _map[itemId] ?? '';

  static const _map = <String, String>{
    // ── Hotels – Marrakech ──
    'hotel_002': 'assets/images/marrakech/hotels/la_mamounia/1.png',
    'hotel_003': 'assets/images/marrakech/hotels/riad_yasmine/1.png',
    'hotel_005': 'assets/images/marrakech/hotels/la_sultana/1.png',
    'hotel_006': 'assets/images/marrakech/hotels/mandarin_oriental/1.png',
    'hotel_007': 'assets/images/marrakech/hotels/riad_kniza/1.png',
    'hotel_008': 'assets/images/marrakech/hotels/royal_mansour/1.png',
    // ── Hotels – Casablanca ──
    'hotel_casa_001': 'assets/images/casablanca/hotels/four_seasons_casa/1.jpg',
    'hotel_casa_002': 'assets/images/casablanca/hotels/le_doge_casa/1.jpg',
    'hotel_casa_003': 'assets/images/casablanca/hotels/hyatt_casa/1.jpg',
    'hotel_casa_004': 'assets/images/casablanca/hotels/kenzi_tower/1.jpg',
    'hotel_casa_005': 'assets/images/casablanca/hotels/sofitel_casa/1.jpg',
    'hotel_casa_006': 'assets/images/casablanca/hotels/transatlantique/1.jpg',
    // ── Hotels – Agadir ──
    'hotel_aga_001': 'assets/images/agadir/hotels/sofitel_royal_bay/1.jpg',
    'hotel_aga_002': 'assets/images/agadir/hotels/sofitel_thalassa/1.jpg',
    'hotel_aga_003': 'assets/images/agadir/hotels/riu_palace_tikida/1.jpg',
    'hotel_aga_004': 'assets/images/agadir/hotels/the_view/1.jpg',
    'hotel_aga_005': 'assets/images/agadir/hotels/dunes_dor/1.jpg',
    // ── Hotels – Tanger ──
    'hotel_tan_001': 'assets/images/tanger/hotels/hilton_al_houara/1.jpg',
    'hotel_tan_002': 'assets/images/tanger/hotels/hilton_city_center/1.jpg',
    'hotel_tan_003': 'assets/images/tanger/hotels/barcelo/1.jpg',
    'hotel_tan_004': 'assets/images/tanger/hotels/hilton_garden_inn/1.jpg',
    'hotel_tan_005': 'assets/images/tanger/hotels/pestana/1.jpg',

    // ── Restaurants – Marrakech ──
    'resto_001': 'assets/images/marrakech/restaurants/le_jardin/1.png',
    'resto_002': 'assets/images/marrakech/restaurants/nomad/1.png',
    'resto_003': 'assets/images/marrakech/restaurants/dar_moha/1.png',
    'resto_004': 'assets/images/marrakech/restaurants/le_foundouk/1.png',
    'resto_005': 'assets/images/marrakech/restaurants/la_table_al_badia/1.png',
    'resto_006': 'assets/images/marrakech/restaurants/cafe_arabe/1.png',
    // ── Restaurants – Casablanca ──
    'resto_casa_001': 'assets/images/casablanca/restaurants/rick_cafe/1.jpg',
    'resto_casa_002': 'assets/images/casablanca/restaurants/la_sqala/1.jpg',
    'resto_casa_003': 'assets/images/casablanca/restaurants/basmane/1.jpg',
    'resto_casa_004': 'assets/images/casablanca/restaurants/le_cabestan/1.jpg',
    'resto_casa_005': 'assets/images/casablanca/restaurants/brasserie_la_tour/1.jpg',
    'resto_casa_006': 'assets/images/casablanca/restaurants/la_bodega/1.jpg',
    // ── Restaurants – Agadir ──
    'resto_aga_001': 'assets/images/agadir/restaurants/pure_passion/1.jpg',
    'resto_aga_002': 'assets/images/agadir/restaurants/la_scala/1.jpg',
    'resto_aga_003': 'assets/images/agadir/restaurants/english_pub/1.jpg',
    'resto_aga_004': 'assets/images/agadir/restaurants/mezzo_mezzo/1.jpg',
    'resto_aga_005': 'assets/images/agadir/restaurants/les_blancs/1.jpg',
    // ── Restaurants – Tanger ──
    'resto_tan_001': 'assets/images/tanger/restaurants/el_morocco_club/1.jpg',
    'resto_tan_002': 'assets/images/tanger/restaurants/le_saveur_de_poisson/1.jpg',
    'resto_tan_003': 'assets/images/tanger/restaurants/le_nabab/1.jpg',
    'resto_tan_004': 'assets/images/tanger/restaurants/rif_kebdani/1.jpg',
    'resto_tan_005': 'assets/images/tanger/restaurants/la_fabrique/1.jpg',

    // ── Experiences – Marrakech ──
    'exp_001': 'assets/images/marrakech/experiences/safari_agafay/1.png',
    'exp_002': 'assets/images/marrakech/experiences/medina_visite/1.png',
    'exp_003': 'assets/images/marrakech/experiences/randonnee_atlas/1.png',
    'exp_004': 'assets/images/marrakech/experiences/cours_cuisine/1.png',
    'exp_005': 'assets/images/marrakech/experiences/vol_montgolfiere/1.png',
    'exp_006': 'assets/images/marrakech/experiences/jardin_majorelle/1.png',
    // ── Experiences – Casablanca ──
    'exp_casa_001': 'assets/images/casablanca/experiences/mosquee_hassan/1.jpg',
    'exp_casa_002': 'assets/images/casablanca/experiences/corniche_casa/1.jpg',
    'exp_casa_003': 'assets/images/casablanca/experiences/medina_casa/1.jpeg',
    'exp_casa_004': 'assets/images/casablanca/experiences/morocco_mall/1.png',
    'exp_casa_005': 'assets/images/casablanca/experiences/art_deco_tour/1.png',
    'exp_casa_006': 'assets/images/casablanca/experiences/yacht_casa/1.png',
    // ── Experiences – Agadir ──
    'exp_aga_001': 'assets/images/agadir/experiences/city_tour/1.jpg',
    'exp_aga_002': 'assets/images/agadir/experiences/sandboarding/1.jpg',
    'exp_aga_003': 'assets/images/agadir/experiences/yacht_cruise/1.jpg',
    'exp_aga_004': 'assets/images/agadir/experiences/cable_car/1.jpg',
    'exp_aga_005': 'assets/images/agadir/experiences/paradise_valley/1.jpg',
    'exp_aga_006': 'assets/images/agadir/experiences/crocoparc/1.jpg',
    // ── Experiences – Tanger ──
    'exp_tan_001': 'assets/images/tanger/experiences/luxury_tour/1.jpg',
    'exp_tan_002': 'assets/images/tanger/experiences/grand_tour/4.png',

    // ── Véhicules ──
    'vehicule_001': 'assets/images/vehicules/mercedes_classe_e/1.png',
    'vehicule_002': 'assets/images/vehicules/dacia_duster/1.png',
    'vehicule_003': 'assets/images/vehicules/bmw_x5/1.png',
    'vehicule_004': 'assets/images/vehicules/peugeot_3008/1.png',
    'vehicule_005': 'assets/images/vehicules/range_rover/1.png',
    'vehicule_006': 'assets/images/vehicules/toyota_land_cruiser/1.png',

    // ── Boutiques ──
    'boutique_001': 'assets/images/boutiques/art_berber/1.png',
    'boutique_002': 'assets/images/boutiques/souk_delights/1.png',
    'boutique_003': 'assets/images/boutiques/moroccan_treasures/1.png',
    'boutique_004': 'assets/images/boutiques/zellige_art/1.png',
    'boutique_005': 'assets/images/boutiques/atlas_craft/1.png',
    'boutique_006': 'assets/images/boutiques/maison_artisanale/1.png',
  };
}
