import 'dart:math';

import 'package:armotaleadmin/models/deliveryModel.dart';
import 'package:armotaleadmin/models/driverModel.dart';
import 'package:armotaleadmin/services/adminServices.dart';
import 'package:armotaleadmin/services/deliveryServices.dart';
import 'package:armotaleadmin/services/driverServices.dart';
import 'package:armotaleadmin/widgets&helpers/helpers/helperClasses.dart';
import 'package:armotaleadmin/widgets&helpers/widgets/customText.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_util/date_util.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SalesLineChart extends StatefulWidget {
  const SalesLineChart({Key key}) : super(key: key);

  @override
  _SalesLineChartState createState() => _SalesLineChartState();
}

class _SalesLineChartState extends State<SalesLineChart> {
  bool loading = false;
  // int totalDaysOfMonth = 0;
  var dateUtility = DateUtil();
  List<double> numbers = [
    0,
    // 2900,
    // 1500,
    // 2500,
    // 3300,
    // 4000,
    // 5500,
    // 3300,
    // 1250,
  ];
  List<double> graphNumbers = [];
  double maxYValue = 0;
  double todayValue = 0;
  int maxNumberLength = 0;
  List<FlSpot> plottingSpots = [];
  AdminServices _adminServices = new AdminServices();
  DriverServices _driverServices = new DriverServices();
  DeliveryServices _deliveryServices = new DeliveryServices();
  List<int> earnings = [];

  @override
  void initState() {
    super.initState();
    // getGraphData();
    print(DateTime(2021, DateTime.june, 28).millisecondsSinceEpoch + 3000);
    print(DateTime.fromMillisecondsSinceEpoch(1624827603000));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          text: 'Armotale Express 2018',
          // fontWeight: FontWeight.bold,
          size: 19,
        ),
        GestureDetector(
          onTap: () => getGraphData(),
          child: CustomText(
            text: 'Weekly Sales',
            fontWeight: FontWeight.bold,
            size: 25,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .01,
        ),
     
      ],
    );
  }

  LineChartData sampleData1() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
      ),
      titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTextStyles: (value) => const TextStyle(
              color: Color(0xff72719b),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            // margin: totalDaysOfMonth.toDouble(),
            getTitles: (value) {
              switch (value.toInt()) {
                case 0:
                  return '';
                case 1:
                  return 'Mon';
                case 2:
                  return 'Tue';
                case 3:
                  return 'Wed';
                case 4:
                  return 'Thur';
                case 5:
                  return 'Fri';
                case 6:
                  return 'Sat';
                case 7:
                  return 'Sun';
              }
              return '';
            },
          ),
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => const TextStyle(
              color: Color(0xff75729e),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            getTitles: (value) {
              // switch (value.toInt()) {
              //   case 1:
              //     return '1000${HelperClass.naira}';
              //   case 2:
              //     return '2000${HelperClass.naira}';
              //   case 3:
              //     return '3000${HelperClass.naira}';
              //   case 4:
              //     return '4000${HelperClass.naira}';
              //   case 5:
              //     return '5000${HelperClass.naira}';
              // }
              return '';
            },
            margin: 8,
            reservedSize: 50,
          ),
          rightTitles: SideTitles()),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 2,
          ),
          left: BorderSide(
            color: Colors.transparent,
            width: 2,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: 8,
      maxY: maxYValue,
      minY: 0,
      lineBarsData: linesBarData1(),
    );
  }

  List<LineChartBarData> linesBarData1() {
    final lineChartBarData2 = LineChartBarData(
      spots: plottingSpots,
      isCurved: true,
      colors: [
        const Color(0xffaa4cfc),
      ],
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(
        show: false,
        colors: [
          const Color(0x00aa4cfc),
        ],
      ),
    );

    return [
      lineChartBarData2,
    ];
  }

  getGraphData() async {
    String todayDate = Timestamp.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch).toDate().toString().substring(0, 10);
    double latestEarningValue = 0;
    List<DeliveryModel> deliveries = [];
    deliveries = await _deliveryServices.getDeliveries();
    for (int i = 0; i < deliveries.length; i++) {
      if (deliveries[i].status == 'Completed' &&
          Timestamp.fromMillisecondsSinceEpoch(deliveries[i].completedTransitON).toDate().toString().substring(0, 10) == todayDate) {
        earnings.add(deliveries[i].earnings);
      }
    }
    for (int i = 0; i < earnings.length; i++) {
      latestEarningValue += earnings[i];
    }
    todayValue = latestEarningValue;
    if (numbers.length < 8) {
      numbers.insert(DateTime.now().weekday, todayValue);
    }
    Future.delayed(Duration(seconds: 1)).then((value) => _adminServices.saveGraphList(numbers)).then(
      (value) async {
        numbers = await _adminServices.getGraphList();
      },
    );

    maxNumberLength = numbers.reduce(max).toString().length;
    if (maxNumberLength == 4) {
      numbers.forEach((element) {
        graphNumbers.add(element / 1000);
        for (double i = 0; i < graphNumbers.length; i++) {
          if (!plottingSpots.contains(FlSpot(i, graphNumbers[i.toInt()]))) {
            plottingSpots.add(FlSpot(i, graphNumbers[i.toInt()]));
          }
        }
      });
    }
    // print(numbers);
    maxYValue = graphNumbers.reduce(max).ceil().toDouble() + 2;
    setState(() {});
  }
}
