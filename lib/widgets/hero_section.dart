import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/portfolio_data.dart';
import '../models/personal_info_model.dart';
import '../theme/professional_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;

class HeroSection extends StatefulWidget {
  final Map<String, GlobalKey> sectionKeys;
  final Function(GlobalKey) onSectionTap;
  final bool isWeb;

  const HeroSection({
    super.key,
    required this.sectionKeys,
    required this.onSectionTap,
    required this.isWeb,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 600;
    final isMedium = size.width >= 600 && size.width < 1200;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ProfessionalTheme.darkBg,
            ProfessionalTheme.darkBg2,
            ProfessionalTheme.darkBg,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Animated background particles
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(_controller.value),
                size: Size.infinite,
              );
            },
          ),
          // Content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmall ? 20 : (isMedium ? 40 : 60),
                  vertical: isSmall ? 30 : 40,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile circle with glow
                    Container(
                      width: isSmall ? 120 : (isMedium ? 150 : 200),
                      height: isSmall ? 120 : (isMedium ? 150 : 200),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: ProfessionalTheme.primaryGradient,
                        boxShadow: [
                          BoxShadow(
                            color:
                                ProfessionalTheme.electricBlue.withOpacity(0.6),
                            blurRadius: isSmall ? 40 : 60,
                            spreadRadius: isSmall ? 10 : 20,
                          ),
                          BoxShadow(
                            color:
                                ProfessionalTheme.neonPurple.withOpacity(0.4),
                            blurRadius: isSmall ? 60 : 80,
                            spreadRadius: isSmall ? 5 : 10,
                            offset:
                                Offset(isSmall ? 10 : 20, isSmall ? 10 : 20),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person,
                          size: isSmall ? 60 : (isMedium ? 80 : 100),
                          color: ProfessionalTheme.darkBg,
                        ),
                      ),
                    )
                        .animate(onPlay: (controller) => controller.repeat())
                        .shimmer(
                          duration: 2000.ms,
                          color: Colors.white.withOpacity(0.3),
                        )
                        .animate()
                        .fadeIn(duration: 800.ms)
                        .scale(
                          begin: const Offset(0, 0),
                          end: const Offset(1, 1),
                          curve: Curves.elasticOut,
                        ),
                    SizedBox(height: isSmall ? 30 : 50),

                    // Name and title from Firebase
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('personal_info')
                          .snapshots(),
                      builder: (context, snapshot) {
                        String displayName = PortfolioData.name;
                        String displayTitle = PortfolioData.title;
                        String displayLocation = PortfolioData.location;

                        if (snapshot.hasData &&
                            snapshot.data!.docs.isNotEmpty) {
                          final docData = snapshot.data!.docs[0].data()
                              as Map<String, dynamic>;
                          final personalInfo = PersonalInfoModel.fromFirestore(
                            docData,
                          );

                          displayName = personalInfo.fullName.isNotEmpty
                              ? personalInfo.fullName
                              : PortfolioData.name;
                          displayTitle = personalInfo.title.isNotEmpty
                              ? personalInfo.title
                              : PortfolioData.title;
                          displayLocation = personalInfo.location.isNotEmpty
                              ? personalInfo.location
                              : PortfolioData.location;
                        }

                        return Column(
                          children: [
                            // Gradient text name
                            ShaderMask(
                              shaderCallback: (bounds) => ProfessionalTheme
                                  .primaryGradient
                                  .createShader(bounds),
                              child: Text(
                                displayName,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                      fontSize:
                                          isSmall ? 32 : (isMedium ? 48 : 72),
                                      color: Colors.white,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            )
                                .animate(delay: 200.ms)
                                .fadeIn(duration: 800.ms)
                                .slideY(begin: -0.3, end: 0),
                            SizedBox(height: isSmall ? 12 : 20),

                            // Title
                            Text(
                              displayTitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontSize:
                                        isSmall ? 18 : (isMedium ? 24 : 32),
                                    color: ProfessionalTheme.textSecondary,
                                  ),
                              textAlign: TextAlign.center,
                            )
                                .animate(delay: 400.ms)
                                .fadeIn(duration: 800.ms)
                                .slideY(begin: 0.3, end: 0),
                            SizedBox(height: isSmall ? 8 : 12),

                            // Location
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: ProfessionalTheme.electricBlue,
                                  size: isSmall ? 16 : 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  displayLocation,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontSize: isSmall ? 14 : 16,
                                        color: ProfessionalTheme.textMuted,
                                      ),
                                ),
                              ],
                            ).animate(delay: 600.ms).fadeIn(duration: 800.ms),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: isSmall ? 40 : 60),

                    // CTA Buttons
                    Wrap(
                      spacing: isSmall ? 12 : 20,
                      runSpacing: isSmall ? 12 : 20,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildGradientButton(
                          label: isSmall ? '📧 Contact' : '📧  Contact Me',
                          onPressed: () => widget
                              .onSectionTap(widget.sectionKeys['contact']!),
                          isSmall: isSmall,
                        ),
                        _buildOutlineButton(
                          label: isSmall ? '💼 Projects' : '💼  View Projects',
                          onPressed: () => widget
                              .onSectionTap(widget.sectionKeys['projects']!),
                          isSmall: isSmall,
                        ),
                      ],
                    ).animate(delay: 800.ms).fadeIn(duration: 800.ms).scale(),

                    SizedBox(height: isSmall ? 50 : 80),

                    // Scroll indicator
                    Column(
                      children: [
                        Text(
                          'Scroll to explore',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: ProfessionalTheme.textMuted),
                        ),
                        const SizedBox(height: 12),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: ProfessionalTheme.electricBlue,
                          size: 32,
                        )
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            .moveY(
                              begin: 0,
                              end: 10,
                              duration: 1500.ms,
                              curve: Curves.easeInOut,
                            ),
                      ],
                    ).animate(delay: 1000.ms).fadeIn(duration: 800.ms),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientButton({
    required String label,
    required VoidCallback onPressed,
    required bool isSmall,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: ProfessionalTheme.primaryGradient,
        borderRadius: BorderRadius.circular(isSmall ? 12 : 16),
        boxShadow: [
          BoxShadow(
            color: ProfessionalTheme.electricBlue.withOpacity(0.3),
            blurRadius: isSmall ? 15 : 20,
            offset: Offset(0, isSmall ? 6 : 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(
            horizontal: isSmall ? 24 : 40,
            vertical: isSmall ? 16 : 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isSmall ? 12 : 16),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: isSmall ? 14 : 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildOutlineButton({
    required String label,
    required VoidCallback onPressed,
    required bool isSmall,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: isSmall ? 24 : 40,
          vertical: isSmall ? 16 : 24,
        ),
        side: BorderSide(
          color: ProfessionalTheme.electricBlue.withOpacity(0.5),
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isSmall ? 12 : 16),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: isSmall ? 14 : 18,
          fontWeight: FontWeight.w600,
          color: ProfessionalTheme.electricBlue,
        ),
      ),
    );
  }
}

// Custom painter for animated particles
class ParticlePainter extends CustomPainter {
  final double animationValue;

  ParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ProfessionalTheme.electricBlue.withOpacity(0.1);

    for (int i = 0; i < 50; i++) {
      final x = (i * 137.5) % size.width;
      final y = ((i * 50 + animationValue * 100) % size.height);
      final radius = (math.sin(i + animationValue * 2 * math.pi) + 1) * 2;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
