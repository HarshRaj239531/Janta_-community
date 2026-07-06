import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../provider/profile_provider.dart';
import '../../provider/auth_provider.dart';
import '../login/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).fetchProfile();
      Provider.of<ProfileProvider>(context, listen: false).fetchVault();
    });
  }

  void _showEditProfileDialog() {
    final pp = Provider.of<ProfileProvider>(context, listen: false);
    final user = pp.profile;
    if (user == null) return;

    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final phoneController = TextEditingController(text: user.phone);
    final addressController = TextEditingController(text: user.address);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Edit Profile Info',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nameController, 'Name'),
                const SizedBox(height: 12),
                _buildTextField(emailController, 'Email'),
                const SizedBox(height: 12),
                _buildTextField(phoneController, 'Phone'),
                const SizedBox(height: 12),
                _buildTextField(addressController, 'Address'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.outfit(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final success = await pp.updateProfile({
                  'name': nameController.text.trim(),
                  'email': emailController.text.trim(),
                  'phone': phoneController.text.trim(),
                  'address': addressController.text.trim(),
                });
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success ? 'Profile updated successfully!' : (pp.error ?? 'Update failed'),
                        style: GoogleFonts.outfit(),
                      ),
                      backgroundColor: success ? AppColors.successGreen : AppColors.errorAccent,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
              child: Text(
                'Save',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditBankDialog() {
    final pp = Provider.of<ProfileProvider>(context, listen: false);
    final user = pp.profile;
    if (user == null) return;

    final bankNameController = TextEditingController(text: user.bankName);
    final accNoController = TextEditingController(text: user.bankAccountNumber);
    final ifscController = TextEditingController(text: user.bankIfsc);
    final accTypeController = TextEditingController(text: user.bankAccountType ?? 'Savings');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Edit Bank Details',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(bankNameController, 'Bank Name'),
                const SizedBox(height: 12),
                _buildTextField(accNoController, 'Account Number'),
                const SizedBox(height: 12),
                _buildTextField(ifscController, 'IFSC Code'),
                const SizedBox(height: 12),
                _buildTextField(accTypeController, 'Account Type (Savings/Current)'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.outfit(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final success = await pp.updateProfile({
                  'bank_name': bankNameController.text.trim(),
                  'bank_account_number': accNoController.text.trim(),
                  'bank_ifsc': ifscController.text.trim(),
                  'bank_account_type': accTypeController.text.trim(),
                });
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success ? 'Bank details updated!' : (pp.error ?? 'Update failed'),
                        style: GoogleFonts.outfit(),
                      ),
                      backgroundColor: success ? AppColors.successGreen : AppColors.errorAccent,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
              child: Text(
                'Save',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.outfit(fontSize: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      style: GoogleFonts.outfit(fontSize: 14),
    );
  }

  Future<void> _logout() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.logout();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(
              Icons.settings_rounded,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Settings & Security',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, pp, child) {
          if (pp.isLoading && pp.profile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = pp.profile;
          final vault = pp.vault ?? {};
          final isKycDone = vault['aadhar_card'] != null && vault['pan_card'] != null;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Profile Summary Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderMuted),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0F4C3A),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          user != null && user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? 'User Account',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              user?.email ?? user?.phone ?? 'Member',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: isKycDone ? AppColors.successLight : AppColors.errorLight,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                isKycDone ? 'KYC VERIFIED' : 'KYC PENDING',
                                style: GoogleFonts.outfit(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isKycDone ? theme.colorScheme.primary : AppColors.errorAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 2. Account Settings Group
                _buildSectionHeader('Account Settings'),
                const SizedBox(height: 8),
                _buildSettingsTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Edit Personal Details',
                  subtitle: 'Update your name, email, phone, and address',
                  onTap: _showEditProfileDialog,
                ),
                const SizedBox(height: 8),
                _buildSettingsTile(
                  icon: Icons.account_balance_outlined,
                  title: 'Bank Details',
                  subtitle: 'Configure your settlement bank account',
                  onTap: _showEditBankDialog,
                ),
                const SizedBox(height: 24),

                // 3. Documents & Vault
                _buildSectionHeader('Verification & Documents'),
                const SizedBox(height: 8),
                _buildSettingsTile(
                  icon: Icons.shield_outlined,
                  title: 'KYC Documents Vault',
                  subtitle: 'View Aadhar, PAN, and ID Proof attachments',
                  onTap: () {
                    // Navigate to LoanDetails documents tab (switcher index 2)
                    // Or let user view KYC attachments
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'KYC Vault can be managed directly in the "Documents" tab of Loan Details.',
                          style: GoogleFonts.outfit(),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // 4. About Janta
                _buildSectionHeader('App Info & Support'),
                const SizedBox(height: 8),
                _buildSettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: 'About Janta community',
                  subtitle: 'Terms of service & privacy policies',
                  onTap: () {},
                ),
                const SizedBox(height: 24),

                // 5. Danger Zone / Logout
                ElevatedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 18),
                  label: Text(
                    'Logout Account',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.errorAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondary,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: AppColors.lavenderSoft,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.textPrimary, size: 20),
        ),
        title: Text(
          title,
          style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textSecondary),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
      ),
    );
  }
}
