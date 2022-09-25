import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../Models/Transactions_model.dart';

class History_page extends StatefulWidget {
  const History_page({Key? key}) : super(key: key);

  @override
  State<History_page> createState() => _History_pageState();
}

class _History_pageState extends State<History_page> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionsModel>(
      builder: (context, transactions, child) {
        return ListView.builder(
            itemCount: transactions.count,
            itemBuilder: (BuildContext context, int index) {
              Transaction transaction = transactions.atIndex(index);
              return Card(
                child: Column(
                  children: [
                    Text(transaction.id.toString()),
                    Text(transaction.amount.toString()),
                    Text(transaction.to.toString()),
                    Text(transaction.from.toString()),
                    Text(transaction.debitOrCredit.toString()),
                    Text(transaction.dateTime.toString()),
                  ],
                ),
              );
            });
      },
    );
  }
}
