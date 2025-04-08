import 'package:flutter/material.dart';

typedef NavigationCardLoading = Future<void> Function();

class NavigationCardAction {
  final IconData? icon;
  final Color? color;
  final String label;
  final VoidCallback onTap;

  NavigationCardAction({
    this.icon,
    this.color,
    required this.label,
    required this.onTap,
  });

  NavigationCardAction.icon({
    this.color,
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class NavigationCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final NavigationCardLoading? onLoading;
  final List<NavigationCardAction> actions;

  const NavigationCard({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
    this.onLoading,
    this.actions = const [],
  });

  @override
  State<NavigationCard> createState() => _NavigationCardState();
}

class _NavigationCardState extends State<NavigationCard> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.onLoading != null) {
      callOnLoading();
    }
  }

  callOnLoading() async {
    setState(() {
      isLoading = true;
    });

    await widget.onLoading!.call();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  InkWell(
                    onTap: widget.onTap,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.title,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          if (widget.subtitle != null)
                            Text(
                              widget.subtitle!,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                        ],
                      ),
                    ),
                  ),
                  widget.actions.isNotEmpty
                      ? Positioned(
                        top: 0,
                        right: 0,
                        child: PopupMenuButton(
                          itemBuilder:
                              (context) =>
                                  widget.actions
                                      .map(
                                        (action) => PopupMenuItem(
                                          onTap: action.onTap,
                                          child: Row(
                                            children: [
                                              if (action.icon != null)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 8,
                                                      ),
                                                  child: Icon(
                                                    action.icon,
                                                    color: action.color,
                                                  ),
                                                ),
                                              Text(
                                                action.label,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium
                                                    ?.copyWith(
                                                      color: action.color,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                        ),
                      )
                      : const SizedBox.shrink(),
                ],
              ),
    );
  }
}
