import 'dart:io';

import 'package:armotaleadmin/services/adminServices.dart';
import 'package:armotaleadmin/views/home/admin/appSettings.dart';
import 'package:armotaleadmin/views/home/dashboard/dashboard.dart';
import 'package:armotaleadmin/views/home/dashboard/googleMaps.dart';
import 'package:armotaleadmin/views/home/dashboard/riderManagement/riderManagement.dart';
import 'package:armotaleadmin/views/home/dashboard/userManagement/userManagement.dart';
import 'package:armotaleadmin/widgets&helpers/helpers/helperClasses.dart';
import 'package:armotaleadmin/widgets&helpers/helpers/styling.dart';
import 'package:armotaleadmin/widgets&helpers/widgets/customDrawerItem.dart';
import 'package:armotaleadmin/widgets&helpers/widgets/customListTIle.dart';
import 'package:armotaleadmin/widgets&helpers/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'dashboard/tripManagement/tripManagement.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  // FirebaseAuth auth = FirebaseAuth.instance;
  AdminServices _adminServices = new AdminServices();
  final bool showCustomDrawer = false;
  String pageTitle = 'DASHBOARD';
  int selectedIndex = 0;
  String currentExpansionText = '';
  bool isSelected = false;
  Platform platform = Platform();
  // SizingInformation sizingInformation = new sizingin
  @override
  void initState() {
    // print(platform.);
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return selectedScreen();
  }

  Widget selectedScreen() {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        List<CustomDrawerItem> customDrawerItems = <CustomDrawerItem>[
          CustomDrawerItem(
              callback: () {
                setState(() {
                  selectedIndex = 0;
                  currentExpansionText = '';
                  pageTitle = 'DASHBOARD';
                });
                if (sizingInformation.deviceScreenType != DeviceScreenType.desktop) {
                  Navigator.pop(context);
                }
              },
              title: 'Dashboard'),
          CustomDrawerItem(
              callback: () {
                setState(() {
                  selectedIndex = 1;
                  currentExpansionText = '';
                  pageTitle = 'TRIP MANAGEMENT';
                });
                if (sizingInformation.deviceScreenType != DeviceScreenType.desktop) {
                  Navigator.pop(context);
                }
              },
              title: 'Trip Management'),
          CustomDrawerItem(
              callback: () {
                setState(() {
                  selectedIndex = 2;
                  currentExpansionText = '';
                  pageTitle = 'USER MANAGEMENT';
                });
                if (sizingInformation.deviceScreenType != DeviceScreenType.desktop) {
                  Navigator.pop(context);
                }
              },
              title: 'User Management'),
          CustomDrawerItem(
              callback: () {
                setState(() {
                  selectedIndex = 3;
                  currentExpansionText = '';
                  pageTitle = 'RIDER MANAGEMENT';
                });
                if (sizingInformation.deviceScreenType != DeviceScreenType.desktop) {
                  Navigator.pop(context);
                }
              },
              title: 'Rider Management'),
          CustomDrawerItem(
              callback: () {
                setState(() {
                  selectedIndex = 4;
                  currentExpansionText = '';
                  pageTitle = 'MAPS';
                });
                if (sizingInformation.deviceScreenType != DeviceScreenType.desktop) {
                  Navigator.pop(context);
                }
              },
              title: 'Maps'),
        ];
        if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  children: [
                    CustomText(text: pageTitle),
                    Spacer(),
                    Image.asset(
                      HelperClass.logo,
                      height: 20,
                      width: 100,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    width: 300,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ExpansionTile(
                          childrenPadding: EdgeInsets.only(left: 55),
                          expandedAlignment: Alignment.centerLeft,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(
                                  HelperClass.mainLogo,
                                ),
                                backgroundColor: white,
                                radius: 30,
                              ),
                              SizedBox(width: 15),
                              Expanded(child: CustomText(text: 'Admin')),
                            ],
                          ),
                          children: [
                            SizedBox(height: 13),
                            CustomListTile(
                              title: Padding(
                                padding: currentExpansionText != '' && currentExpansionText != 'logOut'
                                    ? const EdgeInsets.only(left: 8.0)
                                    : const EdgeInsets.only(left: 0.0),
                                child: CustomText(
                                  text: 'Mobile App Settings',
                                  color: currentExpansionText != '' && currentExpansionText != 'logOut' ? primaryColor : black,
                                ),
                              ),
                              leading: Icon(Icons.person),
                              color: grey[200],
                              callback: () {
                                setState(() {
                                  currentExpansionText = 'AppSettings';
                                  selectedIndex = null;
                                  pageTitle = 'Mobile App Settings';
                                });
                              },
                            ),
                            CustomListTile(
                              title: CustomText(text: 'Logout'),
                              leading: Icon(Icons.exit_to_app),
                              color: grey[200],
                              callback: () {
                                setState(() {
                                  currentExpansionText = 'logOut';
                                });
                                _adminServices.signOutAdmin(context);
                              },
                            ),
                          ],
                        ),
                        Column(
                          children: customDrawerItems
                              .map((e) => CustomDrawerItem(
                                    title: e.title,
                                    callback: e.callback,
                                    color: selectedIndex == customDrawerItems.indexOf(e) ? primaryColor[300] : grey[100],
                                  ))
                              .toList(),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: grey[200],
                          borderRadius: BorderRadius.all(Radius.circular(9)),
                        ),
                        child: selectedPage()),
                  ),
                ],
              ),
            ),
          );
        }

        if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              iconTheme: IconThemeData(color: black),
              automaticallyImplyLeading: true,
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
          
              ),
            ),
            body: selectedPage(),
            drawer: Container(
              width: 300,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(color: grey[200]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExpansionTile(
                    maintainState: true,
                    childrenPadding: EdgeInsets.only(left: 55),
                    expandedAlignment: Alignment.centerLeft,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(HelperClass.logo),
                          radius: 30,
                        ),
                        SizedBox(width: 15),
                        Expanded(child: CustomText(text: 'Admin')),
                      ],
                    ),
                    children: [
                      SizedBox(height: 13),
                      CustomListTile(
                        title: Padding(
                          padding: currentExpansionText != '' && currentExpansionText != 'logOut'
                              ? const EdgeInsets.only(left: 8.0)
                              : const EdgeInsets.only(left: 0.0),
                          child: CustomText(
                            text: 'Mobile App Settings',
                            color: currentExpansionText != '' && currentExpansionText != 'logOut' ? primaryColor : black,
                          ),
                        ),
                        leading: Icon(Icons.person),
                        color: grey[200],
                        callback: () {
                          setState(() {
                            currentExpansionText = 'AppSettings';
                            selectedIndex = null;
                            Navigator.pop(context);
                          });
                        },
                      ),
                      CustomListTile(
                        title: CustomText(text: 'Logout'),
                        leading: Icon(Icons.exit_to_app),
                        color: grey[200],
                        callback: () {
                          setState(() {
                            currentExpansionText = 'logOut';
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: customDrawerItems
                        .map((e) => CustomDrawerItem(
                              title: e.title,
                              callback: e.callback,
                              color: selectedIndex == customDrawerItems.indexOf(e) ? primaryColor[300] : grey[100],
                            ))
                        .toList(),
                  )
                ],
              ),
            ),
          );
        }

        if (sizingInformation.deviceScreenType == DeviceScreenType.mobile) {
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              iconTheme: IconThemeData(color: black),
              automaticallyImplyLeading: true,
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              
            ),
            body: selectedPage(),
            drawer: Container(
              width: 300,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(color: grey[200]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExpansionTile(
                    maintainState: true,
                    childrenPadding: EdgeInsets.only(left: 55),
                    expandedAlignment: Alignment.centerLeft,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(HelperClass.logo),
                          radius: 30,
                        ),
                        SizedBox(width: 15),
                        Expanded(child: CustomText(text: 'Admin')),
                      ],
                    ),
                    children: [
                      SizedBox(height: 13),
                      CustomListTile(
                        title: Padding(
                          padding: currentExpansionText != '' && currentExpansionText != 'logOut'
                              ? const EdgeInsets.only(left: 8.0)
                              : const EdgeInsets.only(left: 0.0),
                          child: CustomText(
                            text: 'Mobile App Settings',
                            color: currentExpansionText != '' && currentExpansionText != 'logOut' ? primaryColor : black,
                          ),
                        ),
                        leading: Icon(Icons.person),
                        color: grey[200],
                        callback: () {
                          setState(() {
                            currentExpansionText = 'AppSettings';
                            selectedIndex = null;
                            Navigator.pop(context);
                          });
                        },
                      ),
                      CustomListTile(
                        title: CustomText(text: 'Logout'),
                        leading: Icon(Icons.exit_to_app),
                        color: grey[200],
                        callback: () {
                          setState(() {
                            currentExpansionText = 'logOut';
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: customDrawerItems
                        .map((e) => CustomDrawerItem(
                              title: e.title,
                              callback: e.callback,
                              color: selectedIndex == customDrawerItems.indexOf(e) ? primaryColor[300] : grey[100],
                            ))
                        .toList(),
                  )
                ],
              ),
            ),
          );
        }

        return Container(color: Colors.purple);
      },
    );
  }

  Widget selectedPage() {
    if (currentExpansionText == 'AppSettings') {
      return AppSettings();
    } else {
      if (selectedIndex == 0) {
        return Dashboard();
      }
      if (selectedIndex == 1) {
        return TripManagement();
      }
      if (selectedIndex == 2) {
        return UserManagement();
      }
      if (selectedIndex == 3) {
        return RiderManagement();
      }
      if (selectedIndex == 4) {
        return MapsScreen();
      }
    }
    return Container(
      child: Center(
        child: CustomText(text: 'Logout'),
      ),
    );
  }
}
