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

  bool beforeTo(DateTime futureDate) {
    try {
      if (toLowerCase() == "null") return false;
      var thisDate = DateTime.parse(this);
      return thisDate.isBefore(futureDate);
    } catch (error) {
      if (error is FormatException) {
        var datePart = split("-");
        var y = datePart.firstWhere((element) => element.length >= 3);
        var m = datePart[1];

        return DateTime.now()
            .copyWith(year: int.parse(y), month: int.parse(m))
            .isBefore(futureDate);
      }
      return false;
    }
  }

  bool afterTo(DateTime nowDate) {
    try {
      if (toLowerCase() == "null") return false;
      var thisDate = DateTime.parse(this);
      var thisMonth = DateFormat('yyyy-MM').format(thisDate);
      var nowMonth = DateFormat('yyyy-MM').format(nowDate);
      return thisMonth.compareTo(nowMonth) >= 0;
    } catch (error) {
      if (error is FormatException) {
        var datePart = split("-");
        var y = datePart.firstWhere((element) => element.length >= 3);
        var m = datePart[1];
        var thisDate = DateTime.parse(this);
        var nowDate = DateTime.now().copyWith(
          year: int.parse(y),
          month: int.parse(m),
        );

        var thisMonth = DateFormat('yyyy-MM').format(thisDate);
        var nowMonth = DateFormat('yyyy-MM').format(nowDate);

        return thisMonth.compareTo(nowMonth) >= 0;
      }
      return false;
    }
  }

  bool thisMountIncluded() {
    var nowMonth = DateFormat('yyyy-MM').format(DateTime.now());

    try {
      if (toLowerCase() == "null") return false;
      var thisDate = DateFormat('yyyy-MM').format(DateTime.parse(this));
      return nowMonth.compareTo(thisDate) <= 0;
    } catch (error) {
      if (error is FormatException) {
        var datePart = split("-");
        var y = datePart.firstWhere((element) => element.length >= 3);
        var m = datePart[1];

        var thisDate = DateFormat('yyyy-MM').format(
          DateTime.now().copyWith(year: int.parse(y), month: int.parse(m)),
        );

        return nowMonth.compareTo(thisDate) <= 0;
      }
      return false;
    }
  }

  String firstLetter() {
    return this[0].toUpperCase() + substring(1);
  }
}
