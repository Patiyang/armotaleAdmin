import 'package:armotaleadmin/models/adminModel.dart';
import 'package:armotaleadmin/services/adminServices.dart';
import 'package:armotaleadmin/widgets&helpers/helpers/helperClasses.dart';
import 'package:armotaleadmin/widgets&helpers/helpers/styling.dart';
import 'package:armotaleadmin/widgets&helpers/widgets/customButton.dart';
import 'package:armotaleadmin/widgets&helpers/widgets/customText.dart';
import 'package:armotaleadmin/widgets&helpers/widgets/textField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppSettings extends StatefulWidget {
  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  final servicesProvidedController = new TextEditingController();
  final termsAndCondition = new TextEditingController();
  final aboutUs = new TextEditingController();
  final miscSettings = new TextEditingController();

  List<AdminModel> admin = [];
  AdminServices adminServices = new AdminServices();
  bool loading = false;
  bool updatingUser = false;

  @override
  void initState() {
    getCurrentValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(10),
      child: loading == true
          ? SpinKitFadingCube(
              color: black,
              size: 40,
            )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              primary: false,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: 'Manage your app settings ',
                    fontWeight: FontWeight.bold,
                    size: 22,
                  ),
                  SizedBox(height: 10),
                  CartItemRich(
                    lightFont: 'Last Updated On: ',
                    boldFont: admin[0].updatedAt == Timestamp.fromMillisecondsSinceEpoch(0) ? 'Never' : admin[0].updatedAt.toDate().toString().substring(0, 16),
                    lightFontSize: 17,
                    boldFontSize: 22,
                  ),
                  SizedBox(height: 20),
                  Image.asset(HelperClass.logo, height: 100, width: 150, fit: BoxFit.contain),
                  SizedBox(height: 20),
                  Align(alignment: Alignment.centerLeft, child: CustomText(text: 'About us', size: 22, fontWeight: FontWeight.bold)),
                  CustomRegisterTextField(
                    text: 'Say something about the mobile app',
                    maxLins: 4,
                    controller: aboutUs,
                  ),
                  Align(alignment: Alignment.centerLeft, child: CustomText(text: 'Terms & Conditions', size: 22, fontWeight: FontWeight.bold)),
                  CustomRegisterTextField(
                    text: 'Describe the terms and conditions for using the app',
                    maxLins: 4,
                    controller: termsAndCondition,
                  ),
                  Align(alignment: Alignment.centerLeft, child: CustomText(text: 'Our Services', size: 22, fontWeight: FontWeight.bold)),
                  CustomRegisterTextField(
                    text: 'Say something about the services you provide',
                    maxLins: 4,
                    controller: servicesProvidedController,
                  ),
                  Align(alignment: Alignment.centerLeft, child: CustomText(text: 'Miscellaneous', size: 22, fontWeight: FontWeight.bold)),
                  CustomRegisterTextField(
                    text: 'Include additional info that may be necessary regarding the use of your app',
                    maxLins: 4,
                    controller: miscSettings,
                  ),
                  updatingUser == true
                      ? SpinKitThreeBounce(
                          color: black,
                          size: 30,
                        )
                      : CustomFlatButton(
                          icon: Icons.update,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          text: 'UPDATE DATA',
                          callback: () => updateAppValues(),
                          radius: 20,
                          iconColor: white,
                          iconSize: 30,
                          textColor: white,
                          height: 50,
                        ),
                ],
              ),
            ),
    );
  }

  getCurrentValues() async {
    setState(() {
      loading = true;
    });
    admin = await adminServices.getLatestValues();
    servicesProvidedController.text = admin[0].services;
    termsAndCondition.text = admin[0].termsConditions;
    aboutUs.text = admin[0].aboutUs;
    miscSettings.text = admin[0].miscSettings;
    setState(() {
      loading = false;
    });
  }

  updateAppValues() async {
    setState(() {
      updatingUser = true;
    });
    await adminServices.updateAdmin(termsAndCondition.text, servicesProvidedController.text, miscSettings.text, aboutUs.text, Timestamp.now());
    setState(() {
      updatingUser = false;
    });
  }
}
