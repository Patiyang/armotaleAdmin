import 'package:armotaleadmin/models/customerModel.dart';
import 'package:armotaleadmin/models/deliveryModel.dart';
import 'package:armotaleadmin/models/driverModel.dart';
import 'package:armotaleadmin/services/customerServices.dart';
import 'package:armotaleadmin/services/deliveryServices.dart';
import 'package:armotaleadmin/services/driverServices.dart';
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

class TripManagement extends StatefulWidget {
  @override
  _TripManagementState createState() => _TripManagementState();
}

bool showEditContainer = false;
DeliveryModel selectedDelivery;
bool userUpdateLoading = false;
double totalUserRevenue = 0;

class _TripManagementState extends State<TripManagement> {
  //CUSTOMER MODELS
  List<CustomerModel> customers = [];
  List<DeliveryModel> searchedDeliveries = [];
  List<DeliveryModel> deliveries = [];
  List<DriverModel> drivers = [];
//DELIVERIES
  DeliveryServices _deliveryServices = new DeliveryServices();
  CustomerService customerService = new CustomerService();
  DriverServices driverServices = new DriverServices();
  bool loading = true;
  List<String> deliveryOrderNumbers = [];
  String searchString = '';
  ListType listType = ListType.gridView;
  DriverModel servingDriver;
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
                              CustomText(text: 'Please Wait..loading Trip data', size: 23),
                              SizedBox(width: 10),
                              SpinKitFadingCube(size: 13, color: black)
                            ],
                          )
                        : FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomText(
                                    text: 'Trip Management - ${deliveries.length} Trips booked', fontWeight: FontWeight.w300, letterSpacing: .2, size: 23),
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
                            hint: 'Search Trip by Order Number...',
                            onChanged: (String val) {
                              searchedDeliveries.clear();
                              setState(() {
                                searchString = val;
                              });
                              for (int i = 0; i < deliveryOrderNumbers.length; i++) {
                                if (deliveryOrderNumbers[i].startsWith(val)) {
                                  searchedDeliveries.add(deliveries[i]);
                                  for (int i = 0; i < searchedDeliveries.length; i++) {
                                    print(searchedDeliveries[i].orderNumber);
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
                              CustomText(text: 'Trip Management - ${deliveries.length} booked trips', fontWeight: FontWeight.w300, letterSpacing: .2, size: 23),
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
                          hint: 'Search Trip by order Number...',
                          onChanged: (String val) {
                            searchedDeliveries.clear();
                            setState(() {
                              searchString = val;
                              showEditContainer = false;
                            });
                            for (int i = 0; i < deliveryOrderNumbers.length; i++) {
                              if (deliveryOrderNumbers[i].startsWith(val)) {
                                searchedDeliveries.add(deliveries[i]);
                                for (int i = 0; i < searchedDeliveries.length; i++) {
                                  print(searchedDeliveries[i].serviceId);
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
                        return desktopSingleOrder();
                      }
                      return mobileTablet();
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
        : Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Table(
                    // defaultColumnWidth: FixedColumnWidth(MediaQuery.of(context).size.width * .15),
                    border: TableBorder.all(color: Colors.black26, width: 1, style: BorderStyle.none),
                    children: [
                      TableRow(children: [
                        // TableCell(child: Center(child: Text('Profile Image'))),
                        TableCell(child: Center(child: Text('Package Type'))),
                        TableCell(child: Center(child: Text('Revenue spent'))),
                        TableCell(child: Center(child: Text('Distance'))),
                        TableCell(child: Center(child: Text('Order Number'))),
                        TableCell(child: Center(child: Text('Order Status'))),
                        TableCell(child: Center(child: Text('Actions'))),
                      ]),
                    ],
                  ),
                ),
              ),
              ListView(
                  shrinkWrap: true,
                  primary: false,
                  children: searchString.length > 0
                      ? searchedDeliveries
                          .map(
                            (e) => Padding(
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
                                  child: Table(
                                    border: TableBorder.all(color: Colors.black26, width: 1, style: BorderStyle.none),
                                    children: [
                                      TableRow(
                                        children: [
                                          TableCell(
                                              verticalAlignment: TableCellVerticalAlignment.middle,
                                              child: Center(
                                                child: CustomText(
                                                  text: '${e.packageType}',
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                ),
                                              )),
                                          TableCell(
                                              verticalAlignment: TableCellVerticalAlignment.middle,
                                              child: Center(
                                                child: CustomText(
                                                  text: '${HelperClass.naira}${e.earnings}',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )),
                                          TableCell(
                                              verticalAlignment: TableCellVerticalAlignment.middle,
                                              child: Center(child: CustomText(text: e.distance.toString() + 'Kms', fontWeight: FontWeight.bold))),
                                          TableCell(
                                              verticalAlignment: TableCellVerticalAlignment.middle,
                                              child: Center(child: CustomText(text: '#' + e.orderNumber.toString()))),
                                          TableCell(
                                              verticalAlignment: TableCellVerticalAlignment.middle,
                                              child: Center(child: CustomText(text: e.status.toString()))),
                                          TableCell(
                                            verticalAlignment: TableCellVerticalAlignment.middle,
                                            child: Center(
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectedDelivery = e;
                                                    showEditContainer = true;
                                                    userUpdateLoading = false;
                                                  });
                                                  getServingDriverInfo(e.driverId);
                                                  // getselectedDeliverySpendings();
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
                          )
                          .toList()
                      : deliveries
                          .map(
                            (e) => Padding(
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
                                  child: Table(
                                    border: TableBorder.all(color: Colors.black26, width: 1, style: BorderStyle.none),
                                    children: [
                                      TableRow(
                                        children: [
                                          TableCell(
                                              verticalAlignment: TableCellVerticalAlignment.middle,
                                              child: Center(
                                                child: CustomText(
                                                  text: '${e.packageType}',
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                ),
                                              )),
                                          TableCell(
                                              verticalAlignment: TableCellVerticalAlignment.middle,
                                              child: Center(
                                                child: CustomText(
                                                  text: '${HelperClass.naira}${e.earnings}',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )),
                                          TableCell(
                                              verticalAlignment: TableCellVerticalAlignment.middle,
                                              child: Center(child: CustomText(text: e.distance.toString() + 'Kms', fontWeight: FontWeight.bold))),
                                          TableCell(
                                              verticalAlignment: TableCellVerticalAlignment.middle,
                                              child: Center(child: CustomText(text: '#' + e.orderNumber.toString()))),
                                          TableCell(
                                              verticalAlignment: TableCellVerticalAlignment.middle,
                                              child: Center(child: CustomText(text: e.status.toString()))),
                                          TableCell(
                                            verticalAlignment: TableCellVerticalAlignment.middle,
                                            child: Center(
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectedDelivery = e;
                                                    showEditContainer = true;
                                                    userUpdateLoading = false;
                                                  });
                                                  getServingDriverInfo(e.driverId);
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
                          )
                          .toList()),
            ],
          );
  }

  getAllCustomers() async {
    customers.clear();
    setState(() {
      loading = true;
    });
    deliveries = await _deliveryServices.getDeliveries();
    drivers = await driverServices.getAllDrivers();

    // customers = await customerService.getAllCustomers();
    for (int i = 0; i < deliveries.length; i++) {
      deliveryOrderNumbers.add(deliveries[i].orderNumber.toString());
    }
    selectedDelivery = deliveries[0];
    servingDriver = drivers[0];
    showEditContainer = false;
    setState(() {
      loading = false;
    });
  }

  int getIndexCustomerSpendings(String senderId) {
    int indexEarnings = 0;
    for (int i = 0; i < deliveries.length; i++) {
      if (deliveries[i].status == HelperClass.deliveryComplete && deliveries[i].senderID == senderId) {
        indexEarnings += deliveries[i].earnings;
      }
    }
    return indexEarnings;
  }

  Widget desktopSingleOrder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CartItemRich(
          lightFont: 'Order Number: ',
          boldFont: '${selectedDelivery.orderNumber}',
          boldFontSize: 25,
          lightFontSize: 18,
        ),
        CartItemRich(
          lightFont: 'Sent By: ',
          boldFont: '${selectedDelivery.senderName}',
          boldFontSize: 25,
          lightFontSize: 18,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            SizedBox(height: 10),
            CartItemRich(
              lightFont: 'Total Earnings: ',
              boldFont: '${HelperClass.naira}${selectedDelivery.earnings}',
              boldFontSize: 18,
              lightFontSize: 14,
            ),
            CartItemRich(
              lightFont: 'Package Type: ',
              boldFont: '${selectedDelivery.packageType}',
              boldFontSize: 18,
              lightFontSize: 14,
            ),
            CartItemRich(
              lightFont: 'Payment Mode: ',
              boldFont: '${selectedDelivery.paymentMode}',
              boldFontSize: 18,
              lightFontSize: 14,
            ),
            CartItemRich(
              lightFont: 'Placement Date: ',
              boldFont: '${selectedDelivery.placedOn.toDate().toString()}',
              boldFontSize: 18,
              lightFontSize: 14,
            ),
          ],
        ),
        SizedBox(height: 10),
        FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3,
                padding: EdgeInsets.all(9),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: primaryColor, style: BorderStyle.solid),
                    color: white,
                    borderRadius: BorderRadius.all(Radius.circular(9))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: 'Pick Up Address Information',
                      size: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 10),
                    CartItemRich(
                      lightFont: 'User Address: ',
                      boldFont: '${selectedDelivery.senderAddress}',
                      boldFontSize: 18,
                      lightFontSize: 14,
                      maxLines: 2,
                    ),
                    CartItemRich(
                      lightFont: 'User Email: ',
                      boldFont: '${selectedDelivery.senderEmail}',
                      boldFontSize: 18,
                      lightFontSize: 14,
                    ),
                    CartItemRich(
                      lightFont: 'Sender Phone Number: ',
                      boldFont: '${selectedDelivery.senderPhone}',
                      boldFontSize: 18,
                      lightFontSize: 14,
                    ),
                    CartItemRich(
                      lightFont: 'Sender ID: ',
                      boldFont: '${selectedDelivery.senderID}',
                      boldFontSize: 18,
                      lightFontSize: 14,
                    ),
                    CartItemRich(
                      lightFont: 'Sender LandMark: ',
                      boldFont: '${selectedDelivery.senderLandmark}',
                      boldFontSize: 18,
                      lightFontSize: 14,
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                padding: EdgeInsets.all(9),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: primaryColor, style: BorderStyle.solid),
                    color: white,
                    borderRadius: BorderRadius.all(Radius.circular(9))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: 'Drop Off Address Information',
                      size: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 10),
                    CartItemRich(
                      lightFont: 'Recipient Address: ',
                      boldFont: '${selectedDelivery.recipientAddress}',
                      boldFontSize: 18,
                      lightFontSize: 14,
                      maxLines: 3,
                    ),
                    CartItemRich(
                      lightFont: 'Recipient Email: ',
                      boldFont: '${selectedDelivery.recipientEmail}',
                      boldFontSize: 18,
                      lightFontSize: 14,
                    ),
                    CartItemRich(
                      lightFont: 'Recipient Phone Number: ',
                      boldFont: '${selectedDelivery.recipientPhone}',
                      boldFontSize: 18,
                      lightFontSize: 14,
                      maxLines: 3,
                    ),
                    CartItemRich(
                      lightFont: 'Recipient Land Mark: ',
                      boldFont: '${selectedDelivery.recipientLandmark}',
                      boldFontSize: 18,
                      lightFontSize: 14,
                      maxLines: 3,
                    ),
                    CartItemRich(
                      lightFont: 'Recipient Names: ',
                      boldFont: '${selectedDelivery.recipientname}',
                      boldFontSize: 18,
                      lightFontSize: 14,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        // selectedDelivery.status != HelperClass.deliveryAccepted ||
        //         selectedDelivery.status != HelperClass.deliveryInProgress ||
        //         selectedDelivery.status != HelperClass.deliveryComplete
        //     ? SizedBox.shrink()
        //     :

        Container(
          width: MediaQuery.of(context).size.width / 2,
          padding: EdgeInsets.all(9),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: primaryColor, style: BorderStyle.solid), color: white, borderRadius: BorderRadius.all(Radius.circular(9))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: 'Serving Driver Information',
                size: 20,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 10),
              Stack(
                alignment: Alignment.center,
                children: [
                  SpinKitFadingCircle(color: black, size: 12),
                  ClipOval(
                    child: Container(
                      height: 110,
                      width: 110,
                      // decoration: BoxDecoration(shape: BoxShape.circle),
                      child: servingDriver.profilePicture != null
                          ? FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: servingDriver.profilePicture, fit: BoxFit.cover)
                          : Image.asset(HelperClass.noImage, fit: BoxFit.fill, height: 60, width: 60),
                    ),
                  )
                ],
              ),
              CartItemRich(
                lightFont: 'Driver Name: ',
                boldFont: '${servingDriver.firstName} ${servingDriver.lastName} ',
                boldFontSize: 18,
                lightFontSize: 14,
                maxLines: 2,
              ),
              CartItemRich(
                lightFont: 'Driver Phone: ',
                boldFont: '${servingDriver.phoneNumber}',
                boldFontSize: 18,
                lightFontSize: 14,
              ),
              CartItemRich(
                lightFont: 'Email Address: ',
                boldFont: '${servingDriver.email}',
                boldFontSize: 18,
                lightFontSize: 14,
              ),
              CartItemRich(
                lightFont: 'Driver ID: ',
                boldFont: '${servingDriver.driverId}',
                boldFontSize: 18,
                lightFontSize: 14,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget mobileTablet() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CartItemRich(
            lightFont: 'Order Number: ',
            boldFont: '${selectedDelivery.orderNumber}',
            boldFontSize: 18,
            lightFontSize: 14,
          ),
          CartItemRich(
            lightFont: 'Sent By: ',
            boldFont: '${selectedDelivery.senderName}',
            boldFontSize: 18,
            lightFontSize: 14,
          ),
          SizedBox(height: 10),
          SizedBox(height: 10),
          CartItemRich(
            lightFont: 'Total Earnings: ',
            boldFont: '${HelperClass.naira}${selectedDelivery.earnings}',
            boldFontSize: 18,
            lightFontSize: 14,
          ),
          CartItemRich(
            lightFont: 'Package Type: ',
            boldFont: '${selectedDelivery.packageType}',
            boldFontSize: 18,
            lightFontSize: 14,
          ),
          CartItemRich(
            lightFont: 'Payment Mode: ',
            boldFont: '${selectedDelivery.paymentMode}',
            boldFontSize: 18,
            lightFontSize: 14,
          ),
          CartItemRich(
            lightFont: 'Placement Date: ',
            boldFont: '${selectedDelivery.placedOn.toDate().toString()}',
            boldFontSize: 18,
            lightFontSize: 14,
          ),
          SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width * .93,
            padding: EdgeInsets.all(9),
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: primaryColor, style: BorderStyle.solid), color: white, borderRadius: BorderRadius.all(Radius.circular(9))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: 'Pick Up Address Information',
                    size: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                CartItemRich(
                  lightFont: 'User Address: ',
                  boldFont: '${selectedDelivery.senderAddress}',
                  boldFontSize: 18,
                  lightFontSize: 14,
                  maxLines: 2,
                ),
                CartItemRich(
                  lightFont: 'User Email: ',
                  boldFont: '${selectedDelivery.senderEmail}',
                  boldFontSize: 18,
                  lightFontSize: 14,
                ),
                CartItemRich(
                  lightFont: 'Sender Phone Number: ',
                  boldFont: '${selectedDelivery.senderPhone}',
                  boldFontSize: 18,
                  lightFontSize: 14,
                ),
                CartItemRich(
                  lightFont: 'Sender ID: ',
                  boldFont: '${selectedDelivery.senderID}',
                  boldFontSize: 18,
                  lightFontSize: 14,
                ),
                CartItemRich(
                  lightFont: 'Sender LandMark: ',
                  boldFont: '${selectedDelivery.senderLandmark}',
                  boldFontSize: 18,
                  lightFontSize: 14,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width * .93,
            padding: EdgeInsets.all(9),
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: primaryColor, style: BorderStyle.solid), color: white, borderRadius: BorderRadius.all(Radius.circular(9))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: 'Drop Off Address Information',
                  size: 20,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 10),
                CartItemRich(
                  lightFont: 'Recipient Address: ',
                  boldFont: '${selectedDelivery.recipientAddress}',
                  boldFontSize: 18,
                  lightFontSize: 14,
                  maxLines: 2,
                ),
                CartItemRich(
                  lightFont: 'Recipient Email: ',
                  boldFont: '${selectedDelivery.recipientEmail}',
                  boldFontSize: 18,
                  lightFontSize: 14,
                ),
                CartItemRich(
                  lightFont: 'Recipient Phone Number: ',
                  boldFont: '${selectedDelivery.recipientPhone}',
                  boldFontSize: 18,
                  lightFontSize: 14,
                ),
                CartItemRich(
                  lightFont: 'Recipient Land Mark: ',
                  boldFont: '${selectedDelivery.recipientLandmark}',
                  boldFontSize: 18,
                  lightFontSize: 14,
                ),
                CartItemRich(
                  lightFont: 'Recipient Names: ',
                  boldFont: '${selectedDelivery.recipientname}',
                  boldFontSize: 18,
                  lightFontSize: 14,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: MediaQuery.of(context).size.width * .93,
            padding: EdgeInsets.all(9),
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: primaryColor, style: BorderStyle.solid), color: white, borderRadius: BorderRadius.all(Radius.circular(9))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: 'Serving Driver Information',
                  size: 20,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 10),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SpinKitFadingCircle(color: black, size: 12),
                    ClipOval(
                      child: Container(
                        height: 110,
                        width: 110,
                        // decoration: BoxDecoration(shape: BoxShape.circle),
                        child: servingDriver.profilePicture != null
                            ? FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: servingDriver.profilePicture, fit: BoxFit.cover)
                            : Image.asset(HelperClass.noImage, fit: BoxFit.fill, height: 60, width: 60),
                      ),
                    )
                  ],
                ),
                CartItemRich(
                  lightFont: 'Driver Name: ',
                  boldFont: '${servingDriver.firstName} ${servingDriver.lastName} ',
                  boldFontSize: 18,
                  lightFontSize: 14,
                  maxLines: 2,
                ),
                CartItemRich(
                  lightFont: 'Driver Phone: ',
                  boldFont: '${servingDriver.phoneNumber}',
                  boldFontSize: 18,
                  lightFontSize: 14,
                ),
                CartItemRich(
                  lightFont: 'Email Address: ',
                  boldFont: '${servingDriver.email}',
                  boldFontSize: 18,
                  lightFontSize: 14,
                ),
                CartItemRich(
                  lightFont: 'Driver ID: ',
                  boldFont: '${servingDriver.driverId}',
                  boldFontSize: 18,
                  lightFontSize: 14,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  getServingDriverInfo(String driverId) {
    for (int i = 0; i < drivers.length; i++) {
      if (drivers[i].driverId == driverId) {
        setState(() {
          servingDriver = drivers[i];
        });
      }
    }
  }
}
