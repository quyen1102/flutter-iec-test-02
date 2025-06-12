import 'package:flutter/material.dart';

import 'flying_coins_animation.dart';

/// Manager class to handle multiple flying coin animations
class FlyingCoinsManager extends StatefulWidget {
  final Widget child;

  const FlyingCoinsManager({super.key, required this.child});

  @override
  _FlyingCoinsManagerState createState() => _FlyingCoinsManagerState();

  static _FlyingCoinsManagerState? of(BuildContext context) {
    return context.findAncestorStateOfType<_FlyingCoinsManagerState>();
  }
}

class _FlyingCoinsManagerState extends State<FlyingCoinsManager> {
  final List<Widget> _activeAnimations = [];

  /// Starts a flying coins animation from startKey to endKey
  void startFlyingCoinsAnimation({
    required GlobalKey startKey,
    required GlobalKey endKey,
    required VoidCallback onComplete,
    int coinCount = 5,
  }) {
    final startContext = startKey.currentContext;
    final endContext = endKey.currentContext;

    if (startContext == null || endContext == null) return;

    final startBox = startContext.findRenderObject() as RenderBox;
    final endBox = endContext.findRenderObject() as RenderBox;

    final startPosition = startBox.localToGlobal(Offset.zero);
    final endPosition = endBox.localToGlobal(
      Offset(endBox.size.width / 2, endBox.size.height / 2),
    );

    final animation = FlyingCoinsAnimation(
      startPosition: startPosition,
      endPosition: endPosition,
      coinCount: coinCount,
      onAnimationComplete: () {
        setState(() {
          _activeAnimations.removeWhere(
            (widget) => widget is FlyingCoinsAnimation,
          );
        });
        onComplete();
      },
    );

    setState(() {
      _activeAnimations.add(animation);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [widget.child, ..._activeAnimations]);
  }
}
