library tasty_toast;

import 'package:flutter/material.dart';

final Map<ToastWidget, OverlayEntry> _toastWithCorrespondingOverlayEntry =
    <ToastWidget, OverlayEntry>{};
OverlayState _overlayState;

void showToast(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 2),
  Alignment alignment = Alignment.bottomCenter,
  TextStyle textStyle,
  BoxDecoration background,
  EdgeInsets padding,
  Offset offsetAnimationStart,
}) {
  // Only initialize once. I *think* this is safe to do.
  _overlayState ??= Overlay.of(context);

  _toastWithCorrespondingOverlayEntry.forEach((key, value) {
    key.hide();
  });

  final ToastWidget toast = ToastWidget(
    message: message,
    duration: duration,
    alignment: alignment,
    textStyle: textStyle,
    background: background,
    padding: padding,
    offsetAnimationStart: offsetAnimationStart,
  );

  final OverlayEntry overlayEntry =
      OverlayEntry(builder: (BuildContext context) => toast);
  _overlayState.insert(overlayEntry);
  _toastWithCorrespondingOverlayEntry[toast] = overlayEntry;
}

void _removeOverlayEntry({ToastWidget toastWidget}) {
  final OverlayEntry overlayEntry =
      _toastWithCorrespondingOverlayEntry.remove(toastWidget);
  overlayEntry?.remove();
}

class ToastWidget extends StatefulWidget {
  final String message;
  final Duration duration;
  final Alignment alignment;
  final TextStyle textStyle;
  final BoxDecoration background;
  final EdgeInsets padding;
  final Offset offsetAnimationStart;

  ToastWidget({
    this.message,
    this.duration,
    this.alignment,
    this.textStyle,
    this.background,
    this.padding,
    this.offsetAnimationStart,
    Key key,
  }) : super(key: key);

  final _ToastWidgetState state = _ToastWidgetState();

  @override
  _ToastWidgetState createState() => state;

  void hide() => state.hide();
}

class _ToastWidgetState extends State<ToastWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _opacityAnimation;
  Animation<Offset> _offsetAnimation;
  bool _isHiding = false;

  Future<void> hide() async {
    // Make sure that the widget is currently in the tree and that it is not hiding already.
    if (!_isHiding && mounted) {
      _isHiding = true;
      await _animationController.reverse();
      _removeOverlayEntry(toastWidget: widget);
    }
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    // Fade in/out animation
    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);

    // Positional animation
    _offsetAnimation = Tween<Offset>(
      begin: widget.offsetAnimationStart ?? getBeginOffset(),
      end: Offset.zero,
    ).animate(_animationController);

    // Immediately start the animation
    _animationController.forward().whenComplete(() async {
      final duration = widget.duration ?? const Duration(seconds: 2);
      Future.delayed(duration).whenComplete(() => hide());
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SlideTransition(
        position: _offsetAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: SafeArea(
            child: Material(
              color: Colors.transparent,
              child: Container(
                alignment: widget.alignment,
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  decoration: widget.background ??
                      BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(25),
                      ),
                  padding: widget.padding ??
                      const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                  child: Text(
                    widget.message,
                    style: widget.textStyle ??
                        const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                    softWrap: true,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Offset getBeginOffset() {
    final String alignment = widget.alignment.toString().toLowerCase();
    if (alignment.contains("top")) {
      return const Offset(0.0, -0.01);
    } else if (alignment.contains("bottom")) {
      return const Offset(0.0, 0.01);
    } else if (alignment.contains("left")) {
      return const Offset(-0.01, 0.0);
    } else if (alignment.contains("right")) {
      return const Offset(0.01, 0.0);
    } else {
      return const Offset(0.0, 0.0);
    }
  }
}
