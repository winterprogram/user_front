import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<String> categoryList = [
    'Restaurant/Bar',
    'Beauty Salon/Spa',
    'Cafe/Fast Food',
    'Ice-Cream Parlour',
    'Boutiques'
  ];
  List<String> selectedCategoryList = List(5);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              MultiSelectChip(
                categoryList,
                onSelectionChanged: (selectedList) {
                  setState(() {
                    selectedCategoryList = selectedList;
                  });
                },
              ),
              Container(
                height: 100,
                child: ListView(
                  children: printChoice(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  printChoice() {
    List<Widget> showChoice = List();
    showChoice.add(Text('Selected category according to priority'));
    print(selectedCategoryList);
    selectedCategoryList.forEach((item) {
      showChoice.add(Text(item));
    });
    print(showChoice);
    return showChoice;
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final Function(List<String>) onSelectionChanged;
  MultiSelectChip(this.reportList, {this.onSelectionChanged});
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedChoices = List();
  List<Widget> showChoices = [Text('Categories on priority basis')];

  _buildChoiceList() {
    List<Widget> choices = List();
    widget.reportList.forEach(
      (item) {
        choices.add(
          Container(
            padding: const EdgeInsets.all(2.0),
            child: ChoiceChip(
              label: Text(item),
              selected: selectedChoices.contains(item),
              onSelected: (selected) {
                setState(() {
                  if (selectedChoices.contains(item)) {
                    selectedChoices.remove(item);
                  } else {
                    selectedChoices.add(item);
                  }
                  widget.onSelectionChanged(selectedChoices);
                });
              },
            ),
          ),
        );
      },
    );
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
