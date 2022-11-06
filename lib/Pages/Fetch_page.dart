import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wallet/Pages/Automate_page.dart';
import 'package:wallet/Pages/New_transaction_page.dart';
import 'package:intl/intl.dart';
import 'package:wallet/constants.dart';

import '../Models/Transactions_model.dart';
import '../Models/transactionAdapter.dart';

String formatDate(DateTime date) => new DateFormat("MMM d, h:m a").format(date);
double getAmount(String body) {
  var words = body.split(' ');
  words = words
      .where((word) => word.length > 2 && word.substring(0, 2) == 'Rs')
      .toList();
  if (words.isNotEmpty) return double.parse(words[0].substring(2));
  return -1;
}

String getRecipient(String body) {
  var first = body.indexOf('transfer to ');
  var second = body.indexOf(' Ref No');
  if (first == -1 || second == -1) return "_";
  return body.substring(first + 12, second);
}

class FetchPage extends StatefulWidget {
  List<String> seenHashes;
  List<Automation> automations;
  FetchPage(this.seenHashes, this.automations, {Key? key}) : super(key: key);

  @override
  State<FetchPage> createState() => _FetchPageState();
}

class _FetchPageState extends State<FetchPage> {
  SmsQuery query = new SmsQuery();
  List<SmsMessage> allmessages = [];
  bool loading = true;
  List<String> seenHashes = [];

  @override
  void initState() {
    takePermission();
    box = Hive.box('transactions');
    _openBox();
    seenHashes = widget.seenHashes;
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
                msg.body!.toLowerCase().contains('debited') &&
                widget.seenHashes.contains(
                        encodeString(msg.body! + msg.date.toString())) ==
                    false)
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
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...allmessages.map((msg) {
                            double amount = getAmount(msg.body!);
                            if (amount == -1) amount = 0;
                            String recipient = getRecipient(msg.body!);
                            if (recipient == "_") recipient = "";
                            DateTime date = msg.date!;
                            String category = categories[0];
                            bool foundAutomation = false;
                            var cur_automation = widget.automations
                                .where((a) => a.recipient == recipient)
                                .toList();
                            if (cur_automation.length > 0) {
                              category = cur_automation[0].category;
                              foundAutomation = true;
                            }
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ExpansionTile(
                                  title: Column(children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Parsed Amount: '),
                                        Text(
                                          'Rs ' + amount.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Parsed Recipient: '),
                                        Flexible(
                                          child: Text(
                                            recipient,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Parsed Date: '),
                                        Text(
                                          formatDate(msg.date!),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    foundAutomation == false
                                        ? Container()
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Category automation: '),
                                              Text(
                                                category,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                    // Text(msg.body!),
                                  ]),
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 8, bottom: 8),
                                      child: Text(
                                        msg.body!,
                                      ),
                                    ),
                                    Row(children: [
                                      Expanded(
                                        child: OutlinedButton(
                                            child: Text('Remove'),
                                            onPressed: () {
                                              seenHashes.add(encodeString(
                                                  msg.body! +
                                                      msg.date.toString()));
                                              getAllMessages();
                                              setState(() {});
                                            }),
                                      ),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      Expanded(
                                        child: ElevatedButton(
                                            child: Text('Add transaction'),
                                            onPressed: () async {
                                              var result = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      New_transaction_page(
                                                    additionCallback: _addInfo,
                                                    transactions: transactions,
                                                    amount: amount,
                                                    recipient: recipient,
                                                    date: date,
                                                  ),
                                                ),
                                              );
                                              if (result == 'success') {
                                                seenHashes.add(encodeString(
                                                    msg.body! +
                                                        msg.date.toString()));
                                                getAllMessages();
                                              }
                                            }),
                                      ),
                                    ]),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
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
