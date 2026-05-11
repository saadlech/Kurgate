import 'package:flutter/material.dart';

class FeedbackSheet extends StatefulWidget {
  final String bookingName;
  final String bookingType;
  final void Function(int rating, String comment) onSubmit;

  const FeedbackSheet({
    super.key,
    required this.bookingName,
    required this.bookingType,
    required this.onSubmit,
  });

  @override
  State<FeedbackSheet> createState() => _FeedbackSheetState();
}

class _FeedbackSheetState extends State<FeedbackSheet>
    with SingleTickerProviderStateMixin {
  int _rating = 0;
  final _commentController = TextEditingController();
  bool _submitted = false;
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _commentController.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_rating == 0) return;
    widget.onSubmit(_rating, _commentController.text.trim());
    setState(() => _submitted = true);
    _animCtrl.forward();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          12,
          24,
          MediaQuery.of(context).viewInsets.bottom + 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),

            if (_submitted) ...[
              // Success state
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF2ECC71).withValues(alpha: 0.15),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Color(0xFF2ECC71),
                    size: 44,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Merci pour votre avis !',
                style: TextStyle(
                  fontFamily: 'DarkerGrotesque',
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Votre retour nous aide à améliorer nos services',
                style: TextStyle(
                  fontFamily: 'DarkerGrotesque',
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ] else ...[
              // Title
              const Text(
                'Donner un avis',
                style: TextStyle(
                  fontFamily: 'DarkerGrotesque',
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${widget.bookingType} · ${widget.bookingName}',
                style: TextStyle(
                  fontFamily: 'DarkerGrotesque',
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Star rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final starIndex = i + 1;
                  final active = starIndex <= _rating;
                  return GestureDetector(
                    onTap: () => setState(() => _rating = starIndex),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(
                        active
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: active
                            ? const Color(0xFFFF8C00)
                            : Colors.white.withValues(alpha: 0.2),
                        size: 44,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  _ratingLabel,
                  key: ValueKey(_rating),
                  style: TextStyle(
                    fontFamily: 'DarkerGrotesque',
                    color: _rating > 0
                        ? const Color(0xFFFF8C00)
                        : Colors.white.withValues(alpha: 0.3),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Comment field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: TextField(
                  controller: _commentController,
                  maxLines: 3,
                  style: const TextStyle(
                    fontFamily: 'DarkerGrotesque',
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Partagez votre expérience (optionnel)...',
                    hintStyle: TextStyle(
                      fontFamily: 'DarkerGrotesque',
                      color: Colors.white.withValues(alpha: 0.2),
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _rating > 0 ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _rating > 0
                        ? const Color(0xFFFF8C00)
                        : Colors.white.withValues(alpha: 0.06),
                    foregroundColor: Colors.black,
                    disabledBackgroundColor:
                        Colors.white.withValues(alpha: 0.06),
                    disabledForegroundColor:
                        Colors.white.withValues(alpha: 0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _rating > 0
                        ? 'Envoyer mon avis ($_rating/5)'
                        : 'Sélectionnez une note',
                    style: const TextStyle(
                      fontFamily: 'DarkerGrotesque',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String get _ratingLabel {
    switch (_rating) {
      case 1:
        return 'Décevant';
      case 2:
        return 'Passable';
      case 3:
        return 'Correct';
      case 4:
        return 'Très bien';
      case 5:
        return 'Exceptionnel !';
      default:
        return 'Touchez pour noter';
    }
  }
}
