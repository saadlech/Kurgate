import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_error_snackbar.dart';
import '../widgets/kurgate_button.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  bool _emailSent = false;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();

  late AnimationController _entryController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

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

    _pulseAnimation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _titleFade = _fade(0.0, 0.35);
    _titleSlide = _slide(0.0, 0.35, const Offset(0, 0.2));
    _formFade = _fade(0.2, 0.6);
    _formSlide = _slide(0.2, 0.6, const Offset(0, 0.15));
    _btnFade = _fade(0.4, 1.0);
    _btnSlide = _slide(0.4, 1.0, const Offset(0, 0.15));

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

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    _entryController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final success = await ref
        .read(authProvider.notifier)
        .resetPassword(email: _emailController.text.trim());

    if (mounted) {
      setState(() {
        _isLoading = false;
        _emailSent = success;
      });

      if (!success) {
        final authState = ref.read(authProvider);
        showAuthErrorSnackBar(
          context,
          authState.errorMessage ?? 'Failed to send reset email',
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
            top: -120,
            right: -80,
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, _) =>
                    _orb(300, _pulseAnimation.value * 0.12),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -60,
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, _) =>
                    _orb(250, _pulseAnimation.value * 0.08),
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
                        child: _emailSent
                            ? _buildSuccessView()
                            : _buildFormView(),
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

  Widget _buildSuccessView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 80),

        // Success icon
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
          'We\'ve sent a password reset link to\n${_emailController.text.trim()}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'DarkerGrotesque',
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 40),

        // Back to login button
        KurgateButton(
          label: 'Back to Sign In',
          trailingIcon: Icons.arrow_forward_rounded,
          onPressed: () => context.pop(),
        ),

        const SizedBox(height: 20),

        // Resend link
        Center(
          child: GestureDetector(
            onTap: _isLoading ? null : _handleResetPassword,
            child: Text(
              'Didn\'t receive it? Resend',
              style: TextStyle(
                fontFamily: 'DarkerGrotesque',
                color: const Color(0xFFFF8C00).withValues(alpha: 0.85),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),

        // Lock icon
        FadeTransition(
          opacity: _titleFade,
          child: SlideTransition(
            position: _titleSlide,
            child: Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFF8C00).withValues(alpha: 0.1),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF8C00).withValues(alpha: 0.15),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.lock_reset_rounded,
                  color: Color(0xFFFF8C00),
                  size: 38,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 36),

        // Title
        FadeTransition(
          opacity: _titleFade,
          child: SlideTransition(
            position: _titleSlide,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Reset your',
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
                    'password.',
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
                const SizedBox(height: 12),
                Text(
                  'Enter the email address associated with your account '
                  'and we\'ll send you a link to reset your password.',
                  style: TextStyle(
                    fontFamily: 'DarkerGrotesque',
                    color: Colors.white.withValues(alpha: 0.45),
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 36),

        // Email field
        FadeTransition(
          opacity: _formFade,
          child: SlideTransition(
            position: _formSlide,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 8),
                    child: Text(
                      'Email',
                      style: TextStyle(
                        fontFamily: 'DarkerGrotesque',
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                        width: 1,
                      ),
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _handleResetPassword(),
                      style: const TextStyle(
                        fontFamily: 'DarkerGrotesque',
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      cursorColor: const Color(0xFFFF8C00),
                      decoration: InputDecoration(
                        hintText: 'Enter your email address',
                        hintStyle: TextStyle(
                          fontFamily: 'DarkerGrotesque',
                          color: Colors.white.withValues(alpha: 0.2),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 12),
                          child: Icon(
                            Icons.email_outlined,
                            color: Colors.white.withValues(alpha: 0.35),
                            size: 22,
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 50,
                        ),
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
              ),
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Submit button
        FadeTransition(
          opacity: _btnFade,
          child: SlideTransition(
            position: _btnSlide,
            child: Column(
              children: [
                KurgateButton(
                  label: 'Send Reset Link',
                  trailingIcon: Icons.send_rounded,
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : _handleResetPassword,
                ),

                const SizedBox(height: 28),

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
                          TextSpan(text: 'Remember your password? '),
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
}
