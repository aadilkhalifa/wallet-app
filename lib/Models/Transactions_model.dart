import 'dart:collection';

import 'package:flutter/material.dart';

int next_id = 1;

class Transaction {
  Transaction(this.id, this.amount, this.from, this.to, this.debit,
      this.dateTime, this.category);
  late int id;
  late double amount;
  late String from;
  late String to;
  late bool debit;
  late DateTime dateTime;
  late String category;
}

class TransactionsModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<Transaction> _transactions = [
    Transaction(0, 100, 'me', 'amul', true, DateTime.now(), 'food'),
  ];

  UnmodifiableListView<Transaction> get items =>
      UnmodifiableListView(_transactions);

  void add(Transaction transaction) {
    transaction.id = next_id;
    next_id = next_id + 1;

    if (transaction.from == '') transaction.from = 'null';
    if (transaction.category == '') transaction.category = 'null';
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

  void deleteTransactionWithId(id) {
    int index = _transactions.indexWhere((t) => t.id == id);
    _transactions.removeAt(index);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void updateTransactionWithId(id, transaction) {
    if (transaction.from == '') transaction.from = 'null';
    if (transaction.category == '') transaction.category = 'null';

    int index = _transactions.indexWhere((t) => t.id == id);
    _transactions[index] = transaction;
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
