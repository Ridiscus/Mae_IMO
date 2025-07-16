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

      if ((now.day - this.day) == 1) {
        return "Hier, ${formatTime.format(this)}";
      }

      return DateFormat('dd LLLL, HH:mm', 'fr').format(this);
    } catch (e) {
      return "-";
    }
  }

  String humain() {
    try {
      return DateFormat('dd LLLL y, HH:mm', 'fr').format(this);
    } catch (e) {
      return "-";
    }
  }
}
