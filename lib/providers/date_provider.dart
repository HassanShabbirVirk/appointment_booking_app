import 'package:flutter/material.dart';

class DateProvider with ChangeNotifier {
  DateTime? _pickedDate;
  DateTime? get pickedDate => _pickedDate;

  int? _day = DateTime.now().day;
  int? _month = DateTime.now().month;
  int? _year = DateTime.now().year;

  int? get day => _day;
  int? get month => _month;
  int? get year => _year;

  void datePicker(DateTime? date) {
    _pickedDate = date;
    _day = date!.day;
    _month = date.month;
    _year = date.year;
    notifyListeners();
  }
}
