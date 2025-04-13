import 'package:flutter/material.dart';
import 'screen_navigation_bar.dart';
import 'screen_navigation_drawer.dart';

class ScreenContainer extends StatefulWidget {
  final Widget? child;
  final ScreenNavigationBar? navigationBar;
  final ScreenNavigationDrawer? navigationDrawer;

  const ScreenContainer({
    super.key,
    this.child,
    this.navigationBar,
    this.navigationDrawer,
  });

  @override
  State<ScreenContainer> createState() => _ScreenContainerState();
}

class _ScreenContainerState extends State<ScreenContainer> {
  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.tertiary.withBlue(200),
            ],
          ),
        ),
        child: Column(
          children: [
            widget.navigationBar ?? SizedBox.shrink(),
            widget.navigationBar == null
                ? Expanded(child: widget.child ?? SizedBox.shrink())
                : widget.child ?? SizedBox.shrink(),
          ],
        ),
      ),
      drawer: Drawer(child: widget.navigationDrawer),
    );
  }
}
