import 'package:armotaleadmin/models/customerModel.dart';
import 'package:armotaleadmin/models/deliveryModel.dart';
import 'package:armotaleadmin/models/driverModel.dart';
import 'package:armotaleadmin/services/customerServices.dart';
import 'package:armotaleadmin/services/deliveryServices.dart';
import 'package:armotaleadmin/services/driverServices.dart';
import 'package:armotaleadmin/widgets&helpers/helpers/helperClasses.dart';
import 'package:armotaleadmin/widgets&helpers/helpers/styling.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:transparent_image/transparent_image.dart';

import '../customText.dart';

class FavoriteStats extends StatefulWidget {
  const FavoriteStats({Key key}) : super(key: key);

  @override
  _FavoriteStatsState createState() => _FavoriteStatsState();
}

class _FavoriteStatsState extends State<FavoriteStats> {
  List<CustomerModel> customerList = [];
  List<DriverModel> driverList = [];
  List<DeliveryModel> deliveries = [];

      List<CustomerModel> newCustomerList = [];
    List<DriverModel> newDriverList = [];

  DeliveryServices deliveryServices = new DeliveryServices();
  CustomerService customerService = new CustomerService();
  DriverServices driverServices = new DriverServices();

  bool loadingFavs = false;
  @override
  void initState() {
    getFavDriversAndCustomers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
            return webView();
          }
          return mobileView();
        },
      ),
    );
  }

  Widget mobileView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            gradient: LinearGradient(
              colors: [
                primaryColor[100],
                white,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          // height: MediaQuery.of(context).size.height * .4,
          width: MediaQuery.of(context).size.width / 1.1,
          child: loadingFavs == true
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitFadingCube(
                      size: 25,
                      color: black,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    CustomText(text: 'Please wait...', size: 20),
                  ],
                )
              : Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      GestureDetector(
                          onTap: () => print(newDriverList.length),
                          child: CustomText(text: 'Top Customers', size: 20, fontWeight: FontWeight.bold)),
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(9))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Table(
                            // defaultColumnWidth: FixedColumnWidth(MediaQuery.of(context).size.width * .15),
                            border: TableBorder.all(color: Colors.black26, width: 1, style: BorderStyle.none),
                            children: [
                              TableRow(children: [
                                TableCell(child: Center(child: CustomText(text: 'Image', textAlign: TextAlign.center, maxLines: 2))),
                                TableCell(child: Center(child: CustomText(text: 'Names'))),
                                TableCell(child: Center(child: CustomText(text: 'Revenue\nEarned', textAlign: TextAlign.center, maxLines: 2))),
                                TableCell(child: Center(child: CustomText(text: 'trips\nCompleted', textAlign: TextAlign.center, maxLines: 2))),
                              ]),
                            ],
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                        child: Column(
                          // shrinkWrap: true,
                          // primary: false,
                          // scrollDirection: Axis.vertical,
                          children: newCustomerList
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
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
                                        // defaultColumnWidth: FixedColumnWidth(MediaQuery.of(context).size.width * .15),
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
                                                child: CustomText(text: '${e.names.toLowerCase()}', maxLines: 2, textAlign: TextAlign.center),
                                              ),
                                            ),
                                            TableCell(
                                                verticalAlignment: TableCellVerticalAlignment.middle,
                                                child: Center(
                                                  child: CustomText(text: '${HelperClass.naira} ${e.totalSpendings}', fontWeight: FontWeight.bold),
                                                )),
                                            TableCell(
                                                verticalAlignment: TableCellVerticalAlignment.middle,
                                                child: Center(child: CustomText(text: e.tripCount.toString()))),
                                          ]),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      )
                    ],
                  ),
                ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .01,
        ),
        Container(
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            gradient: LinearGradient(
              colors: [
                primaryColor[100],
                white,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          // height: MediaQuery.of(context).size.height * .4,
          width: MediaQuery.of(context).size.width / 1.1,
          child: loadingFavs == true
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitFadingCube(
                      size: 25,
                      color: black,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    CustomText(
                      text: 'Please wait...',
                      size: 20,
                    )
                  ],
                )
              : Column(
                  children: [
                    CustomText(text: 'Top Riders', size: 20, fontWeight: FontWeight.bold),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Table(
                          border: TableBorder.all(color: Colors.black26, width: 1, style: BorderStyle.none),
                          children: [
                            TableRow(
                              children: [
                                TableCell(child: Center(child: CustomText(text: 'Image', textAlign: TextAlign.center, maxLines: 2))),
                                TableCell(child: Center(child: CustomText(text: 'Names'))),
                                // TableCell(child: Center(child: CustomText(text: 'Driver\nRatings', textAlign: TextAlign.center, maxLines: 2))),
                                TableCell(child: Center(child: CustomText(text: 'Revnue\nSpent', textAlign: TextAlign.center, maxLines: 2))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Column(
                    children: newDriverList
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                              child: Table(
                                // defaultColumnWidth: FixedColumnWidth(MediaQuery.of(context).size.width * .15),
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
                                                  ? FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: e.profilePicture, fit: BoxFit.cover)
                                                  : Image.asset(HelperClass.noImage, fit: BoxFit.fill, height: 60, width: 60),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child: Center(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: AutoSizeText(
                                              '${e.firstName} ${e.lastName}',
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                            ),
                                          ),
                                        )),
                                    // TableCell(
                                    //     verticalAlignment: TableCellVerticalAlignment.middle,
                                    //     child: Center(
                                    //       child: RatingBar.builder(
                                    //         itemSize: 15,
                                    //         initialRating: 3,
                                    //         minRating: 1,
                                    //         direction: Axis.horizontal,
                                    //         allowHalfRating: true,
                                    //         itemCount: 5,
                                    //         itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                    //         itemBuilder: (context, _) => Icon(
                                    //           Icons.star,
                                    //           color: Colors.amber,
                                    //         ),
                                    //         onRatingUpdate: (rating) {
                                    //           print(rating);
                                    //         },
                                    //       ),
                                    //     )),
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child: Center(
                                          child: CustomText(text: '${HelperClass.naira}${e.totalEarnings}', fontWeight: FontWeight.bold),
                                        )),
                                  ]),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                      ),
                    )
                  ],
                ),
        ),
      ],
    );
  }

  Widget webView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gradient: LinearGradient(
                colors: [
                  primaryColor[100],
                  white,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            height: MediaQuery.of(context).size.height * .4,
            width: MediaQuery.of(context).size.width / 3,
            child: loadingFavs == true
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitFadingCube(
                        size: 25,
                        color: black,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),
                      CustomText(text: 'Please wait...', size: 20),
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        GestureDetector(
                            onTap: () => print(MediaQuery.of(context).size.width),
                            child: CustomText(text: 'Top Customers', size: 20, fontWeight: FontWeight.bold)),
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(9))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Table(
                              // defaultColumnWidth: FixedColumnWidth(MediaQuery.of(context).size.width * .15),
                              border: TableBorder.all(color: Colors.black26, width: 1, style: BorderStyle.none),
                              children: [
                                TableRow(children: [
                                  TableCell(child: Center(child: CustomText(text: 'Image', textAlign: TextAlign.center, maxLines: 2))),
                                  TableCell(child: Center(child: CustomText(text: 'Names'))),
                                  TableCell(child: Center(child: CustomText(text: 'Revenue\nEarned', textAlign: TextAlign.center, maxLines: 2))),
                                  TableCell(child: Center(child: CustomText(text: 'trips\nCompleted', textAlign: TextAlign.center, maxLines: 2))),
                                ]),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(9)),
                            child: ListView(
                              shrinkWrap: true,
                              primary: false,
                              scrollDirection: Axis.vertical,
                              children: newCustomerList
                                  .map(
                                    (e) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
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
                                            // defaultColumnWidth: FixedColumnWidth(MediaQuery.of(context).size.width * .15),
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
                                                    child: CustomText(text: '${e.names.toLowerCase()}', maxLines: 2, textAlign: TextAlign.center),
                                                  ),
                                                ),
                                                TableCell(
                                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                                    child: Center(
                                                      child: CustomText(text: '${HelperClass.naira} ${e.totalSpendings}', fontWeight: FontWeight.bold),
                                                    )),
                                                TableCell(
                                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                                    child: Center(child: CustomText(text: e.tripCount.toString()))),
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
                        )
                      ],
                    ),
                  ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * .01,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gradient: LinearGradient(
                colors: [primaryColor[100], white],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            height: MediaQuery.of(context).size.height * .4,
            width: MediaQuery.of(context).size.width / 3,
            child: loadingFavs == true
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitFadingCube(
                        size: 25,
                        color: black,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),
                      CustomText(
                        text: 'Please wait...',
                        size: 20,
                      )
                    ],
                  )
                : Column(
                    children: [
                      CustomText(text: 'Top Riders', size: 20, fontWeight: FontWeight.bold),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Table(
                            // defaultColumnWidth: FixedColumnWidth(MediaQuery.of(context).size.width * .15),
                            border: TableBorder.all(color: Colors.black26, width: 1, style: BorderStyle.none),
                            children: [
                              TableRow(
                                children: [
                                  TableCell(child: Center(child: CustomText(text: 'Image', textAlign: TextAlign.center, maxLines: 2))),
                                  TableCell(child: Center(child: CustomText(text: 'Names'))),
                                  TableCell(child: Center(child: CustomText(text: 'Driver\nRatings', textAlign: TextAlign.center, maxLines: 2))),
                                  TableCell(child: Center(child: CustomText(text: 'Revnue\nSpent', textAlign: TextAlign.center, maxLines: 2))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          child: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: ListView(
                          children: newDriverList
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                                    child: Table(
                                      // defaultColumnWidth: FixedColumnWidth(MediaQuery.of(context).size.width * .15),
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
                                                        ? FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: e.profilePicture, fit: BoxFit.cover)
                                                        : Image.asset(HelperClass.noImage, fit: BoxFit.fill, height: 60, width: 60),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                          TableCell(
                                              verticalAlignment: TableCellVerticalAlignment.middle,
                                              child: Center(
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: AutoSizeText(
                                                    '${e.firstName} ${e.lastName}',
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              )),
                                          TableCell(
                                              verticalAlignment: TableCellVerticalAlignment.middle,
                                              child: Center(
                                                child: RatingBar.builder(
                                                  itemSize: 15,
                                                  initialRating: 3,
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                  itemBuilder: (context, _) => Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  onRatingUpdate: (rating) {
                                                    print(rating);
                                                  },
                                                ),
                                              )),
                                          TableCell(
                                              verticalAlignment: TableCellVerticalAlignment.middle,
                                              child: Center(
                                                child: CustomText(text: '${HelperClass.naira}${e.totalEarnings}', fontWeight: FontWeight.bold),
                                              )),
                                        ]),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ))
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  getFavDriversAndCustomers() async {

    setState(() {
      loadingFavs = true;
    });
    customerList.clear();
    driverList.clear();
    driverList = await driverServices.getAllDriverEarnings();
    customerList = await customerService.getAllCustomerSpendings();

    for (int i = 0; i < 3; i++) {
      newDriverList.add(driverList[i]);
      newCustomerList.add(customerList[i]);
    }

    
    setState(() {
      loadingFavs = false;
    });
  }
}
