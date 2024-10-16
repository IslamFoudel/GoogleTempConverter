import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  static final ROUTE = '/Home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double tempFrom = 0.0, tempTo = 0.0;
  var temperatures = ['Celsius', 'Fahrenheit', 'Kelvin'];
  var selectedTempTypeFrom = 'Celsius';
  var selectedTempTypeTo = 'Fahrenheit';
  var selectedTempControllerFrom = TextEditingController();
  var selectedTempControllerTo = TextEditingController();
  bool isUpdating = false;

  @override
  initState() {
    super.initState();
    selectedTempControllerFrom.addListener(tempFromListener);
    selectedTempControllerTo.addListener(
        tempToListener); // Added listener for the second text field
  }

  // Listener for the first text field
  tempFromListener() {
    if (isUpdating) return;
    setState(() {
      if (selectedTempControllerFrom.text.isNotEmpty) {
        final parsedTemp = double.tryParse(selectedTempControllerFrom.text);
        if (parsedTemp != null) {
          isUpdating = true;
          tempFrom = parsedTemp;
          tempTo =
              convertTemp(tempFrom, selectedTempTypeFrom, selectedTempTypeTo);
          selectedTempControllerTo.text = tempTo.toStringAsFixed(2);
          isUpdating = false;
        }
      } else {
        isUpdating = true;
        selectedTempControllerTo.clear();
        isUpdating = false;
      }
    });
  }

  // Listener for the second text field
  tempToListener() {
    if (isUpdating) return;
    setState(() {
      if (selectedTempControllerTo.text.isNotEmpty) {
        final parsedTemp = double.tryParse(selectedTempControllerTo.text);
        if (parsedTemp != null) {
          isUpdating = true;
          tempTo = parsedTemp;
          tempFrom =
              convertTemp(tempTo, selectedTempTypeTo, selectedTempTypeFrom);
          selectedTempControllerFrom.text = tempFrom.toStringAsFixed(2);
          isUpdating = false;
        }
      } else {
        isUpdating = true;
        selectedTempControllerFrom.clear();
        isUpdating = false;
      }
    });
  }

  // Converts from one temperature unit to another
  double convertTemp(double temp, String from, String to) {
    switch (from) {
      case 'Celsius':
        switch (to) {
          case 'Fahrenheit':
            return (temp * 9 / 5) + 32;
          case 'Kelvin':
            return temp + 273.15;
          case 'Celsius':
            return temp;
        }
        break;
      case 'Fahrenheit':
        switch (to) {
          case 'Celsius':
            return (temp - 32) * 5 / 9;
          case 'Kelvin':
            return (temp - 32) * 5 / 9 + 273.15;
          case 'Fahrenheit':
            return temp;
        }
        break;
      case 'Kelvin':
        switch (to) {
          case 'Celsius':
            return temp - 273.15;
          case 'Fahrenheit':
            return (temp - 273.15) * 9 / 5 + 32;
          case 'Kelvin':
            return temp;
        }
        break;
    }
    return temp;
  }

  // Handles changes in the first dropdown
  onFirstDropdownChange(String? newValue) {
    setState(() {
      selectedTempTypeFrom = newValue!;
      // Recalculate the second field based on the new selection, but keep the first input unchanged
      if (selectedTempControllerFrom.text.isNotEmpty) {
        final parsedTemp = double.tryParse(selectedTempControllerFrom.text);
        if (parsedTemp != null) {
          tempTo =
              convertTemp(parsedTemp, selectedTempTypeFrom, selectedTempTypeTo);
          selectedTempControllerTo.text = tempTo.toStringAsFixed(2);
        }
      }
    });
  }

  // Handles changes in the second dropdown
  onSecondDropdownChange(String? newValue) {
    setState(() {
      selectedTempTypeTo = newValue!;
      // Recalculate the second field based on the new selection, but keep the first input unchanged
      if (selectedTempControllerFrom.text.isNotEmpty) {
        final parsedTemp = double.tryParse(selectedTempControllerFrom.text);
        if (parsedTemp != null) {
          tempTo =
              convertTemp(parsedTemp, selectedTempTypeFrom, selectedTempTypeTo);
          selectedTempControllerTo.text = tempTo.toStringAsFixed(2);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bidirectional Temperature Converter'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DropdownButton(
                    items: temperatures.map((item) {
                      return DropdownMenuItem(
                        child: Text(item),
                        value: item,
                      );
                    }).toList(),
                    value: selectedTempTypeFrom,
                    onChanged: onFirstDropdownChange, // Updated method
                  ),
                  TextField(
                    controller: selectedTempControllerFrom,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      suffixText: selectedTempTypeFrom[0],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.0),
              child: SizedBox(
                height: 50,
                child: VerticalDivider(
                  color: Colors.grey,
                  width: 22,
                  thickness: 1,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DropdownButton(
                    items: temperatures.map((item) {
                      return DropdownMenuItem(
                        child: Text(item),
                        value: item,
                      );
                    }).toList(),
                    value: selectedTempTypeTo,
                    onChanged: onSecondDropdownChange, // Updated method
                  ),
                  TextField(
                    controller: selectedTempControllerTo,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      suffixText: selectedTempTypeTo[0],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
