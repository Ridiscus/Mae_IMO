part of 'index.dart';

class UIHelper {
  static cachedNetworkImage(
    String? imageUrl, {
    double height = 100,
    BoxFit? fit,
  }) {
    return CachedNetworkImage(
      imageUrl: imageUrl ?? "",
      repeat: ImageRepeat.noRepeat,
      height: height.h,
      width: height.h,
      fit: fit ?? BoxFit.contain,

      errorWidget:
          (context, url, error) => Icon(Icons.error, color: Colors.red),
      placeholder: (context, url) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              width: 20.sp,
              height: 20.sp,
              child: CircularProgressIndicator.adaptive(
                strokeCap: StrokeCap.round,
              ),
            ),
          ],
        );
      },
    );
  }

  static cachedNetworkImageProvider(
    String? imageUrl, {
    double height = 100,
    BoxFit? fit,
  }) {
    return CachedNetworkImageProvider(imageUrl ?? "");
  }

  static networkImage(String? imageUrl, {double height = 100}) {
    return Image.network(
      imageUrl ?? "",
      repeat: ImageRepeat.noRepeat,
      height: height.h,
      width: height.h,
      fit: BoxFit.contain,
      errorBuilder:
          (context, url, error) => Icon(Icons.error, color: Colors.red),
      loadingBuilder:
          (context, child, loadingProgress) =>
              loadingProgress == null
                  ? child
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 20.sp,
                        height: 20.sp,
                        child: CircularProgressIndicator.adaptive(
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                    ],
                  ),
    );
  }

  /// Fonction pour sélectionner une image depuis la galerie
  static Future<File?> pickImage(BuildContext context) async {
    try {
      // Vérifier les permissions pour le stockage
      final storagePermission = await Permission.photos.request();

      if (storagePermission.isDenied) {
        showToast(msg: "Permission requise pour accéder à la galerie");
        return null;
      }

      // Utiliser FilePicker pour sélectionner une image
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        // allowedExtensions: ['png', 'jpg', 'jpeg', 'webp', 'svg'],
        allowMultiple: false,
      );

      if (result == null || result.xFiles.isEmpty) {
        return null;
      }

      final File file = File(result.xFiles.first.path);

      // Vérifier que le fichier existe
      if (!await file.exists()) {
        showToast(msg: "Le fichier sélectionné n'existe pas");
        return null;
      }

      // Vérifier la taille du fichier (max 5MB)
      final int fileSizeInBytes = await file.length();
      final double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

      if (fileSizeInMB > 5) {
        showToast(msg: "L'image est trop volumineuse. Taille maximale: 5MB");
        return null;
      }

      // Vérifier le format de l'image
      final String extension = file.path.toLowerCase().split('.').last;
      final List<String> allowedFormats = ['png', 'jpg', 'jpeg', 'webp', 'svg'];

      if (!allowedFormats.contains(extension)) {
        showToast(msg: "Format non supporté. Utilisez PNG, JPG, JPEG, WebP ou SVG");
        return null;
      }

      return file;
    } catch (e) {
      print(e.toString());
      showToast(msg: "Erreur lors de la sélection de l'image");
      return null;
    }
  }
}
