import 'package:intl/intl.dart';

class FormatUtils {
  static String formatPrice(double price) {
      final formatter = NumberFormat('#,###');
      return formatter.format(price);
    }

  static String formatDate(String date) {
    DateTime inputDate = DateTime.parse(date);
    String formattedDate = '${inputDate.day.toString().padLeft(2, '0')}/${inputDate.month.toString().padLeft(2, '0')}/${inputDate.year}';
    return formattedDate;
  }

  static bool phoneValidate(String phone){
    return RegExp(r'^0(3[2-9]|5[6-8]|7[0-9]|8[1-6]|9[0-8])\d{7}$').hasMatch(phone);
  }
}