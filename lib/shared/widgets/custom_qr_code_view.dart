part of 'index.dart';

class CustomQrCodeView extends StatelessWidget {
  final String data;
  final double? size;
  final Color? backgroundColor;
  final EdgeInsets? padding;

  const CustomQrCodeView({
    super.key,
    required this.data,
    this.size = 80,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: size,
      backgroundColor: backgroundColor ?? Colors.white,
      padding: padding ?? EdgeInsets.all(2),
    );
  }
}
