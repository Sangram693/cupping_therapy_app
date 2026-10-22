import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedLocale = ref.watch(localeProvider);
    final selectedThemeMode = ref.watch(themeProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(fallbackRouteName: RouteNames.home),
        title: Text(l10n.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.language,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing4),
                  Text(
                    l10n.chooseLanguage,
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppDimensions.spacing8),
                  RadioGroup<Locale>(
                    groupValue: selectedLocale,
                    onChanged: (locale) {
                      if (locale != null) {
                        _updateLocale(context, ref, locale);
                      }
                    },
                    child: Column(
                      children: [
                        RadioListTile<Locale>(
                          value: const Locale('en'),
                          title: Text(l10n.english),
                          activeColor: colorScheme.primary,
                          contentPadding: EdgeInsets.zero,
                        ),
                        RadioListTile<Locale>(
                          value: const Locale('bn'),
                          title: Text(l10n.bengali),
                          activeColor: colorScheme.primary,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacing16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.appearance,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing4),
                  Text(
                    l10n.chooseTheme,
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppDimensions.spacing8),
                  RadioGroup<ThemeMode>(
                    groupValue: selectedThemeMode,
                    onChanged: (themeMode) {
                      if (themeMode != null) {
                        _updateTheme(context, ref, themeMode);
                      }
                    },
                    child: Column(
                      children: [
                        RadioListTile<ThemeMode>(
                          value: ThemeMode.system,
                          title: Text(l10n.systemDefault),
                          activeColor: colorScheme.primary,
                          contentPadding: EdgeInsets.zero,
                        ),
                        RadioListTile<ThemeMode>(
                          value: ThemeMode.light,
                          title: Text(l10n.lightTheme),
                          activeColor: colorScheme.primary,
                          contentPadding: EdgeInsets.zero,
                        ),
                        RadioListTile<ThemeMode>(
                          value: ThemeMode.dark,
                          title: Text(l10n.darkTheme),
                          activeColor: colorScheme.primary,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateTheme(
    BuildContext context,
    WidgetRef ref,
    ThemeMode themeMode,
  ) async {
    try {
      await ref.read(themeProvider.notifier).setThemeMode(themeMode);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.themeSaveFailed),
            ),
          );
      }
    }
  }

  Future<void> _updateLocale(
    BuildContext context,
    WidgetRef ref,
    Locale locale,
  ) async {
    try {
      await ref.read(localeProvider.notifier).setLocale(locale);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.languageSaveFailed),
            ),
          );
      }
    }
  }
}
