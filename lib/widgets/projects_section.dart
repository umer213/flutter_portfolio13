import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_portfolio/models/project_data.model.dart';
import '../theme/professional_theme.dart';

class ProjectsSection extends StatefulWidget {
  final GlobalKey sectionKey;
  final bool isWeb;
  final Function(String) onLaunchURL;

  const ProjectsSection({
    required this.sectionKey,
    required this.isWeb,
    required this.onLaunchURL,
    super.key,
  });

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  late Future<DocumentSnapshot> _projectsFuture;

  @override
  void initState() {
    super.initState();
    _projectsFuture = FirebaseFirestore.instance
        .collection('projects')
        .doc('my_projects')
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
              _buildSectionHeader(context),
              const SizedBox(height: 50),
              FutureBuilder<DocumentSnapshot>(
                future: _projectsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: ProfessionalTheme.electricBlue,
                      ),
                    );
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return _buildEmptyState('No projects available');
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  final projectsList = data['projects'] as List<dynamic>;

                  final projects = projectsList
                      .map((e) => ProjectDataModel.fromFirestore(
                          e as Map<String, dynamic>))
                      .toList();

                  return Column(
                    children: projects.asMap().entries.map((entry) {
                      return _buildProjectCard(entry.value, entry.key);
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
          child: const Icon(Icons.rocket_launch, color: Colors.white, size: 32),
        ),
        const SizedBox(width: 20),
        ShaderMask(
          shaderCallback: (bounds) =>
              ProfessionalTheme.primaryGradient.createShader(bounds),
          child: Text(
            'Projects',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.3, end: 0);
  }

  Widget _buildProjectCard(ProjectDataModel project, int index) {
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
                child: const Icon(Icons.code, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ShaderMask(
                  shaderCallback: (bounds) =>
                      ProfessionalTheme.primaryGradient.createShader(bounds),
                  child: Text(
                    project.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            project.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: ProfessionalTheme.textSecondary,
                  height: 1.7,
                ),
          ),
          if (project.playStoreLink.isNotEmpty ||
              project.appStoreLink.isNotEmpty) ...[
            const SizedBox(height: 30),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                if (project.playStoreLink.isNotEmpty)
                  _buildStoreButton(
                    icon: Icons.android,
                    label: 'Play Store',
                    onPressed: () => widget.onLaunchURL(project.playStoreLink),
                  ),
                if (project.appStoreLink.isNotEmpty)
                  _buildStoreButton(
                    icon: Icons.apple,
                    label: 'App Store',
                    onPressed: () => widget.onLaunchURL(project.appStoreLink),
                  ),
              ],
            ),
          ],
        ],
      ),
    )
        .animate(delay: (index * 100).ms)
        .fadeIn(duration: 800.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildStoreButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: ProfessionalTheme.primaryGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: ProfessionalTheme.electricBlue.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
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
