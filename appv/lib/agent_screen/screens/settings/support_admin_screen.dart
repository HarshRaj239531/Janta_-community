import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/agent_colors.dart';

class SupportAdminScreen extends StatefulWidget {
  const SupportAdminScreen({super.key});

  @override
  State<SupportAdminScreen> createState() => _SupportAdminScreenState();
}

class _SupportAdminScreenState extends State<SupportAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  String _selectedSubject = 'General Inquiry';

  final List<String> _subjects = [
    'General Inquiry',
    'Technical App Issue',
    'Transaction Dispute',
    'Account Settings help',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitTicket() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: AgentColors.successGreen, size: 28),
              const SizedBox(width: 8),
              Text(
                'Ticket Submitted',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AgentColors.primaryGreen),
              ),
            ],
          ),
          content: Text(
            'Your support request has been received. Our admin team will contact you shortly.\n\n'
            'Subject: $_selectedSubject\n'
            'Reference ID: #JT-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
            style: GoogleFonts.outfit(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _descriptionController.clear();
              },
              child: Text(
                'OK',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AgentColors.primaryGreen),
              ),
            ),
          ],
        ),
      );
    }
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
          'Support & Admin',
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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. How can we help? Card
              _buildHelpIntroCard(),
              const SizedBox(height: 20),

              // 2. Send a Message Form Card
              _buildSendMessageFormCard(),
              const SizedBox(height: 20),

              // 3. Direct Contact Card
              _buildDirectContactCard(),
              const SizedBox(height: 20),

              // 4. Headquarters Card
              _buildHeadquartersCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpIntroCard() {
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
          // Speech bubble icon custom container matching mockup
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AgentColors.primaryGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.question_answer_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 18),
          
          Text(
            'How can we help?',
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AgentColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Our dedicated admin team is here to assist you with account inquiries, compliance guidance, and platform support.',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: AgentColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          
          // Availability Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AgentColors.pillGreenBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  color: AgentColors.primaryGreen,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'Mon–Fri, 9 AM – 6 PM',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AgentColors.primaryGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendMessageFormCard() {
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Send a Message',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AgentColors.textPrimary,
              ),
            ),
            const SizedBox(height: 18),
            
            // Subject selection
            Text(
              'Subject',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AgentColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedSubject,
              decoration: InputDecoration(
                filled: true,
                fillColor: AgentColors.backgroundSoft,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AgentColors.textSecondary),
              style: GoogleFonts.outfit(color: AgentColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w500),
              dropdownColor: Colors.white,
              items: _subjects.map((String sub) {
                return DropdownMenuItem<String>(
                  value: sub,
                  child: Text(sub),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    _selectedSubject = value;
                  });
                }
              },
            ),
            const SizedBox(height: 18),
            
            // Description TextArea
            Text(
              'Description',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AgentColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Please describe your request in detail...',
                hintStyle: GoogleFonts.outfit(color: AgentColors.textMuted, fontSize: 14),
                filled: true,
                fillColor: AgentColors.backgroundSoft,
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: GoogleFonts.outfit(fontSize: 15, color: AgentColors.textPrimary),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter description details';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            
            // Submit Button
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _submitTicket,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AgentColors.primaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Submit Ticket',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDirectContactCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AgentColors.lavenderSoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AgentColors.borderMuted.withAlpha(150), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Direct Contact',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AgentColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          
          // Call Us Card
          _buildContactRowCard(
            icon: Icons.phone_android_rounded,
            title: 'Call Us',
            subtitle: '+1 (800) 555-0199',
            onTap: () {},
          ),
          const SizedBox(height: 10),
          
          // Email Card
          _buildContactRowCard(
            icon: Icons.mail_outline_rounded,
            title: 'Email Support',
            subtitle: 'admin@emeraldclarity.com',
            onTap: () {},
          ),
          const SizedBox(height: 10),
          
          // WhatsApp Card
          _buildContactRowCard(
            icon: Icons.chat_bubble_outline_rounded,
            title: 'WhatsApp',
            subtitle: 'Instant Messaging',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildContactRowCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Row(
              children: [
                // Green Circle Icon Container
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AgentColors.pillGreenBackground,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: AgentColors.primaryGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                
                // Text details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AgentColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: AgentColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeadquartersCard() {
    return Container(
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
          // Office Banner photo
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&q=80&w=600',
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          
          // Address Info
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Headquarters',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AgentColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '123 Financial Plaza, Level 14\nNew York, NY 10004',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: AgentColors.textSecondary,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
