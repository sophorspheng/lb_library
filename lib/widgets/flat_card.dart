import 'package:flutter/material.dart';

class FlatCard extends StatelessWidget {
  const FlatCard({
    super.key,
    required this.child,
    this.onHover,
    this.onTap,
    this.padding = const EdgeInsets.all(16.0),
    this.color,
    this.borderRadius = .0,
    this.useInnerSafeArea = false,
    this.side = BorderSide.none,
    this.boxConstraint,
    this.raised = false,
  });

  final Widget child;
  final void Function(bool value)? onHover;
  final void Function()? onTap;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final double borderRadius;
  final bool useInnerSafeArea;
  final BorderSide side;
  final bool raised;
  final BoxConstraints? boxConstraint;

  @override
  Widget build(BuildContext context) {
    Widget myChild = Padding(
      padding: padding,
      child: useInnerSafeArea ? SafeArea(bottom: false, child: child) : child,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: !raised
            ? null
            : [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.2),
                  blurRadius: 1,
                  offset: const Offset(0, 0),
                ),
              ],
      ),
      constraints: boxConstraint,
      child: Card(
        margin: EdgeInsets.zero,
        surfaceTintColor: color ?? Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          side: side,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
        color: color ?? Theme.of(context).cardColor,
        elevation: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              highlightColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              onHover: onHover,
              onTap: onTap,
              child: myChild,
            ),
          ),
        ),
      ),
    );
  }
}
