import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth.dart';
import '../auth/login.dart';

class ScreenNavigationBar extends ConsumerWidget {
  final List<ScreenNavigationItem>? navigationItems;
  final String? title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? titleColor;
  final bool? showLogout;

  const ScreenNavigationBar({
    super.key,
    this.navigationItems,
    this.title,
    this.actions,
    this.backgroundColor,
    this.titleColor,
    this.showLogout = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canPop = Navigator.canPop(context);
    final auth = ref.watch(authProvider);

    return Container(
      width:
          MediaQuery.of(context).size.width > 1024
              ? MediaQuery.of(context).size.width * 0.66
              : MediaQuery.of(context).size.width,
      height: 40,
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            Theme.of(context).colorScheme.surface.withAlpha(200),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              title ?? '',
              style: TextStyle(
                color: titleColor ?? Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Row(
            children: [
              if (canPop)
                ScreenNavigationItem(
                  icon: Icons.arrow_back,
                  onPressed: () => Navigator.pop(context),
                ),
              ...navigationItems ?? [],
              Expanded(child: SizedBox.shrink()),
              ...(actions ?? []),
              if (auth != null && showLogout == true)
                ScreenNavigationItem(
                  icon: Icons.logout,
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    await signOut(ref);
                    navigator.pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginView()),
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class ScreenNavigationItem extends StatelessWidget {
  final String? title;
  final IconData icon;
  final Function()? onPressed;
  final Color? backgroundColor;
  final Color? activeBackgroundColor;
  final Color? iconColor;
  final Color? textColor;
  final bool? isActive;
  final EdgeInsets? padding;

  const ScreenNavigationItem({
    super.key,
    this.title,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.activeBackgroundColor,
    this.iconColor,
    this.textColor,
    this.isActive,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color:
            isActive ?? false
                ? activeBackgroundColor ?? Theme.of(context).colorScheme.surface
                : backgroundColor ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: iconColor ?? Theme.of(context).colorScheme.onSurface,
            ),
          ),
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                title ?? '',
                style: TextStyle(
                  color: textColor ?? Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
