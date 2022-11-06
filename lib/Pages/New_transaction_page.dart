import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:wallet/Models/transactionAdapter.dart';
import 'package:wallet/Pages/Select_category.dart';

import '../Models/Transactions_model.dart';
import '../constants.dart';

class New_transaction_page extends StatefulWidget {
  double amount;
  String recipient = "";
  String category;
  DateTime date;

  New_transaction_page({
    Key? key,
    required this.additionCallback,
    required this.transactions,
    this.amount = 0,
    this.recipient = "",
    this.category = 'Food',
    required this.date,
  }) : super(key: key);
  Function additionCallback;
  TransactionsModel transactions;

  @override
  State<New_transaction_page> createState() => _New_transaction_pageState();
}

class _New_transaction_pageState extends State<New_transaction_page> {
  // @override
  // void initState() {
  //   super.initState();
  //   Hive.registerAdapter(ItemAdapter());
  //   // box = Hive.box('transactions');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: SingleChildScrollView(
                    child: Column(
              children: [
                // Text('Amount'),
                TextFormField(
                  decoration:
                      new InputDecoration(labelText: "Enter the amount"),
                  keyboardType: TextInputType.number,
                  initialValue: widget.amount.toString(),
                  onChanged: (text) {
                    widget.amount = double.parse(text);
                  },
                ),

                TextFormField(
                  decoration:
                      new InputDecoration(labelText: "Enter the recipient"),
                  keyboardType: TextInputType.text,
                  initialValue: widget.recipient,
                  onChanged: (text) {
                    widget.recipient = text;
                  },
                ),
                // TextField(
                //   decoration:
                //       new InputDecoration(labelText: "Enter the category"),
                //   keyboardType: TextInputType.text,
                //   onChanged: (text) {
                //     category = text;
                //   },
                // ),
                Row(
                  children: [
                    Text('Category'),
                    SizedBox(
                      width: 20,
                    ),
                    OutlinedButton(
                      child: Text(widget.category),
                      onPressed: () {
                        _navigateAndDisplaySelection(context);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => SelectCategory(),
                        //   ),
                        // );
                      },
                    ),
                  ],
                ),
              ],
            ))),
            // Consumer<TransactionsModel>(
            //   builder: (context, transactions, child) {
            // return ElevatedButton(
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(40),
              ),
              onPressed: () {
                var newItem = new Transaction(1, widget.amount, 'me',
                    widget.recipient, true, DateTime.now(), '');
                var newItem2 = new Item(
                  transid: 1,
                  amount: widget.amount,
                  from: 'me',
                  to: widget.recipient,
                  debit: true,
                  dateTime: DateTime.now(),
                  category: widget.category,
                );
                widget.additionCallback(newItem2);
                widget.transactions.add(newItem);
                Navigator.pop(context, 'success');
              },
              child: Text('Done'),
            ),
            //   },
            // )
          ],
        ),
      ),
    );
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectCategory(widget.category)),
    );

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!mounted) return;

    setState(() {
      widget.category = result;
    });

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    // ScaffoldMessenger.of(context)
    //   ..removeCurrentSnackBar()
    //   ..showSnackBar(SnackBar(content: Text('$result')));
  }
}
