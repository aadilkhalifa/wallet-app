import 'dart:collection';

import 'package:flutter/material.dart';

class Transaction {
  Transaction(id, amount, from, to, debitOrCredit, dateTime) {
    this.id = id;
    this.amount = amount;
    this.from = from;
    this.to = to;
    this.debitOrCredit = debitOrCredit;
    this.dateTime = dateTime;
  }
  late int id;
  late int amount;
  late String from;
  late String to;
  late String debitOrCredit;
  late DateTime dateTime;
}

class TransactionsModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<Transaction> _transactions = [
    Transaction(1, 100, 'me', 'amul', 'debit', DateTime.now()),
  ];

  UnmodifiableListView<Transaction> get items =>
      UnmodifiableListView(_transactions);

  void add(Transaction transaction) {
    _transactions.add(transaction);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  Transaction atIndex(int index) {
    return _transactions[index];
  }

  int get count {
    return _transactions.length;
  }

  /// Removes all items from the cart.
  void removeAll() {
    _transactions.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
