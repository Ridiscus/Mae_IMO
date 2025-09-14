part of 'index.dart';

extension CurrencyFormater on String {
  String formatCurrency({
    String locale = "fr",
    int decimalDigits = 0,
    String symbol = "F CFA",
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

  String humanWithoutTime() {
    var date = DateTime.tryParse(this);

    if (date == null) {
      return "";
    }
    return date.humanWithoutTime();
  }

  String monthYear() {
    try {
      if (toLowerCase() == "null") return "";
      var date = DateTime.parse(this);
      return date.monthYear();
    } catch (error) {
      if (error is FormatException) {
        var datePart = split("-");
        var y = datePart.firstWhere((element) => element.length >= 3);
        var m = datePart[1];

        return DateTime.now()
            .copyWith(year: int.parse(y), month: int.parse(m))
            .monthYear();
      }
      return "";
    }
  }

  String firstLetter() {
    return this[0].toUpperCase() + substring(1);
  }
}
