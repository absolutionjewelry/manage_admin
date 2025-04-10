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
      body: Stack(
        children: [
          Container(
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
          if (widget.navigationDrawer != null) ...[
            Positioned(
              top: 32,
              left: 16,
              child: IconButton(
                onPressed:
                    () => setState(() {
                      isDrawerOpen = !isDrawerOpen;
                    }),
                icon: Icon(
                  Icons.menu_rounded,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),
            if (isDrawerOpen)
              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap:
                          () => setState(() {
                            isDrawerOpen = false;
                          }),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(100),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.only(
                        top: 16,
                        bottom: 16,
                        right: MediaQuery.of(context).size.width * 0.33,
                      ),
                      child: widget.navigationDrawer!,
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}
