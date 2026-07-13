import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import 'shared_widgets.dart';

class RegisterStep3 extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController mobileController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isPasswordObscured;
  final bool isConfirmPasswordObscured;
  final bool isLoading;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final VoidCallback onCreateAccount;

  const RegisterStep3({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.mobileController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isPasswordObscured,
    required this.isConfirmPasswordObscured,
    required this.isLoading,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    required this.onCreateAccount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Set Password',
            style: GoogleFonts.outfit(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Choose a strong password for your account.',
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 28),

          RegisterCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Account summary chip
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreenTint,
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: AppColors.accentMint, width: 1),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: theme.colorScheme.primary,
                        child: Text(
                          nameController.text.trim().isNotEmpty
                              ? nameController.text.trim()[0].toUpperCase()
                              : 'U',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nameController.text.trim(),
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppColors.textDark,
                              ),
                            ),
                            Text(
                              '+91 ${mobileController.text.trim()}',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.check_circle_rounded,
                          color: theme.colorScheme.primary, size: 20),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Create Password
                const RegisterLabel('CREATE PASSWORD'),
                const SizedBox(height: 6),
                RegisterPasswordField(
                  controller: passwordController,
                  hint: 'At least 6 characters',
                  isObscured: isPasswordObscured,
                  onToggle: onTogglePassword,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Please create a password';
                    }
                    if (v.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Confirm Password
                const RegisterLabel('CONFIRM PASSWORD'),
                const SizedBox(height: 6),
                RegisterPasswordField(
                  controller: confirmPasswordController,
                  hint: 'Re-enter your password',
                  isObscured: isConfirmPasswordObscured,
                  onToggle: onToggleConfirmPassword,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (v != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                // Password strength hint
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 6),
                    Text(
                      'Use letters, numbers & symbols for a strong password.',
                      style: GoogleFonts.outfit(
                          fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Create Account Button
                isLoading
                    ? Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          ),
                        ),
                      )
                    : RegisterPrimaryButton(
                        label: 'Create Account',
                        icon: Icons.rocket_launch_rounded,
                        onPressed: onCreateAccount,
                      ),
              ],
            ),
          ),

          const SizedBox(height: 28),
          const RegisterLoginLink(),
        ],
      ),
    );
  }
}
