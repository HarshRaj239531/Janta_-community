import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import 'api_constants.dart';

class SupportHelper {
  SupportHelper._();

  static const String phoneNumber = ApiConstants.supportPhone;
  static const String formattedPhoneNumber = ApiConstants.supportPhoneFormatted;
  static const String email = ApiConstants.supportEmail;

  /// Launches the device dialer with the support phone number
  static Future<void> makePhoneCall(BuildContext context, [String? phone]) async {
    final targetPhone = phone ?? phoneNumber;
    final uri = Uri.parse('tel:$targetPhone');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Cannot launch dialer';
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not open dialer. Call directly: $formattedPhoneNumber',
              style: GoogleFonts.outfit(),
            ),
            backgroundColor: AppColors.errorAccent,
          ),
        );
      }
    }
  }

  /// Opens WhatsApp with the support number
  static Future<void> openWhatsApp(
    BuildContext context, {
    String? phone,
    String? message,
  }) async {
    final raw = (phone ?? phoneNumber).replaceAll(RegExp(r'[^\d]'), '');
    final cleanPhone = raw.length == 10 ? '91$raw' : raw;
    final msg = message ?? 'Hello Support, I need help with my Janta Community account.';
    final whatsappUrl = Uri.parse('https://wa.me/$cleanPhone?text=${Uri.encodeComponent(msg)}');

    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch WhatsApp';
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not open WhatsApp. Please contact $formattedPhoneNumber directly.',
              style: GoogleFonts.outfit(),
            ),
            backgroundColor: AppColors.errorAccent,
          ),
        );
      }
    }
  }

  /// Opens email app to contact support
  static Future<void> sendEmail(BuildContext context, [String? targetEmail]) async {
    final mail = targetEmail ?? email;
    final uri = Uri.parse(
      'mailto:$mail?subject=${Uri.encodeComponent("Support Request - Janta Community")}',
    );
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Cannot open email app';
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not open email client. Contact: $mail',
              style: GoogleFonts.outfit(),
            ),
            backgroundColor: AppColors.errorAccent,
          ),
        );
      }
    }
  }

  /// Copies support phone number to clipboard
  static void copyPhone(BuildContext context, [String? phone]) {
    final text = phone ?? formattedPhoneNumber;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              'Phone number copied: $text',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: AppColors.successGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Shows a modern, interactive Help & Support bottom sheet
  static void showSupportBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Header Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.successGreen.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.support_agent_rounded,
                    color: AppColors.successGreen,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Help & Support',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '24/7 Helpline & Customer Assistance',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textMuted),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Helpline Number Card with Call Action
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundSoft,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.phone_in_talk_rounded,
                      color: AppColors.primaryGreen,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Direct Phone Helpline',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          formattedPhoneNumber,
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 20, color: AppColors.textSecondary),
                    tooltip: 'Copy Number',
                    onPressed: () => copyPhone(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Call Now Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                makePhoneCall(context);
              },
              icon: const Icon(Icons.call_rounded, color: Colors.white, size: 20),
              label: Text(
                'Call $formattedPhoneNumber',
                style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
            ),
            const SizedBox(height: 10),

            // WhatsApp Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                openWhatsApp(context);
              },
              icon: const Icon(Icons.chat_rounded, color: Colors.white, size: 20),
              label: Text(
                'Chat on WhatsApp',
                style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
            ),
            const SizedBox(height: 14),

            // Operating Hours Info
            Center(
              child: Text(
                'Support Hours: Mon - Sat (9:00 AM - 7:00 PM IST)',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
