import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_portfolio/models/work_experince_data_model.dart';
import '../theme/professional_theme.dart';

class ExperienceSection extends StatefulWidget {
  final GlobalKey sectionKey;
  final bool isWeb;

  const ExperienceSection({
    required this.sectionKey,
    required this.isWeb,
    super.key,
  });

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  late Future<DocumentSnapshot> _experienceFuture;

  @override
  void initState() {
    super.initState();
    _experienceFuture = FirebaseFirestore.instance
        .collection('workExperience')
        .doc('experience')
        .get();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = width < 600 ? 20.0 : (width < 1200 ? 40.0 : 100.0);

    return Container(
      key: widget.sectionKey,
      padding: EdgeInsets.all(padding),
      decoration: const BoxDecoration(
        gradient: ProfessionalTheme.bgGradient,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: widget.isWeb ? 1200 : double.infinity,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(context, Icons.work_outline, 'Experience'),
              const SizedBox(height: 50),
              FutureBuilder<DocumentSnapshot>(
                future: _experienceFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: ProfessionalTheme.electricBlue,
                      ),
                    );
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return _buildEmptyState('No experience data available');
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  final experienceList = data['experience'] as List<dynamic>;

                  final experiences = experienceList
                      .map((e) => WorkExperienceDataModel.fromFirestore(
                          e as Map<String, dynamic>))
                      .toList();

                  return Column(
                    children: experiences.asMap().entries.map((entry) {
                      return _buildExperienceCard(entry.value, entry.key);
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, IconData icon, String title) {
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
          child: Icon(icon, color: Colors.white, size: 32),
        ),
        const SizedBox(width: 20),
        ShaderMask(
          shaderCallback: (bounds) =>
              ProfessionalTheme.primaryGradient.createShader(bounds),
          child: Text(
            title,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.3, end: 0);
  }

  Widget _buildExperienceCard(WorkExperienceDataModel experience, int index) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      padding: EdgeInsets.all(width < 600 ? 20 : (width < 1200 ? 30 : 40)),
      decoration: ProfessionalTheme.glassCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: ProfessionalTheme.accentGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: ProfessionalTheme.cyanGlow.withValues(alpha: 0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.business_center,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      experience.position,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: ProfessionalTheme.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 6),
                    ShaderMask(
                      shaderCallback: (bounds) => ProfessionalTheme
                          .primaryGradient
                          .createShader(bounds),
                      child: Text(
                        experience.company,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: ProfessionalTheme.textMuted,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      experience.duration,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ProfessionalTheme.textSecondary,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 18,
                    color: ProfessionalTheme.textMuted,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      experience.location,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ProfessionalTheme.textSecondary,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (experience.achievements.isNotEmpty) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: ProfessionalTheme.darkBg2.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.05),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Key Achievements',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: ProfessionalTheme.electricBlue,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ...experience.achievements.map((achievement) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8, right: 14),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              gradient: ProfessionalTheme.primaryGradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: ProfessionalTheme.electricBlue
                                      .withValues(alpha: 0.5),
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Text(
                              achievement,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: ProfessionalTheme.textSecondary,
                                    height: 1.6,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ],
      ),
    )
        .animate(delay: (index * 100).ms)
        .fadeIn(duration: 800.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(60),
      decoration: ProfessionalTheme.glassCard(),
      child: Center(
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: ProfessionalTheme.textMuted,
              ),
        ),
      ),
    );
  }
}
