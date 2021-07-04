import 'package:armotaleadmin/models/driverModel.dart';
import 'package:armotaleadmin/widgets&helpers/helpers/helperClasses.dart';
import 'package:armotaleadmin/widgets&helpers/helpers/styling.dart';
import 'package:armotaleadmin/widgets&helpers/widgets/customButton.dart';
import 'package:armotaleadmin/widgets&helpers/widgets/customText.dart';
import 'package:armotaleadmin/widgets&helpers/widgets/textField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';

class SingleDriver extends StatefulWidget {
  const SingleDriver({Key key}) : super(key: key);

  @override
  _SingleDriverState createState() => _SingleDriverState();
}

class _SingleDriverState extends State<SingleDriver> {
  DriverModel selectedDriver;
  bool driverdetailsVisible;
   List<String> vehicleTypes = ['BIKE', 'VAN', 'TRUCK', 'TOWING VAN'];
  List<String> driverStatus = ['Active', 'Suspended', 'Deleted'];
  final firstNameController = new TextEditingController();
  final lastNameController = new TextEditingController();
  final emailController = new TextEditingController();
  final phoneController = new TextEditingController();
  String vehicleType = '';PickedFile dlimageToUpload;  PickedFile idimageToUpload;
  int totalDriverRevenue = 0;
bool driverActivated = false;
  bool userUpdateLoading = false;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: driverdetailsVisible == true,
      child: Stack(
        children: [
          Container(
            // alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: white,
            ),
            width: MediaQuery.of(context).size.width,
            // height: ,
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * .01,
              // horizontal: MediaQuery.of(context).size.width * .01,
            ),
            // height: 300,
            child: SizedBox.expand(
              child: SingleChildScrollView(
                // primary: false,
                scrollDirection: Axis.vertical,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            driverdetailsVisible = false;
                            idimageToUpload = null;
                            dlimageToUpload = null;
                          });
                        },
                        icon: Icon(Icons.arrow_back),
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SpinKitFadingCircle(color: black, size: 12),
                        ClipOval(
                          child: Container(
                            height: 110,
                            width: 110,
                            // decoration: BoxDecoration(shape: BoxShape.circle),
                            child: selectedDriver.profilePicture != null
                                ? FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: selectedDriver.profilePicture, fit: BoxFit.cover)
                                : Image.asset(HelperClass.noImage, fit: BoxFit.fill, height: 60, width: 60),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    CustomText(text: '${selectedDriver.firstName.toUpperCase()} ${selectedDriver.lastName.toUpperCase()}', fontWeight: FontWeight.bold),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(text: 'Vehicle Type: ', size: 17),
                        SizedBox(
                          height: 10,
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: Colors.grey[200]),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                              child: DropdownButtonHideUnderline(
                                  child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: DropdownButton(
                                  // onTap: () => print('object'),
                                  value: vehicleType.isNotEmpty ? vehicleType : null,
                                  hint: Text('Select the type of Vehicle'),
                                  onChanged: (val) {
                                    setState(() {
                                      vehicleType = val;
                                    });
                                  },
                                  items: vehicleTypes
                                      .map((e) => DropdownMenuItem(
                                            child: Text(e),
                                            value: e,
                                            onTap: () {
                                              setState(() {
                                                vehicleType = e;
                                              });
                                            },
                                          ))
                                      .toList(),
                                ),
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    CartItemRich(
                      lightFont: 'Total Earnings: ',
                      boldFont: '${HelperClass.naira}$totalDriverRevenue',
                      boldFontSize: 18,
                      lightFontSize: 15,
                    ),
                    SizedBox(height: 20),
                    Container(
                        width: MediaQuery.of(context).size.width * .35,
                        child: CustomRegisterTextField(
                          controller: firstNameController,
                          text: 'First Name',
                        )),
                    SizedBox(height: 5),
                    Container(
                        width: MediaQuery.of(context).size.width * .35,
                        child: CustomRegisterTextField(
                          controller: lastNameController,
                          text: 'Last Name',
                        )),
                    SizedBox(height: 5),
                    Container(
                        width: MediaQuery.of(context).size.width * .35,
                        child: CustomRegisterTextField(
                          controller: emailController,
                          text: 'Email Address',
                        )),
                    SizedBox(height: 5),
                    Container(
                        width: MediaQuery.of(context).size.width * .35,
                        child: CustomRegisterTextField(
                          controller: phoneController,
                          text: 'Phone Number',
                        )),
                    SizedBox(height: 20),
                    driverActivated == true
                        ? CustomFlatButton(
                            callback: () {
                              setState(() {
                                driverActivated = false;
                              });
                            },
                            color: Colors.red,
                            radius: 20,
                            text: 'Deactivate ${selectedDriver.firstName}',
                            textColor: white,
                          )
                        : CustomFlatButton(
                            callback: () {
                              setState(() {
                                driverActivated = true;
                              });
                            },
                            color: Colors.green,
                            radius: 20,
                            text: 'Activate ${selectedDriver.firstName}',
                            textColor: white,
                          ),
                    SizedBox(height: 20),
                    CustomFlatButton(
                      callback: () => updateDriverDetails(),
                                            color: primaryColor,
                                            radius: 20,
                                            text: 'Update ${selectedDriver.firstName}\'s details',
                                            textColor: white,
                                            icon: Icons.refresh,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: userUpdateLoading == true,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      color: white.withOpacity(.6),
                                    ),
                                    width: MediaQuery.of(context).size.width * .9,
                                    child: SpinKitThreeBounce(
                                      color: black,
                                      size: 60,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                      
                        updateDriverDetails() {}
}
