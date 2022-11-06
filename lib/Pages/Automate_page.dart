import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wallet/Models/transactionAdapter.dart';
import 'package:wallet/Pages/Fetch_page.dart';
import 'package:wallet/Pages/New_transaction_page.dart';

import '../Models/Transactions_model.dart';
import 'package:crypto/crypto.dart';

class Automate_page extends StatefulWidget {
  Automate_page({Key? key}) : super(key: key);

  @override
  State<Automate_page> createState() => _Automate_pageState();
}

String encodeString(String input) {
  return sha256.convert(utf8.encode(input)).toString();
}

class _Automate_pageState extends State<Automate_page> {
  List<String> seenHashes = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionsModel>(builder: (context, transactions, child) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [Text('No automations yet.')],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: OutlinedButton(
                child: Text(
                  'Fetch',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                style: ButtonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChangeNotifierProvider<TransactionsModel>.value(
                        value: transactions,
                        child: FetchPage(seenHashes),
                      ),
                    ),
                    // const New_transaction_page()),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
