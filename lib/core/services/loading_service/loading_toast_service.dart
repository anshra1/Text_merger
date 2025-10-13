import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:text_merger/core/services/loading_service/widget/progress_indicator_widget.dart';
import 'package:toastification/toastification.dart';

/// Rules for using LoadingToastService:
/// 1. Service maintains its own state - no manual disposal needed
/// 2. Show/hide should be called in pairs
/// 3. Only one loading toast can be shown at a time
/// 4. Must be accessed through dependency injection
///
/// Example usage:
/// ```dart
/// final loadingService = sl<LoadingToastService>();
/// try {
///   loadingService.show(context, child: LoadingWidget());
///   // Do work...
/// } finally {
///   loadingService.hide();
/// }
/// ```

class LoadingToastService {
  LoadingToastService({
    required Toastification toastification,
    required ValueNotifier<(String message, double progress)> dataNotifier,
  }) : _toastification = toastification,
       _dataNotifier = dataNotifier;

  final Toastification _toastification;

  final ValueNotifier<(String message, double progress)> _dataNotifier;

  ToastificationItem? _toastItem;

  bool get isShowing => _toastItem != null;

  void show(
    BuildContext context, {
    required Widget child,
    Duration? autoCloseDuration,
    String initialMessage = 'Loading...',
  }) {
    if (_toastItem != null) {
      update(message: initialMessage);
      return;
    }

    _dataNotifier.value = (initialMessage, 0.0);

    _toastItem = toastification.showCustom(
      context: context,
      autoCloseDuration: autoCloseDuration ?? const Duration(seconds: 12),
      config: const ToastificationConfig(
        blockBackgroundInteraction: true,
        alignment: Alignment.center,
      ),
      builder: (context, item) {
        return _LoadingWidget(
          dataNotifier: _dataNotifier,
          child: child,
        );
      },
    );
  }

  void update({String? message, double? progress}) {
    if (_toastItem == null) return;

    if (message != null && progress != null) {
      _dataNotifier.value = (message, progress);
    }
  }

  void hide() {
    if (_toastItem != null) {
      _toastification.dismiss(_toastItem!);
      _toastItem = null;
    }
  }
}

class _LoadingWidget extends HookWidget {
  const _LoadingWidget({
    required this.dataNotifier,
    required this.child,
  });

  final ValueNotifier<(String message, double progress)> dataNotifier;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final data = useValueListenable(dataNotifier);

    if (child is ProgressIndicatorWidget) {
      return ProgressIndicatorWidget(
        message: data.$1,
        progress: data.$2,
      );
    }

    return child;
  }
}
