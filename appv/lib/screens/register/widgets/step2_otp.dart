import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import 'shared_widgets.dart';

class RegisterStep2 extends StatelessWidget {
  final TextEditingController mobileController;
  final List<TextEditingController> otpControllers;
  final List<FocusNode> otpFocusNodes;
  final bool canResend;
  final int resendSeconds;
  final VoidCallback onVerifyOtp;
  final VoidCallback onResendOtp;
  final void Function(String, int) onOtpChanged;

  const RegisterStep2({
    super.key,
    required this.mobileController,
    required this.otpControllers,
    required this.otpFocusNodes,
    required this.canResend,
    required this.resendSeconds,
    required this.onVerifyOtp,
    required this.onResendOtp,
    required this.onOtpChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mobile = mobileController.text.trim();
    final maskedMobile = mobile.length == 10
        ? '+91 ${mobile.substring(0, 2)}••••••${mobile.substring(8)}'
        : '+91 $mobile';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Verify Mobile',
          style: GoogleFonts.outfit(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        RichText(
          text: TextSpan(
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            children: [
              const TextSpan(text: 'OTP sent to '),
              TextSpan(
                text: maskedMobile,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        RegisterCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // OTP sent info banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.lightGreenTint,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.accentMint, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.sms_outlined,
                        color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'A 6-digit OTP has been sent to your mobile number.',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // 6 OTP Boxes
              const RegisterLabel('ENTER 6-DIGIT OTP'),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) => _buildOtpBox(i, theme)),
              ),

              const SizedBox(height: 16),

              // Resend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive OTP? ",
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  canResend
                      ? GestureDetector(
                          onTap: onResendOtp,
                          child: Text(
                            'Resend',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        )
                      : Text(
                          'Resend in ${resendSeconds}s',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMuted,
                          ),
                        ),
                ],
              ),

              const SizedBox(height: 28),

              RegisterPrimaryButton(
                label: 'Verify OTP',
                icon: Icons.verified_user_outlined,
                onPressed: onVerifyOtp,
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),
        const RegisterLoginLink(),
      ],
    );
  }

  Widget _buildOtpBox(int index, ThemeData theme) {
    return SizedBox(
      width: 44,
      height: 52,
      child: TextFormField(
        controller: otpControllers[index],
        focusNode: otpFocusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.borderMuted, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: theme.colorScheme.primary, width: 2),
          ),
        ),
        onChanged: (v) => onOtpChanged(v, index),
      ),
    );
  }
}
