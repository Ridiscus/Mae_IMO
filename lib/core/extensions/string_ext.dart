import 'package:intl/intl.dart' show DateFormat, NumberFormat;

extension CurrencyFormater on String {
  String formatCurrency({
    String locale = "fr",
    int decimalDigits = 0,
    String symbol = "F",
  }) {
    if (isEmpty || toLowerCase() == "null") return "";

    return NumberFormat.currency(
      locale: locale,
      decimalDigits: decimalDigits,
      symbol: symbol,
    ).format(double.parse(this));
  }

  String time() {
    final now = DateTime.now();
    final dateFormat = DateFormat("YYYY-MM-dd", 'fr');
    final formatTime = DateFormat("HH:m", 'fr');
    final dt = DateTime.parse(this);

    if (dateFormat.format(now) == dateFormat.format(dt)) {
      return "Aujourd’hui, ${formatTime.format(dt)}";
    }

    if ((now.day - dt.day) == 1) {
      return "Hier, ${formatTime.format(dt)}";
    }

    return DateFormat('dd LLLL, HH:m', 'fr').format(dt);
  }
}
