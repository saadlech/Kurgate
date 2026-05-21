import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_error_snackbar.dart';
import '../widgets/kurgate_button.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen>
    with TickerProviderStateMixin {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreeTerms = false;
  bool _isLoading = false;
  bool _signupComplete = false;
  bool _signupSuccess = false;
  int _passwordStrength = 0;

  // Country code for phone
  String _selectedCountryCode = '+212';

  static const List<Map<String, String>> _countryCodes = [
    // Default — Morocco first
    {'code': '+212', 'flag': '🇲🇦', 'name': 'Morocco'},
    // A
    {'code': '+93', 'flag': '🇦🇫', 'name': 'Afghanistan'},
    {'code': '+355', 'flag': '🇦🇱', 'name': 'Albania'},
    {'code': '+213', 'flag': '🇩🇿', 'name': 'Algeria'},
    {'code': '+376', 'flag': '🇦🇩', 'name': 'Andorra'},
    {'code': '+244', 'flag': '🇦🇴', 'name': 'Angola'},
    {'code': '+1268', 'flag': '🇦🇬', 'name': 'Antigua & Barbuda'},
    {'code': '+54', 'flag': '🇦🇷', 'name': 'Argentina'},
    {'code': '+374', 'flag': '🇦🇲', 'name': 'Armenia'},
    {'code': '+61', 'flag': '🇦🇺', 'name': 'Australia'},
    {'code': '+43', 'flag': '🇦🇹', 'name': 'Austria'},
    {'code': '+994', 'flag': '🇦🇿', 'name': 'Azerbaijan'},
    // B
    {'code': '+1242', 'flag': '🇧🇸', 'name': 'Bahamas'},
    {'code': '+973', 'flag': '🇧🇭', 'name': 'Bahrain'},
    {'code': '+880', 'flag': '🇧🇩', 'name': 'Bangladesh'},
    {'code': '+1246', 'flag': '🇧🇧', 'name': 'Barbados'},
    {'code': '+375', 'flag': '🇧🇾', 'name': 'Belarus'},
    {'code': '+32', 'flag': '🇧🇪', 'name': 'Belgium'},
    {'code': '+501', 'flag': '🇧🇿', 'name': 'Belize'},
    {'code': '+229', 'flag': '🇧🇯', 'name': 'Benin'},
    {'code': '+975', 'flag': '🇧🇹', 'name': 'Bhutan'},
    {'code': '+591', 'flag': '🇧🇴', 'name': 'Bolivia'},
    {'code': '+387', 'flag': '🇧🇦', 'name': 'Bosnia & Herzegovina'},
    {'code': '+267', 'flag': '🇧🇼', 'name': 'Botswana'},
    {'code': '+55', 'flag': '🇧🇷', 'name': 'Brazil'},
    {'code': '+673', 'flag': '🇧🇳', 'name': 'Brunei'},
    {'code': '+359', 'flag': '🇧🇬', 'name': 'Bulgaria'},
    {'code': '+226', 'flag': '🇧🇫', 'name': 'Burkina Faso'},
    {'code': '+257', 'flag': '🇧🇮', 'name': 'Burundi'},
    // C
    {'code': '+855', 'flag': '🇰🇭', 'name': 'Cambodia'},
    {'code': '+237', 'flag': '🇨🇲', 'name': 'Cameroon'},
    {'code': '+1', 'flag': '🇨🇦', 'name': 'Canada'},
    {'code': '+238', 'flag': '🇨🇻', 'name': 'Cape Verde'},
    {'code': '+236', 'flag': '🇨🇫', 'name': 'Central African Republic'},
    {'code': '+235', 'flag': '🇹🇩', 'name': 'Chad'},
    {'code': '+56', 'flag': '🇨🇱', 'name': 'Chile'},
    {'code': '+86', 'flag': '🇨🇳', 'name': 'China'},
    {'code': '+57', 'flag': '🇨🇴', 'name': 'Colombia'},
    {'code': '+269', 'flag': '🇰🇲', 'name': 'Comoros'},
    {'code': '+242', 'flag': '🇨🇬', 'name': 'Congo'},
    {'code': '+243', 'flag': '🇨🇩', 'name': 'Congo (DRC)'},
    {'code': '+506', 'flag': '🇨🇷', 'name': 'Costa Rica'},
    {'code': '+385', 'flag': '🇭🇷', 'name': 'Croatia'},
    {'code': '+53', 'flag': '🇨🇺', 'name': 'Cuba'},
    {'code': '+357', 'flag': '🇨🇾', 'name': 'Cyprus'},
    {'code': '+420', 'flag': '🇨🇿', 'name': 'Czech Republic'},
    // D
    {'code': '+45', 'flag': '🇩🇰', 'name': 'Denmark'},
    {'code': '+253', 'flag': '🇩🇯', 'name': 'Djibouti'},
    {'code': '+1767', 'flag': '🇩🇲', 'name': 'Dominica'},
    {'code': '+1809', 'flag': '🇩🇴', 'name': 'Dominican Republic'},
    // E
    {'code': '+593', 'flag': '🇪🇨', 'name': 'Ecuador'},
    {'code': '+20', 'flag': '🇪🇬', 'name': 'Egypt'},
    {'code': '+503', 'flag': '🇸🇻', 'name': 'El Salvador'},
    {'code': '+240', 'flag': '🇬🇶', 'name': 'Equatorial Guinea'},
    {'code': '+291', 'flag': '🇪🇷', 'name': 'Eritrea'},
    {'code': '+372', 'flag': '🇪🇪', 'name': 'Estonia'},
    {'code': '+268', 'flag': '🇸🇿', 'name': 'Eswatini'},
    {'code': '+251', 'flag': '🇪🇹', 'name': 'Ethiopia'},
    // F
    {'code': '+679', 'flag': '🇫🇯', 'name': 'Fiji'},
    {'code': '+358', 'flag': '🇫🇮', 'name': 'Finland'},
    {'code': '+33', 'flag': '🇫🇷', 'name': 'France'},
    // G
    {'code': '+241', 'flag': '🇬🇦', 'name': 'Gabon'},
    {'code': '+220', 'flag': '🇬🇲', 'name': 'Gambia'},
    {'code': '+995', 'flag': '🇬🇪', 'name': 'Georgia'},
    {'code': '+49', 'flag': '🇩🇪', 'name': 'Germany'},
    {'code': '+233', 'flag': '🇬🇭', 'name': 'Ghana'},
    {'code': '+30', 'flag': '🇬🇷', 'name': 'Greece'},
    {'code': '+1473', 'flag': '🇬🇩', 'name': 'Grenada'},
    {'code': '+502', 'flag': '🇬🇹', 'name': 'Guatemala'},
    {'code': '+224', 'flag': '🇬🇳', 'name': 'Guinea'},
    {'code': '+245', 'flag': '🇬🇼', 'name': 'Guinea-Bissau'},
    {'code': '+592', 'flag': '🇬🇾', 'name': 'Guyana'},
    // H
    {'code': '+509', 'flag': '🇭🇹', 'name': 'Haiti'},
    {'code': '+504', 'flag': '🇭🇳', 'name': 'Honduras'},
    {'code': '+852', 'flag': '🇭🇰', 'name': 'Hong Kong'},
    {'code': '+36', 'flag': '🇭🇺', 'name': 'Hungary'},
    // I
    {'code': '+354', 'flag': '🇮🇸', 'name': 'Iceland'},
    {'code': '+91', 'flag': '🇮🇳', 'name': 'India'},
    {'code': '+62', 'flag': '🇮🇩', 'name': 'Indonesia'},
    {'code': '+98', 'flag': '🇮🇷', 'name': 'Iran'},
    {'code': '+964', 'flag': '🇮🇶', 'name': 'Iraq'},
    {'code': '+353', 'flag': '🇮🇪', 'name': 'Ireland'},
    {'code': '+972', 'flag': '🇮🇱', 'name': 'Israel'},
    {'code': '+39', 'flag': '🇮🇹', 'name': 'Italy'},
    {'code': '+225', 'flag': '🇨🇮', 'name': 'Ivory Coast'},
    // J
    {'code': '+1876', 'flag': '🇯🇲', 'name': 'Jamaica'},
    {'code': '+81', 'flag': '🇯🇵', 'name': 'Japan'},
    {'code': '+962', 'flag': '🇯🇴', 'name': 'Jordan'},
    // K
    {'code': '+7', 'flag': '🇰🇿', 'name': 'Kazakhstan'},
    {'code': '+254', 'flag': '🇰🇪', 'name': 'Kenya'},
    {'code': '+686', 'flag': '🇰🇮', 'name': 'Kiribati'},
    {'code': '+383', 'flag': '🇽🇰', 'name': 'Kosovo'},
    {'code': '+965', 'flag': '🇰🇼', 'name': 'Kuwait'},
    {'code': '+996', 'flag': '🇰🇬', 'name': 'Kyrgyzstan'},
    // L
    {'code': '+856', 'flag': '🇱🇦', 'name': 'Laos'},
    {'code': '+371', 'flag': '🇱🇻', 'name': 'Latvia'},
    {'code': '+961', 'flag': '🇱🇧', 'name': 'Lebanon'},
    {'code': '+266', 'flag': '🇱🇸', 'name': 'Lesotho'},
    {'code': '+231', 'flag': '🇱🇷', 'name': 'Liberia'},
    {'code': '+218', 'flag': '🇱🇾', 'name': 'Libya'},
    {'code': '+423', 'flag': '🇱🇮', 'name': 'Liechtenstein'},
    {'code': '+370', 'flag': '🇱🇹', 'name': 'Lithuania'},
    {'code': '+352', 'flag': '🇱🇺', 'name': 'Luxembourg'},
    // M
    {'code': '+853', 'flag': '🇲🇴', 'name': 'Macau'},
    {'code': '+261', 'flag': '🇲🇬', 'name': 'Madagascar'},
    {'code': '+265', 'flag': '🇲🇼', 'name': 'Malawi'},
    {'code': '+60', 'flag': '🇲🇾', 'name': 'Malaysia'},
    {'code': '+960', 'flag': '🇲🇻', 'name': 'Maldives'},
    {'code': '+223', 'flag': '🇲🇱', 'name': 'Mali'},
    {'code': '+356', 'flag': '🇲🇹', 'name': 'Malta'},
    {'code': '+222', 'flag': '🇲🇷', 'name': 'Mauritania'},
    {'code': '+230', 'flag': '🇲🇺', 'name': 'Mauritius'},
    {'code': '+52', 'flag': '🇲🇽', 'name': 'Mexico'},
    {'code': '+373', 'flag': '🇲🇩', 'name': 'Moldova'},
    {'code': '+377', 'flag': '🇲🇨', 'name': 'Monaco'},
    {'code': '+976', 'flag': '🇲🇳', 'name': 'Mongolia'},
    {'code': '+382', 'flag': '🇲🇪', 'name': 'Montenegro'},
    {'code': '+258', 'flag': '🇲🇿', 'name': 'Mozambique'},
    {'code': '+95', 'flag': '🇲🇲', 'name': 'Myanmar'},
    // N
    {'code': '+264', 'flag': '🇳🇦', 'name': 'Namibia'},
    {'code': '+977', 'flag': '🇳🇵', 'name': 'Nepal'},
    {'code': '+31', 'flag': '🇳🇱', 'name': 'Netherlands'},
    {'code': '+64', 'flag': '🇳🇿', 'name': 'New Zealand'},
    {'code': '+505', 'flag': '🇳🇮', 'name': 'Nicaragua'},
    {'code': '+227', 'flag': '🇳🇪', 'name': 'Niger'},
    {'code': '+234', 'flag': '🇳🇬', 'name': 'Nigeria'},
    {'code': '+850', 'flag': '🇰🇵', 'name': 'North Korea'},
    {'code': '+389', 'flag': '🇲🇰', 'name': 'North Macedonia'},
    {'code': '+47', 'flag': '🇳🇴', 'name': 'Norway'},
    // O
    {'code': '+968', 'flag': '🇴🇲', 'name': 'Oman'},
    // P
    {'code': '+92', 'flag': '🇵🇰', 'name': 'Pakistan'},
    {'code': '+970', 'flag': '🇵🇸', 'name': 'Palestine'},
    {'code': '+507', 'flag': '🇵🇦', 'name': 'Panama'},
    {'code': '+675', 'flag': '🇵🇬', 'name': 'Papua New Guinea'},
    {'code': '+595', 'flag': '🇵🇾', 'name': 'Paraguay'},
    {'code': '+51', 'flag': '🇵🇪', 'name': 'Peru'},
    {'code': '+63', 'flag': '🇵🇭', 'name': 'Philippines'},
    {'code': '+48', 'flag': '🇵🇱', 'name': 'Poland'},
    {'code': '+351', 'flag': '🇵🇹', 'name': 'Portugal'},
    {'code': '+1787', 'flag': '🇵🇷', 'name': 'Puerto Rico'},
    // Q
    {'code': '+974', 'flag': '🇶🇦', 'name': 'Qatar'},
    // R
    {'code': '+40', 'flag': '🇷🇴', 'name': 'Romania'},
    {'code': '+7', 'flag': '🇷🇺', 'name': 'Russia'},
    {'code': '+250', 'flag': '🇷🇼', 'name': 'Rwanda'},
    // S
    {'code': '+1869', 'flag': '🇰🇳', 'name': 'Saint Kitts & Nevis'},
    {'code': '+1758', 'flag': '🇱🇨', 'name': 'Saint Lucia'},
    {'code': '+685', 'flag': '🇼🇸', 'name': 'Samoa'},
    {'code': '+378', 'flag': '🇸🇲', 'name': 'San Marino'},
    {'code': '+239', 'flag': '🇸🇹', 'name': 'São Tomé & Príncipe'},
    {'code': '+966', 'flag': '🇸🇦', 'name': 'Saudi Arabia'},
    {'code': '+221', 'flag': '🇸🇳', 'name': 'Senegal'},
    {'code': '+381', 'flag': '🇷🇸', 'name': 'Serbia'},
    {'code': '+248', 'flag': '🇸🇨', 'name': 'Seychelles'},
    {'code': '+232', 'flag': '🇸🇱', 'name': 'Sierra Leone'},
    {'code': '+65', 'flag': '🇸🇬', 'name': 'Singapore'},
    {'code': '+421', 'flag': '🇸🇰', 'name': 'Slovakia'},
    {'code': '+386', 'flag': '🇸🇮', 'name': 'Slovenia'},
    {'code': '+677', 'flag': '🇸🇧', 'name': 'Solomon Islands'},
    {'code': '+252', 'flag': '🇸🇴', 'name': 'Somalia'},
    {'code': '+27', 'flag': '🇿🇦', 'name': 'South Africa'},
    {'code': '+82', 'flag': '🇰🇷', 'name': 'South Korea'},
    {'code': '+211', 'flag': '🇸🇸', 'name': 'South Sudan'},
    {'code': '+34', 'flag': '🇪🇸', 'name': 'Spain'},
    {'code': '+94', 'flag': '🇱🇰', 'name': 'Sri Lanka'},
    {'code': '+249', 'flag': '🇸🇩', 'name': 'Sudan'},
    {'code': '+597', 'flag': '🇸🇷', 'name': 'Suriname'},
    {'code': '+46', 'flag': '🇸🇪', 'name': 'Sweden'},
    {'code': '+41', 'flag': '🇨🇭', 'name': 'Switzerland'},
    {'code': '+963', 'flag': '🇸🇾', 'name': 'Syria'},
    // T
    {'code': '+886', 'flag': '🇹🇼', 'name': 'Taiwan'},
    {'code': '+992', 'flag': '🇹🇯', 'name': 'Tajikistan'},
    {'code': '+255', 'flag': '🇹🇿', 'name': 'Tanzania'},
    {'code': '+66', 'flag': '🇹🇭', 'name': 'Thailand'},
    {'code': '+228', 'flag': '🇹🇬', 'name': 'Togo'},
    {'code': '+676', 'flag': '🇹🇴', 'name': 'Tonga'},
    {'code': '+1868', 'flag': '🇹🇹', 'name': 'Trinidad & Tobago'},
    {'code': '+216', 'flag': '🇹🇳', 'name': 'Tunisia'},
    {'code': '+90', 'flag': '🇹🇷', 'name': 'Turkey'},
    {'code': '+993', 'flag': '🇹🇲', 'name': 'Turkmenistan'},
    {'code': '+688', 'flag': '🇹🇻', 'name': 'Tuvalu'},
    // U
    {'code': '+256', 'flag': '🇺🇬', 'name': 'Uganda'},
    {'code': '+380', 'flag': '🇺🇦', 'name': 'Ukraine'},
    {'code': '+971', 'flag': '🇦🇪', 'name': 'UAE'},
    {'code': '+44', 'flag': '🇬🇧', 'name': 'United Kingdom'},
    {'code': '+1', 'flag': '🇺🇸', 'name': 'United States'},
    {'code': '+598', 'flag': '🇺🇾', 'name': 'Uruguay'},
    {'code': '+998', 'flag': '🇺🇿', 'name': 'Uzbekistan'},
    // V
    {'code': '+678', 'flag': '🇻🇺', 'name': 'Vanuatu'},
    {'code': '+379', 'flag': '🇻🇦', 'name': 'Vatican City'},
    {'code': '+58', 'flag': '🇻🇪', 'name': 'Venezuela'},
    {'code': '+84', 'flag': '🇻🇳', 'name': 'Vietnam'},
    // Y
    {'code': '+967', 'flag': '🇾🇪', 'name': 'Yemen'},
    // Z
    {'code': '+260', 'flag': '🇿🇲', 'name': 'Zambia'},
    {'code': '+263', 'flag': '🇿🇼', 'name': 'Zimbabwe'},
  ];

  /// Expected phone digit lengths per country code (local number only, without code).
  /// Most countries accept a range; we store [min, max].
  static const Map<String, List<int>> _phoneDigitLengths = {
    '+93': [9, 9],     // Afghanistan
    '+355': [9, 9],    // Albania
    '+213': [9, 9],    // Algeria
    '+376': [6, 9],    // Andorra
    '+244': [9, 9],    // Angola
    '+1268': [7, 7],   // Antigua & Barbuda
    '+54': [10, 10],   // Argentina
    '+374': [8, 8],    // Armenia
    '+61': [9, 9],     // Australia
    '+43': [10, 13],   // Austria
    '+994': [9, 9],    // Azerbaijan
    '+1242': [7, 7],   // Bahamas
    '+973': [8, 8],    // Bahrain
    '+880': [10, 10],  // Bangladesh
    '+1246': [7, 7],   // Barbados
    '+375': [9, 10],   // Belarus
    '+32': [8, 9],     // Belgium
    '+501': [7, 7],    // Belize
    '+229': [8, 8],    // Benin
    '+975': [8, 8],    // Bhutan
    '+591': [8, 8],    // Bolivia
    '+387': [8, 8],    // Bosnia & Herzegovina
    '+267': [7, 8],    // Botswana
    '+55': [10, 11],   // Brazil
    '+673': [7, 7],    // Brunei
    '+359': [8, 9],    // Bulgaria
    '+226': [8, 8],    // Burkina Faso
    '+257': [8, 8],    // Burundi
    '+855': [8, 9],    // Cambodia
    '+237': [9, 9],    // Cameroon
    '+1': [10, 10],    // Canada / USA
    '+238': [7, 7],    // Cape Verde
    '+236': [8, 8],    // Central African Republic
    '+235': [8, 8],    // Chad
    '+56': [9, 9],     // Chile
    '+86': [11, 11],   // China
    '+57': [10, 10],   // Colombia
    '+269': [7, 7],    // Comoros
    '+242': [9, 9],    // Congo
    '+243': [9, 9],    // Congo (DRC)
    '+506': [8, 8],    // Costa Rica
    '+385': [8, 9],    // Croatia
    '+53': [8, 8],     // Cuba
    '+357': [8, 8],    // Cyprus
    '+420': [9, 9],    // Czech Republic
    '+45': [8, 8],     // Denmark
    '+253': [8, 8],    // Djibouti
    '+1767': [7, 7],   // Dominica
    '+1809': [7, 7],   // Dominican Republic
    '+593': [9, 9],    // Ecuador
    '+20': [10, 10],   // Egypt
    '+503': [8, 8],    // El Salvador
    '+240': [9, 9],    // Equatorial Guinea
    '+291': [7, 7],    // Eritrea
    '+372': [7, 8],    // Estonia
    '+268': [8, 8],    // Eswatini
    '+251': [9, 9],    // Ethiopia
    '+679': [7, 7],    // Fiji
    '+358': [9, 10],   // Finland
    '+33': [9, 9],     // France
    '+241': [7, 8],    // Gabon
    '+220': [7, 7],    // Gambia
    '+995': [9, 9],    // Georgia
    '+49': [10, 11],   // Germany
    '+233': [9, 9],    // Ghana
    '+30': [10, 10],   // Greece
    '+1473': [7, 7],   // Grenada
    '+502': [8, 8],    // Guatemala
    '+224': [9, 9],    // Guinea
    '+245': [7, 7],    // Guinea-Bissau
    '+592': [7, 7],    // Guyana
    '+509': [8, 8],    // Haiti
    '+504': [8, 8],    // Honduras
    '+852': [8, 8],    // Hong Kong
    '+36': [9, 9],     // Hungary
    '+354': [7, 7],    // Iceland
    '+91': [10, 10],   // India
    '+62': [9, 12],    // Indonesia
    '+98': [10, 10],   // Iran
    '+964': [10, 10],  // Iraq
    '+353': [9, 9],    // Ireland
    '+972': [9, 9],    // Israel
    '+39': [9, 10],    // Italy
    '+225': [10, 10],  // Ivory Coast
    '+1876': [7, 7],   // Jamaica
    '+81': [10, 10],   // Japan
    '+962': [9, 9],    // Jordan
    '+7': [10, 10],    // Kazakhstan / Russia
    '+254': [9, 9],    // Kenya
    '+686': [8, 8],    // Kiribati
    '+383': [8, 8],    // Kosovo
    '+965': [8, 8],    // Kuwait
    '+996': [9, 9],    // Kyrgyzstan
    '+856': [9, 10],   // Laos
    '+371': [8, 8],    // Latvia
    '+961': [7, 8],    // Lebanon
    '+266': [8, 8],    // Lesotho
    '+231': [7, 8],    // Liberia
    '+218': [9, 10],   // Libya
    '+423': [7, 7],    // Liechtenstein
    '+370': [8, 8],    // Lithuania
    '+352': [8, 9],    // Luxembourg
    '+853': [8, 8],    // Macau
    '+261': [9, 9],    // Madagascar
    '+265': [9, 9],    // Malawi
    '+60': [9, 10],    // Malaysia
    '+960': [7, 7],    // Maldives
    '+223': [8, 8],    // Mali
    '+356': [8, 8],    // Malta
    '+222': [8, 8],    // Mauritania
    '+230': [8, 8],    // Mauritius
    '+52': [10, 10],   // Mexico
    '+373': [8, 8],    // Moldova
    '+377': [8, 8],    // Monaco
    '+976': [8, 8],    // Mongolia
    '+382': [8, 8],    // Montenegro
    '+212': [9, 9],    // Morocco
    '+258': [9, 9],    // Mozambique
    '+95': [8, 10],    // Myanmar
    '+264': [9, 9],    // Namibia
    '+977': [10, 10],  // Nepal
    '+31': [9, 9],     // Netherlands
    '+64': [8, 10],    // New Zealand
    '+505': [8, 8],    // Nicaragua
    '+227': [8, 8],    // Niger
    '+234': [10, 10],  // Nigeria
    '+850': [8, 10],   // North Korea
    '+389': [8, 8],    // North Macedonia
    '+47': [8, 8],     // Norway
    '+968': [8, 8],    // Oman
    '+92': [10, 10],   // Pakistan
    '+970': [9, 9],    // Palestine
    '+507': [7, 8],    // Panama
    '+675': [8, 8],    // Papua New Guinea
    '+595': [9, 9],    // Paraguay
    '+51': [9, 9],     // Peru
    '+63': [10, 10],   // Philippines
    '+48': [9, 9],     // Poland
    '+351': [9, 9],    // Portugal
    '+1787': [7, 7],   // Puerto Rico
    '+974': [8, 8],    // Qatar
    '+40': [9, 9],     // Romania
    '+250': [9, 9],    // Rwanda
    '+1869': [7, 7],   // Saint Kitts & Nevis
    '+1758': [7, 7],   // Saint Lucia
    '+685': [5, 7],    // Samoa
    '+378': [8, 10],   // San Marino
    '+239': [7, 7],    // São Tomé & Príncipe
    '+966': [9, 9],    // Saudi Arabia
    '+221': [9, 9],    // Senegal
    '+381': [8, 9],    // Serbia
    '+248': [7, 7],    // Seychelles
    '+232': [8, 8],    // Sierra Leone
    '+65': [8, 8],     // Singapore
    '+421': [9, 9],    // Slovakia
    '+386': [8, 8],    // Slovenia
    '+677': [7, 7],    // Solomon Islands
    '+252': [7, 8],    // Somalia
    '+27': [9, 9],     // South Africa
    '+82': [9, 10],    // South Korea
    '+211': [9, 9],    // South Sudan
    '+34': [9, 9],     // Spain
    '+94': [9, 9],     // Sri Lanka
    '+249': [9, 9],    // Sudan
    '+597': [7, 7],    // Suriname
    '+46': [9, 9],     // Sweden
    '+41': [9, 9],     // Switzerland
    '+963': [9, 9],    // Syria
    '+886': [9, 9],    // Taiwan
    '+992': [9, 9],    // Tajikistan
    '+255': [9, 9],    // Tanzania
    '+66': [9, 9],     // Thailand
    '+228': [8, 8],    // Togo
    '+676': [5, 7],    // Tonga
    '+1868': [7, 7],   // Trinidad & Tobago
    '+216': [8, 8],    // Tunisia
    '+90': [10, 10],   // Turkey
    '+993': [8, 8],    // Turkmenistan
    '+688': [5, 6],    // Tuvalu
    '+256': [9, 9],    // Uganda
    '+380': [9, 9],    // Ukraine
    '+971': [9, 9],    // UAE
    '+44': [10, 10],   // United Kingdom
    '+598': [8, 8],    // Uruguay
    '+998': [9, 9],    // Uzbekistan
    '+678': [5, 7],    // Vanuatu
    '+379': [8, 10],   // Vatican City
    '+58': [10, 10],   // Venezuela
    '+84': [9, 10],    // Vietnam
    '+967': [9, 9],    // Yemen
    '+260': [9, 9],    // Zambia
    '+263': [9, 9],    // Zimbabwe
  };

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  late AnimationController _entryController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  // Staggered animations
  late Animation<double> _logoFade; // ignore: unused_field
  late Animation<Offset> _logoSlide; // ignore: unused_field
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _formFade;
  late Animation<Offset> _formSlide;
  late Animation<double> _btnFade;
  late Animation<Offset> _btnSlide;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _logoFade = _fade(0.0, 0.3);
    _logoSlide = _slide(0.0, 0.3, const Offset(0, -0.3));
    _titleFade = _fade(0.15, 0.45);
    _titleSlide = _slide(0.15, 0.45, const Offset(0, 0.2));
    _formFade = _fade(0.3, 0.7);
    _formSlide = _slide(0.3, 0.7, const Offset(0, 0.15));
    _btnFade = _fade(0.55, 1.0);
    _btnSlide = _slide(0.55, 1.0, const Offset(0, 0.15));

    _passwordController.addListener(_calcPasswordStrength);
    _entryController.forward();
  }

  Animation<double> _fade(double start, double end) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );
  }

  Animation<Offset> _slide(double start, double end, Offset begin) {
    return Tween<Offset>(begin: begin, end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ),
    );
  }

  void _calcPasswordStrength() {
    final pwd = _passwordController.text;
    int s = 0;
    if (pwd.length >= 6) s++;
    if (pwd.length >= 10) s++;
    if (RegExp(r'[A-Z]').hasMatch(pwd)) s++;
    if (RegExp(r'[0-9]').hasMatch(pwd)) s++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(pwd)) s++;
    setState(() => _passwordStrength = s.clamp(0, 4));
  }

  Color _strengthColor() {
    switch (_passwordStrength) {
      case 0:
        return Colors.white.withValues(alpha: 0.1);
      case 1:
        return const Color(0xFFFF6B6B);
      case 2:
        return const Color(0xFFFFB347);
      case 3:
        return const Color(0xFFFCA91C);
      default:
        return const Color(0xFF4ADE80);
    }
  }

  String _strengthLabel() {
    switch (_passwordStrength) {
      case 0:
        return '';
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      default:
        return 'Strong';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    _entryController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  /// Returns the expected digit range [min, max] for the selected country code.
  List<int> _expectedDigitRange() {
    return _phoneDigitLengths[_selectedCountryCode] ?? [6, 15];
  }

  /// Checks if a phone number already exists in the `utilisateurs` table.
  Future<bool> _checkPhoneExists(String fullPhone) async {
    try {
      final result = await Supabase.instance.client
          .from('utilisateurs')
          .select('id')
          .eq('num_de_telephone', fullPhone)
          .maybeSingle();
      return result != null;
    } catch (_) {
      // If the check fails (e.g. network), allow signup to proceed
      // — the server will catch duplicates if needed
      return false;
    }
  }

  void _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeTerms) {
      showAuthErrorSnackBar(
        context,
        'Please agree to the Terms & Privacy Policy',
        AuthErrorType.unknown,
      );
      return;
    }

    setState(() => _isLoading = true);

    // Combine country code + phone number digits
    final fullPhone = '$_selectedCountryCode${_phoneController.text.trim()}';

    // Check if phone number is already registered
    final phoneExists = await _checkPhoneExists(fullPhone);
    if (phoneExists && mounted) {
      setState(() => _isLoading = false);
      showAuthErrorSnackBar(
        context,
        'This phone number is already registered. Try signing in instead.',
        AuthErrorType.emailAlreadyRegistered,
      );
      return;
    }

    final success = await ref
        .read(authProvider.notifier)
        .signup(
          nom: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          numDeTelephone: fullPhone,
        );

    if (mounted) {
      if (success) {
        setState(() => _signupSuccess = true);
        // Transition to email confirmation happens in onFlyAwayComplete
      } else {
        setState(() => _isLoading = false);
        final authState = ref.read(authProvider);
        showAuthErrorSnackBar(
          context,
          authState.errorMessage ?? 'Signup failed',
          authState.errorType,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Stack(
        children: [
          // Background orbs — ISOLATED pulse
          Positioned(
            top: -100,
            left: -80,
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _pulseAnim,
                builder: (context, _) => _orb(280, _pulseAnim.value * 0.10),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -60,
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _pulseAnim,
                builder: (context, _) => _orb(220, _pulseAnim.value * 0.07),
              ),
            ),
          ),

          // Content — only rebuilds during entry animation
          AnimatedBuilder(
            animation: _entryController,
            builder: (context, _) {
              return SafeArea(
                child: Column(
                  children: [
                    // Back button row
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        top: 8,
                        right: 20,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => context.pop(),
                            icon: const Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const Spacer(),
                          Image.asset(
                            'assets/images/branding/icon_orange.png',
                            height: 40,
                            width: 40,
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: _signupComplete
                            ? _buildEmailConfirmationView()
                            : _buildSignupForm(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmailConfirmationView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 60),

        // Success icon with glow
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF4ADE80).withValues(alpha: 0.12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4ADE80).withValues(alpha: 0.2),
                blurRadius: 40,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(
            Icons.mark_email_read_rounded,
            color: Color(0xFF4ADE80),
            size: 44,
          ),
        ),

        const SizedBox(height: 36),

        const Text(
          'Check your email',
          style: TextStyle(
            fontFamily: 'DarkerGrotesque',
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w800,
            height: 1.1,
            letterSpacing: -0.5,
          ),
        ),

        const SizedBox(height: 14),

        Text(
          'We\'ve sent a confirmation link to',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'DarkerGrotesque',
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          _emailController.text.trim(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'DarkerGrotesque',
            color: Color(0xFFFCA91C),
            fontSize: 17,
            fontWeight: FontWeight.w700,
            height: 1.3,
          ),
        ),

        const SizedBox(height: 14),

        Text(
          'Please confirm your email address to activate\nyour account and start exploring Morocco.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'DarkerGrotesque',
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 40),

        // Back to Sign In button
        KurgateButton(
          label: 'Back to Sign In',
          trailingIcon: Icons.arrow_forward_rounded,
          onPressed: () => context.go('/login'),
        ),

        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSignupForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        // Title
        FadeTransition(
          opacity: _titleFade,
          child: SlideTransition(
            position: _titleSlide,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create your',
                  style: TextStyle(
                    fontFamily: 'DarkerGrotesque',
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: [Color(0xFFFF8C00), Color(0xFFFCA91C)],
                    ).createShader(bounds);
                  },
                  child: const Text(
                    'account.',
                    style: TextStyle(
                      fontFamily: 'DarkerGrotesque',
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Start exploring Morocco today',
                  style: TextStyle(
                    fontFamily: 'DarkerGrotesque',
                    color: Colors.white.withValues(alpha: 0.45),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Form
        FadeTransition(
          opacity: _formFade,
          child: SlideTransition(
            position: _formSlide,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Full name
                  _field(
                    controller: _nameController,
                    focus: _nameFocus,
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    icon: Icons.person_outline_rounded,
                    action: TextInputAction.next,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onSubmit: (_) => _emailFocus.requestFocus(),
                  ),
                  const SizedBox(height: 16),

                  // Email
                  _field(
                    controller: _emailController,
                    focus: _emailFocus,
                    label: 'Email',
                    hint: 'Enter your email address',
                    icon: Icons.email_outlined,
                    keyboard: TextInputType.emailAddress,
                    action: TextInputAction.next,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(v)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSubmit: (_) => _phoneFocus.requestFocus(),
                  ),
                  const SizedBox(height: 16),

                  // Phone number with region code
                  _phoneField(),
                  const SizedBox(height: 16),

                  // Password
                  _field(
                    controller: _passwordController,
                    focus: _passwordFocus,
                    label: 'Password',
                    hint: 'Create a password',
                    icon: Icons.lock_outline_rounded,
                    isPassword: true,
                    obscure: _obscurePassword,
                    action: TextInputAction.next,
                    onToggle: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (v.length < 6) {
                        return 'At least 6 characters';
                      }
                      return null;
                    },
                    onSubmit: (_) => _confirmFocus.requestFocus(),
                  ),

                  // Password strength bar
                  if (_passwordController.text.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ...List.generate(4, (i) {
                          return Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: 3,
                              margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: i < _passwordStrength
                                    ? _strengthColor()
                                    : Colors.white.withValues(alpha: 0.08),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(width: 12),
                        Text(
                          _strengthLabel(),
                          style: TextStyle(
                            fontFamily: 'DarkerGrotesque',
                            color: _strengthColor(),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Confirm password
                  _field(
                    controller: _confirmController,
                    focus: _confirmFocus,
                    label: 'Confirm Password',
                    hint: 'Confirm your password',
                    icon: Icons.lock_outline_rounded,
                    isPassword: true,
                    obscure: _obscureConfirm,
                    action: TextInputAction.done,
                    onToggle: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (v != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    onSubmit: (_) => _handleSignup(),
                  ),

                  const SizedBox(height: 20),

                  // Terms checkbox
                  GestureDetector(
                    onTap: () => setState(() => _agreeTerms = !_agreeTerms),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 20,
                          height: 20,
                          margin: const EdgeInsets.only(top: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: _agreeTerms
                                ? const Color(0xFFFF8C00)
                                : Colors.transparent,
                            border: Border.all(
                              color: _agreeTerms
                                  ? const Color(0xFFFF8C00)
                                  : Colors.white.withValues(alpha: 0.25),
                              width: 1.5,
                            ),
                          ),
                          child: _agreeTerms
                              ? const Icon(
                                  Icons.check_rounded,
                                  size: 14,
                                  color: Colors.black,
                                )
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: 'DarkerGrotesque',
                                color: Colors.white.withValues(alpha: 0.45),
                                fontSize: 13,
                                height: 1.4,
                              ),
                              children: const [
                                TextSpan(text: 'I agree to the '),
                                TextSpan(
                                  text: 'Terms of Service',
                                  style: TextStyle(
                                    color: Color(0xFFFF8C00),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    color: Color(0xFFFF8C00),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 28),

        // Create Account button
        FadeTransition(
          opacity: _btnFade,
          child: SlideTransition(
            position: _btnSlide,
            child: Column(
              children: [
                KurgateButton(
                  label: 'Create Account',
                  trailingIcon: Icons.arrow_forward_rounded,
                  isLoading: _isLoading,
                  isSuccess: _signupSuccess,
                  onPressed: _isLoading ? null : _handleSignup,
                  onSuccessAnimComplete: () {
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                        _signupSuccess = false;
                        _signupComplete = true;
                      });
                    }
                  },
                ),
                const SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          color: Colors.white.withValues(alpha: 0.45),
                          fontSize: 15,
                        ),
                        children: const [
                          TextSpan(text: 'Already have an account? '),
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                              color: Color(0xFFFF8C00),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _orb(double size, double alpha) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            const Color(0xFFFF8C00).withValues(alpha: alpha),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required FocusNode focus,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    TextInputAction action = TextInputAction.next,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggle,
    String? Function(String?)? validator,
    void Function(String)? onSubmit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'DarkerGrotesque',
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: TextFormField(
            controller: controller,
            focusNode: focus,
            keyboardType: keyboard,
            textInputAction: action,
            obscureText: isPassword ? obscure : false,
            validator: validator,
            onFieldSubmitted: onSubmit,
            style: const TextStyle(
              fontFamily: 'DarkerGrotesque',
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            cursorColor: const Color(0xFFFF8C00),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontFamily: 'DarkerGrotesque',
                color: Colors.white.withValues(alpha: 0.2),
                fontSize: 15,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16, right: 12),
                child: Icon(
                  icon,
                  color: Colors.white.withValues(alpha: 0.35),
                  size: 22,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 50),
              suffixIcon: isPassword
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: IconButton(
                        icon: Icon(
                          obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.white.withValues(alpha: 0.35),
                          size: 22,
                        ),
                        onPressed: onToggle,
                      ),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 17,
              ),
              errorStyle: const TextStyle(
                fontFamily: 'DarkerGrotesque',
                color: Color(0xFFFF6B6B),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Phone number field with country code dropdown prefix
  Widget _phoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Phone Number',
            style: TextStyle(
              fontFamily: 'DarkerGrotesque',
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Row(
            children: [
              // Country code dropdown
              GestureDetector(
                onTap: _showCountryCodePicker,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _countryCodes.firstWhere(
                          (c) => c['code'] == _selectedCountryCode,
                        )['flag']!,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _selectedCountryCode,
                        style: TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white.withValues(alpha: 0.35),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              // Phone number input
              Expanded(
                child: TextFormField(
                  controller: _phoneController,
                  focusNode: _phoneFocus,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    // Strip spaces/dashes the user may have typed
                    final digits = v.replaceAll(RegExp(r'[^0-9]'), '');
                    if (digits.isEmpty) {
                      return 'Phone number must contain digits';
                    }
                    final range = _expectedDigitRange();
                    final min = range[0];
                    final max = range[1];
                    if (digits.length < min || digits.length > max) {
                      if (min == max) {
                        return 'Expected $min digits for this country';
                      }
                      return 'Expected $min–$max digits for this country';
                    }
                    return null;
                  },
                  style: const TextStyle(
                    fontFamily: 'DarkerGrotesque',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  cursorColor: const Color(0xFFFF8C00),
                  decoration: InputDecoration(
                    hintText: 'Phone number',
                    hintStyle: TextStyle(
                      fontFamily: 'DarkerGrotesque',
                      color: Colors.white.withValues(alpha: 0.2),
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 17,
                    ),
                    errorStyle: const TextStyle(
                      fontFamily: 'DarkerGrotesque',
                      color: Color(0xFFFF6B6B),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Shows a bottom sheet picker for country codes
  void _showCountryCodePicker() {
    final searchController = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF222222),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final query = searchController.text.toLowerCase();
            final filtered = _countryCodes.where((c) {
              return c['name']!.toLowerCase().contains(query) ||
                  c['code']!.contains(query);
            }).toList();

            return DraggableScrollableSheet(
              initialChildSize: 0.55,
              minChildSize: 0.3,
              maxChildSize: 0.85,
              expand: false,
              builder: (_, scrollController) {
                return Column(
                  children: [
                    // Handle bar
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    // Title
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Text(
                        'Select Country Code',
                        style: TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    // Search bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: TextField(
                          controller: searchController,
                          onChanged: (_) => setModalState(() {}),
                          style: const TextStyle(
                            fontFamily: 'DarkerGrotesque',
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          cursorColor: const Color(0xFFFF8C00),
                          decoration: InputDecoration(
                            hintText: 'Search country...',
                            hintStyle: TextStyle(
                              fontFamily: 'DarkerGrotesque',
                              color: Colors.white.withValues(alpha: 0.25),
                              fontSize: 15,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: Colors.white.withValues(alpha: 0.3),
                              size: 20,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Country list
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final country = filtered[i];
                          final isSelected =
                              country['code'] == _selectedCountryCode;
                          return ListTile(
                            onTap: () {
                              setState(
                                () => _selectedCountryCode = country['code']!,
                              );
                              Navigator.pop(ctx);
                            },
                            leading: Text(
                              country['flag']!,
                              style: const TextStyle(fontSize: 24),
                            ),
                            title: Text(
                              country['name']!,
                              style: TextStyle(
                                fontFamily: 'DarkerGrotesque',
                                color: isSelected
                                    ? const Color(0xFFFF8C00)
                                    : Colors.white.withValues(alpha: 0.8),
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                            trailing: Text(
                              country['code']!,
                              style: TextStyle(
                                fontFamily: 'DarkerGrotesque',
                                color: isSelected
                                    ? const Color(0xFFFF8C00)
                                    : Colors.white.withValues(alpha: 0.4),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            tileColor: isSelected
                                ? const Color(0xFFFF8C00)
                                    .withValues(alpha: 0.08)
                                : null,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
