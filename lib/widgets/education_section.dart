import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/portfolio_data.dart';
import '../theme/professional_theme.dart';

class EducationSection extends StatelessWidget {
  final GlobalKey sectionKey;
  final bool isWeb;

  const EducationSection({
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
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isWeb ? 1000 : double.infinity,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(context),
              const SizedBox(height: 50),
              Container(
                padding:
                    EdgeInsets.all(width < 600 ? 20 : (width < 1200 ? 30 : 40)),
                decoration: ProfessionalTheme.glassCard(),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: ProfessionalTheme.accentGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: ProfessionalTheme.cyanGlow.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.school,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => ProfessionalTheme
                                .primaryGradient
                                .createShader(bounds),
                            child: Text(
                              PortfolioData.education.degree,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            PortfolioData.education.institution,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: ProfessionalTheme.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
                  .animate(delay: 200.ms)
                  .fadeIn(duration: 800.ms)
                  .slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
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
          child:
              const Icon(Icons.school_outlined, color: Colors.white, size: 32),
        ),
        const SizedBox(width: 20),
        ShaderMask(
          shaderCallback: (bounds) =>
              ProfessionalTheme.primaryGradient.createShader(bounds),
          child: Text(
            'Education',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.3, end: 0);
  }
}
