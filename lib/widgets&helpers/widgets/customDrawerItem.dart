import 'package:armotaleadmin/widgets&helpers/helpers/styling.dart';
import 'package:armotaleadmin/widgets&helpers/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomDrawerItem extends StatefulWidget {
  final String title;
  final VoidCallback callback;
  final Color color;
  final bool isSelected;
  const CustomDrawerItem({Key key, this.title, this.callback, this.color, this.isSelected}) : super(key: key);
  @override
  _CustomDrawerItemState createState() => _CustomDrawerItemState();
}

class _CustomDrawerItemState extends State<CustomDrawerItem> {
  var containerColor = grey[100];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 7),
      child: GestureDetector(
        onTap: widget.callback ?? null,
        child: MouseRegion(
          onEnter: (enter) {
            // print(widget.title);
          },
          onExit: (exit) {
            setState(() {
              containerColor = grey[200];
            });
          },
          cursor: SystemMouseCursors.click,
          child: Container(
            // padding: EdgeInsets.all(8),
            width: double.infinity,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: CustomText(
              text: widget.title,
              color: widget.color == primaryColor[300] ? white : black,
            ),
          ),
        ),
      ),
    );
  }
}
