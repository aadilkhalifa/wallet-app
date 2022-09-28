import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:wallet/Pages/New_transaction_page.dart';
import 'package:wallet/Pages/Transaction_details.page.dart';

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
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: transactions.count,
                    itemBuilder: (BuildContext context, int index) {
                      Transaction transaction = transactions.atIndex(index);
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider<
                                  TransactionsModel>.value(
                                value: transactions,
                                child: Transation_details_page(transaction),
                              ),
                            ),
                            // const New_transaction_page()),
                          );
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text('Transaction id: '),
                                    Text(transaction.id.toString()),
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                                Row(
                                  children: [
                                    Text('Amount: '),
                                    Text(transaction.amount.toString()),
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                                Row(
                                  children: [
                                    Text('Recipient: '),
                                    Text(transaction.to),
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                                Row(
                                  children: [
                                    Text('Debit or credit: '),
                                    Text('Debit'),
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                                Row(
                                  children: [
                                    Text('Date and time: '),
                                    Text(transaction.dateTime.toString()),
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                                Row(
                                  children: [
                                    Text('Category: '),
                                    Text(transaction.category),
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                                // Text(transaction.id.toString()),
                                // Text(transaction.amount.toString()),
                                // Text(transaction.to.toString()),
                                // Text(transaction.from.toString()),
                                // Text(transaction.debit ? 'debit' : 'credit'),
                                // Text(transaction.dateTime.toString()),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(
                      40), // fromHeight use double.infinity as width and 40 is the height
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChangeNotifierProvider<TransactionsModel>.value(
                        value: transactions,
                        child: New_transaction_page(),
                      ),
                    ),
                    // const New_transaction_page()),
                  );
                },
                child: Text('Add'),
              ),
            ],
          ),
        );
      },
    );
  }
}
