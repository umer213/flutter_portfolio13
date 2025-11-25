import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/hero_section.dart';
import '../widgets/profile_section.dart';
import '../widgets/experience_section.dart';
import '../widgets/projects_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/education_section.dart';
import '../widgets/contact_section.dart';

class ParallaxPortfolioScreen extends StatefulWidget {
  const ParallaxPortfolioScreen({super.key});

  @override
  State<ParallaxPortfolioScreen> createState() =>
      _ParallaxPortfolioScreenState();
}

class _ParallaxPortfolioScreenState extends State<ParallaxPortfolioScreen> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _profileKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _educationKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  Map<String, GlobalKey> get _sectionKeys => {
        'profile': _profileKey,
        'experience': _experienceKey,
        'projects': _projectsKey,
        'skills': _skillsKey,
        'education': _educationKey,
        'contact': _contactKey,
      };

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isWeb = kIsWeb;

    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            SizedBox(
              height: screenHeight,
              child: HeroSection(
                sectionKeys: _sectionKeys,
                onSectionTap: _scrollToSection,
                isWeb: isWeb,
              ),
            ),
            ProfileSection(sectionKey: _profileKey, isWeb: isWeb),
            ExperienceSection(sectionKey: _experienceKey, isWeb: isWeb),
            ProjectsSection(
              sectionKey: _projectsKey,
              isWeb: isWeb,
              onLaunchURL: _launchURL,
            ),
            SkillsSection(sectionKey: _skillsKey, isWeb: isWeb),
            EducationSection(sectionKey: _educationKey, isWeb: isWeb),
            ContactSection(
              sectionKey: _contactKey,
              isWeb: isWeb,
              onLaunchURL: _launchURL,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open $url')),
        );
      }
    }
  }
}
