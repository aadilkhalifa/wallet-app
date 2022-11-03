import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:wallet/Models/transactionAdapter.dart';

import '../Models/Transactions_model.dart';

class Transation_details_page extends StatelessWidget {
  Transation_details_page(
      this.transaction, this.updateCallback, this.deleteCallback,
      {Key? key})
      : super(key: key) {
    amount = transaction.amount;
    recipient = transaction.to;
    category = transaction.category;
  }
  Function updateCallback;
  Function deleteCallback;
  Item transaction;
  double amount = 0;
  String recipient = "";
  String category = "";

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
                      initialValue: amount.toString(),
                      decoration:
                          new InputDecoration(labelText: "Enter the amount"),
                      keyboardType: TextInputType.number,
                      // controller: amountController,
                      onChanged: (text) {
                        amount = double.parse(text);
                        print(amount);
                      },
                    ),
                    TextFormField(
                      initialValue: recipient,
                      decoration:
                          new InputDecoration(labelText: "Enter the recipient"),
                      keyboardType: TextInputType.text,
                      onChanged: (text) {
                        recipient = text;
                      },
                    ),
                    TextFormField(
                      initialValue: category,
                      decoration:
                          new InputDecoration(labelText: "Enter the category"),
                      keyboardType: TextInputType.text,
                      onChanged: (text) {
                        category = text;
                      },
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
                          deleteCallback(transaction.transid);
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
                          print(transaction.transid);
                          updateCallback(transaction.transid - 1, amount,
                              recipient, category);
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
}
