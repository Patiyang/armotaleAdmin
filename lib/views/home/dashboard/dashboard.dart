import 'package:armotaleadmin/models/customerModel.dart';
import 'package:armotaleadmin/models/deliveryModel.dart';
import 'package:armotaleadmin/models/driverModel.dart';
import 'package:armotaleadmin/services/customerServices.dart';
import 'package:armotaleadmin/services/deliveryServices.dart';
import 'package:armotaleadmin/services/driverServices.dart';
import 'package:armotaleadmin/widgets&helpers/widgets/favoriteStats/faoriteStats.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../widgets&helpers/helpers/helperClasses.dart';
import '../../../widgets&helpers/helpers/styling.dart';
import '../../../widgets&helpers/widgets/customText.dart';
import '../../../widgets&helpers/widgets/dashboardBoardItem.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  CustomerService _customerService = new CustomerService();
  DriverServices _driverServices = new DriverServices();
  DeliveryServices _deliveryServices = new DeliveryServices();
  List<CustomerModel> customers = [];
  List<DriverModel> drivers = [];
  List<DeliveryModel> deliveries = [];
  List<int> earnings = [];
  int totalEarnings = 0;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    getCustomersAndDrivers();
  }

  @override
  Widget build(BuildContext context) {
    List<DashboardItem> dashItems = <DashboardItem>[
      DashboardItem(
          // callback: () => print('Earnings'),
          icon: Center(
            child: CustomText(
              text: HelperClass.naira,
              color: white,
              size: 36,
              textAlign: TextAlign.center,
            ),
          ),
          color: Colors.green,
          text: 'Earnings',
          loading: loading,
          mainText: '${HelperClass.naira}${totalEarnings.toString()}',
          overLayColor: Colors.green),
      DashboardItem(
          // callback: () => print('Bookings'),
          icon: Image.asset(HelperClass.carrier, color: white),
          color: Colors.blue,
          text: 'Bookings',
          loading: loading,
          mainText: deliveries.length.toString(),
          overLayColor: Colors.blue),
      DashboardItem(
          // callback: () => print('Users'),
          icon: Icon(
            Icons.person_add_alt_1_sharp,
            color: white,
            size: 36,
          ),
          color: Colors.green,
          text: 'Users',
          loading: loading,
          mainText: customers.length.toString(),
          overLayColor: Colors.pink),
      DashboardItem(
          // callback: () => print('Employees'),
          icon: Icon(
            Icons.work,
            color: white,
            size: 36,
          ),
          color: Colors.green,
          text: 'Drivers',
          loading: loading,
          mainText: drivers.length.toString(),
          overLayColor: Colors.amber)
    ];
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 12),
        children: [
          ResponsiveBuilder(
            builder: (context, sizingInformation) {
              if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
                return Row(
                  children: dashItems,
                );
              }
              if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
                return Column(
                  children: [
                    Row(
                      children: [dashItems[0], dashItems[1]],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [dashItems[2], dashItems[3]],
                    ),
                  ],
                );
              }
              if (sizingInformation.deviceScreenType == DeviceScreenType.mobile) {
                return Column(
                  children: [
                    Row(
                      children: [dashItems[0]],
                    ),
                    Row(
                      children: [dashItems[1]],
                    ),
                    Row(
                      children: [dashItems[2]],
                    ),
                    Row(
                      children: [dashItems[3]],
                    )
                  ],
                );
              }
              return Container(color: Colors.purple);
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .01,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .01,
          ),
          FavoriteStats()
        ],
      ),
    );
  }

  getCustomersAndDrivers() async {
    setState(() {
      loading = true;
    });
    drivers = await _driverServices.getAllDrivers();
    customers = await _customerService.getAllCustomers();
    deliveries = await _deliveryServices.getDeliveries();

    for (int i = 0; i < deliveries.length; i++) {
      if (deliveries[i].status == 'Completed') {
        earnings.add(deliveries[i].earnings);
      }
    }
    for (int i = 0; i < earnings.length; i++) {
      totalEarnings += earnings[i];
    }
    setState(() {
      loading = false;
    });
  }
}
