import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_portfolio/models/personal_info_model.dart';
import '../models/portfolio_data.dart';
import '../theme/professional_theme.dart';

class ProfileSection extends StatelessWidget {
  final GlobalKey sectionKey;
  final bool isWeb;

  const ProfileSection({
    required this.sectionKey,
    required this.isWeb,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = width < 600 ? 20.0 : (width < 1200 ? 40.0 : 100.0);

    return Container(
      key: sectionKey,
      padding: EdgeInsets.all(padding),
      decoration: const BoxDecoration(gradient: ProfessionalTheme.bgGradient),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isWeb ? 1000 : double.infinity),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: ProfessionalTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: ProfessionalTheme.electricBlue.withOpacity(
                            0.3,
                          ),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 20),
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        ProfessionalTheme.primaryGradient.createShader(bounds),
                    child: Text(
                      'About Me',
                      style: Theme.of(
                        context,
                      ).textTheme.displaySmall?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.3, end: 0),
              const SizedBox(height: 50),

              // Bio card
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('personal_info')
                    .snapshots(),
                builder: (context, snapshot) {
                  String bio = PortfolioData.profileDescription;
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    final docData =
                        snapshot.data!.docs[0].data() as Map<String, dynamic>;
                    final personalInfo = PersonalInfoModel.fromFirestore(
                      docData,
                    );
                    if (personalInfo.bio.isNotEmpty) {
                      bio = personalInfo.bio;
                    }
                  }
                  return Container(
                    padding: EdgeInsets.all(
                        width < 600 ? 24 : (width < 1200 ? 36 : 50)),
                    decoration: ProfessionalTheme.glassCard(),
                    child: Text(
                      bio,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: isWeb ? 20 : 16,
                            color: ProfessionalTheme.textSecondary,
                          ),
                    ),
                  )
                      .animate(delay: 200.ms)
                      .fadeIn(duration: 800.ms)
                      .slideY(begin: 0.2, end: 0);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
