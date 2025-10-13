import 'package:flutter/material.dart';
import 'package:material_design_system/material_design_system.dart';

class AnimatedFileUploadDialog extends StatefulWidget {
  const AnimatedFileUploadDialog({
    required this.fileName,
    required this.progress,
    this.onCancel,
    super.key,
  });

  final String fileName;
  final double progress;
  final VoidCallback? onCancel;

  @override
  State<AnimatedFileUploadDialog> createState() => _AnimatedFileUploadDialogState();
}

class _AnimatedFileUploadDialogState extends State<AnimatedFileUploadDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _iconController;
  late final Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // continuous rotation

    _iconAnimation = CurvedAnimation(
      parent: _iconController,
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = MdTheme.of(context);
    final spacing = SpacingTokens();
    final shape = ShapeTokens();
    final size = MediaQuery.of(context).size;
    final barWidth = size.width * 0.7;
    const barHeight = 12.0;

    return Center(
      child: Container(
        width: barWidth,
        height: size.height * 0.4,
        padding: EdgeInsets.all(spacing.extraLarge(context)),
        decoration: BoxDecoration(
          color: tokens.sys.surfaceContainer,
          borderRadius: shape.borderRadiusLarge,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Rotating upload icon
            RotationTransition(
              turns: _iconAnimation,
              child: Icon(
                Icons.file_upload_rounded,
                size: 48,
                color: tokens.sys.primary,
              ),
            ),
            SizedBox(height: spacing.large(context)),
            Text(
              'Uploading File',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: tokens.sys.onSurface,
              ),
            ),
            SizedBox(height: spacing.small(context)),
            Text(
              widget.fileName,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: tokens.sys.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: spacing.extraLarge(context)),

            // Animated progress bar container
            Stack(
              children: [
                // Background track
                Container(
                  width: barWidth,
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: tokens.sys.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(barHeight / 2),
                  ),
                ),

                // Foreground fill with shimmer
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutQuart,
                  width: barWidth * widget.progress,
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: tokens.sys.primary,
                    borderRadius: BorderRadius.circular(barHeight / 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(barHeight / 2),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: 0.5, // shimmer stripe width
                        child: ShimmerStripe(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing.medium(context)),
            Text(
              '${(widget.progress * 100).toStringAsFixed(0)}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: tokens.sys.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A simple repeating shimmer stripe
class ShimmerStripe extends StatefulWidget {
  const ShimmerStripe({super.key});

  @override
  ShimmerStripeState createState() => ShimmerStripeState();
}

class ShimmerStripeState extends State<ShimmerStripe>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return FractionallySizedBox(
          alignment: Alignment(-1 + 2 * _shimmerController.value, 0),
          widthFactor: 0.5,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withAlpha(0),
                  Colors.white.withAlpha(30),
                  Colors.white.withAlpha(0),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        );
      },
    );
  }
}
