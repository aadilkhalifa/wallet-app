import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wallet/Pages/New_transaction_page.dart';

import '../Models/Transactions_model.dart';
import '../Models/transactionAdapter.dart';

class FetchPage extends StatefulWidget {
  const FetchPage({Key? key}) : super(key: key);

  @override
  State<FetchPage> createState() => _FetchPageState();
}

class _FetchPageState extends State<FetchPage> {
  SmsQuery query = new SmsQuery();
  List<SmsMessage> allmessages = [];
  bool loading = true;

  @override
  void initState() {
    takePermission();
    box = Hive.box('transactions');
    _openBox();
  }

  Future<void> takePermission() async {
    if (await Permission.sms.request().isGranted) {
      print('granted');
      getAllMessages();
    }
  }

  void getAllMessages() {
    Future.delayed(Duration.zero, () async {
      List<SmsMessage> messages = await query.querySms(
        //querySms is from sms package
        // kinds: [SmsQueryKind.Inbox, SmsQueryKind.Sent, SmsQueryKind.Draft],
        //filter Inbox, sent or draft messages
        count: 10, //number of sms to read
      );

      setState(() {
        //update UI
        allmessages = messages
            .where((msg) =>
                msg.body!.toLowerCase().contains('rs') &&
                msg.body!.toLowerCase().contains('debited'))
            .toList();
        // print(allmessages);
        loading = false;
      });
    });
  }

  late final Box box;

  List<Box> itemsBox = [];
  Future<List<Box>> _openBox() async {
    print("reached open box");
    box = await Hive.openBox('transactions');
    return itemsBox;
  }

  _addInfo(Item newItem) async {
    // Add info to box
    newItem.transid = box.length + 1;
    box.add(newItem);
    print(box.length);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionsModel>(builder: (context, transactions, child) {
      return Scaffold(
        appBar: AppBar(),
        body: loading == true
            ? CircularProgressIndicator()
            : allmessages.length == 0
                ? Center(child: Text('No new sms'))
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ...allmessages.map(
                          (msg) => GestureDetector(
                              child: Card(
                                child: Text(msg.body!),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => New_transaction_page(
                                      additionCallback: _addInfo,
                                      transactions: transactions,
                                    ),
                                  ),
                                  // const New_transaction_page()),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
      );
    });
  }

  Future<void> _navigateAndAddTransaction(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    // final result = await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => New_transaction_page(
    //           additionCallback: _addInfo, transactions: transactions)),
    // );

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!mounted) return;

    setState(() {
      // category = result;
    });

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    // ScaffoldMessenger.of(context)
    //   ..removeCurrentSnackBar()
    //   ..showSnackBar(SnackBar(content: Text('$result')));
  }
}
