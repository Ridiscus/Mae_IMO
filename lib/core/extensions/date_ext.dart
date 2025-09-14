part of 'index.dart';

extension DateFormaterExt on DateTime {
  String time() {
    try {
      final now = DateTime.now();
      final dateFormat = DateFormat("YYYY-MM-dd", 'fr');
      final formatTime = DateFormat("HH:mm", 'fr');

      if (dateFormat.format(now) == dateFormat.format(this)) {
        return "Aujourd’hui, ${formatTime.format(this)}";
      }

      if ((now.day - day) == 1) {
        return "Hier, ${formatTime.format(this)}";
      }

      return DateFormat('dd LLLL, HH:mm', 'fr').format(this);
    } catch (e) {
      return "-";
    }
  }

  String human() {
    try {
      return DateFormat('dd LLLL y, HH:mm', 'fr').format(this);
    } catch (e) {
      return "-";
    }
  }

  String humanWithoutTime() {
    try {
      return DateFormat('dd LLLL y', 'fr').format(this);
    } catch (e) {
      return "-";
    }
  }

  String monthYear() {
    try {
      return DateFormat('LLLL y', 'fr').format(this);
    } catch (e) {
      return "-";
    }
  }

}
