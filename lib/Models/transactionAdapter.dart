import 'package:hive/hive.dart';
//import 'package:flutter/material.dart';
part 'transactionAdapter.g.dart';

@HiveType(typeId: 1)
class Item extends HiveObject {
  @HiveField(0)
  late int transid;
  @HiveField(1)
  late double amount;
  @HiveField(2)
  late String from;
  @HiveField(3)
  late String to;
  @HiveField(4)
  late bool debit;
  @HiveField(5)
  late DateTime dateTime;
  @HiveField(6)
  late String category;

  // String transactionType; //Expense or Income

  // String categoryName; //Categories such as Food, Shopping, etc..
  // @HiveField(2)
  // String transName; //Item in a specific Category
  // @HiveField(3)
  // double amount; //Amount spent or gained by this Transaction
  // @HiveField(4)
  // DateTime dateTime; //Transaction Date

  Item(
      {required this.transid,
      required this.amount,
      required this.from,
      required this.to,
      required this.debit,
      required this.dateTime,
      required this.category});
}
