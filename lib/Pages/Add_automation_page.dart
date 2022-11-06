import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wallet/Pages/Select_category.dart';

import '../constants.dart';

class AddAutomationPage extends StatefulWidget {
  const AddAutomationPage({Key? key}) : super(key: key);

  @override
  State<AddAutomationPage> createState() => _AddAutomationPageState();
}

class _AddAutomationPageState extends State<AddAutomationPage> {
  String recipient = '';
  String category = categories[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add automation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: new InputDecoration(
                          labelText: "Enter the recipient name"),
                      keyboardType: TextInputType.text,
                      // initialValue: recipient,
                      onChanged: (text) {
                        recipient = text;
                      },
                    ),
                    Row(
                      children: [
                        Text('Category'),
                        SizedBox(
                          width: 20,
                        ),
                        OutlinedButton(
                          child: Text(category),
                          onPressed: () {
                            _navigateAndDisplaySelection(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                child: Text('Done'),
                onPressed: () {
                  Navigator.pop(context, Automation(recipient, category));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectCategory(category)),
    );

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!mounted) return;

    setState(() {
      category = result;
    });

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    // ScaffoldMessenger.of(context)
    //   ..removeCurrentSnackBar()
    //   ..showSnackBar(SnackBar(content: Text('$result')));
  }
}
