import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/booking_provider.dart';
import '../providers/review_provider.dart';
import '../providers/auth_provider.dart';
import '../models/avis.dart';
import '../widgets/feedback_sheet.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final String bookingId;
  const PaymentScreen({super.key, required this.bookingId});
  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen>
    with TickerProviderStateMixin {
  final _cardNumberCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  bool _processing = false;
  bool _success = false;
  late AnimationController _pulseCtrl;
  late AnimationController _successCtrl;
  late Animation<double> _successScale;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _successCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _successScale = CurvedAnimation(
      parent: _successCtrl,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _cardNumberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _nameCtrl.dispose();
    _pulseCtrl.dispose();
    _successCtrl.dispose();
    super.dispose();
  }

  bool get _formValid =>
      _cardNumberCtrl.text.replaceAll(' ', '').length == 16 &&
      _expiryCtrl.text.length == 5 &&
      _isExpiryValid &&
      _cvvCtrl.text.length == 3 &&
      _nameCtrl.text.trim().isNotEmpty;

  /// Returns true if the expiry MM/YY is a real month and not in the past.
  bool get _isExpiryValid {
    final raw = _expiryCtrl.text;
    if (raw.length != 5 || !raw.contains('/')) return false;
    final parts = raw.split('/');
    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);
    if (month == null || year == null) return false;
    if (month < 1 || month > 12) return false;
    // Convert YY to full year
    final fullYear = 2000 + year;
    final now = DateTime.now();
    // Card is valid through the last day of the expiry month
    if (fullYear < now.year) return false;
    if (fullYear == now.year && month < now.month) return false;
    return true;
  }

  /// User-facing error message for the expiry field.
  String? get _expiryError {
    final raw = _expiryCtrl.text;
    if (raw.isEmpty) return null;
    if (raw.length < 5) return null; // still typing
    if (!raw.contains('/')) return 'Format MM/AA';
    final parts = raw.split('/');
    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);
    if (month == null || year == null) return 'Format invalide';
    if (month < 1 || month > 12) return 'Mois invalide';
    final fullYear = 2000 + year;
    final now = DateTime.now();
    if (fullYear < now.year || (fullYear == now.year && month < now.month)) {
      return 'Carte expirée';
    }
    return null;
  }

  /// Detect card brand from the first digit.
  /// 4 → Visa, 2 or 5 → Mastercard
  String? _detectCardBrand(String cardNumber) {
    final digits = cardNumber.replaceAll(' ', '');
    if (digits.isEmpty) return null;
    final first = digits[0];
    if (first == '4') return 'visa';
    if (first == '2' || first == '5') return 'mastercard';
    return null;
  }

  void _processPayment() {
    if (!_formValid || _processing) return;
    setState(() => _processing = true);

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      ref.read(bookingProvider.notifier).markAsPaid(widget.bookingId);
      setState(() {
        _processing = false;
        _success = true;
      });
      _successCtrl.forward();

      // Auto-show feedback after a short delay
      Future.delayed(const Duration(milliseconds: 1800), () {
        if (!mounted) return;
        final booking = ref
            .read(bookingProvider.notifier)
            .getBookingById(widget.bookingId);
        if (booking != null) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => FeedbackSheet(
              bookingName: booking.nom,
              bookingType: booking.typeLabel,
              onSubmit: (rating, comment) {
                ref
                    .read(bookingProvider.notifier)
                    .addFeedback(widget.bookingId, rating, comment);
                // Also save to global reviews so all users can see it
                final user = ref.read(authProvider).currentUser;
                if (user != null && booking != null) {
                  ref
                      .read(reviewProvider.notifier)
                      .addReview(
                        Avis(
                          idAvis: '${booking.itemId}_${user.id}',
                          itemId: booking.itemId,
                          userId: user.id,
                          userName: user.nom,
                          note: rating,
                          commentaire: comment,
                          datePublication: DateTime.now(),
                        ),
                      );
                }
              },
            ),
          ).then((_) {
            if (mounted) context.pop();
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final booking = ref
        .watch(bookingProvider)
        .where((b) => b.idReservation == widget.bookingId);
    if (booking.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        body: Center(
          child: Text(
            'Réservation introuvable',
            style: TextStyle(
              fontFamily: 'DarkerGrotesque',
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 16,
            ),
          ),
        ),
      );
    }
    final b = booking.first;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Paiement',
          style: TextStyle(
            fontFamily: 'DarkerGrotesque',
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: _success
          ? _buildSuccessState(b)
          : _processing
          ? _buildProcessingState()
          : _buildPaymentForm(b),
    );
  }

  // ─── SUCCESS ─────────────────────────────────────────
  Widget _buildSuccessState(Reservation b) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _successScale,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF2ECC71).withValues(alpha: 0.15),
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Color(0xFF2ECC71),
                size: 56,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Paiement réussi !',
            style: TextStyle(
              fontFamily: 'DarkerGrotesque',
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${b.nom} · \$${b.prixTotal}',
            style: TextStyle(
              fontFamily: 'DarkerGrotesque',
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Préparation de votre avis...',
            style: TextStyle(
              fontFamily: 'DarkerGrotesque',
              color: const Color(0xFFFF8C00).withValues(alpha: 0.6),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ─── PROCESSING ──────────────────────────────────────
  Widget _buildProcessingState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _pulseCtrl,
            builder: (context, child) => Transform.scale(
              scale: 0.9 + _pulseCtrl.value * 0.15,
              child: child,
            ),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF8C00).withValues(alpha: 0.12),
                border: Border.all(
                  color: const Color(0xFFFF8C00).withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.credit_card_rounded,
                color: Color(0xFFFF8C00),
                size: 44,
              ),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Traitement en cours...',
            style: TextStyle(
              fontFamily: 'DarkerGrotesque',
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Veuillez patienter',
            style: TextStyle(
              fontFamily: 'DarkerGrotesque',
              color: Colors.white.withValues(alpha: 0.3),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 180,
            child: LinearProgressIndicator(
              backgroundColor: Colors.white.withValues(alpha: 0.06),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFFF8C00),
              ),
              minHeight: 3,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  // ─── FORM ────────────────────────────────────────────
  Widget _buildPaymentForm(Reservation b) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order summary card
          _buildOrderSummary(b),
          const SizedBox(height: 28),

          // Card section title
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8C00).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.credit_card_rounded,
                  color: Color(0xFFFF8C00),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Informations de paiement',
                style: TextStyle(
                  fontFamily: 'DarkerGrotesque',
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Card number + brand detection
          AnimatedBuilder(
            animation: _cardNumberCtrl,
            builder: (context, _) {
              final brand = _detectCardBrand(_cardNumberCtrl.text);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Numéro de carte',
                        style: TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      // Brand badge
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        switchInCurve: Curves.easeOutCubic,
                        transitionBuilder: (child, anim) => FadeTransition(
                          opacity: anim,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.3, 0),
                              end: Offset.zero,
                            ).animate(anim),
                            child: child,
                          ),
                        ),
                        child: brand != null
                            ? Container(
                                key: ValueKey(brand),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: brand == 'visa'
                                      ? const Color(
                                          0xFF1A1F71,
                                        ).withValues(alpha: 0.25)
                                      : const Color(
                                          0xFFEB001B,
                                        ).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: brand == 'visa'
                                        ? const Color(
                                            0xFF1A1F71,
                                          ).withValues(alpha: 0.4)
                                        : const Color(
                                            0xFFEB001B,
                                          ).withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (brand == 'visa') ...[
                                      const Text(
                                        'VISA',
                                        style: TextStyle(
                                          fontFamily: 'DarkerGrotesque',
                                          color: Color(0xFF4A6CF7),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                    ] else ...[
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color(
                                            0xFFEB001B,
                                          ).withValues(alpha: 0.8),
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: const Offset(-4, 0),
                                        child: Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: const Color(
                                              0xFFF79E1B,
                                            ).withValues(alpha: 0.8),
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        'Mastercard',
                                        style: TextStyle(
                                          fontFamily: 'DarkerGrotesque',
                                          color: Color(0xFFF79E1B),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(key: ValueKey('none')),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: TextField(
                      controller: _cardNumberCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                        _CardNumberFormatter(),
                      ],
                      style: const TextStyle(
                        fontFamily: 'DarkerGrotesque',
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.credit_card_rounded,
                          size: 18,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        hintText: '0000 0000 0000 0000',
                        hintStyle: TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          color: Colors.white.withValues(alpha: 0.15),
                          fontSize: 16,
                          letterSpacing: 1.2,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),

          // Expiry + CVV row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildField(
                      label: 'Expiration',
                      hint: 'MM/AA',
                      controller: _expiryCtrl,
                      icon: Icons.calendar_today_rounded,
                      keyboardType: TextInputType.number,
                      formatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        _ExpiryFormatter(),
                      ],
                    ),
                    // Expiry error message
                    AnimatedBuilder(
                      animation: _expiryCtrl,
                      builder: (context, _) {
                        final err = _expiryError;
                        return AnimatedSize(
                          duration: const Duration(milliseconds: 200),
                          child: err != null
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                    top: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.error_outline_rounded,
                                        size: 12,
                                        color: Color(0xFFFF5252),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        err,
                                        style: const TextStyle(
                                          fontFamily: 'DarkerGrotesque',
                                          color: Color(0xFFFF5252),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildField(
                  label: 'CVV',
                  hint: '•••',
                  controller: _cvvCtrl,
                  icon: Icons.lock_rounded,
                  keyboardType: TextInputType.number,
                  obscure: true,
                  formatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Cardholder name
          _buildField(
            label: 'Nom du titulaire',
            hint: 'Prénom Nom',
            controller: _nameCtrl,
            icon: Icons.person_rounded,
            keyboardType: TextInputType.name,
            formatters: [LengthLimitingTextInputFormatter(40)],
          ),
          const SizedBox(height: 12),

          // Security note
          Row(
            children: [
              Icon(
                Icons.shield_rounded,
                size: 14,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              const SizedBox(width: 6),
              Text(
                'Paiement sécurisé — Vos données sont chiffrées',
                style: TextStyle(
                  fontFamily: 'DarkerGrotesque',
                  color: Colors.white.withValues(alpha: 0.2),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Pay button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _cardNumberCtrl,
                _expiryCtrl,
                _cvvCtrl,
                _nameCtrl,
              ]),
              builder: (context, _) {
                final valid = _formValid;
                return ElevatedButton(
                  onPressed: valid ? _processPayment : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: valid
                        ? const Color(0xFFFF8C00)
                        : Colors.white.withValues(alpha: 0.06),
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: Colors.white.withValues(
                      alpha: 0.06,
                    ),
                    disabledForegroundColor: Colors.white.withValues(
                      alpha: 0.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_rounded,
                        size: 18,
                        color: valid
                            ? Colors.black
                            : Colors.white.withValues(alpha: 0.2),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Payer \$${b.prixTotal}',
                        style: TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: valid
                              ? Colors.black
                              : Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Accepted cards
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _cardBrand('VISA'),
              const SizedBox(width: 12),
              _cardBrand('MC'),
              const SizedBox(width: 12),
              _cardBrand('AMEX'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(Reservation b) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 60,
              height: 60,
              child: Image.asset(
                b.imageUrl,
                fit: BoxFit.cover,
                cacheWidth: 120,
                cacheHeight: 120,
                gaplessPlayback: true,
                errorBuilder: (_, _, _) => Container(
                  color: const Color(0xFF2A2A2A),
                  child: Icon(
                    Icons.image_rounded,
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  b.nom,
                  style: const TextStyle(
                    fontFamily: 'DarkerGrotesque',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  b.typeLabel,
                  style: TextStyle(
                    fontFamily: 'DarkerGrotesque',
                    color: Colors.white.withValues(alpha: 0.35),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${b.prixTotal}',
            style: const TextStyle(
              fontFamily: 'DarkerGrotesque',
              color: Color(0xFFFF8C00),
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    List<TextInputFormatter> formatters = const [],
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'DarkerGrotesque',
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscure,
            inputFormatters: formatters,
            style: const TextStyle(
              fontFamily: 'DarkerGrotesque',
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                size: 18,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              hintText: hint,
              hintStyle: TextStyle(
                fontFamily: 'DarkerGrotesque',
                color: Colors.white.withValues(alpha: 0.15),
                fontSize: 16,
                letterSpacing: 1.2,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _cardBrand(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Text(
        name,
        style: TextStyle(
          fontFamily: 'DarkerGrotesque',
          color: Colors.white.withValues(alpha: 0.3),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ─── Input Formatters ──────────────────────────────────

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(text[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll('/', '');
    if (text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Validate & auto-correct month
    if (text.length >= 1) {
      final firstDigit = int.parse(text[0]);
      // If first digit > 1, it can't start a valid month → prefix with 0
      if (firstDigit > 1) {
        text = '0$text';
      }
    }
    if (text.length >= 2) {
      final month = int.parse(text.substring(0, 2));
      if (month == 0) {
        text = '01${text.substring(2)}';
      } else if (month > 12) {
        text = '12${text.substring(2)}';
      }
    }

    // Limit to 4 digits (MMYY)
    if (text.length > 4) text = text.substring(0, 4);

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(text[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
