import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../constants/agent_colors.dart';
import '../../provider/agent_provider.dart';
import '../../models/agent_client_model.dart';
import 'client_kyc_screen.dart';

class ClientProfileScreen extends StatefulWidget {
  final String clientName;
  final String clientId;
  final String status;

  const ClientProfileScreen({
    super.key,
    required this.clientName,
    required this.clientId,
    required this.status,
  });

  @override
  State<ClientProfileScreen> createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
  late String _fatherName = 'N/A';
  late String _mobile = 'N/A';
  late String _email = 'N/A';
  late String _address = 'N/A';
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AgentProvider>(context, listen: false)
          .fetchClientDetails(int.parse(widget.clientId));
    });
  }

  void _showEditDetailsSheet() {
    final formKey = GlobalKey<FormState>();
    final fNameController = TextEditingController(text: _fatherName);
    final mobileController = TextEditingController(text: _mobile);
    final emailController = TextEditingController(text: _email);
    final addressController = TextEditingController(text: _address);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24,
            left: 24,
            right: 24,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Edit Personal Details',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AgentColors.primaryGreen,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Father's Name
                  _buildEditLabel("FATHER'S NAME"),
                  TextFormField(
                    controller: fNameController,
                    decoration: _buildInputDecoration('Enter father\'s name'),
                    validator: (v) => v!.trim().isEmpty ? 'Enter father\'s name' : null,
                  ),
                  const SizedBox(height: 14),

                  // Mobile
                  _buildEditLabel("MOBILE NUMBER"),
                  TextFormField(
                    controller: mobileController,
                    decoration: _buildInputDecoration('Enter mobile number'),
                    validator: (v) => v!.trim().isEmpty ? 'Enter mobile number' : null,
                  ),
                  const SizedBox(height: 14),

                  // Email
                  _buildEditLabel("EMAIL ADDRESS"),
                  TextFormField(
                    controller: emailController,
                    decoration: _buildInputDecoration('Enter email address'),
                    validator: (v) => v!.trim().isEmpty ? 'Enter email address' : null,
                  ),
                  const SizedBox(height: 14),

                  // Address
                  _buildEditLabel("ADDRESS"),
                  TextFormField(
                    controller: addressController,
                    maxLines: 2,
                    decoration: _buildInputDecoration('Enter address'),
                    validator: (v) => v!.trim().isEmpty ? 'Enter address' : null,
                  ),
                  const SizedBox(height: 24),
                  
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          _fatherName = fNameController.text.trim();
                          _mobile = mobileController.text.trim();
                          _email = emailController.text.trim();
                          _address = addressController.text.trim();
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AgentColors.successGreen,
                            content: Text(
                              'Personal details updated successfully.',
                              style: GoogleFonts.outfit(color: Colors.white),
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AgentColors.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Save Changes',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEditLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AgentColors.textSecondary,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.outfit(color: AgentColors.textMuted, fontSize: 14),
      filled: true,
      fillColor: AgentColors.backgroundSoft,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgentColors.backgroundSoft,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AgentColors.primaryGreen),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Client Profile',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: AgentColors.primaryGreen,
            fontSize: 20,
          ),
        ),
        shape: Border(
          bottom: BorderSide(
            color: AgentColors.borderMuted.withAlpha(120),
            width: 1.5,
          ),
        ),
      ),
      body: SafeArea(
        child: Consumer<AgentProvider>(
          builder: (context, agentProvider, child) {
            if (agentProvider.isProfileLoading && agentProvider.clientProfile == null) {
              return const Center(child: CircularProgressIndicator(color: AgentColors.primaryGreen));
            }
            if (agentProvider.profileError != null && agentProvider.clientProfile == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(agentProvider.profileError!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                ),
              );
            }
            final profile = agentProvider.clientProfile;
            if (profile == null) {
              return const Center(child: Text('Client details not found'));
            }

            if (!_initialized) {
              _mobile = profile.personalDetails.phone ?? 'N/A';
              _email = profile.personalDetails.email ?? 'N/A';
              _address = profile.personalDetails.address ?? 'N/A';
              _initialized = true;
            }

            return RefreshIndicator(
              onRefresh: () async {
                await agentProvider.fetchClientDetails(int.parse(widget.clientId));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Profile Header Box
                    _buildProfileHeaderCard('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=200'),
                    const SizedBox(height: 20),
  
                    // 2. Personal Details Card
                    _buildPersonalDetailsCard(),
                    const SizedBox(height: 24),
  
                    // 3. Active Loans Section
                    if (profile.activeLoans.isEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Active Loans',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AgentColors.primaryGreen,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AgentColors.borderMuted, width: 1),
                            ),
                            child: Center(
                              child: Text(
                                'No active loans for this client.',
                                style: GoogleFonts.outfit(color: AgentColors.textSecondary),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      ...profile.activeLoans.map((loan) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: _buildActiveLoansSection(
                            "Standard Loan",
                            "LN-${loan.loanId}",
                            "₹${loan.totalLoanAmount.toStringAsFixed(0)}",
                            "₹${loan.outstanding.toStringAsFixed(0)}",
                            "₹${(loan.totalLoanAmount / 10).toStringAsFixed(0)}", // estimate next emi
                            loan.emiProgress,
                            (loan.totalPaid / (loan.totalLoanAmount == 0 ? 1.0 : loan.totalLoanAmount)).clamp(0.0, 1.0),
                          ),
                        );
                      }),
                    const SizedBox(height: 8),
  
                    // 4. Recent Transactions Section
                    _buildRecentTransactionsSection(profile.recentTransactions),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeaderCard(String avatarUrl) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AgentColors.borderMuted, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          // Avatar with verified badge
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AgentColors.borderMuted,
                    width: 1,
                  ),
                ),
                child: CircleAvatar(
                  radius: 36,
                  backgroundColor: AgentColors.pillGreenBackground,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(1.5),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified_rounded,
                    color: AgentColors.primaryGreen,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          
          Text(
            widget.clientName,
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AgentColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Client ID: ${widget.clientId}',
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: AgentColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          
          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: widget.status == 'Active'
                  ? AgentColors.successLight
                  : widget.status == 'Pending KYC'
                      ? AgentColors.warningAmber.withAlpha(50)
                      : AgentColors.errorLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.status,
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: widget.status == 'Active'
                    ? AgentColors.successDark
                    : widget.status == 'Pending KYC'
                        ? AgentColors.warningAmber.darken(0.15)
                        : AgentColors.errorDark,
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Call & WhatsApp row
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Calling ${widget.clientName} at $_mobile...'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AgentColors.primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.phone_rounded, size: 16),
                            const SizedBox(width: 6),
                            Text('Call', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Opening WhatsApp chat for ${widget.clientName}...'),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AgentColors.textPrimary,
                    side: const BorderSide(color: AgentColors.borderMuted, width: 1.2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: AgentColors.textPrimary),
                      const SizedBox(width: 6),
                      Text('WhatsApp', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (widget.status == 'Pending KYC') ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ClientKycScreen(
                        clientId: int.tryParse(widget.clientId),
                        clientName: widget.clientName,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AgentColors.warningAmber,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.verified_user_outlined, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Complete Client KYC',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPersonalDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AgentColors.borderMuted, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Personal Details',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AgentColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: _showEditDetailsSheet,
                child: Text(
                  'Edit',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AgentColors.primaryGreen,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          
          _buildDetailRow("Father's Name", _fatherName),
          const SizedBox(height: 14),
          _buildDetailRow("Mobile Number", _mobile),
          const SizedBox(height: 14),
          _buildDetailRow("Email Address", _email),
          const SizedBox(height: 14),
          _buildDetailRow("Address", _address),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 11,
            color: AgentColors.textMuted,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: AgentColors.textPrimary,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveLoansSection(
    String group,
    String ref,
    String total,
    String outstanding,
    String nextEmi,
    String progressLabel,
    double progressValue,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Active Loans',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AgentColors.primaryGreen,
          ),
        ),
        const SizedBox(height: 12),
        
        Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AgentColors.borderMuted, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(5),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Group and In Progress Badge Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group,
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AgentColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Loan Ref: $ref',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: AgentColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AgentColors.lavenderSoft.withAlpha(200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'In Progress',
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AgentColors.infoBlueDark,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              
              // Total Amount Label
              Text(
                'Total Loan Amount',
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  color: AgentColors.textMuted,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                total,
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AgentColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 18),
              
              // Outstanding & Next EMI Box Row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AgentColors.backgroundSoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Outstanding',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: AgentColors.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            outstanding,
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AgentColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AgentColors.backgroundSoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Next EMI',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: AgentColors.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            nextEmi,
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AgentColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // EMI Progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'EMI Progress',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AgentColors.textSecondary,
                    ),
                  ),
                  Text(
                    progressLabel,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AgentColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progressValue,
                  minHeight: 6,
                  backgroundColor: AgentColors.backgroundSoft,
                  valueColor: const AlwaysStoppedAnimation<Color>(AgentColors.primaryGreen),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactionsSection(List<ClientTransactionModel> transactions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AgentColors.primaryGreen,
              ),
            ),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Opening all transactions for ${widget.clientName}...'),
                  ),
                );
              },
              child: Row(
                children: [
                  Text(
                    'View All',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AgentColors.textSecondary,
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: AgentColors.textSecondary, size: 16),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AgentColors.borderMuted, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(5),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: transactions.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      'No transactions recorded.',
                      style: GoogleFonts.outfit(color: AgentColors.textSecondary),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  separatorBuilder: (context, index) => const Divider(
                    color: AgentColors.borderMuted,
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    final isSuccess = tx.status.toLowerCase() == 'success' || tx.status.toLowerCase() == 'approved';
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                      child: Row(
                        children: [
                          // Green receipt icon
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AgentColors.pillGreenBackground,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.receipt_rounded,
                              color: AgentColors.primaryGreen,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          
                          // Transaction details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tx.type,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AgentColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${tx.date} • ID: TXN-${tx.id}',
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    color: AgentColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          
                          // Amount and status
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '₹${tx.amount.toStringAsFixed(0)}',
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AgentColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isSuccess ? AgentColors.successLight : AgentColors.alertOrangeBackground,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  tx.status.toUpperCase(),
                                  style: GoogleFonts.outfit(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: isSuccess ? AgentColors.successDark : AgentColors.alertOrange,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// Extension to darken custom colors inside helper
extension _ColorDarken on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
