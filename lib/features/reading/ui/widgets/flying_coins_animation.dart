import 'package:flutter/material.dart';
import 'dart:math';

/// Enhanced widget that handles attractive flying coins animation with trails
class FlyingCoinsAnimation extends StatefulWidget {
  final Offset startPosition;
  final Offset endPosition;
  final VoidCallback onAnimationComplete;
  final int coinCount;

  const FlyingCoinsAnimation({
    super.key,
    required this.startPosition,
    required this.endPosition,
    required this.onAnimationComplete,
    this.coinCount = 5,
  });

  @override
  _FlyingCoinsAnimationState createState() => _FlyingCoinsAnimationState();
}

class _FlyingCoinsAnimationState extends State<FlyingCoinsAnimation>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  List<CoinAnimation> _coinAnimations = [];
  final Random _random = Random();
  final int _trailLength = 4; // Number of trail particles per coin

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1200,
      ), // Increased duration for smoother effect
    );

    // Create individual animations for each coin with stagger delays
    for (int i = 0; i < widget.coinCount; i++) {
      final staggerDelay = i * 0.08; // Reduced delay for faster succession

      // Add some randomness to start and end positions
      final startOffset = Offset(
        widget.startPosition.dx + _random.nextDouble() * 30 - 15,
        widget.startPosition.dy + _random.nextDouble() * 30 - 15,
      );
      final endOffset = Offset(
        widget.endPosition.dx + _random.nextDouble() * 50 - 25,
        widget.endPosition.dy + _random.nextDouble() * 50 - 25,
      );

      // Create control point for curved path (parabolic arc)
      final midPoint = Offset(
        (startOffset.dx + endOffset.dx) / 2 +
            (_random.nextDouble() - 0.5) * 120,
        min(startOffset.dy, endOffset.dy) -
            60 -
            _random.nextDouble() * 60, // Higher arc
      );

      // Position animation with curved path
      final positionTween = CurveTween(
        curve: Interval(staggerDelay, 1.0, curve: Curves.easeOutCubic),
      ).chain(CurveTween(curve: Curves.easeInOut));

      final positionAnimation = _animationController
          .drive(positionTween)
          .drive(Tween<double>(begin: 0.0, end: 1.0));

      // Rotation animation (spinning coins faster)
      final rotationTween = CurveTween(
        curve: Interval(staggerDelay, 1.0, curve: Curves.linear),
      );

      final rotationAnimation = _animationController
          .drive(rotationTween)
          .drive(Tween<double>(begin: 0.0, end: 6.0 * pi)); // 3 full rotations

      // Scale animation with more dramatic bounce
      final scaleTween = CurveTween(
        curve: Interval(
          staggerDelay,
          min(1.0, staggerDelay + 0.7),
          curve: Curves.elasticOut,
        ),
      );

      final scaleAnimation = _animationController
          .drive(scaleTween)
          .drive(
            Tween<double>(begin: 1.2, end: 0.2),
          ); // Start bigger, end smaller

      // Opacity animation with fade out
      final opacityTween = CurveTween(
        curve: Interval(staggerDelay, 1.0, curve: Curves.easeInCubic),
      );

      final opacityAnimation = _animationController
          .drive(opacityTween)
          .drive(Tween<double>(begin: 1.0, end: 0.0));

      _coinAnimations.add(
        CoinAnimation(
          startPosition: startOffset,
          endPosition: endOffset,
          midPoint: midPoint,
          positionAnimation: positionAnimation,
          rotationAnimation: rotationAnimation,
          scaleAnimation: scaleAnimation,
          opacityAnimation: opacityAnimation,
          color: _getRandomCoinColor(),
          trailPositions: [],
        ),
      );
    }

    // Add listener to update trail positions
    _animationController.addListener(() {
      for (var coinAnim in _coinAnimations) {
        final progress = coinAnim.positionAnimation.value;
        final currentPosition = _calculateBezierPosition(
          coinAnim.startPosition,
          coinAnim.midPoint,
          coinAnim.endPosition,
          progress,
        );

        // Add current position to trail
        coinAnim.trailPositions.add(currentPosition);

        // Keep only the last few positions for trail effect
        if (coinAnim.trailPositions.length > _trailLength) {
          coinAnim.trailPositions.removeAt(0);
        }
      }
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete();
      }
    });

    // Start the animation
    _animationController.forward();
  }

  // Get random coin colors for variety with more vibrant options
  Color _getRandomCoinColor() {
    final colors = [
      Colors.amber,
      Colors.yellow.shade600,
      Colors.orange.shade400,
      Colors.yellow.shade800,
      const Color(0xFFFFD700), // Pure gold
      const Color(0xFFB8860B), // Dark gold
    ];
    return colors[_random.nextInt(colors.length)];
  }

  // Calculate bezier curve position
  Offset _calculateBezierPosition(
    Offset start,
    Offset control,
    Offset end,
    double t,
  ) {
    final double oneMinusT = 1.0 - t;
    return Offset(
      oneMinusT * oneMinusT * start.dx +
          2 * oneMinusT * t * control.dx +
          t * t * end.dx,
      oneMinusT * oneMinusT * start.dy +
          2 * oneMinusT * t * control.dy +
          t * t * end.dy,
    );
  }

  // Build trail effect for a coin
  List<Widget> _buildTrailEffect(CoinAnimation coinAnim) {
    List<Widget> trails = [];

    for (int i = 0; i < coinAnim.trailPositions.length; i++) {
      final position = coinAnim.trailPositions[i];
      final trailOpacity =
          (i + 1) / coinAnim.trailPositions.length * 0.4; // Fade older trails
      final trailScale =
          (i + 1) /
          coinAnim.trailPositions.length *
          0.6; // Smaller older trails

      trails.add(
        Positioned(
          left: position.dx - 10,
          top: position.dy - 10,
          child: Opacity(
            opacity: trailOpacity * coinAnim.opacityAnimation.value,
            child: Transform.scale(
              scale: trailScale * coinAnim.scaleAnimation.value,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: coinAnim.color.withValues(alpha: 0.6),
                  boxShadow: [
                    BoxShadow(
                      color: coinAnim.color.withValues(alpha: 0.3),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return trails;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        List<Widget> allWidgets = [];

        for (var coinAnim in _coinAnimations) {
          // Add trail effects first (so they appear behind the main coin)
          allWidgets.addAll(_buildTrailEffect(coinAnim));

          final progress = coinAnim.positionAnimation.value;
          final position = _calculateBezierPosition(
            coinAnim.startPosition,
            coinAnim.midPoint,
            coinAnim.endPosition,
            progress,
          );

          // Add main coin
          allWidgets.add(
            Positioned(
              left: position.dx - 15, // Center the coin
              top: position.dy - 15,
              child: Opacity(
                opacity: coinAnim.opacityAnimation.value,
                child: Transform.scale(
                  scale: coinAnim.scaleAnimation.value,
                  child: Transform.rotate(
                    angle: coinAnim.rotationAnimation.value,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: coinAnim.color,
                        boxShadow: [
                          BoxShadow(
                            color: coinAnim.color.withValues(alpha: 0.8),
                            blurRadius: 12,
                            spreadRadius: 3,
                          ),
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.4),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            color: Colors.orange.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.8),
                            coinAnim.color,
                            coinAnim.color.withValues(alpha: 0.7),
                          ],
                          stops: const [0.0, 0.6, 1.0],
                        ),
                      ),
                      child: Icon(
                        Icons.monetization_on,
                        color: Colors.white,
                        size: 22,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.6),
                            offset: const Offset(1, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return Stack(children: allWidgets);
      },
    );
  }
}

/// Class to hold all animation data for a single coin
class CoinAnimation {
  final Offset startPosition;
  final Offset endPosition;
  final Offset midPoint;
  final Animation<double> positionAnimation;
  final Animation<double> rotationAnimation;
  final Animation<double> scaleAnimation;
  final Animation<double> opacityAnimation;
  final Color color;
  final List<Offset> trailPositions;

  CoinAnimation({
    required this.startPosition,
    required this.endPosition,
    required this.midPoint,
    required this.positionAnimation,
    required this.rotationAnimation,
    required this.scaleAnimation,
    required this.opacityAnimation,
    required this.color,
    required this.trailPositions,
  });
}

// Widget that handles the flying coins animation
class FlyingCoinsAnimationForLowBattery extends StatefulWidget {
  final Offset startPosition;
  final Offset endPosition;
  final VoidCallback onAnimationComplete;
  final int coinCount;

  const FlyingCoinsAnimationForLowBattery({
    super.key,
    required this.startPosition,
    required this.endPosition,
    required this.onAnimationComplete,
    this.coinCount = 5,
  });

  @override
  _FlyingCoinsAnimationForLowBatteryState createState() =>
      _FlyingCoinsAnimationForLowBatteryState();
}

class _FlyingCoinsAnimationForLowBatteryState
    extends State<FlyingCoinsAnimationForLowBattery>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  List<Animation<Offset>> _coinAnimations = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Create individual animations for each coin
    for (int i = 0; i < widget.coinCount; i++) {
      // Add some randomness to start and end positions
      final start = Offset(
        widget.startPosition.dx + _random.nextDouble() * 20 - 10,
        widget.startPosition.dy + _random.nextDouble() * 20 - 10,
      );
      final end = Offset(
        widget.endPosition.dx + _random.nextDouble() * 40 - 20,
        widget.endPosition.dy + _random.nextDouble() * 40 - 20,
      );

      final curvedAnimation = CurvedAnimation(
        parent: _animationController,
        curve: Curves.bounceInOut,
      );

      final animation = Tween<Offset>(
        begin: start,
        end: end,
      ).animate(curvedAnimation);

      _coinAnimations.add(animation);
    }

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete();
      }
    });

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          children:
              _coinAnimations.map((animation) {
                return Positioned(
                  left: animation.value.dx,
                  top: animation.value.dy,
                  child: Transform.scale(
                    scale:
                        1.0 -
                        (_animationController.value *
                            0.3), // Shrink as they fly
                    child: const Icon(
                      Icons.monetization_on,
                      color: Colors.amber,
                      size: 20,
                    ),
                  ),
                );
              }).toList(),
        );
      },
    );
  }
}
