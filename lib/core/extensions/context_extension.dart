part of 'index.dart';

extension ContextExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  Size get getSize => MediaQuery.of(this).size;
}
