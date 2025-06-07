import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final bool isDisabled;
  final VoidCallback? onTap;
  const Button({
    super.key,
    required this.text,
    this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: SizedBox(
        width: double.infinity,
        child: Material(
          color:
              !isDisabled
                  ? theme.colorScheme.primary
                  : theme.colorScheme.primary.withValues(alpha: 0.38),
          child: InkWell(
            onTap: !isDisabled ? onTap : null,
            splashColor: !isDisabled ? null : Colors.transparent,
            highlightColor: onTap != null ? null : Colors.transparent,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Center(
                child: Text(
                  text,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color:
                        !isDisabled
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface.withValues(
                              alpha: 0.38,
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
