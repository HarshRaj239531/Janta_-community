import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../provider/auth_provider.dart';
import 'widgets/step1_details.dart';
import 'widgets/step2_password.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  // Step controller: 0: Details, 1: Password
  int _currentStep = 0;

  // Step 1 controllers (Details)
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _step1FormKey = GlobalKey<FormState>();

  // Step 2 controllers (Password)
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _step2FormKey = GlobalKey<FormState>();
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
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _nextStep() {
    _slideController.reset();
    setState(() => _currentStep++);
    _slideController.forward();
  }

  void _prevStep() {
    _slideController.reset();
    setState(() => _currentStep--);
    _slideController.forward();
  }

  void _verifyStep1() {
    if (_step1FormKey.currentState!.validate()) {
      _nextStep();
    }
  }

  Future<void> _createAccount() async {
    if (!_step2FormKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _mobileController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      _showSnackBar('Account created successfully! Please login.',
          isError: false);
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      Navigator.of(context).pop();
    } else {
      _showSnackBar(
        authProvider.error ?? 'Registration failed. Please try again.',
        isError: true,
      );
    }
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
                  IconButton(
                    onPressed: () {
                      if (_currentStep > 0) {
                        _prevStep();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
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
    final steps = ['Details', 'Password'];
    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          // Connector line
          final stepIndex = i ~/ 2;
          return Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 8),
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
          onContinue: _verifyStep1,
        );
      case 1:
        return RegisterStep2(
          formKey: _step2FormKey,
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
