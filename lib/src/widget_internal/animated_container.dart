import 'package:flutter/material.dart';

class AnimatedCollapse extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final double? height;
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
