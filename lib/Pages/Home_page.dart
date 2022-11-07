import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../Models/transactionAdapter.dart';

class Home_page extends StatefulWidget {
  const Home_page({Key? key}) : super(key: key);

  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  late Box box;

  @override
  void initState() {
    super.initState();
    _openBox();
    box = Hive.box('transactions');
  }

  double totalSum = 0;
  double monthlyLimit = 100;

  List<Box> itemsBox = [];
  Future<List<Box>> _openBox() async {
    box = await Hive.openBox('transactions');
    setState(() {
      var boxTrans = Hive.box('transactions');

      for (int i = 0; i < boxTrans.length; i++) {
        Item item = boxTrans.getAt(i);
        if (item.debit == true) {
          if (item.dateTime.month == DateTime.now().month) {
            totalSum += item.amount;
          }
        }
      }
    });
    // getAllData();
    return itemsBox;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: WatchBoxBuilder(
        box: Hive.box('transactions'),
        builder: ((context, box) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Current month expenditure:'),
                    Text('Rs ' + totalSum.toString()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Current monthy limit:'),
                    Text('Rs ' + monthlyLimit.toString()),
                  ],
                ),
                // Container(
                //   width: double.infinity,
                //   // decoration: BoxDecoration(color: Colors.red),
                //   child: LinearPercentIndicator(
                //     width: double.infinity,
                //     lineHeight: 8.0,
                //     percent: 0.5,
                //     progressColor: Colors.orange,
                //   ),
                // ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Flexible(
                      flex: totalSum.toInt(),
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          color: Colors.red,
                        ), //BoxDecoration
                      ),
                    ),
                    Flexible(
                      flex: max(monthlyLimit.toInt() - totalSum.toInt(), 0),
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: Color.fromARGB(255, 255, 192, 187),
                        ), //BoxDecoration
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  (totalSum * 100 / monthlyLimit).toStringAsFixed(2) +
                      '% of the monthly budget used.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
