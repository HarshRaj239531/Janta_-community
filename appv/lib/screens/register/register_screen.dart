import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import 'widgets/step1_details.dart';
import 'widgets/step2_otp.dart';
import 'widgets/step3_password.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  // Step controller
  int _currentStep = 0; // 0: Details, 1: OTP, 2: Password

  // Step 1 controllers
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _step1FormKey = GlobalKey<FormState>();

  // Step 2 — OTP (6 separate boxes)
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List.generate(6, (_) => FocusNode());
  int _resendSeconds = 30;
  bool _canResend = false;

  // Step 3 controllers
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _step3FormKey = GlobalKey<FormState>();
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;
  bool _isLoading = false;

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    _slideController.forward();
    _startResendTimer();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocusNodes) {
      f.dispose();
    }
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    _resendSeconds = 30;
    _canResend = false;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        if (_resendSeconds > 0) {
          _resendSeconds--;
        } else {
          _canResend = true;
        }
      });
      return _resendSeconds > 0;
    });
  }

  void _nextStep() {
    _slideController.reset();
    setState(() => _currentStep++);
    _slideController.forward();
    if (_currentStep == 1) _startResendTimer();
  }

  void _prevStep() {
    _slideController.reset();
    setState(() => _currentStep--);
    _slideController.forward();
  }

  String _getOtp() => _otpControllers.map((c) => c.text).join();

  void _verifyStep1() {
    if (_step1FormKey.currentState!.validate()) {
      _nextStep();
    }
  }

  void _verifyOtp() {
    final otp = _getOtp();
    if (otp.length < 6) {
      _showSnackBar('Please enter the complete 6-digit OTP', isError: true);
      return;
    }
    _nextStep();
  }

  Future<void> _createAccount() async {
    if (!_step3FormKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);
    _showSnackBar('Account created successfully! Please login.',
        isError: false);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.outfit()),
        backgroundColor:
            isError ? AppColors.errorAccent : AppColors.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 16, 0),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    IconButton(
                      onPressed: _prevStep,
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 20),
                      color: AppColors.textDark,
                    )
                  else
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 20),
                      color: AppColors.textDark,
                    ),
                  const Spacer(),
                  Text(
                    'Janta Trader',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.primary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // ── Step Indicator ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: _buildStepIndicator(theme),
            ),

            // ── Content ───────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildCurrentStep(theme),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Step Indicator ─────────────────────────────────────────────────────────
  Widget _buildStepIndicator(ThemeData theme) {
    final steps = ['Details', 'Verify', 'Password'];
    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          // Connector line
          final stepIndex = i ~/ 2;
          return Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: stepIndex < _currentStep
                    ? theme.colorScheme.primary
                    : AppColors.borderMuted,
              ),
            ),
          );
        }
        final stepIndex = i ~/ 2;
        final isCompleted = stepIndex < _currentStep;
        final isActive = stepIndex == _currentStep;
        return Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? theme.colorScheme.primary
                    : isActive
                        ? theme.colorScheme.primary
                        : Colors.white,
                border: Border.all(
                  color: isCompleted || isActive
                      ? theme.colorScheme.primary
                      : AppColors.borderMuted,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check_rounded,
                        color: Colors.white, size: 16)
                    : Text(
                        '${stepIndex + 1}',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isActive ? Colors.white : AppColors.textMuted,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              steps[stepIndex],
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive
                    ? theme.colorScheme.primary
                    : AppColors.textMuted,
              ),
            ),
          ],
        );
      }),
    );
  }

  // ── Step Router ────────────────────────────────────────────────────────────
  Widget _buildCurrentStep(ThemeData theme) {
    switch (_currentStep) {
      case 0:
        return RegisterStep1(
          formKey: _step1FormKey,
          nameController: _nameController,
          mobileController: _mobileController,
          emailController: _emailController,
          onVerify: _verifyStep1,
        );
      case 1:
        return RegisterStep2(
          mobileController: _mobileController,
          otpControllers: _otpControllers,
          otpFocusNodes: _otpFocusNodes,
          canResend: _canResend,
          resendSeconds: _resendSeconds,
          onVerifyOtp: _verifyOtp,
          onResendOtp: () {
            _showSnackBar('OTP resent to ${_mobileController.text.trim()}',
                isError: false);
            _startResendTimer();
          },
          onOtpChanged: (v, index) {
            if (v.isNotEmpty && index < 5) {
              _otpFocusNodes[index + 1].requestFocus();
            } else if (v.isEmpty && index > 0) {
              _otpFocusNodes[index - 1].requestFocus();
            }
            setState(() {});
          },
        );
      case 2:
        return RegisterStep3(
          formKey: _step3FormKey,
          nameController: _nameController,
          mobileController: _mobileController,
          passwordController: _passwordController,
          confirmPasswordController: _confirmPasswordController,
          isPasswordObscured: _isPasswordObscured,
          isConfirmPasswordObscured: _isConfirmPasswordObscured,
          isLoading: _isLoading,
          onTogglePassword: () =>
              setState(() => _isPasswordObscured = !_isPasswordObscured),
          onToggleConfirmPassword: () => setState(() =>
              _isConfirmPasswordObscured = !_isConfirmPasswordObscured),
          onCreateAccount: _createAccount,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
