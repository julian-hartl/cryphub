import 'package:flutter/material.dart';

/// https://docs.flutter.dev/cookbook/effects/shimmer-loading
class ShimmerEffect extends StatefulWidget {
  const ShimmerEffect({
    Key? key,
    required this.child,
    this.backgroundColor,
    this.shimmerColor,
  }) : super(key: key);

  final Widget child;
  final Color? backgroundColor;
  final Color? shimmerColor;

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController.unbounded(vsync: this);
    _shimmerController.repeat(
        min: -0.5, max: 1.5, period: const Duration(milliseconds: 1000));
  }

  late LinearGradient _shimmerGradient;

  LinearGradient get shimmerGradient => updateGradient();

  @override
  void didUpdateWidget(covariant ShimmerEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.backgroundColor != widget.backgroundColor) {
      updateGradient();
    }
    if (oldWidget.shimmerColor != widget.shimmerColor) {
      updateGradient();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    updateGradient();
  }

  LinearGradient updateGradient() {
    _shimmerGradient = LinearGradient(
      colors: [
        widget.backgroundColor ?? Theme.of(context).colorScheme.background,
        widget.shimmerColor ?? Theme.of(context).colorScheme.primary,
        widget.backgroundColor ?? Theme.of(context).colorScheme.background,
      ],
      stops: const [
        0.1,
        0.3,
        0.4,
      ],
      begin: const Alignment(-1.0, -0.3),
      end: const Alignment(1.0, 0.3),
      tileMode: TileMode.clamp,
      transform:
          _SlidingGradientTransform(slidePercent: _shimmerController.value),
    );
    return _shimmerGradient;
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
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return shimmerGradient.createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({required this.slidePercent});

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}
