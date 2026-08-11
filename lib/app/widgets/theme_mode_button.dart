import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:task_management_app/app/theme/theme_mode_provider.dart';
import 'package:task_management_app/app/widgets/theme_mode_sheet.dart';
import 'package:task_management_app/core/constants/app_strings.dart';

/// App bar control that opens the appearance bottom sheet.
class ThemeModeButton extends ConsumerWidget {
  const ThemeModeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Tooltip(
        message: AppStrings.appearance,
        child: IconButton.filledTonal(
          key: const Key('theme_mode_button'),
          onPressed: () => showThemeModeSheet(context, ref),
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.primaryContainer.withValues(
              alpha: 0.7,
            ),
            foregroundColor: colorScheme.primary,
          ),
          icon: Icon(_triggerIcon(themeMode)),
        ),
      ),
    );
  }

  static IconData _triggerIcon(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => Icons.wb_sunny_rounded,
      ThemeMode.dark => Icons.nights_stay_rounded,
      ThemeMode.system => Icons.palette_rounded,
    };
  }
}
