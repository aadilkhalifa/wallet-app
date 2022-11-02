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
  State<History_page> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<History_page> {
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
                        child: TransactionCard(transaction),
                      );
                    }),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(
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
                child: const Text('Add'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TransactionCard extends StatelessWidget {
  Transaction transaction;

  TransactionCard(this.transaction, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.swap_vertical_circle,
                  size: 40,
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment to',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      transaction.to.length > 0 ? transaction.to : 'Unnamed',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(),
                ),
                Text(
                  '₹${transaction.amount}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '2 days ago',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  transaction.category.toUpperCase(),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
