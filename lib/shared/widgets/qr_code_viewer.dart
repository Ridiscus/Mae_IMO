part of 'index.dart';

class QrCodeViewer extends StatefulWidget {
  final Function(String) onQrCodeScanned;
  final double? width;
  final double? height;

  const QrCodeViewer({
    super.key,
    required this.onQrCodeScanned,
    this.width,
    this.height,
  });

  @override
  State<QrCodeViewer> createState() => _QrCodeViewerState();
}

class _QrCodeViewerState extends State<QrCodeViewer> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // Dans le cas d'une application iOS, nous devons reprendre le scanner après une pause
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? MediaQuery.of(context).size.width * 0.9,
      height:
          widget.height ??
          MediaQuery.of(context).size.width * 0.9, // Carré par défaut
      child: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        // overlayMargin: EdgeInsets.zero,
        overlay: QrScannerOverlayShape(
          borderColor: AppColors.primary,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          overlayColor: Colors.white,
          //  cutOutSize: widget.width != null ? widget.width! * 0.8 : MediaQuery.of(context).size.width * 0.7,
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // Si nous avons un résultat valide
      if (scanData.code != null) {
        // On appelle la fonction de callback avec le code scanné
        widget.onQrCodeScanned(scanData.code!);

        // Optionnellement, pause la caméra après un scan réussi
        controller.pauseCamera();
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
