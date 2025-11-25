import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_portfolio/models/personal_info_model.dart';
import '../theme/professional_theme.dart';

class SkillsSection extends StatelessWidget {
  final GlobalKey sectionKey;
  final bool isWeb;

  const SkillsSection({
    required this.sectionKey,
    required this.isWeb,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: sectionKey,
      padding: EdgeInsets.all(isWeb ? 100 : 30),
      decoration: const BoxDecoration(
        gradient: ProfessionalTheme.bgGradient,
      ),
      child: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('personal_info').snapshots(),
        builder: (context, snapshot) {
          List<String> skills = [];
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            final docData = snapshot.data!.docs[0].data();
            final personalInfo = PersonalInfoModel.fromFirestore(docData);
            skills = personalInfo.topSkills.cast<String>();
          }

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWeb ? 1200 : double.infinity,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(context),
                  const SizedBox(height: 50),
                  if (skills.isEmpty)
                    _buildEmptyState(context)
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isWeb
                            ? (MediaQuery.of(context).size.width > 1200 ? 4 : 3)
                            : (MediaQuery.of(context).size.width > 600 ? 3 : 2),
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: skills.length,
                      itemBuilder: (context, index) {
                        return _buildSkillCard(context, skills[index], index);
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: ProfessionalTheme.primaryGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: ProfessionalTheme.electricBlue.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(Icons.stars, color: Colors.white, size: 32),
        ),
        const SizedBox(width: 20),
        ShaderMask(
          shaderCallback: (bounds) =>
              ProfessionalTheme.primaryGradient.createShader(bounds),
          child: Text(
            'Skills',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.3, end: 0);
  }

  Widget _buildSkillCard(BuildContext context, String skill, int index) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: ProfessionalTheme.glassCard(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: ProfessionalTheme.accentGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: ProfessionalTheme.cyanGlow.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              _getSkillIcon(skill),
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            skill,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ProfessionalTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    )
        .animate(delay: (index * 50).ms)
        .fadeIn(duration: 800.ms)
        .scale(begin: const Offset(0, 0), end: const Offset(1, 1));
  }

  IconData _getSkillIcon(String skill) {
    switch (skill.toLowerCase()) {
      case 'flutter':
        return Icons.flutter_dash;
      case 'android':
      case 'android studio':
        return Icons.android;
      case 'mongodb':
      case 'database':
        return Icons.storage;
      case 'dart':
        return Icons.code;
      case 'python':
        return Icons.terminal;
      case 'github':
      case 'git':
        return Icons.source;
      case 'firebase':
        return Icons.cloud;
      default:
        return Icons.star;
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(60),
      decoration: ProfessionalTheme.glassCard(),
      child: Center(
        child: Text(
          'No skills data available',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: ProfessionalTheme.textMuted,
              ),
        ),
      ),
    );
  }
}
