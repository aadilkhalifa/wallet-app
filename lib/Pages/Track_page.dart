import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

class Track_page extends StatefulWidget {
  const Track_page({Key? key}) : super(key: key);

  @override
  State<Track_page> createState() => _Track_pageState();
}

class _Track_pageState extends State<Track_page> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Track page'),
    );
  }
}
