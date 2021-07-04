import 'package:armotaleadmin/views/home/homePage.dart';
import 'package:armotaleadmin/widgets&helpers/helpers/helperClasses.dart';
import 'package:armotaleadmin/widgets&helpers/widgets/loginContainer.dart';
import 'package:armotaleadmin/widgets&helpers/helpers/styling.dart';
import 'package:armotaleadmin/widgets&helpers/widgets/customText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Color textColor = white;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double pageHheight = MediaQuery.of(context).size.height;
    double pageWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
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
                  return _auth.currentUser != null
                      ? HomePage()
                      : Padding(
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
                              Expanded(child: LoginForm()),
                              // Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MouseRegion(
                                      onEnter: (val) {
                                        setState(() {
                                          textColor = primaryColor[300];
                                        });
                                      },
                                      onExit: (val) {
                                        setState(() {
                                          textColor = white;
                                        });
                                      },
                                      cursor: SystemMouseCursors.click,
                                      child: CustomText(text: 'Armotale Express', color: textColor)),
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
                        );
                }

                if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
                  return _auth.currentUser != null
                      ? HomePage()
                      : Padding(
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
                              Expanded(child: LoginForm()),
                              // Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MouseRegion(
                                      onEnter: (val) {
                                        setState(() {
                                          textColor = primaryColor[300];
                                        });
                                      },
                                      onExit: (val) {
                                        setState(() {
                                          textColor = white;
                                        });
                                      },
                                      cursor: SystemMouseCursors.click,
                                      child: CustomText(text: 'Armotale Express', color: textColor)),
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
                        );
                }

                if (sizingInformation.deviceScreenType == DeviceScreenType.mobile) {
                  return _auth.currentUser != null ? HomePage() : LoginForm();
                }

                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  void checkUser() {
    // print(_auth.currentUser.uid.toString()??'null');
  }
}
