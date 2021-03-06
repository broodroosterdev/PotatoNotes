import 'package:flutter/material.dart';

class FlatIconButton extends StatelessWidget {
  final Widget icon;
  final Widget text;
  final VoidCallback onPressed;

  FlatIconButton({
    @required this.icon,
    @required this.text,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color highlightColor = Theme.of(context).accentColor.withOpacity(0.1);
    ThemeData theme = Theme.of(context);
    Color accent = Theme.of(context).accentColor;

    return InkResponse(
      onTap: onPressed,
      highlightShape: BoxShape.rectangle,
      containedInkWell: true,
      splashColor: highlightColor,
      highlightColor: highlightColor,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Row(
          children: [
            DefaultTextStyle(
              style: theme.textTheme.button.copyWith(
                color: onPressed != null ? accent : accent.withOpacity(0.38),
              ),
              child: text,
            ),
            SizedBox(width: 8),
            Theme(
              data: theme.copyWith(
                iconTheme: theme.iconTheme.copyWith(
                  color: onPressed != null ? accent : accent.withOpacity(0.38),
                ),
              ),
              child: icon,
            ),
          ],
        ),
      ),
    );
  }
}
