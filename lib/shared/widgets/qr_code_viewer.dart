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
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: false,
  );

  // Pour éviter de scanner plusieurs fois le même code
  bool _hasScanned = false;

  @override
  Widget build(BuildContext context) {
    // Calcul des dimensions comme dans votre code original
    final double actualWidth = widget.width ?? MediaQuery.of(context).size.width * 0.9;
    final double actualHeight = widget.height ?? MediaQuery.of(context).size.width * 0.9;

    return SizedBox(
      width: actualWidth,
      height: actualHeight,
      child: Stack(
        children: [
          // 1. La caméra
          MobileScanner(
            controller: controller,
            onDetect: (BarcodeCapture capture) {
              if (_hasScanned) return; // Si déjà scanné, on ignore

              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  setState(() {
                    _hasScanned = true;
                  });

                  // Appel du callback
                  widget.onQrCodeScanned(barcode.rawValue!);

                  // Pause la caméra comme dans votre ancien code
                  controller.stop();
                  break;
                }
              }
            },
          ),

          // 2. L'Overlay (Décoration visuelle qui remplace QrScannerOverlayShape)
          Container(
            decoration: ShapeDecoration(
              shape: _ScannerOverlayShape(
                borderColor: AppColors.primary, // Utilise votre couleur
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                overlayColor: Colors.white, // Fond blanc comme demandé
                cutOutSize: actualWidth * 0.8, // Taille de la fenêtre de scan
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

// --- CLASSE UTILITAIRE POUR DESSINER LE CARRÉ (OVERLAY) ---
// Cette classe reproduit le design de l'ancien plugin qr_code_scanner
class _ScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  const _ScannerOverlayShape({
    this.borderColor = Colors.red,
    this.borderWidth = 10.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 0,
    this.borderLength = 40,
    this.cutOutSize = 250,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return getLeftTopPath(rect)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..lineTo(rect.left, rect.top);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {

    final width = rect.width;
    final height = rect.height;
    final borderOffset = borderWidth / 2;
    final double cutOutWidth = cutOutSize < width ? cutOutSize : width - borderOffset;
    final double cutOutHeight = cutOutSize < height ? cutOutSize : height - borderOffset;

    final backgroundPaint = Paint()
    ..color = overlayColor
    ..style = PaintingStyle.fill;

    final borderPaint = Paint()
    ..color = borderColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = borderWidth;

    final cutOutRect = Rect.fromLTWH(
    rect.left + width / 2 - cutOutWidth / 2 + borderOffset,
    rect.top + height / 2 - cutOutHeight / 2 + borderOffset,
    cutOutWidth - borderOffset * 2,
    cutOutHeight - borderOffset * 2,
    );

    // Dessine le fond (overlay) avec le trou
    canvas
    ..saveLayer(rect, backgroundPaint)
    ..drawRect(rect, backgroundPaint)
    ..drawRRect(
    RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius)),
    Paint()..blendMode = BlendMode.clear, // Crée le trou transparent
    )
    ..restore();

    // Dessine les coins colorés
    final Path path = Path();

    // Coin haut gauche
    path.moveTo(cutOutRect.left, cutOutRect.top + borderLength);
    path.lineTo(cutOutRect.left, cutOutRect.top);
    path.lineTo(cutOutRect.left + borderLength, cutOutRect.top);

    // Coin haut droit
    path.moveTo(cutOutRect.right, cutOutRect.top + borderLength);
    path.lineTo(cutOutRect.right, cutOutRect.top);
    path.lineTo(cutOutRect.right - borderLength, cutOutRect.top);

    // Coin bas droit
    path.moveTo(cutOutRect.right, cutOutRect.bottom - borderLength);
    path.lineTo(cutOutRect.right, cutOutRect.bottom);
    path.lineTo(cutOutRect.right - borderLength, cutOutRect.bottom);

    // Coin bas gauche
    path.moveTo(cutOutRect.left, cutOutRect.bottom - borderLength);
    path.lineTo(cutOutRect.left, cutOutRect.bottom);
    path.lineTo(cutOutRect.left + borderLength, cutOutRect.bottom);

    canvas.drawPath(path, borderPaint);
  }

  @override
  ShapeBorder scale(double t) => this;
}