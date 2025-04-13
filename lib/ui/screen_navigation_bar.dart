import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth.dart';
import '../auth/login.dart';
import 'screen_navigation_item.dart';

class ScreenNavigationBar extends ConsumerStatefulWidget {
  final List<ScreenNavigationItem>? navigationItems;
  final String? title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? titleColor;
  final bool? showLogout;
  final bool? showBack;
  final bool? showMenu;

  const ScreenNavigationBar({
    super.key,
    this.navigationItems,
    this.title,
    this.actions,
    this.backgroundColor,
    this.titleColor,
    this.showLogout = true,
    this.showBack = true,
    this.showMenu = false,
  });

  @override
  ConsumerState<ScreenNavigationBar> createState() =>
      _ScreenNavigationBarState();
}

class _ScreenNavigationBarState extends ConsumerState<ScreenNavigationBar> {
  findScaffold(BuildContext context) {
    return context.findRootAncestorStateOfType<ScaffoldState>();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Row(
      children: [
        if (widget.showMenu == true)
          IconButton(
            onPressed: () {
              final scaffold = findScaffold(context);
              if (scaffold != null) {
                scaffold.openDrawer();
              }
            },
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
        Spacer(),
        if (isMobile) SizedBox(width: 40),
        Container(
          width: MediaQuery.of(context).size.width - 124,
          height: 40,
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                widget.backgroundColor ??
                Theme.of(context).colorScheme.surface.withAlpha(200),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 8,
                right: isMobile && widget.navigationItems != null ? 50 : 0,
                child: Text(
                  widget.title ?? '',
                  style: TextStyle(
                    color:
                        widget.titleColor ??
                        Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign:
                      isMobile && widget.navigationItems != null
                          ? TextAlign.right
                          : TextAlign.center,
                ),
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        if (widget.showBack == true)
                          ScreenNavigationItem(
                            icon: Icons.arrow_back,
                            onPressed: () => Navigator.pop(context),
                            tooltip: 'Back',
                          ),
                        ...widget.navigationItems ?? [],
                      ],
                    ),
                  ),
                  Expanded(child: SizedBox.shrink()),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        ...(widget.actions ?? []),
                        if (auth != null && widget.showLogout == true)
                          ScreenNavigationItem(
                            icon: Icons.logout,
                            onPressed: () async {
                              final navigator = Navigator.of(context);
                              await signOut(ref);
                              navigator.pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => LoginView(),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Spacer(),
      ],
    );
  }
}
