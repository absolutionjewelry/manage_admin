import 'package:flutter/material.dart';

class ScreenNavigationItem extends StatelessWidget {
  final String? title;
  final String? tooltip;
  final IconData icon;
  final Function()? onPressed;
  final Color? backgroundColor;
  final Color? activeBackgroundColor;
  final Color? iconColor;
  final Color? textColor;
  final bool? isActive;
  final EdgeInsets? padding;
  final bool collapsed;

  const ScreenNavigationItem({
    super.key,
    this.title,
    this.tooltip,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.activeBackgroundColor,
    this.iconColor,
    this.textColor,
    this.isActive,
    this.padding,
    this.collapsed = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color:
            isActive ?? false
                ? activeBackgroundColor ??
                    Theme.of(context).colorScheme.onTertiaryContainer
                : backgroundColor ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Tooltip(
        message: tooltip ?? '',
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  color:
                      iconColor ??
                      (isActive ?? false
                          ? Theme.of(context).colorScheme.secondaryContainer
                          : Theme.of(context).colorScheme.onSurface),
                ),
                if (title != null && !collapsed)
                  Padding(
                    padding: const EdgeInsets.only(right: 8, left: 8),
                    child: Text(
                      title ?? '',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color:
                            textColor ??
                            Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
