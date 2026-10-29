// Dart imports:
import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

// Flutter imports:
import 'package:flutter/material.dart';

/// [AnimatedExtents] tracks the animated extent (width or height) of a set of
/// table items (columns or rows) driven by a single shared [controller].
///
/// Sharing one controller instead of animating every cell on its own keeps
/// the number of tickers constant regardless of the table size, and
/// guarantees that every widget reading an item's extent in the same frame
/// gets exactly the same value (e.g. a header cell and the body cells below it).
class AnimatedExtents<T extends Object> {
  /// [controller] drives the transition between the previous and the new extents.
  final AnimationController controller;

  /// [curve] applied to the transition.
  Curve curve;

  final Map<T, double> _begin = Map<T, double>.identity();
  final Map<T, double> _end = Map<T, double>.identity();

  /// [AnimatedExtents] constructor.
  AnimatedExtents({
    required this.controller,
    required this.curve,
  });

  /// [of] returns the current (animated) extent of [item].
  double of(T item) {
    final double end = _end[item] ?? 0;
    final double begin = _begin[item] ?? end;
    if (begin == end) {
      return end;
    }
    // Overshooting curves (e.g. elasticOut) must not produce negative sizes.
    return math.max(
        0, lerpDouble(begin, end, curve.transform(controller.value))!);
  }

  /// [isDisplayed] returns true if [item] currently takes up space, or is
  /// still animating out, so it must be part of the layout.
  bool isDisplayed(T item) =>
      (_end[item] ?? 0) > 0 ||
      (controller.isAnimating && (_begin[item] ?? 0) > 0);

  /// [update] sets the new target extents. If any of them changed, a
  /// transition starts from the current animated values. Items that were not
  /// tracked before (e.g. after replacing the rows) appear without animation.
  void update(Map<T, double> targets, {required Duration duration}) {
    final bool changed = targets.length != _end.length ||
        targets.entries.any((e) => _end[e.key] != e.value);
    if (!changed) {
      return;
    }
    final Map<T, double> begin = Map<T, double>.identity();
    bool animate = false;
    for (final MapEntry<T, double> entry in targets.entries) {
      final double from =
          _end.containsKey(entry.key) ? of(entry.key) : entry.value;
      begin[entry.key] = from;
      animate = animate || from != entry.value;
    }
    _begin
      ..clear()
      ..addAll(begin);
    _end
      ..clear()
      ..addAll(targets);
    if (animate && duration > Duration.zero) {
      controller.duration = duration;
      controller.forward(from: 0);
    } else {
      // Nothing to animate: settle immediately on the targets.
      _begin
        ..clear()
        ..addAll(targets);
      controller.value = 1;
    }
  }
}
