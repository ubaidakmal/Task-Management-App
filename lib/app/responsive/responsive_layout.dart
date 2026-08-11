import 'package:flutter/widgets.dart';

import 'package:task_management_app/app/responsive/app_breakpoints.dart';

/// Builds a different widget tree per semantic breakpoint using [LayoutBuilder].
///
/// Larger breakpoints fall back to the nearest defined smaller builder so
/// feature code does not need to repeat identical subtrees.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.compact,
    this.medium,
    this.expanded,
    this.large,
  });

  final Widget compact;
  final Widget? medium;
  final Widget? expanded;
  final Widget? large;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = AppBreakpoints.breakpointForWidth(
          constraints.maxWidth,
        );

        final child = switch (breakpoint) {
          AppBreakpoint.compact => compact,
          AppBreakpoint.medium => medium ?? compact,
          AppBreakpoint.expanded => expanded ?? medium ?? compact,
          AppBreakpoint.large => large ?? expanded ?? medium ?? compact,
        };

        return child;
      },
    );
  }
}
