import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
  late Animation<double> _logoFade;
  late Animation<Offset> _logoSlide;
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

    final success = await ref.read(authProvider.notifier).signup(
      nom: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      numDeTelephone: int.tryParse(_phoneController.text.trim()) ?? 0,
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
                            'assets/images/icon_orange.png',
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
                      colors: [
                        Color(0xFFFF8C00),
                        Color(0xFFFCA91C),
                      ],
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

                  // Phone number
                  _field(
                    controller: _phoneController,
                    focus: _phoneFocus,
                    label: 'Phone Number',
                    hint: 'Enter your phone number',
                    icon: Icons.phone_outlined,
                    keyboard: TextInputType.phone,
                    action: TextInputAction.next,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (!RegExp(r'^[0-9]{10}$').hasMatch(v)) {
                        return 'Please enter a valid 10-digit phone number';
                      }
                      return null;
                    },
                    onSubmit: (_) => _passwordFocus.requestFocus(),
                  ),
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
                    onToggle: () => setState(
                      () => _obscurePassword = !_obscurePassword,
                    ),
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
                              margin: EdgeInsets.only(
                                right: i < 3 ? 6 : 0,
                              ),
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
                    onToggle: () => setState(
                      () => _obscureConfirm = !_obscureConfirm,
                    ),
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
                    onTap: () => setState(
                      () => _agreeTerms = !_agreeTerms,
                    ),
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
}
