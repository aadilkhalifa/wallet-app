import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class History_page extends StatefulWidget {
  const History_page({Key? key}) : super(key: key);

  @override
  State<History_page> createState() => _History_pageState();
}

class _History_pageState extends State<History_page> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('History page'),
    );
  }
}
