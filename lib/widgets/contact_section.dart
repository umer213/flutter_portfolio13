import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_portfolio/models/personal_info_model.dart';
import '../models/portfolio_data.dart';
import '../theme/professional_theme.dart';

class ContactSection extends StatelessWidget {
  final GlobalKey sectionKey;
  final bool isWeb;
  final Function(String) onLaunchURL;

  const ContactSection({
    required this.sectionKey,
    required this.isWeb,
    required this.onLaunchURL,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('personal_info').snapshots(),
      builder: (context, snap) {
        String phone = PortfolioData.phone;
        String email = PortfolioData.email;
        String linkedIn = PortfolioData.linkedIn;

        if (snap.hasData && snap.data!.docs.isNotEmpty) {
          final docData = snap.data!.docs[0].data();
          final personalInfo = PersonalInfoModel.fromFirestore(docData);
          phone = personalInfo.phone;
          email = personalInfo.email;
          linkedIn = personalInfo.linkedIn;
        }

        final width = MediaQuery.of(context).size.width;
        final padding = width < 600 ? 20.0 : (width < 1200 ? 40.0 : 100.0);

        return Container(
          key: sectionKey,
          padding: EdgeInsets.all(padding),
          decoration: const BoxDecoration(
            gradient: ProfessionalTheme.bgGradient,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWeb ? 900 : double.infinity,
              ),
              child: Container(
                padding:
                    EdgeInsets.all(width < 600 ? 30 : (width < 1200 ? 45 : 60)),
                decoration: BoxDecoration(
                  gradient: ProfessionalTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: ProfessionalTheme.electricBlue.withOpacity(0.4),
                      blurRadius: 40,
                      spreadRadius: 5,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Let\'s Connect',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ).animate().fadeIn(duration: 600.ms),
                    const SizedBox(height: 12),
                    Text(
                      'Ready to bring your ideas to life',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                    ).animate(delay: 100.ms).fadeIn(duration: 600.ms),
                    const SizedBox(height: 50),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildContactButton(
                          icon: Icons.phone,
                          label: 'Call',
                          url: 'tel:${phone.replaceAll(RegExp(r'\s+'), '')}',
                        ),
                        _buildContactButton(
                          icon: Icons.email,
                          label: 'Email',
                          url: 'mailto:${email.trim()}',
                        ),
                        _buildContactButton(
                          icon: Icons.link,
                          label: 'LinkedIn',
                          url: linkedIn.startsWith('http')
                              ? linkedIn
                              : 'https://$linkedIn',
                        ),
                      ],
                    ).animate(delay: 200.ms).fadeIn(duration: 800.ms).scale(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required String url,
  }) {
    return ElevatedButton.icon(
      onPressed: () => onLaunchURL(url),
      icon: Icon(icon, size: 22),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: ProfessionalTheme.darkBg,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 0,
      ),
    );
  }
}
