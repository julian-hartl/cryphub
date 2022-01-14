import 'package:flutter/material.dart';

class ExpandableSidebar extends StatefulWidget {
  const ExpandableSidebar({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _ExpandableSidebarState createState() => _ExpandableSidebarState();
}

class _ExpandableSidebarState extends State<ExpandableSidebar> {
  late final Animation animation;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        /*
        AnimatedBuilder(
          animation: animation,
          child: Container(
            width: 200,
            height: MediaQuery.of(context).size.height,
            color: Colors.red,
          ),
          builder: (BuildContext context, Widget? child) {
            return Transform.translate(offset: Offset());
          },
        ),
        */
      ],
    );
  }
}
