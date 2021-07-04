import 'package:armotaleadmin/models/customerModel.dart';
import 'package:armotaleadmin/models/deliveryModel.dart';
import 'package:armotaleadmin/services/customerServices.dart';
import 'package:armotaleadmin/services/deliveryServices.dart';
import 'package:armotaleadmin/widgets&helpers/helpers/helperClasses.dart';
import 'package:armotaleadmin/widgets&helpers/helpers/styling.dart';
import 'package:armotaleadmin/widgets&helpers/widgets/customButton.dart';
import 'package:armotaleadmin/widgets&helpers/widgets/customText.dart';
import 'package:armotaleadmin/widgets&helpers/widgets/textField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:transparent_image/transparent_image.dart';

enum ListType { gridView, listView }

class UserManagement extends StatefulWidget {
  @override
  _UserManagementState createState() => _UserManagementState();
}

bool showEditContainer = false;
CustomerModel selectedCustomer;
bool userUpdateLoading = false;
double totalUserRevenue = 0;

class _UserManagementState extends State<UserManagement> {
  //CUSTOMER MODELS
  List<CustomerModel> customers = [];
  List<CustomerModel> searchedCustomers = [];
  List<DeliveryModel> deliveries = [];
//DELIVERIES
  DeliveryServices _deliveryServices = new DeliveryServices();

  bool loading = true;
  List<String> customerNames = [];
  String searchString = '';
  ListType listType = ListType.gridView;
  CustomerService customerService = new CustomerService();
  @override
  void initState() {
    super.initState();
    getAllCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey[200],
      body: ResponsiveBuilder(
        builder: (context, sizeInfo) {
          if (sizeInfo.deviceScreenType == DeviceScreenType.desktop) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: Column(
                  children: [
                    loading == true
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomText(text: 'Please Wait..loading Customer data', size: 23),
                              SizedBox(width: 10),
                              SpinKitFadingCube(size: 13, color: black)
                            ],
                          )
                        : FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomText(
                                    text: 'Customer Management - ${customers.length} Registered customers',
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: .2,
                                    size: 23),
                                SizedBox(width: 20),
                                CustomFlatButton(
                                  width: 90,
                                  radius: 30,
                                  text: 'Refresh',
                                  textColor: white,
                                  icon: Icons.refresh,
                                  callback: () => getAllCustomers(),
                                )
                              ],
                            ),
                          ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          SearchTextField(
                            width: 200,
                            hint: 'Search Customer by name',
                            onChanged: (String val) {
                              searchedCustomers.clear();
                              setState(() {
                                searchString = val;
                              });
                              for (int i = 0; i < customerNames.length; i++) {
                                if (customerNames[i].startsWith(val)) {
                                  searchedCustomers.add(customers[i]);
                                  for (int i = 0; i < searchedCustomers.length; i++) {
                                    print(searchedCustomers[i].names);
                                  }
                                }
                              }
                            },
                          ),
                          Spacer(),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          selectedListType(),
                          if (loading == false) singleCustomer(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                  text: 'Customer Management - ${customers.length} Registered customers',
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: .2,
                                  size: 23),
                              // Spacer(),
                              SizedBox(width: 20),

                              CustomFlatButton(
                                width: 90,
                                radius: 30,
                                text: 'Refresh',
                                textColor: white,
                                icon: Icons.refresh,
                                callback: () => getAllCustomers(),
                              )
                            ],
                          ),
                        ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        SearchTextField(
                          width: 200,
                          hint: 'Search Customer by name',
                          onChanged: (String val) {
                            searchedCustomers.clear();
                            setState(() {
                              searchString = val;
                            });
                            for (int i = 0; i < customerNames.length; i++) {
                              if (customerNames[i].startsWith(val)) {
                                searchedCustomers.add(customers[i]);
                                for (int i = 0; i < searchedCustomers.length; i++) {
                                  print(searchedCustomers[i].names);
                                }
                              }
                            }
                          },
                        ),
                        Spacer(),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        selectedListType(),
                        if (loading == false) singleCustomer(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget singleCustomer(BuildContext context) {
    return Visibility(
      visible: showEditContainer == true,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            showEditContainer = false;
                          });
                        },
                        icon: Icon(Icons.arrow_back),
                      ),
                    ),
                    ResponsiveBuilder(builder: (context, sizingInfo) {
                      if (sizingInfo.deviceScreenType == DeviceScreenType.desktop) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SpinKitFadingCircle(color: black, size: 12),
                                    ClipOval(
                                      child: Container(
                                        height: 110,
                                        width: 110,
                                        child: selectedCustomer.profilePicture != null
                                            ? FadeInImage.memoryNetwork(
                                                placeholder: kTransparentImage, image: selectedCustomer.profilePicture, fit: BoxFit.cover)
                                            : Image.asset(HelperClass.noImage, fit: BoxFit.fill, height: 60, width: 60),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10),
                                CartItemRich(
                                  lightFont: 'Full Names: ',
                                  boldFont: '${selectedCustomer.names}',
                                  boldFontSize: 18,
                                  lightFontSize: 15,
                                ),
                                SizedBox(height: 10),
                                CartItemRich(
                                  lightFont: 'Total Earnings: ',
                                  boldFont: '${HelperClass.naira}$totalUserRevenue',
                                  boldFontSize: 18,
                                  lightFontSize: 15,
                                ),
                                CartItemRich(
                                  lightFont: 'User Id: ',
                                  boldFont: '${selectedCustomer.id}',
                                  boldFontSize: 18,
                                  lightFontSize: 15,
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: primaryColor, style: BorderStyle.solid),
                                  color: white,
                                  borderRadius: BorderRadius.all(Radius.circular(9))),
                              child: FittedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      text: 'Address Information',
                                      size: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    SizedBox(height: 10),
                                    CartItemRich(
                                      lightFont: 'Land Mark: ',
                                      boldFont: '${selectedCustomer.landMark}',
                                      boldFontSize: 18,
                                      lightFontSize: 15,
                                    ),
                                    CartItemRich(
                                      lightFont: 'User Address: ',
                                      boldFont: '${selectedCustomer.senderAddress}',
                                      boldFontSize: 18,
                                      lightFontSize: 15,
                                    ),
                                    CartItemRich(
                                      lightFont: 'User Email: ',
                                      boldFont: '${selectedCustomer.email}',
                                      boldFontSize: 18,
                                      lightFontSize: 15,
                                    ),
                                    CartItemRich(
                                      lightFont: 'User Phone Number: ',
                                      boldFont: '${selectedCustomer.phoneNumber}',
                                      boldFontSize: 18,
                                      lightFontSize: 15,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SpinKitFadingCircle(color: black, size: 12),
                                  ClipOval(
                                    child: Container(
                                      height: 110,
                                      width: 110,
                                      child: selectedCustomer.profilePicture != null
                                          ? FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: selectedCustomer.profilePicture, fit: BoxFit.cover)
                                          : Image.asset(HelperClass.noImage, fit: BoxFit.fill, height: 60, width: 60),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              CartItemRich(
                                lightFont: 'Full Names: ',
                                boldFont: '${selectedCustomer.names}',
                                boldFontSize: 18,
                                lightFontSize: 15,
                              ),
                              SizedBox(height: 10),
                              CartItemRich(
                                lightFont: 'Total Earnings: ',
                                boldFont: '${HelperClass.naira}$totalUserRevenue',
                                boldFontSize: 18,
                                lightFontSize: 15,
                              ),
                              CartItemRich(
                                lightFont: 'User Id: ',
                                boldFont: '${selectedCustomer.id}',
                                boldFontSize: 18,
                                lightFontSize: 15,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.all(9),
                            decoration: BoxDecoration(
                                border: Border.all(width: 1, color: primaryColor, style: BorderStyle.solid),
                                color: white,
                                borderRadius: BorderRadius.all(Radius.circular(9))),
                            child: FittedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: 'Address Information',
                                    size: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(height: 10),
                                  CartItemRich(
                                    lightFont: 'Land Mark: ',
                                    boldFont: '${selectedCustomer.landMark}',
                                    boldFontSize: 18,
                                    lightFontSize: 15,
                                  ),
                                  CartItemRich(
                                    lightFont: 'User Address: ',
                                    boldFont: '${selectedCustomer.senderAddress}',
                                    boldFontSize: 18,
                                    lightFontSize: 15,
                                  ),
                                  CartItemRich(
                                    lightFont: 'User Email: ',
                                    boldFont: '${selectedCustomer.email}',
                                    boldFontSize: 18,
                                    lightFontSize: 15,
                                  ),
                                  CartItemRich(
                                    lightFont: 'User Phone Number: ',
                                    boldFont: '${selectedCustomer.phoneNumber}',
                                    boldFontSize: 18,
                                    lightFontSize: 15,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    }),
                    SizedBox(height: 20),
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

  Widget selectedListType() {
    return loading == true
        ? SpinKitFadingCube(color: black, size: 40)
        : ListView(
          primary: false,
          shrinkWrap: true,
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Table(
                      defaultColumnWidth: FixedColumnWidth(100),
                      border: TableBorder.all(color: Colors.black26, width: 1, style: BorderStyle.none),
                      children: [
                        TableRow(children: [
                          TableCell(child: Center(child: Text('Profile Image', textAlign: TextAlign.center))),
                          TableCell(child: Center(child: Text('Customer Names', textAlign: TextAlign.center))),
                          TableCell(child: Center(child: Text('Revenue spent', textAlign: TextAlign.center))),
                          TableCell(child: Center(child: Text('Phone Number', textAlign: TextAlign.center))),
                          TableCell(child: Center(child: Text('Email Address', textAlign: TextAlign.center))),
                          TableCell(child: Center(child: Text('Actions', textAlign: TextAlign.center))),
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
              ListView(
                  shrinkWrap: true,
                  primary: false,
                  children: searchString.length > 0
                      ? searchedCustomers
                          .map((e) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9),
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
                                  child: Center(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Table(
                                        defaultColumnWidth: FixedColumnWidth(100),
                                        border: TableBorder.all(color: Colors.black26, width: 1, style: BorderStyle.none),
                                        children: [
                                          TableRow(
                                            children: [
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
                                                    child: CustomText(
                                                      text: '${e.names}',
                                                      textAlign: TextAlign.center,
                                                      maxLines: 2,
                                                    ),
                                                  )),
                                              TableCell(
                                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                                  child: Center(
                                                    child: CustomText(
                                                      text: '${HelperClass.naira} ${getIndexCustomerSpendings(e.id)}',
                                                    ),
                                                  )),
                                              TableCell(
                                                  verticalAlignment: TableCellVerticalAlignment.middle, child: Center(child: CustomText(text: e.phoneNumber))),
                                              TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Center(child: CustomText(text: e.email))),
                                              TableCell(
                                                verticalAlignment: TableCellVerticalAlignment.middle,
                                                child: Center(
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedCustomer = e;
                                                        showEditContainer = true;
                                                        userUpdateLoading = false;
                                                      });
                                                      getSelectedCustomerSpendings();
                                                      print(showEditContainer.toString());
                                                    },
                                                    child: Icon(Icons.remove_red_eye),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                          .toList()
                      : customers
                          .map((e) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9),
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
                                  child: Center(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Table(
                                        defaultColumnWidth: FixedColumnWidth(100),
                                        border: TableBorder.all(color: Colors.black26, width: 1, style: BorderStyle.none),
                                        children: [
                                          TableRow(
                                            children: [
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
                                                    child: CustomText(
                                                      text: '${e.names}',
                                                      textAlign: TextAlign.center,
                                                      maxLines: 2,
                                                    ),
                                                  )),
                                              TableCell(
                                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                                  child: Center(
                                                    child: CustomText(
                                                      text: '${HelperClass.naira} ${getIndexCustomerSpendings(e.id)}',
                                                    ),
                                                  )),
                                              TableCell(
                                                  verticalAlignment: TableCellVerticalAlignment.middle, child: Center(child: CustomText(text: e.phoneNumber))),
                                              TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Center(child: CustomText(text: e.email))),
                                              TableCell(
                                                verticalAlignment: TableCellVerticalAlignment.middle,
                                                child: Center(
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedCustomer = e;
                                                        showEditContainer = true;
                                                        userUpdateLoading = false;
                                                      });
                                                      getSelectedCustomerSpendings();
                                                      print(showEditContainer.toString());
                                                    },
                                                    child: Icon(Icons.remove_red_eye),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                          .toList()),
            ],
          );
  }

  getAllCustomers() async {
    customers.clear();
    setState(() {
      loading = true;
    });
    customers = await customerService.getAllCustomers();
    for (int i = 0; i < customers.length; i++) {
      customerNames.add(customers[i].names);
    }
    deliveries = await _deliveryServices.getDeliveries();
    selectedCustomer = customers[0];
    showEditContainer = false;
    // print(deliveries.length);
    setState(() {
      loading = false;
    });
  }

  getSelectedCustomerSpendings() {
    double earnings = 0;
    for (int i = 0; i < deliveries.length; i++) {
      if (deliveries[i].status == HelperClass.deliveryComplete && deliveries[i].senderID == selectedCustomer.id) {
        earnings += deliveries[i].earnings.toDouble();
      }
    }
    setState(() {
      totalUserRevenue = earnings ?? 0;
    });
  }

  double getIndexCustomerSpendings(String senderId) {
    double indexEarnings = 0;
    for (int i = 0; i < deliveries.length; i++) {
      if (deliveries[i].status == HelperClass.deliveryComplete && deliveries[i].senderID == senderId) {
        indexEarnings += deliveries[i].earnings.toDouble();
      }
    }
    return indexEarnings;
  }
}
