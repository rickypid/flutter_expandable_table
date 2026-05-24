import 'package:flutter/material.dart';

/// [AnimatedCollapse] animates its [width] and/or [height] like [AnimatedContainer],
/// but additionally removes the [child] from the widget tree once the collapse
/// animation completes (i.e. when the animated dimension reaches zero).
///
/// This avoids the cost of keeping hidden subtrees alive after they are fully
/// collapsed. The child is re-inserted before the expand animation begins so
/// it is always present while visible.
///
/// At least one of [width] or [height] must be provided; omitted dimensions
/// are left unconstrained (the child determines its own size on that axis).
class AnimatedCollapse extends StatefulWidget {
  /// The widget below this widget in the tree.
  final Widget child;

  /// Duration of the collapse/expand animation.
  final Duration duration;

  /// Curve applied to the collapse/expand animation.
  final Curve curve;

  /// Animated height. When this reaches `0` the [child] is removed from the
  /// tree. When it returns to a positive value the [child] is restored.
  /// If `null`, height is unconstrained.
  final double? height;

  /// Animated width. When this reaches `0` the [child] is removed from the
  /// tree. When it returns to a positive value the [child] is restored.
  /// If `null`, width is unconstrained.
  final double? width;

  const AnimatedCollapse({
    super.key,
    required this.child,
    required this.duration,
    required this.curve,
    this.height,
    this.width,
  });

  @override
  State<AnimatedCollapse> createState() => _AnimatedCollapseState();
}

class _AnimatedCollapseState extends State<AnimatedCollapse> {
  bool _shouldRenderChild = true;

  @override
  void didUpdateWidget(covariant AnimatedCollapse oldWidget) {
    super.didUpdateWidget(oldWidget);
    final hasSize = (widget.height == null || widget.height! > 0) &&
        (widget.width == null || widget.width! > 0);
    if (hasSize && !_shouldRenderChild) {
      setState(() {
        _shouldRenderChild = true;
      });
    }
  }

  void _handleEnd() {
    final isZeroSize = (widget.height != null && widget.height == 0) ||
        (widget.width != null && widget.width == 0);
    if (isZeroSize && _shouldRenderChild) {
      setState(() {
        _shouldRenderChild = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: widget.duration,
        curve: widget.curve,
        height: widget.height,
        width: widget.width,
        onEnd: _handleEnd,
        child: _shouldRenderChild ? widget.child : null,
      );
}
