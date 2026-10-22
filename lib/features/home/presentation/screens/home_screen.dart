import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/services/app_color_service.dart';
import '../widgets/contact_card.dart';
import '../widgets/home_header.dart';
import '../widgets/home_promo_banner.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/service_card.dart';
import '../widgets/training_promo_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth =
                constraints.maxWidth -
                AppDimensions.screenPaddingHorizontal * 2;
            final actionColumns = contentWidth >= 900 ? 4 : 2;

            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppDimensions.maxContentWidth,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.screenPaddingHorizontal,
                      vertical: AppDimensions.screenPaddingVertical,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HomeHeader(),
                        const SizedBox(height: AppDimensions.spacing24),
                        HomePromoBanner(
                          onExplore: () =>
                              context.pushNamed(RouteNames.therapy),
                        ),
                        const SizedBox(height: AppDimensions.spacing32),
                        _SectionHeading(
                          title: 'Quick actions',
                          subtitle: 'Find what you need, quickly.',
                        ),
                        const SizedBox(height: AppDimensions.spacing16),
                        GridView.count(
                          crossAxisCount: actionColumns,
                          crossAxisSpacing: AppDimensions.spacing12,
                          mainAxisSpacing: AppDimensions.spacing12,
                          childAspectRatio: actionColumns == 2 ? 1.2 : 1.45,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            QuickActionCard(
                              icon: Icons.event_available_outlined,
                              label: 'Book an Appointment',
                              onTap: () =>
                                  context.pushNamed(RouteNames.appointments),
                            ),
                            QuickActionCard(
                              icon: Icons.spa_outlined,
                              label: 'Explore Therapy',
                              onTap: () =>
                                  context.pushNamed(RouteNames.therapy),
                            ),
                            QuickActionCard(
                              icon: Icons.menu_book_outlined,
                              label: 'Training Programs',
                              onTap: () =>
                                  context.pushNamed(RouteNames.training),
                            ),
                            QuickActionCard(
                              icon: Icons.chat_bubble_outline,
                              label: 'Contact Us',
                              onTap: () => _showContactDetailsMessage(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spacing32),
                        _SectionHeading(
                          title: 'Our Services',
                          subtitle: 'Service information is being prepared.',
                          trailing: TextButton(
                            onPressed: () =>
                                context.pushNamed(RouteNames.therapy),
                            child: const Text('View all'),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacing16),
                        _ServiceCards(
                          onTap: () => context.pushNamed(RouteNames.therapy),
                        ),
                        const SizedBox(height: AppDimensions.spacing32),
                        _SectionHeading(
                          title: 'Training Programs',
                          subtitle: 'Learn more about practical training.',
                        ),
                        const SizedBox(height: AppDimensions.spacing16),
                        TrainingPromoCard(
                          onExplore: () =>
                              context.pushNamed(RouteNames.training),
                        ),
                        const SizedBox(height: AppDimensions.spacing32),
                        _SectionHeading(title: 'Contact & location'),
                        const SizedBox(height: AppDimensions.spacing16),
                        ContactCard(
                          onContact: () => _showContactDetailsMessage(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showContactDetailsMessage(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Contact details are not available yet. Please check back soon.',
          ),
        ),
      );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, this.subtitle, this.trailing});

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final titleWidget = Text(
      title,
      style: Theme.of(context).textTheme.titleLarge
          ?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
    );
    final subtitleText = subtitle;

    if (trailing == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleWidget,
          if (subtitleText != null) ...[
            const SizedBox(height: AppDimensions.spacing4),
            Text(
              subtitleText,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleWidget,
              if (subtitleText != null) ...[
                const SizedBox(height: AppDimensions.spacing4),
                Text(
                  subtitleText,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ],
          ),
        ),
        trailing!,
      ],
    );
  }
}

class _ServiceCards extends StatelessWidget {
  const _ServiceCards({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final services = [
      (
        icon: Icons.spa_outlined,
        title: 'Hijama Therapy',
        description: 'Contact us for service details and availability.',
      ),
      (
        icon: Icons.health_and_safety_outlined,
        title: 'Consultation',
        description: 'Ask us about available consultation options.',
      ),
      (
        icon: Icons.widgets_outlined,
        title: 'Therapy Packages',
        description: 'Package information will be shared soon.',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 700) {
          return Column(
            children: [
              for (var index = 0; index < services.length; index++) ...[
                if (index > 0) const SizedBox(height: AppDimensions.spacing12),
                ServiceCard(
                  icon: services[index].icon,
                  title: services[index].title,
                  description: services[index].description,
                  onTap: onTap,
                ),
              ],
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var index = 0; index < services.length; index++) ...[
              if (index > 0) const SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: ServiceCard(
                  icon: services[index].icon,
                  title: services[index].title,
                  description: services[index].description,
                  onTap: onTap,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
