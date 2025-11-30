import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    final width = MediaQuery.of(context).size.width;
    final padding = width < 600 ? 20.0 : (width < 1200 ? 40.0 : 100.0);

    return Container(
      key: sectionKey,
      padding: EdgeInsets.all(padding),
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
                        crossAxisCount: width < 600 ? 2 : (width < 900 ? 3 : 4),
                        crossAxisSpacing: width < 600 ? 12 : 24,
                        mainAxisSpacing: width < 600 ? 12 : 24,
                        childAspectRatio: 1.0,
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
                color: ProfessionalTheme.electricBlue.withValues(alpha: 0.3),
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
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final metadata = _getSkillMetadata(skill);

    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 20),
      decoration: ProfessionalTheme.glassCard().copyWith(
        border: Border.all(
          color: metadata.color.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(isMobile ? 10 : 16),
            decoration: BoxDecoration(
              color: metadata.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
              boxShadow: [
                BoxShadow(
                  color: metadata.color.withValues(alpha: 0.2),
                  blurRadius: isMobile ? 12 : 20,
                  spreadRadius: isMobile ? 1 : 2,
                ),
              ],
            ),
            child: FaIcon(
              metadata.icon,
              color: metadata.color,
              size: isMobile ? 24 : 32,
            ),
          ),
          SizedBox(height: isMobile ? 8 : 12),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                skill,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: ProfessionalTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: isMobile ? 14 : 18,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    )
        .animate(delay: (index * 50).ms)
        .fadeIn(duration: 800.ms)
        .scale(begin: const Offset(0, 0), end: const Offset(1, 1));
  }

  _SkillMetadata _getSkillMetadata(String skill) {
    final s = skill.toLowerCase();
    if (s.contains('flutter')) {
      return const _SkillMetadata(FontAwesomeIcons.flutter, Color(0xFF02569B));
    } else if (s.contains('dart')) {
      // Dart icon not available in FontAwesome, using code icon
      return const _SkillMetadata(FontAwesomeIcons.code, Color(0xFF0175C2));
    } else if (s.contains('firebase')) {
      return const _SkillMetadata(FontAwesomeIcons.fire, Color(0xFFFFCA28));
    } else if (s.contains('android')) {
      return const _SkillMetadata(FontAwesomeIcons.android, Color(0xFF3DDC84));
    } else if (s.contains('ios') || s.contains('apple')) {
      return const _SkillMetadata(FontAwesomeIcons.apple, Color(0xFFFFFFFF));
    } else if (s.contains('python')) {
      return const _SkillMetadata(FontAwesomeIcons.python, Color(0xFF3776AB));
    } else if (s.contains('java') && !s.contains('script')) {
      return const _SkillMetadata(FontAwesomeIcons.java, Color(0xFF007396));
    } else if (s.contains('javascript') || s.contains('js')) {
      return const _SkillMetadata(FontAwesomeIcons.js, Color(0xFFF7DF1E));
    } else if (s.contains('react')) {
      return const _SkillMetadata(FontAwesomeIcons.react, Color(0xFF61DAFB));
    } else if (s.contains('node')) {
      return const _SkillMetadata(FontAwesomeIcons.nodeJs, Color(0xFF339933));
    } else if (s.contains('html')) {
      return const _SkillMetadata(FontAwesomeIcons.html5, Color(0xFFE34F26));
    } else if (s.contains('css')) {
      return const _SkillMetadata(FontAwesomeIcons.css3Alt, Color(0xFF1572B6));
    } else if (s.contains('git') || s.contains('github')) {
      return const _SkillMetadata(FontAwesomeIcons.github, Color(0xFFF05032));
    } else if (s.contains('docker')) {
      return const _SkillMetadata(FontAwesomeIcons.docker, Color(0xFF2496ED));
    } else if (s.contains('aws')) {
      return const _SkillMetadata(FontAwesomeIcons.aws, Color(0xFFFF9900));
    } else if (s.contains('cloud')) {
      return const _SkillMetadata(FontAwesomeIcons.cloud, Color(0xFF4285F4));
    } else if (s.contains('database') ||
        s.contains('sql') ||
        s.contains('mongo')) {
      return const _SkillMetadata(FontAwesomeIcons.database, Color(0xFF47A248));
    } else if (s.contains('figma')) {
      return const _SkillMetadata(FontAwesomeIcons.figma, Color(0xFFF24E1E));
    }

    // Default
    return const _SkillMetadata(
        FontAwesomeIcons.code, ProfessionalTheme.electricBlue);
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

class _SkillMetadata {
  final IconData icon;
  final Color color;

  const _SkillMetadata(this.icon, this.color);
}
