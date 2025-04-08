import 'package:flutter/material.dart';
import 'screen_navigation_bar.dart';

class ScreenContainer extends StatelessWidget {
  final Widget? child;
  final ScreenNavigationBar? navigationBar;

  const ScreenContainer({super.key, this.child, this.navigationBar});

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
            navigationBar ?? SizedBox.shrink(),
            navigationBar == null
                ? Expanded(child: child ?? SizedBox.shrink())
                : child ?? SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
