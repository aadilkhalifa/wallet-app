import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:wallet/utilities.dart';

import '../Models/transactionAdapter.dart';

class Track_page extends StatefulWidget {
  const Track_page({Key? key}) : super(key: key);

  @override
  State<Track_page> createState() => _Track_pageState();
}

class _Track_pageState extends State<Track_page> {
  late Box box;

  @override
  void initState() {
    super.initState();
    _openBox();
    box = Hive.box('transactions');
  }

  double totalSum = 201.5;

  List<Box> itemsBox = [];
  Future<List<Box>> _openBox() async {
    // print("reached open box in track page");
    chart1['00-0000'] = 0;
    chart2['00-0000'] = 0;
    box = await Hive.openBox('transactions');
    chart1.clear();
    chart2.clear();
    setState(() {
      var boxTrans = Hive.box('transactions');
      // print(boxTrans.length);
      chart1['Oct-2022'] = 201.5;

      for (int i = 0; i < boxTrans.length; i++) {
        Item item = boxTrans.getAt(i);
        String date = '${dataMap[item.dateTime.month]}-${item.dateTime.year}';
        String cat = item.category;
        if (item.debit == true) {
          print("this amt :$date- ${item.dateTime.day}");
          double? value = chart1[date];
          if (value != null) {
            chart1[date] = (item.amount) + value;
          } else {
            chart1[date] = (item.amount);
          }
          //print(chart1);
          totalSum += item.amount;
          if (item.dateTime.month == DateTime.now().month) {
            double? value = chart2[cat];
            if (value != null) {
              chart2[cat] = (item.amount) + value;
            } else {
              chart2[cat] = (item.amount);
            }
          }
        }
      }
    });
    // getAllData();
    return itemsBox;
  }

  final dataMap2 = {}; //category,

  final Map<double, String> dataMap = <double, String>{
    1: "Jan",
    2: "Feb",
    3: "Mar",
    4: "Apr",
    5: "May",
    6: "Jun",
    7: "Jul",
    8: "Aug",
    9: "Sept",
    10: "Oct",
    11: "Nov",
    12: "Dec"
  };

  final gradientList = <List<Color>>[
    [
      const Color.fromRGBO(223, 250, 92, 1),
      const Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      const Color.fromRGBO(129, 182, 205, 1),
      const Color.fromRGBO(91, 253, 199, 1),
    ],
    [
      const Color.fromRGBO(175, 63, 62, 1.0),
      const Color.fromRGBO(254, 154, 92, 1),
    ],
    [
      Color.fromARGB(255, 112, 53, 142),
      Color.fromARGB(255, 128, 33, 47),
    ],
    [
      Color.fromARGB(255, 28, 76, 77),
      Color.fromARGB(255, 30, 101, 54),
    ]
  ];

  // LegendShape? _legendShape = LegendShape.circle;

  LegendPosition? _legendPosition = LegendPosition.right;

  int key = 0;
  final colorList = <Color>[
    const Color(0xfffdcb6e),
    const Color(0xff0984e3),
    const Color(0xfffd79a8),
    const Color(0xffe17055),
    const Color(0xff6c5ce7),
  ];

  @override
  Widget build(BuildContext context) {
    // _openBox();
    // print(box.length);
    // print(chart1);
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: WatchBoxBuilder(
              box: Hive.box('transactions'),
              builder: ((context, box) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    const Text("Debit Amount"),
                    const SizedBox(
                      height: 50,
                    ),
                    PieChart(
                      gradientList: gradientList,
                      dataMap: chart1,
                      animationDuration: const Duration(milliseconds: 800),
                      chartLegendSpacing: 32,
                      chartRadius: MediaQuery.of(context).size.width / 2,
                      colorList: colorList,
                      initialAngleInDegree: 0,
                      chartType: ChartType.ring,
                      ringStrokeWidth: 32,
                      centerText: "$totalSum",
                      legendOptions: const LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.right,
                        showLegends: true,
                        legendShape: BoxShape.circle,
                        legendTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValues: true,
                        showChartValuesInPercentage: false,
                        showChartValuesOutside: true,
                        decimalPlaces: 1,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Text("Current Month Expenditures"),
                    const SizedBox(
                      height: 50,
                    ),
                    PieChart(
                      gradientList: gradientList,
                      dataMap: chart2,
                      animationDuration: const Duration(milliseconds: 800),
                      chartLegendSpacing: 32,
                      chartRadius: MediaQuery.of(context).size.width / 2,
                      colorList: colorList,
                      initialAngleInDegree: 0,
                      chartType: ChartType.ring,
                      ringStrokeWidth: 32,
                      centerText: "$totalSum",
                      legendOptions: const LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.right,
                        showLegends: true,
                        legendShape: BoxShape.circle,
                        legendTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValues: true,
                        showChartValuesInPercentage: false,
                        showChartValuesOutside: true,
                        decimalPlaces: 1,
                      ),
                    ),
                  ],
                );
              })),
        ),
      ),
    );
  }
}
