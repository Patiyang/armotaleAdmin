import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../helpers/styling.dart';
import 'customText.dart';

class DashboardItem extends StatefulWidget {
  final String text;
  final String mainText;
  final icon;
  final VoidCallback callback;
  final Color color;
  final Color overLayColor;
  final double fontSize;
  final bool loading;

  const DashboardItem({Key key, this.text, this.mainText, this.icon, this.callback, this.color, this.overLayColor, this.fontSize, this.loading})
      : super(key: key);
  @override
  _DashboardItemState createState() => _DashboardItemState();
}

class _DashboardItemState extends State<DashboardItem> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height * .15,
        // width: 300,
        child: Stack(
          children: [
            Positioned(
              top: 18,
              left: 5,
              right: 5,
              bottom: 5,
              child: InkWell(
                onTap: widget.callback,
                child: Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: white,
                    gradient: LinearGradient(
                      colors: [primaryColor[100], white],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomText(text: widget.text),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .01,
                      ),
                      widget.loading == true
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CustomText(text: 'Loading'),
                                SizedBox(
                                  height: MediaQuery.of(context).size.width * .01,
                                ),
                                SpinKitFadingCircle(color: black, size: 17),
                              ],
                            )
                          : CustomText(text: widget.mainText, size: widget.fontSize ?? 25, fontWeight: FontWeight.w900, letterSpacing: 0),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Container(
                height: 80,
                width: 80,
                padding: EdgeInsets.all(8),
                child: widget.icon,
                decoration: BoxDecoration(
                  color: widget.overLayColor,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
