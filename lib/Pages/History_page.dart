import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wallet/Models/transactionAdapter.dart';
import 'package:wallet/Pages/New_transaction_page.dart';
import 'package:wallet/Pages/Transaction_details.page.dart';

import '../Models/Transactions_model.dart';

class History_page extends StatefulWidget {
  const History_page({Key? key}) : super(key: key);

  @override
  State<History_page> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<History_page> {
  late Box box;

  @override
  void initState() {
    super.initState();
    // WidgetsFlutterBinding.ensureInitialized();
    // await Hive.initFlutter();
    // Hive.registerAdapter(ItemAdapter());
    _openBox();
    box = Hive.box('transactions');
  }

  List<Box> itemsBox = [];
  Future<List<Box>> _openBox() async {
    print("reached open box");
    box = await Hive.openBox('transactions');
    return itemsBox;
  }

  @override
  void dispose() {
    // Closes all Hive boxes
    // Hive.close();
    super.dispose();
  }

  final List<Transaction> _transactions = [
    Transaction(1, 100, 'me', 'amul', true, DateTime.now(), 'food'),
  ];
  int next = 2;
  _addInfo(Item newItem) async {
    // Add info to box
    newItem.transid = next++;
    box.add(newItem);
    print(box.length);
  }

  _getInfo() {
    // Get info from people box
    Map<dynamic, dynamic> entireList = box.toMap();
    print(entireList[0].transid);
  }

  _updateInfo(int transid, double amount, String recipent, String category,
      DateTime date) {
    // final trans = box.getAt(transid);
    final trans =
        box.values.firstWhere((element) => element.transid == transid);
    trans.amount = amount;
    trans.to = recipent;
    trans.category = category;
    trans.dateTime = date;
    trans.save();
    print("updated");
    // Update info of people box
  }

  _deleteInfo(int transid) async {
    // Delete info from people box
    // box.deleteAt(transid);
    // box.deleteAll(box.keys);
    final itemToDelete =
        await box.values.firstWhere((element) => element.transid == transid);
    await itemToDelete.delete();
    // box.keyAt(index)
  }

  @override
  Widget build(BuildContext context) {
    _openBox();

    return Consumer<TransactionsModel>(
      builder: (context, transactions, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: WatchBoxBuilder(
                  box: Hive.box('transactions'),
                  builder: ((context, box) {
                    Map<dynamic, dynamic> raw = box.toMap();
                    // print(raw[0].transid);
                    List list = raw.values.toList();
                    return ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int index) {
                          Item transaction = list[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChangeNotifierProvider<
                                      TransactionsModel>.value(
                                    value: transactions,
                                    child: Transation_details_page(
                                        transaction, _updateInfo, _deleteInfo),
                                  ),
                                ),
                                // const New_transaction_page()),
                              );
                            },
                            child: TransactionCard(transaction),
                          );
                        });
                  }),
                ),
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
                        child: New_transaction_page(
                          additionCallback: _addInfo,
                          transactions: transactions,
                          date: DateTime.now(),
                        ),
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
  Item transaction;

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
                      'Payment to' + transaction.transid.toString(),
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
                  DateFormat("MMM d yyyy").format(transaction.dateTime),
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
