import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wallet/Models/transactionAdapter.dart';
import 'package:wallet/Pages/Select_category.dart';

import '../Models/Transactions_model.dart';

class Transation_details_page extends StatefulWidget {
  Transation_details_page(
      this.transaction, this.updateCallback, this.deleteCallback,
      {Key? key})
      : super(key: key) {
    amount = transaction.amount;
    recipient = transaction.to;
    category = transaction.category;
    date = transaction.dateTime;
  }
  Function updateCallback;
  Function deleteCallback;
  Item transaction;
  double amount = 0;
  String recipient = "";
  String category = "defult";
  DateTime date = DateTime.now();

  @override
  State<Transation_details_page> createState() =>
      _Transation_details_pageState();
}

class _Transation_details_pageState extends State<Transation_details_page> {
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction details'),
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
                    TextFormField(
                      initialValue: widget.amount.toString(),
                      decoration:
                          new InputDecoration(labelText: "Enter the amount"),
                      keyboardType: TextInputType.number,
                      // controller: amountController,
                      onChanged: (text) {
                        widget.amount = double.parse(text);
                        print(widget.amount);
                      },
                    ),
                    TextFormField(
                      initialValue: widget.recipient,
                      decoration:
                          new InputDecoration(labelText: "Enter the recipient"),
                      keyboardType: TextInputType.text,
                      onChanged: (text) {
                        widget.recipient = text;
                      },
                    ),
                    // TextFormField(
                    //   initialValue: category,
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
                    Row(
                      children: [
                        Text('Date time'),
                        SizedBox(
                          width: 20,
                        ),
                        OutlinedButton(
                          child: Text(
                              DateFormat("MMM d yyyy").format(widget.date)),
                          onPressed: () {
                            DatePicker.showDatePicker(
                              context,
                              showTitleActions: true,
                              minTime: DateTime(2018, 3, 5),
                              maxTime: DateTime.now(),
                              onChanged: (date) {
                                // print('change $date');
                              },
                              onConfirm: (date) {
                                // print('confirm $date');
                                widget.date = date;
                                setState(() {});
                              },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Consumer<TransactionsModel>(
              builder: (context, transactions, child) {
                return Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(40),
                        ),
                        onPressed: () {
                          widget.deleteCallback(widget.transaction.transid);
                          // transactions
                          //     .deleteTransactionWithId(transaction.transid);
                          Navigator.pop(context);
                        },
                        child: Text('Delete'),
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Expanded(
                      child: OutlinedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(40),
                        ),
                        onPressed: () {
                          // final trans = box.getAt(transaction.transid)
                          print(widget.transaction.transid);
                          widget.updateCallback(
                              widget.transaction.transid - 1,
                              widget.amount,
                              widget.recipient,
                              widget.category,
                              widget.date);
                          // transactions.updateTransactionWithId(
                          //   transaction.transid,
                          //   new Transaction(
                          //     transaction.transid,
                          //     amount,
                          //     transaction.from,
                          //     recipient,
                          //     transaction.debit,
                          //     transaction.dateTime,
                          //     category,
                          //   ),
                          // );
                          Navigator.pop(context);
                        },
                        child: Text('Update'),
                      ),
                    ),
                  ],
                );
              },
            ),
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
