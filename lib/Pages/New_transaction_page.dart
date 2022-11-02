import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../Models/Transactions_model.dart';

class New_transaction_page extends StatefulWidget {
  const New_transaction_page({Key? key}) : super(key: key);

  @override
  State<New_transaction_page> createState() => _New_transaction_pageState();
}

class _New_transaction_pageState extends State<New_transaction_page> {
  double amount = 0;
  String recipient = "";
  String category = "";

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
                  TextField(
                    decoration:
                        new InputDecoration(labelText: "Enter the amount"),
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      amount = double.parse(text);
                    },
                  ),

                  TextField(
                    decoration:
                        new InputDecoration(labelText: "Enter the recipient"),
                    keyboardType: TextInputType.text,
                    onChanged: (text) {
                      recipient = text;
                    },
                  ),
                  TextField(
                    decoration:
                        new InputDecoration(labelText: "Enter the category"),
                    keyboardType: TextInputType.text,
                    onChanged: (text) {
                      category = text;
                    },
                  ),
                ],
              ))),
              Consumer<TransactionsModel>(
                builder: (context, transactions, child) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(40),
                    ),
                    onPressed: () {
                      transactions.add(new Transaction(1, amount, 'me',
                          recipient, true, DateTime.now(), ''));
                      Navigator.pop(context);
                    },
                    child: Text('Done'),
                  );
                },
              )
            ],
          ),
        ));
  }
}
