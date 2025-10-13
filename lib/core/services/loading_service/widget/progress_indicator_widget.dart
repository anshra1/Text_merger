import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:text_merger/core/services/loading_service/widget/global_loading_overlay.dart';

/// A reusable widget for displaying progress with a spinner, message,
/// and a determinate progress bar.
class ProgressIndicatorWidget extends HookWidget {
  const ProgressIndicatorWidget({
    required this.message,
    required this.progress,
    super.key,
  });

  final String message;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return AnimatedFileUploadDialog(fileName: message, progress: progress);
  }
}
