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
          image: const DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
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
