import 'dart:io';

import 'package:armotaleadmin/models/deliveryModel.dart';
import 'package:armotaleadmin/models/driverModel.dart';
import 'package:armotaleadmin/services/adminServices.dart';
import 'package:armotaleadmin/services/deliveryServices.dart';
import 'package:armotaleadmin/services/driverServices.dart';
import 'package:armotaleadmin/widgets&helpers/helpers/helperClasses.dart';
import 'package:armotaleadmin/widgets&helpers/helpers/styling.dart';
import 'package:armotaleadmin/widgets&helpers/widgets/customButton.dart';
import 'package:armotaleadmin/widgets&helpers/widgets/customText.dart';
import 'package:armotaleadmin/widgets&helpers/widgets/textField.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;
// import 'package:firebase_storage_web/firebase_storage_web.dart' as firebaseStorage;

enum ListType { gridView, listView }

class RiderManagement extends StatefulWidget {
  @override
  _RiderManagementState createState() => _RiderManagementState();
}

class _RiderManagementState extends State<RiderManagement> with TickerProviderStateMixin {
  List<DriverModel> drivers = [];
  List<DriverModel> searchedDrivers = [];
  List<DeliveryModel> deliveries = [];
  bool loading = true;
  DriverServices _driverServices = new DriverServices();
  AdminServices _adminServices = new AdminServices();
  DeliveryServices _deliveryServices = new DeliveryServices();
  List<bool> driversVerified = [];
  List<String> driverNames = [];
  String searchString = '';
  TargetPlatform targetPlatform;

  ListType listType = ListType.listView;
  AnimationController _animationController;
  Animation<Offset> _animation;
  DriverModel selectedDriver;
  bool driverdetailsVisible = false;
  bool driverActivated = false;
  ImagePicker _picker = new ImagePicker();

  bool userUpdateLoading = false;
  String idPicture = '';
  String idimageUrl = '';
  PickedFile idimageToUpload;

  String dlPicture = '';
  String dlImageUrl = '';
  PickedFile dlimageToUpload;

  int totalDriverRevenue = 0;
  // text editingController for updating driver details
  List<String> vehicleTypes = ['BIKE', 'VAN', 'TRUCK', 'TOWING VAN'];
  List<String> driverStatus = ['Active', 'Suspended', 'Deleted'];
  final firstNameController = new TextEditingController();
  final lastNameController = new TextEditingController();
  final emailController = new TextEditingController();
  final phoneController = new TextEditingController();
  String vehicleType = '';
  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();
    _animation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    getAllDrivers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey[200],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Center(
          child: Column(
            children: [
              loading == true
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomText(text: 'Please Wait..loading Employee data', size: 23),
                        SizedBox(width: 10),
                        SpinKitFadingCube(size: 13, color: black)
                      ],
                    )
                  : FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomText(
                              text: 'Manage Your Drivers - ${drivers.length} Registered Drivers', fontWeight: FontWeight.w300, letterSpacing: .2, size: 23),
                          SizedBox(width: 20),
                          CustomFlatButton(
                            icon: Icons.refresh,
                            width: 100,
                            radius: 30,
                            text: 'Refresh',
                            textColor: white,
                            callback: () {
                              getAllDrivers().whenComplete(() => Fluttertoast.showToast(
                                    msg: 'Driver LIst updated succesfully',
                                    webShowClose: false,
                                    webPosition: 'center',
                                  ));
                            },
                          )
                        ],
                      ),
                    ),
              Align(
                alignment: Alignment.topLeft,
                child: SearchTextField(
                  width: 200,
                  hint: 'Search driver by name',
                  onChanged: (String val) {
                    searchedDrivers.clear();
                    setState(() {
                      driverdetailsVisible = false;
                      searchString = val;
                    });
                    for (int i = 0; i < driverNames.length; i++) {
                      if (driverNames[i].startsWith(val)) {
                        searchedDrivers.add(drivers[i]);
                        for (int i = 0; i < searchedDrivers.length; i++) {
                          print(searchedDrivers[i].lastName);
                        }
                      }
                    }
                  },
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Table(
                    defaultColumnWidth: FixedColumnWidth(100),
                    border: TableBorder.all(color: Colors.black26, width: 1, style: BorderStyle.none),
                    children: [
                      TableRow(children: [
                        TableCell(child: Center(child: CustomText(text: 'Image', maxLines: 2, size: 14, textAlign: TextAlign.center))),
                        TableCell(child: Center(child: CustomText(text: 'Names', maxLines: 2, size: 14, textAlign: TextAlign.center))),
                        TableCell(child: Center(child: CustomText(text: 'Revenue', maxLines: 2, size: 14, textAlign: TextAlign.center))),
                        TableCell(child: Center(child: CustomText(text: 'Verified', maxLines: 2, size: 14, textAlign: TextAlign.center))),
                        TableCell(child: Center(child: CustomText(text: 'Email', maxLines: 2, size: 14, textAlign: TextAlign.center))),
                        TableCell(child: Center(child: CustomText(text: 'Actions', maxLines: 2, size: 14, textAlign: TextAlign.center))),
                      ]),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    selectedListType(),
                    if (loading == false) manageSingleDriver(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget selectedListType() {
    return loading == true
        ? SpinKitFadingCube(color: black, size: 40)
        : ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: ListView(
                      shrinkWrap: true,
                      primary: false,
                      children: searchString.length > 0
                          ? searchedDrivers
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        color: white,
                                        boxShadow: [
                                          BoxShadow(color: grey[200], offset: Offset(2, 2), blurRadius: 3, spreadRadius: 3),
                                        ],
                                        gradient: LinearGradient(
                                          colors: [
                                            white,
                                            primaryColor[100],
                                          ],
                                          begin: Alignment.bottomLeft,
                                          end: Alignment.topRight,
                                        )),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Table(
                                        defaultColumnWidth: FixedColumnWidth(100),
                                        border: TableBorder.all(color: Colors.black26, width: 1, style: BorderStyle.none),
                                        children: [
                                          TableRow(children: [
                                            TableCell(
                                                child: Center(
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  SpinKitFadingCircle(color: black, size: 12),
                                                  ClipOval(
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      // decoration: BoxDecoration(shape: BoxShape.circle),
                                                      child: e.profilePicture != null
                                                          ? FadeInImage.memoryNetwork(
                                                              placeholder: kTransparentImage, image: e.profilePicture, fit: BoxFit.cover)
                                                          : Image.asset(HelperClass.noImage, fit: BoxFit.fill, height: 60, width: 60),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )),
                                            TableCell(
                                                verticalAlignment: TableCellVerticalAlignment.middle,
                                                child: Center(
                                                  child: AutoSizeText(
                                                    '${e.firstName} ${e.lastName}'.toUpperCase(),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                  ),
                                                )),
                                            TableCell(
                                                verticalAlignment: TableCellVerticalAlignment.middle,
                                                child: Center(
                                                  child: CustomText(
                                                      text: '${HelperClass.naira}${getIndexDriverEarnings(e.driverId)}', fontWeight: FontWeight.bold),
                                                )),
                                            TableCell(
                                                verticalAlignment: TableCellVerticalAlignment.middle,
                                                child: Center(
                                                  child: Checkbox(
                                                      value: driversVerified[drivers.indexOf(e)],
                                                      onChanged: (value) async {
                                                        setState(() {
                                                          driversVerified[drivers.indexOf(e)] = value;
                                                        });
                                                        print(value);
                                                        _adminServices.authorizeUser(e.driverId, driversVerified[drivers.indexOf(e)], context);
                                                      }),
                                                )),
                                            TableCell(
                                              verticalAlignment: TableCellVerticalAlignment.middle,
                                              child: Center(
                                                child: CustomText(
                                                  text: e.email,
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              verticalAlignment: TableCellVerticalAlignment.middle,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {},
                                                        icon: Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                        )),
                                                    IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            selectedDriver = e;
                                                            driverdetailsVisible = true;
                                                            vehicleType = selectedDriver.vehicleType;
                                                            dlPicture = selectedDriver.identificationPicture;
                                                            idPicture = selectedDriver.driverLicense;
                                                            driverActivated = selectedDriver.status ?? false;

                                                            phoneController.text = selectedDriver.phoneNumber;
                                                            emailController.text = selectedDriver.email;
                                                            firstNameController.text = selectedDriver.firstName;
                                                            lastNameController.text = selectedDriver.lastName;
                                                          });

                                                          getSelectedDriverEarnings();
                                                        },
                                                        icon: Icon(
                                                          Icons.edit,
                                                          color: Colors.black,
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ]),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList()
                          : drivers
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        color: white,
                                        boxShadow: [
                                          BoxShadow(color: grey[200], offset: Offset(2, 2), blurRadius: 3, spreadRadius: 3),
                                        ],
                                        gradient: LinearGradient(
                                          colors: [
                                            white,
                                            primaryColor[100],
                                          ],
                                          begin: Alignment.bottomLeft,
                                          end: Alignment.topRight,
                                        )),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Table(
                                        defaultColumnWidth: FixedColumnWidth(100),
                                        border: TableBorder.all(color: Colors.black26, width: 1, style: BorderStyle.none),
                                        children: [
                                          TableRow(children: [
                                            TableCell(
                                                child: Center(
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  SpinKitFadingCircle(color: black, size: 12),
                                                  ClipOval(
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      // decoration: BoxDecoration(shape: BoxShape.circle),
                                                      child: e.profilePicture != null
                                                          ? FadeInImage.memoryNetwork(
                                                              placeholder: kTransparentImage, image: e.profilePicture, fit: BoxFit.cover)
                                                          : Image.asset(HelperClass.noImage, fit: BoxFit.fill, height: 60, width: 60),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )),
                                            TableCell(
                                                verticalAlignment: TableCellVerticalAlignment.middle,
                                                child: Center(
                                                  child: AutoSizeText(
                                                    '${e.firstName} ${e.lastName}'.toUpperCase(),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                  ),
                                                )),
                                            TableCell(
                                                verticalAlignment: TableCellVerticalAlignment.middle,
                                                child: Center(
                                                  child: CustomText(
                                                      text: '${HelperClass.naira}${getIndexDriverEarnings(e.driverId)}', fontWeight: FontWeight.bold),
                                                )),
                                            TableCell(
                                                verticalAlignment: TableCellVerticalAlignment.middle,
                                                child: Center(
                                                  child: Checkbox(
                                                      value: driversVerified[drivers.indexOf(e)],
                                                      onChanged: (value) async {
                                                        setState(() {
                                                          driversVerified[drivers.indexOf(e)] = value;
                                                        });
                                                        print(value);
                                                        _adminServices.authorizeUser(e.driverId, driversVerified[drivers.indexOf(e)], context);
                                                      }),
                                                )),
                                            TableCell(
                                              verticalAlignment: TableCellVerticalAlignment.middle,
                                              child: Center(
                                                child: CustomText(
                                                  text: e.email,
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              verticalAlignment: TableCellVerticalAlignment.middle,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {},
                                                        icon: Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                        )),
                                                    IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            selectedDriver = e;
                                                            driverdetailsVisible = true;
                                                            vehicleType = selectedDriver.vehicleType;
                                                            dlPicture = selectedDriver.identificationPicture;
                                                            idPicture = selectedDriver.driverLicense;
                                                            driverActivated = selectedDriver.status ?? false;

                                                            phoneController.text = selectedDriver.phoneNumber;
                                                            emailController.text = selectedDriver.email;
                                                            firstNameController.text = selectedDriver.firstName;
                                                            lastNameController.text = selectedDriver.lastName;
                                                          });

                                                          getSelectedDriverEarnings();
                                                        },
                                                        icon: Icon(
                                                          Icons.edit,
                                                          color: Colors.black,
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ]),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget manageSingleDriver() {
    return Visibility(
      visible: driverdetailsVisible == true,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: white,
            ),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * .01,
            ),
            child: SizedBox.expand(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
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
                        width: MediaQuery.of(context).size.width * .45,
                        child: CustomRegisterTextField(
                          controller: firstNameController,
                          text: 'First Name',
                        )),
                    SizedBox(height: 5),
                    Container(
                        width: MediaQuery.of(context).size.width * .45,
                        child: CustomRegisterTextField(
                          controller: lastNameController,
                          text: 'Last Name',
                        )),
                    SizedBox(height: 5),
                    Container(
                        width: MediaQuery.of(context).size.width * .45,
                        child: CustomRegisterTextField(
                          controller: emailController,
                          text: 'Email Address',
                        )),
                    SizedBox(height: 5),
                    Container(
                        width: MediaQuery.of(context).size.width * .45,
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

  // pickDesktopIDImage() {}
  pickIDImage(Future<PickedFile> pickImage) async {
    PickedFile selectedIDImage = await pickImage;
    setState(() {
      idimageToUpload = selectedIDImage;
    });
  }

  driverIdImage() {
    return idimageToUpload == null
        ? Image.asset(
            HelperClass.noImage,
            fit: BoxFit.cover,
          )
        : (kIsWeb)
            ? Image.network(
                idimageToUpload.path,
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height * .15,
                width: (MediaQuery.of(context).size.width * .9) / 4,
              )
            : Image.file(File(idimageToUpload.path));
  }

  pickDLImage(Future<PickedFile> pickImage) async {
    PickedFile selectedDLImage = await pickImage;
    setState(() {
      dlimageToUpload = selectedDLImage;
    });
  }

  driverDLImage() {
    return dlimageToUpload == null
        ? Image.asset(
            HelperClass.noImage,
            fit: BoxFit.cover,
          )
        : (kIsWeb)
            ? Image.network(
                dlimageToUpload.path,
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height * .15,
                width: (MediaQuery.of(context).size.width * .9) / 4,
              )
            : Image.file(File(dlimageToUpload.path));
  }

  updateDriverDetails() async {
    setState(() {
      userUpdateLoading = true;
    });
    if (dlimageToUpload != null && kIsWeb == true) {
      try {
        String dlImageName = dlimageToUpload.path + DateTime.now().microsecondsSinceEpoch.toString();
        firebaseStorage.TaskSnapshot snapshot =
            await firebaseStorage.FirebaseStorage.instance.ref().child('VerificationDocs/$dlImageName').putFile(File(dlimageToUpload.path));
        dlImageUrl = await snapshot.ref.getDownloadURL();
        await _driverServices
            .updateUser(selectedDriver.driverId, driverActivated, firstNameController.text, lastNameController.text, emailController.text, phoneController.text)
            .then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: grey[100],
                content: CustomText(
                  text: '${selectedDriver.firstName}\'s data has been Updated Successfully',
                  textAlign: TextAlign.center,
                  color: Colors.green,
                ))));
      } catch (e) {
        print('the error is' + e.toString());
      }
    }
    if (idimageToUpload != null && kIsWeb == true) {
      try {
        String idImageName = idimageToUpload.path + DateTime.now().microsecondsSinceEpoch.toString();
        firebaseStorage.TaskSnapshot snapshot =
            await firebaseStorage.FirebaseStorage.instance.ref().child('VerificationDocs/$idImageName').putFile(File(idimageToUpload.path));
        idimageUrl = await snapshot.ref.getDownloadURL();
        await _driverServices
            .updateUser(selectedDriver.driverId, driverActivated, firstNameController.text, lastNameController.text, emailController.text, phoneController.text)
            .then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: grey[100],
                content: CustomText(
                  text: '${selectedDriver.firstName}\'s data has been Updated Successfully',
                  textAlign: TextAlign.center,
                  color: Colors.green,
                ))));
      } catch (e) {
        print('the error also is' + e.toString());
      }
    }
    if (dlimageToUpload == null && idimageToUpload == null) {
      await _driverServices
          .updateUser(selectedDriver.driverId, driverActivated, firstNameController.text, lastNameController.text, emailController.text, phoneController.text)
          .then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: CustomText(
                text: '${selectedDriver.firstName}\'s data has been Updated Successfully',
                textAlign: TextAlign.center,
                color: Colors.green,
              ))));
    }
    setState(() {
      userUpdateLoading = false;
    });
  }

  Future getAllDrivers() async {
    setState(() {
      loading = true;
    });
    drivers = await _driverServices.getAllDrivers();
    for (int i = 0; i < drivers.length; i++) {
      driversVerified.add(drivers[i].verified ?? false);
      driverNames.add(drivers[i].firstName);
      // print(driverNames);
    }
    selectedDriver = drivers[0];
    // vehicleType = vehicleTypes[0];
    dlPicture = selectedDriver.identificationPicture;
    idPicture = selectedDriver.driverLicense;
    deliveries = await _deliveryServices.getDeliveries();
    print(deliveries.length.toString());
    setState(() {
      loading = false;
    });
  }

  getSelectedDriverEarnings() {
    int earnings = 0;
    for (int i = 0; i < deliveries.length; i++) {
      if (deliveries[i].status == HelperClass.deliveryComplete && deliveries[i].driverId == selectedDriver.driverId) {
        earnings += deliveries[i].earnings;
      }
    }
    setState(() {
      totalDriverRevenue = earnings ?? 0;
    });
  }

  int getIndexDriverEarnings(String driverID) {
    int indexEarnings = 0;
    try {
      for (int i = 0; i < deliveries.length; i++) {
        if (deliveries[i].status == HelperClass.deliveryComplete && deliveries[i].driverId == driverID) {
          indexEarnings += deliveries[i].earnings;
        }
      }
      return indexEarnings;
    } catch (e) {
      print('object' + e.toString());
      return null;
    }
  }
}
