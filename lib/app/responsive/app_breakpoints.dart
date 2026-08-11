/// Semantic layout breakpoints based on available width, not platform.
///
/// Values follow Material 3 window size classes and Flutter adaptive design
/// guidance. Layout decisions should derive from [LayoutBuilder] constraints
/// via [breakpointForWidth], not from `Platform` or device type.
library;

/// Named layout tiers used across the application.
enum AppBreakpoint {
  /// Narrow viewports such as phones in portrait.
  /// Single-column layouts with full-width content.
  compact,

  /// Large phones, small tablets, or moderately sized windows.
  /// Wider single-column or simple two-region layouts.
  medium,

  /// Tablets and small-to-medium desktop windows.
  /// Side-by-side panels and increased information density.
  expanded,

  /// Large desktop windows and wide browser viewports.
  /// Multi-column layouts with constrained max content width.
  large,
}

/// Centralized width thresholds for [AppBreakpoint] resolution.
abstract final class AppBreakpoints {
  /// Upper exclusive bound for [AppBreakpoint.compact].
  ///
  /// Matches Material compact window class (< 600 logical pixels).
  /// Phones in portrait typically fall here.
  static const double compact = 600;

  /// Upper exclusive bound for [AppBreakpoint.medium].
  ///
  /// Large phones in landscape, small tablets, and narrow desktop windows
  /// typically fall between [compact] and this value.
  static const double medium = 840;

  /// Upper exclusive bound for [AppBreakpoint.expanded].
  ///
  /// Tablets in landscape and medium desktop windows typically fall between
  /// [medium] and this value. Side-by-side task board layouts become practical.
  static const double expanded = 1200;

  /// Viewports at or above [expanded] resolve to [AppBreakpoint.large].
  ///
  /// Large monitors and maximized browser windows benefit from multi-column
  /// layouts while keeping readable line lengths via max-width constraints.
  static const double large = expanded;

  /// Resolves the semantic breakpoint for the given max width.
  static AppBreakpoint breakpointForWidth(double width) {
    if (width < compact) {
      return AppBreakpoint.compact;
    }
    if (width < medium) {
      return AppBreakpoint.medium;
    }
    if (width < expanded) {
      return AppBreakpoint.expanded;
    }
    return AppBreakpoint.large;
  }

  /// Human-readable label for debugging and temporary foundation screens.
  static String labelFor(AppBreakpoint breakpoint) {
    return switch (breakpoint) {
      AppBreakpoint.compact => 'Compact',
      AppBreakpoint.medium => 'Medium',
      AppBreakpoint.expanded => 'Expanded',
      AppBreakpoint.large => 'Large',
    };
  }
}
