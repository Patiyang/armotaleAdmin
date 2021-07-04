import 'package:armotaleadmin/widgets&helpers/helpers/helperClasses.dart';
import 'package:armotaleadmin/widgets&helpers/widgets/registrationContainer.dart';
import 'package:armotaleadmin/widgets&helpers/helpers/styling.dart';
import 'package:armotaleadmin/widgets&helpers/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  void initState() {
    checkUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double pageHheight = MediaQuery.of(context).size.height;
    double pageWidth = MediaQuery.of(context).size.width;

    return Container(
      height: pageHheight,
      width: pageWidth,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(HelperClass.backgroundLogin, fit: BoxFit.cover, height: pageHheight, width: pageWidth),
          Container(
            height: pageHheight,
            width: pageWidth,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                grey.withOpacity(.7),
                black.withOpacity(.5),
              ],
            )),
          ),
          ResponsiveBuilder(
            builder: (context, sizingInformation) {
              // Check the sizing information here and return your UI
              if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
                return Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 200),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(text: 'Armotale', color: white),
                          ],
                        ),
                        Expanded(child: RegistrationForm()),
                        // Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(text: 'Armotale Express', color: white),
                            SizedBox(width: 10),
                            CustomText(text: 'About Us', color: white),
                            SizedBox(width: 10),
                            CustomText(text: 'Blog', color: white),
                            SizedBox(width: 10),
                            CustomText(text: 'Terms and conditions', color: white),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
                return Container(child: CustomText(text: 'Tablet'));
              }

              if (sizingInformation.deviceScreenType == DeviceScreenType.watch) {
                return Container(
                  child: Column(
                    children: [],
                  ),
                );
              }

              return Container(color: Colors.purple);
            },
          ),
        ],
      ),
    );
  }

  void checkUser() {}
}
