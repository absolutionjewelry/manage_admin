import 'package:flutter/material.dart';

class ScreenNavigationDrawer extends StatelessWidget {
  final List<Widget> children;

  const ScreenNavigationDrawer({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: ListView(children: children),
    );
  }
}
