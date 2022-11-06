import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../constants.dart';

class SelectCategory extends StatefulWidget {
  String selectedCategory;
  SelectCategory(this.selectedCategory, {Key? key}) : super(key: key);

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  // String selectedCategory = widget.selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...categories.map((category) {
                      return GestureDetector(
                        onTap: () {
                          widget.selectedCategory = category;
                          setState(() {});
                        },
                        child: Container(
                          width: double.infinity,
                          child: Text(
                            category,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          decoration: BoxDecoration(
                            border: category == widget.selectedCategory
                                ? Border.all(color: Colors.blueAccent)
                                : Border.all(
                                    color: Color.fromARGB(255, 216, 216, 216)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(16.0),
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                        ),
                      );
                    })
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                  child: Text('Done'),
                  onPressed: () {
                    Navigator.pop(context, widget.selectedCategory);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
