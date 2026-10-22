import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../widgets/contact_card.dart';
import '../widgets/home_header.dart';
import '../widgets/home_image_carousel.dart';
import '../widgets/home_promo_banner.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/service_card.dart';
import '../widgets/training_promo_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
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
                        const HomeImageCarousel(),
                        const SizedBox(height: AppDimensions.spacing24),
                        HomePromoBanner(
                          onExplore: () =>
                              context.pushNamed(RouteNames.therapy),
                        ),
                        const SizedBox(height: AppDimensions.spacing32),
                        _SectionHeading(
                          title: l10n.quickActions,
                          subtitle: l10n.quickActionsSubtitle,
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
                              label: l10n.bookAppointment,
                              onTap: () =>
                                  context.pushNamed(RouteNames.appointments),
                            ),
                            QuickActionCard(
                              icon: Icons.spa_outlined,
                              label: l10n.exploreTherapy,
                              onTap: () =>
                                  context.pushNamed(RouteNames.therapy),
                            ),
                            QuickActionCard(
                              icon: Icons.menu_book_outlined,
                              label: l10n.trainingPrograms,
                              onTap: () =>
                                  context.pushNamed(RouteNames.training),
                            ),
                            QuickActionCard(
                              icon: Icons.chat_bubble_outline,
                              label: l10n.contactUs,
                              onTap: () => _showContactDetailsMessage(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spacing32),
                        _SectionHeading(
                          title: l10n.ourServices,
                          subtitle: l10n.serviceInformationPreparing,
                          trailing: TextButton(
                            onPressed: () =>
                                context.pushNamed(RouteNames.therapy),
                            child: Text(l10n.viewAll),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacing16),
                        _ServiceCards(
                          onTap: () => context.pushNamed(RouteNames.therapy),
                        ),
                        const SizedBox(height: AppDimensions.spacing32),
                        _SectionHeading(
                          title: l10n.trainingPrograms,
                          subtitle: l10n.trainingSectionSubtitle,
                        ),
                        const SizedBox(height: AppDimensions.spacing16),
                        TrainingPromoCard(
                          onExplore: () =>
                              context.pushNamed(RouteNames.training),
                        ),
                        const SizedBox(height: AppDimensions.spacing32),
                        _SectionHeading(title: l10n.contactAndLocation),
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
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.contactDetailsUnavailable,
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
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.w700,
      ),
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
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
    final l10n = AppLocalizations.of(context)!;
    final services = [
      (
        icon: Icons.spa_outlined,
        title: l10n.therapyServiceTitle,
        description: l10n.serviceDetailsUnavailable,
      ),
      (
        icon: Icons.health_and_safety_outlined,
        title: l10n.consultation,
        description: l10n.consultationDetails,
      ),
      (
        icon: Icons.widgets_outlined,
        title: l10n.therapyPackages,
        description: l10n.packageDetailsUnavailable,
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
