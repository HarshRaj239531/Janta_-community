import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import 'shared_widgets.dart';

class RegisterStep1 extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController mobileController;
  final TextEditingController emailController;
  final VoidCallback onVerify;

  const RegisterStep1({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.mobileController,
    required this.emailController,
    required this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Create Account',
            style: GoogleFonts.outfit(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Fill in your details to get started.',
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 28),

          // Card
          RegisterCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Full Name
                const RegisterLabel('FULL NAME'),
                const SizedBox(height: 6),
                RegisterTextField(
                  controller: nameController,
                  hint: 'e.g. Harsh Rajput',
                  prefixIcon: Icons.person_outline_rounded,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Please enter your full name';
                    }
                    if (v.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Mobile Number
                const RegisterLabel('MOBILE NUMBER'),
                const SizedBox(height: 6),
                RegisterTextField(
                  controller: mobileController,
                  hint: '9876543210',
                  prefixIcon: Icons.phone_android_rounded,
                  keyboardType: TextInputType.phone,
                  prefixText: '+91  ',
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Please enter your mobile number';
                    }
                    if (v.trim().length != 10) {
                      return 'Enter a valid 10-digit mobile number';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Email
                const RegisterLabel('EMAIL ADDRESS'),
                const SizedBox(height: 6),
                RegisterTextField(
                  controller: emailController,
                  hint: 'you@example.com',
                  prefixIcon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Please enter your email address';
                    }
                    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,}$');
                    if (!emailRegex.hasMatch(v.trim())) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 28),

                // Send OTP Button
                RegisterPrimaryButton(
                  label: 'Send OTP',
                  icon: Icons.send_rounded,
                  onPressed: onVerify,
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
