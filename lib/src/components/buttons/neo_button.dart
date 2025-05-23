/// A neobrutalism-styled button with interactive hover and press animations.
///
/// NeoButton provides a distinctive visual style with bold borders, customizable colors,
/// and interactive behavior that mimics physical movement when pressed or hovered.
///
/// Example:
/// ```dart
/// NeoButton(
///   id: 'primary_button',
///   label: 'Click Me',
///   onPressed: () {
///     print('Button clicked!');
///   },
/// )
/// ```

library;

import 'package:flutter/material.dart';
import '../abstract/neoprism_component.dart';
import '../abstract/neoprism_state.dart';

enum NeoButtonSize {
  small,
  medium,
  large,
}

class NeoButton extends NeoPrismComponent {
  final String? label;
  final Widget? icon;
  final Widget? child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;
  final bool isEnabled;
  final NeoButtonSize size;
  final MainAxisAlignment contentAlignment;
  final double? iconSize;
  final double iconSpacing;
  final bool isCompressed;

  const NeoButton({
    required super.id,
    required this.label,
    this.onPressed,
    this.isCompressed = false,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    this.isEnabled = true,
    this.size = NeoButtonSize.medium,
    this.contentAlignment = MainAxisAlignment.center,
    this.icon,
    this.iconSize,
    this.iconSpacing = 8.0,
    this.child,
    super.key,
  }) : assert(label != null || child != null,
            'Either label or child must be provided');

  NeoButton.icon({
    required String id,
    required IconData icon,
    required String label,
    VoidCallback? onPressed,
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
    EdgeInsetsGeometry? padding,
    bool isEnabled = true,
    NeoButtonSize size = NeoButtonSize.medium,
    bool isCompressed = false,
    MainAxisAlignment contentAlignment = MainAxisAlignment.center,
    double iconSize = 20.0,
    double iconSpacing = 8.0,
    Key? key,
  }) : this(
          id: id,
          label: label,
          icon: Icon(icon, size: iconSize),
          onPressed: onPressed,
          backgroundColor: backgroundColor,
          textColor: textColor,
          borderColor: borderColor,
          padding: padding ??
              const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          isEnabled: isEnabled,
          size: size,
          isCompressed: isCompressed,
          contentAlignment: contentAlignment,
          iconSize: iconSize,
          iconSpacing: iconSpacing,
          key: key,
        );

  const NeoButton.compressed({
    required String id,
    required String label,
    VoidCallback? onPressed,
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
    bool isEnabled = true,
    NeoButtonSize size = NeoButtonSize.small,
    Key? key,
  }) : this(
          id: id,
          label: label,
          onPressed: onPressed,
          backgroundColor: backgroundColor,
          textColor: textColor,
          borderColor: borderColor,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          isEnabled: isEnabled,
          size: size,
          isCompressed: true,
          key: key,
        );

  const NeoButton.small({
    required String id,
    required String label,
    VoidCallback? onPressed,
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
    bool isEnabled = true,
    Widget? icon,
    Key? key,
  }) : this(
          id: id,
          label: label,
          onPressed: onPressed,
          backgroundColor: backgroundColor,
          textColor: textColor,
          borderColor: borderColor,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          isEnabled: isEnabled,
          size: NeoButtonSize.small,
          icon: icon,
          iconSize: 16.0,
          key: key,
        );

  const NeoButton.large({
    required String id,
    required String label,
    VoidCallback? onPressed,
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
    bool isEnabled = true,
    Widget? icon,
    Key? key,
  }) : this(
          id: id,
          label: label,
          onPressed: onPressed,
          backgroundColor: backgroundColor,
          textColor: textColor,
          borderColor: borderColor,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          isEnabled: isEnabled,
          size: NeoButtonSize.large,
          icon: icon,
          iconSize: 24.0,
          key: key,
        );

  const NeoButton.custom({
    required String id,
    required Widget child,
    VoidCallback? onPressed,
    Color? backgroundColor,
    Color? borderColor,
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
    bool isEnabled = true,
    Key? key,
  }) : this(
          id: id,
          label: null,
          onPressed: onPressed,
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          padding: padding,
          isEnabled: isEnabled,
          child: child,
          key: key,
        );

  @override
  String get componentType => 'NeoButton';

  @override
  State<NeoButton> createState() => _NeoButtonState();
}

class _NeoButtonState extends NeoprismComponentState<NeoButton> {
  bool _isHovered = false;
  bool _isPressed = false;
  // Initialize directly to avoid hot reload issues
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {});

    if (_focusNode.hasFocus) {
      trackInteraction('focused');
    }
  }

  // Use a single method for tap handling
  void _handleTap() {
    if (!widget.isEnabled) return;

    // Set pressed state immediately
    setState(() => _isPressed = true);

    // Call onPressed callback
    widget.onPressed?.call();
    trackInteraction('pressed');

    // Request focus
    _focusNode.requestFocus();

    // Reset pressed state after a short delay
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() => _isPressed = false);

        // Unfocus after a bit longer
        Future.delayed(const Duration(milliseconds: 50), () {
          if (mounted && _focusNode.hasFocus) {
            _focusNode.unfocus();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    double fontSize;
    FontWeight fontWeight;

    switch (widget.size) {
      case NeoButtonSize.small:
        fontSize = 14.0;
        fontWeight = FontWeight.normal;
        break;
      case NeoButtonSize.large:
        fontSize = 18.0;
        fontWeight = FontWeight.bold;
        break;
      case NeoButtonSize.medium:
        fontSize = 16.0;
        fontWeight = FontWeight.bold;
    }

    return MouseRegion(
      cursor: widget.isEnabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: widget.isEnabled
          ? (_) {
              setState(() => _isHovered = true);
              trackInteraction('hovered');
            }
          : null,
      onExit: widget.isEnabled
          ? (_) {
              setState(() => _isHovered = false);
            }
          : null,
      child: GestureDetector(
        behavior:
            HitTestBehavior.opaque, // Essential for reliable tap detection
        onTap: widget.isEnabled ? _handleTap : null,
        child: Focus(
          focusNode: _focusNode,
          child: applyNeoBrutalism(
            context: context,
            isHovered: _isHovered && widget.isEnabled,
            isPressed: _isPressed && widget.isEnabled,
            backgroundColor: widget.isEnabled
                ? (widget.backgroundColor ?? theme.colorScheme.primary)
                : Colors.grey.shade300,
            borderColor: widget.borderColor,
            child: Padding(
              padding: widget.padding,
              child: _buildButtonContent(
                context: context,
                theme: theme,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent({
    required BuildContext context,
    required ThemeData theme,
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    if (widget.child != null) {
      return widget.child!;
    }

    final textStyle = TextStyle(
      color: widget.isEnabled
          ? (widget.textColor ?? theme.colorScheme.onPrimary)
          : Colors.grey,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );

    if (widget.icon == null) {
      return Text(
        widget.label!,
        style: textStyle,
        textAlign: TextAlign.center,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: widget.contentAlignment,
      children: [
        widget.icon!,
        SizedBox(width: widget.iconSpacing),
        Text(
          widget.label!,
          style: textStyle,
        ),
      ],
    );
  }
}
