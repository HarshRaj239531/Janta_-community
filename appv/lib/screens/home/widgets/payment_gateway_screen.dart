import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/app_colors.dart';
import '../../../api/payment_api.dart';
import '../../../helpers/api_constants.dart';

class PaymentGatewayScreen extends StatefulWidget {
  const PaymentGatewayScreen({super.key});

  @override
  State<PaymentGatewayScreen> createState() => _PaymentGatewayScreenState();
}

class _PaymentGatewayScreenState extends State<PaymentGatewayScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  String? _qrCodeUrl;
  String? _adminPhone;

  @override
  void initState() {
    super.initState();
    _loadPaymentSettings();
  }

  Future<void> _loadPaymentSettings() async {
    try {
      final data = await PaymentApi.fetchPaymentSetting();
      setState(() {
        _qrCodeUrl = ApiConstants.resolveImageUrl(data['qr_code']);
        _adminPhone = data['admin_phone'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _openWhatsApp() async {
    if (_adminPhone == null || _adminPhone!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Admin contact number not available.',
            style: GoogleFonts.outfit(),
          ),
          backgroundColor: AppColors.errorAccent,
        ),
      );
      return;
    }

    final cleanPhone = _adminPhone!.replaceAll(RegExp(r'[^\d]'), '');
    final message = "Hello Admin,\n\nI have completed the payment. Please verify the attached screenshot of my payment transaction.";
    final whatsappUrl = Uri.parse("https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}");

    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch WhatsApp';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not open WhatsApp. Please contact admin at $_adminPhone directly.',
              style: GoogleFonts.outfit(),
            ),
            backgroundColor: AppColors.errorAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Payment Gateway',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontSize: 18,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline_rounded, color: AppColors.errorAccent, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to load payment details',
                          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                              _errorMessage = null;
                            });
                            _loadPaymentSettings();
                          },
                          icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                          label: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withAlpha(15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primaryGreen.withAlpha(40)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline_rounded, color: AppColors.primaryGreen, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Scan the QR Code below to make a payment. Once done, share the screenshot of your payment confirmation on WhatsApp.',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.borderLight),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(5),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Scan & Repay',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundAlt,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.borderLight),
                              ),
                              child: _qrCodeUrl != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        _qrCodeUrl!,
                                        width: 250,
                                        height: 250,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) {
                                          return _buildQrErrorPlaceholder();
                                        },
                                      ),
                                    )
                                  : _buildQrErrorPlaceholder(),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.security_rounded, color: AppColors.successGreen, size: 14),
                                const SizedBox(width: 6),
                                Text(
                                  'Secure Instant UPI Verification',
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
                                    color: AppColors.successGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _openWhatsApp,
                        icon: const Icon(Icons.share_rounded, color: Colors.white),
                        label: Text(
                          'Share Payment Screenshot',
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          'Will redirect to WhatsApp to send to ${_adminPhone ?? "admin"}',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildQrErrorPlaceholder() {
    return Container(
      width: 250,
      height: 250,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.qr_code_2_rounded, size: 80, color: AppColors.textMuted),
          const SizedBox(height: 12),
          Text(
            'No QR Code Available',
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Admin has not set the payment QR Code yet.',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 10,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
