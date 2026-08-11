import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:task_management_app/app/theme/app_theme_extensions.dart';
import 'package:task_management_app/app/theme/theme_mode_provider.dart';
import 'package:task_management_app/core/constants/app_strings.dart';

/// Opens a styled bottom sheet for choosing app appearance.
Future<void> showThemeModeSheet(BuildContext context, WidgetRef ref) {
  final theme = Theme.of(context);
  final spacing = theme.extension<AppSpacing>() ?? AppSpacing.standard;
  final radii = theme.extension<AppRadii>() ?? AppRadii.standard;
  final accents = theme.extension<AppAccentColors>() ?? AppAccentColors.light;

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: theme.colorScheme.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(radii.lg)),
    ),
    builder: (sheetContext) {
      return Consumer(
        builder: (context, ref, _) {
          final selected = ref.watch(themeModeProvider);
          final colorScheme = theme.colorScheme;

          return Padding(
            padding: EdgeInsets.fromLTRB(
              spacing.lg,
              spacing.sm,
              spacing.lg,
              spacing.lg + MediaQuery.viewInsetsOf(sheetContext).bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.only(bottom: spacing.md),
                    decoration: BoxDecoration(
                      color: colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(radii.full),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(spacing.md),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accents.headerGradientStart.withValues(alpha: 0.12),
                        accents.headerGradientEnd.withValues(alpha: 0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(radii.md),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              accents.headerGradientStart,
                              accents.headerGradientEnd,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(radii.sm),
                        ),
                        child: const Icon(
                          Icons.palette_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: spacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.appearance,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              AppStrings.appearanceSubtitle,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: spacing.lg),
                _ThemeOptionTile(
                  selected: selected == ThemeMode.light,
                  title: AppStrings.themeLight,
                  description: AppStrings.themeLightDescription,
                  icon: Icons.wb_sunny_rounded,
                  iconBackground: const Color(0xFFFEF3C7),
                  iconColor: const Color(0xFFD97706),
                  onTap: () => _select(ref, sheetContext, ThemeMode.light),
                ),
                SizedBox(height: spacing.sm),
                _ThemeOptionTile(
                  selected: selected == ThemeMode.dark,
                  title: AppStrings.themeDark,
                  description: AppStrings.themeDarkDescription,
                  icon: Icons.nights_stay_rounded,
                  iconBackground: const Color(0xFF1E1B4B),
                  iconColor: const Color(0xFF818CF8),
                  onTap: () => _select(ref, sheetContext, ThemeMode.dark),
                ),
                SizedBox(height: spacing.sm),
                _ThemeOptionTile(
                  selected: selected == ThemeMode.system,
                  title: AppStrings.themeSystem,
                  description: AppStrings.themeSystemDescription,
                  icon: Icons.settings_suggest_rounded,
                  iconBackground: colorScheme.primaryContainer,
                  iconColor: colorScheme.primary,
                  onTap: () => _select(ref, sheetContext, ThemeMode.system),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

void _select(WidgetRef ref, BuildContext context, ThemeMode mode) {
  ref.read(themeModeProvider.notifier).setThemeMode(mode);
  Navigator.of(context).pop();
}

class _ThemeOptionTile extends StatelessWidget {
  const _ThemeOptionTile({
    required this.selected,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.onTap,
  });

  final bool selected;
  final String title;
  final String description;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = theme.extension<AppSpacing>() ?? AppSpacing.standard;
    final radii = theme.extension<AppRadii>() ?? AppRadii.standard;

    return Material(
      color: selected
          ? colorScheme.primaryContainer.withValues(alpha: 0.45)
          : colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(radii.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radii.md),
        child: Container(
          padding: EdgeInsets.all(spacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radii.md),
            border: Border.all(
              color: selected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(radii.sm),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check_circle_rounded, color: colorScheme.primary)
              else
                Icon(
                  Icons.circle_outlined,
                  color: colorScheme.outlineVariant,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
