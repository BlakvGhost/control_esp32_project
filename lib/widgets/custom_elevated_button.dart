import 'package:control/themes/app_theme.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? hoverColor;
  final Color? focusColor;
  final Color? activeColor;
  final Color? textColor;
  final bool isLoading;

  const CustomElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.hoverColor,
    this.focusColor,
    this.activeColor,
    this.textColor,
    this.isLoading = false,
  });

  @override
  CustomElevatedButtonState createState() => CustomElevatedButtonState();
}

class CustomElevatedButtonState extends State<CustomElevatedButton> {
  bool _isHovered = false;
  bool _isFocused = false;
  bool _isPressed = false;
  bool _isLongPressed = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onLongPress: () => setState(() => _isLongPressed = true),
          onLongPressEnd: (_) => setState(() => _isLongPressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: Transform.scale(
              scale: _isPressed ? 0.98 : 1.0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: _isLongPressed
                      ? (widget.activeColor ??
                          AppTheme.primaryColor.withOpacity(0.7))
                      : _isHovered
                          ? (widget.hoverColor ?? AppTheme.secondaryColor)
                          : (_isFocused
                              ? (widget.focusColor ??
                                  AppTheme.primaryColor.withOpacity(0.8))
                              : (widget.backgroundColor ??
                                  AppTheme.primaryColor)),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _isPressed || _isLongPressed
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(0, 3),
                            blurRadius: 5,
                          )
                        ]
                      : _isHovered
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                offset: const Offset(0, 4),
                                blurRadius: 6,
                              )
                            ]
                          : [],
                ),
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: ElevatedButton(
                  onPressed: widget.isLoading ? null : widget.onPressed,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: SizedBox(
                    height: 50,
                    child: Center(
                      child: widget.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              widget.label,
                              style: TextStyle(
                                color: widget.textColor ?? Colors.white,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
