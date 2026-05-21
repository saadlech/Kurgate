import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_error_snackbar.dart';
import '../widgets/kurgate_button.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();

  late AnimationController _entryController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _formFade;
  late Animation<Offset> _formSlide;
  late Animation<double> _btnFade;
  late Animation<Offset> _btnSlide;

  bool _isLoading = false;
  bool _saveSuccess = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _headerFade = _fade(0.0, 0.35);
    _headerSlide = _slide(0.0, 0.35, const Offset(0, -0.2));
    _formFade = _fade(0.2, 0.6);
    _formSlide = _slide(0.2, 0.6, const Offset(0, 0.15));
    _btnFade = _fade(0.45, 0.85);
    _btnSlide = _slide(0.45, 0.85, const Offset(0, 0.15));

    // Pre-fill fields with current user data
    final user = ref.read(authProvider).currentUser;
    if (user != null) {
      _nameController.text = user.nom;
      _emailController.text = user.email;
      if (user.numDeTelephone.isNotEmpty) {
        _phoneController.text = user.numDeTelephone;
      }
    }

    _nameController.addListener(_checkChanges);
    _emailController.addListener(_checkChanges);
    _phoneController.addListener(_checkChanges);

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

  void _checkChanges() {
    final user = ref.read(authProvider).currentUser;
    if (user == null) return;

    final changed = _nameController.text.trim() != user.nom ||
        _emailController.text.trim() != user.email ||
        _phoneController.text.trim() != user.numDeTelephone;

    if (changed != _hasChanges) {
      setState(() => _hasChanges = changed);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _entryController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_hasChanges) return;

    setState(() => _isLoading = true);

    final user = ref.read(authProvider).currentUser!;
    final newName = _nameController.text.trim();
    final newEmail = _emailController.text.trim();
    final newPhone = _phoneController.text.trim();

    final success = await ref.read(authProvider.notifier).updateProfile(
          nom: newName != user.nom ? newName : null,
          email: newEmail != user.email ? newEmail : null,
          numDeTelephone: newPhone != user.numDeTelephone ? newPhone : null,
        );

    if (mounted) {
      if (success) {
        setState(() => _saveSuccess = true);
      } else {
        setState(() => _isLoading = false);
        final authState = ref.read(authProvider);
        showAuthErrorSnackBar(
          context,
          authState.errorMessage ?? 'Update failed',
          authState.errorType,
        );
      }
    }
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        padding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF4ADE80).withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4ADE80).withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF4ADE80).withValues(alpha: 0.12),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF4ADE80),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Profile updated successfully!',
                  style: TextStyle(
                    fontFamily: 'DarkerGrotesque',
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Stack(
        children: [
          // Background orbs
          Positioned(
            top: -100,
            right: -60,
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _pulseAnim,
                builder: (context, _) => _orb(260, _pulseAnim.value * 0.10),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _pulseAnim,
                builder: (context, _) => _orb(200, _pulseAnim.value * 0.07),
              ),
            ),
          ),

          // Content
          AnimatedBuilder(
            animation: _entryController,
            builder: (context, _) {
              return SafeArea(
                child: Column(
                  children: [
                    // App bar
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
                          FadeTransition(
                            opacity: _headerFade,
                            child: const Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontFamily: 'DarkerGrotesque',
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(width: 48), // Balance back button
                        ],
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),

                            // Avatar
                            FadeTransition(
                              opacity: _headerFade,
                              child: SlideTransition(
                                position: _headerSlide,
                                child: _buildAvatar(),
                              ),
                            ),

                            const SizedBox(height: 36),

                            // Form
                            FadeTransition(
                              opacity: _formFade,
                              child: SlideTransition(
                                position: _formSlide,
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      _field(
                                        controller: _nameController,
                                        focus: _nameFocus,
                                        label: 'Full Name',
                                        hint: 'Enter your full name',
                                        icon: Icons.person_outline_rounded,
                                        action: TextInputAction.next,
                                        validator: (v) {
                                          if (v == null || v.trim().isEmpty) {
                                            return 'Name is required';
                                          }
                                          return null;
                                        },
                                        onSubmit: (_) =>
                                            _emailFocus.requestFocus(),
                                      ),
                                      const SizedBox(height: 16),

                                      _field(
                                        controller: _emailController,
                                        focus: _emailFocus,
                                        label: 'Email',
                                        hint: 'Enter your email address',
                                        icon: Icons.email_outlined,
                                        keyboard: TextInputType.emailAddress,
                                        action: TextInputAction.next,
                                        validator: (v) {
                                          if (v == null || v.trim().isEmpty) {
                                            return 'Email is required';
                                          }
                                          if (!RegExp(
                                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                          ).hasMatch(v)) {
                                            return 'Enter a valid email';
                                          }
                                          return null;
                                        },
                                        onSubmit: (_) =>
                                            _phoneFocus.requestFocus(),
                                      ),
                                      const SizedBox(height: 16),

                                      _field(
                                        controller: _phoneController,
                                        focus: _phoneFocus,
                                        label: 'Phone Number',
                                        hint: 'Enter your phone number',
                                        icon: Icons.phone_outlined,
                                        keyboard: TextInputType.phone,
                                        action: TextInputAction.done,
                                        validator: (v) {
                                          if (v == null || v.trim().isEmpty) {
                                            return 'Phone number is required';
                                          }
                                          if (!RegExp(r'^\+?[0-9]{6,15}$')
                                              .hasMatch(v.trim())) {
                                            return 'Enter a valid phone number';
                                          }
                                          return null;
                                        },
                                        onSubmit: (_) => _handleSave(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Change hint
                            FadeTransition(
                              opacity: _formFade,
                              child: AnimatedOpacity(
                                opacity: _hasChanges ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 300),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFCA91C)
                                        .withValues(alpha: 0.06),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFFCA91C)
                                          .withValues(alpha: 0.12),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline_rounded,
                                        color: const Color(0xFFFCA91C)
                                            .withValues(alpha: 0.7),
                                        size: 18,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'You have unsaved changes',
                                        style: TextStyle(
                                          fontFamily: 'DarkerGrotesque',
                                          color: const Color(0xFFFCA91C)
                                              .withValues(alpha: 0.8),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Save button
                            FadeTransition(
                              opacity: _btnFade,
                              child: SlideTransition(
                                position: _btnSlide,
                                child: KurgateButton(
                                  label: 'Save Changes',
                                  trailingIcon: Icons.check_rounded,
                                  isLoading: _isLoading,
                                  isSuccess: _saveSuccess,
                                  onPressed: (_isLoading || !_hasChanges)
                                      ? null
                                      : _handleSave,
                                  onSuccessAnimComplete: () {
                                    if (mounted) {
                                      setState(() {
                                        _isLoading = false;
                                        _saveSuccess = false;
                                        _hasChanges = false;
                                      });
                                      _showSuccessSnackBar();
                                      context.pop();
                                    }
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 40),
                          ],
                        ),
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

  Widget _buildAvatar() {
    final user = ref.watch(authProvider).currentUser;
    final initials = _initials(user?.nom ?? 'U');

    return Center(
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFFF8C00), Color(0xFFE77728)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF8C00).withValues(alpha: 0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  fontFamily: 'DarkerGrotesque',
                  color: Colors.black,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            user?.nom ?? 'User',
            style: const TextStyle(
              fontFamily: 'DarkerGrotesque',
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap a field below to edit',
            style: TextStyle(
              fontFamily: 'DarkerGrotesque',
              color: Colors.white.withValues(alpha: 0.35),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
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
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: TextFormField(
            controller: controller,
            focusNode: focus,
            keyboardType: keyboard,
            textInputAction: action,
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
}
