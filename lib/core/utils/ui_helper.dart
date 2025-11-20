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

  /// Fonction pour sélectionner une image depuis la galerie ou prendre une photo
  static Future<File?> pickImage(BuildContext context) async {
    try {
      // Afficher le modal de sélection
      final String? source = await showModalBottomSheet<String>(
        context: context,
        useSafeArea: true,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Galerie'),
                  onTap: () => Navigator.of(context).pop('gallery'),
                ),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Caméra'),
                  onTap: () => Navigator.of(context).pop('camera'),
                ),
              ],
            ),
          );
        },
      );

      if (source == null) return null;

      File? file;

      if (source == 'gallery') {
        final permissions = [
          Permission.photos,
          Permission.storage,
          Permission.mediaLibrary,
        ];

        for (var permission in permissions) {
          final permissionStatus = await permission.request();

          if (permissionStatus.isGranted) {
            // Utiliser FilePicker pour sélectionner une image depuis la galerie
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.image,
              allowMultiple: false,
            );

            if (result == null || result.xFiles.isEmpty) {
              return null;
            }

            file = File(result.xFiles.first.path);
            break;
          }
        }

      } else if (source == 'camera') {
        // Vérifier les permissions pour la caméra
        final cameraPermission = await Permission.camera.request();
        if (cameraPermission.isDenied) {
          showToast(msg: "Permission requise pour accéder à la caméra");
          return null;
        }

        // Utiliser ImagePicker pour prendre une photo
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 85,
          preferredCameraDevice: CameraDevice.front,
        );

        if (image == null) return null;
        file = File(image.path);
      }

      if (file == null) return null;

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
      final List<String> allowedFormats = ['png', 'jpg', 'jpeg', 'webp'];

      if (!allowedFormats.contains(extension)) {
        showToast(msg: "Format non supporté. Utilisez PNG, JPG, JPEG ou WebP");
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
