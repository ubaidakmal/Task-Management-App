import 'package:task_management_app/app/responsive/app_breakpoints.dart';

/// Returns a value chosen by the current semantic breakpoint.
///
/// Unspecified larger breakpoints fall back to the nearest smaller value,
/// avoiding duplicated configuration when only compact and large differ.
class ResponsiveValue<T> {
  const ResponsiveValue({
    required this.compact,
    this.medium,
    this.expanded,
    this.large,
  });

  final T compact;
  final T? medium;
  final T? expanded;
  final T? large;

  T resolve(AppBreakpoint breakpoint) {
    return switch (breakpoint) {
      AppBreakpoint.compact => compact,
      AppBreakpoint.medium => medium ?? compact,
      AppBreakpoint.expanded => expanded ?? medium ?? compact,
      AppBreakpoint.large => large ?? expanded ?? medium ?? compact,
    };
  }

  T resolveForWidth(double width) {
    return resolve(AppBreakpoints.breakpointForWidth(width));
  }
}
