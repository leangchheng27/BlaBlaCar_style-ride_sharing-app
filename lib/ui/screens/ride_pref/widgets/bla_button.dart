import 'package:flutter/material.dart';
import '../../../theme/theme.dart';

enum BlaButtonType { primary, secondary }

class BlaButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final BlaButtonType type;
  final IconData? icon;

  const BlaButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = BlaButtonType.primary,
    this.icon,
  });

  Color get buttonColor =>
      type == BlaButtonType.primary ? BlaColors.primary : BlaColors.white;

  Color get textColor =>
      type == BlaButtonType.primary ? BlaColors.white : BlaColors.primary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: type == BlaButtonType.primary
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: textColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(BlaSpacings.radius),
                ),
                padding: EdgeInsets.all(BlaSpacings.m),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: textColor),
                    SizedBox(width: 8),
                  ],
                  Text(text,
                      style: BlaTextStyles.button.copyWith(color: textColor)),
                ],
              ),
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: textColor,
                backgroundColor: buttonColor,
                side: BorderSide(color: BlaColors.primary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(BlaSpacings.radius),
                ),
                padding: EdgeInsets.all(BlaSpacings.m),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: textColor),
                    SizedBox(width: 8),
                  ],
                  Text(text,
                      style: BlaTextStyles.button.copyWith(color: textColor)),
                ],
              ),
            ),
    );
  }
}
