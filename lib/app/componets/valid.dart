import 'package:get/get.dart';

valid(val, min, max) {
  if (val.isEmpty) {
    return 'Please enter some text';
  }
  if (val.length < min) {
    return 'Please enter at least $min characters';
  }
  if (val.length > max) {
    return 'Please enter less than $max characters';
  }
}
