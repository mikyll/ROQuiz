import 'package:flutter/material.dart';

/// Handle to the app-wide [ScaffoldMessenger], wired to `MaterialApp` via
/// `scaffoldMessengerKey` in `main.dart`. Lets code without a `BuildContext`
/// (e.g. [SnackBarClearingObserver]) reach the messenger.
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// Default lifetime for snackbars shown via [showAppSnackBar]. Kept short so a
/// message doesn't linger while the user moves on.
const Duration _kDefaultSnackBarDuration = Duration(seconds: 2);

/// Shows a snackbar, replacing any currently visible or queued one instead of
/// letting them stack up behind each other's timeout. Call this everywhere
/// instead of `ScaffoldMessenger.of(context).showSnackBar(...)` so messages that
/// fire one after another don't pile up.
///
/// Uses [ScaffoldMessengerState.clearSnackBars] (not `hideCurrentSnackBar`)
/// because clearing is synchronous: a rapid burst of calls leaves only the
/// newest snackbar, whereas `hideCurrentSnackBar` only animates out the current
/// one and lets the rest of the queue drain one by one.
///
/// Pass [message] for a plain text snackbar (shown for [duration]), or
/// [snackBar] for a custom one (which controls its own duration).
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showAppSnackBar(
  BuildContext context, {
  String? message,
  SnackBar? snackBar,
  Duration duration = _kDefaultSnackBarDuration,
}) {
  assert(
    (message == null) != (snackBar == null),
    "Provide exactly one of message or snackBar",
  );
  final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context)
    ..clearSnackBars();
  return messenger.showSnackBar(
    snackBar ?? SnackBar(content: Text(message!), duration: duration),
  );
}

/// Clears any visible or queued snackbars whenever the top route changes, so a
/// snackbar shown on one screen doesn't linger after navigating to another.
/// Registered in `main.dart` via `MaterialApp.navigatorObservers`.
class SnackBarClearingObserver extends NavigatorObserver {
  // clearSnackBars() drops the queue but only animates the visible one out;
  // removeCurrentSnackBar() then hides it instantly (sets the controller to 0),
  // so the snackbar is gone the moment the route changes.
  void _clearImmediately() {
    scaffoldMessengerKey.currentState
      ?..clearSnackBars()
      ..removeCurrentSnackBar();
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _clearImmediately();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _clearImmediately();
  }
}
