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
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.fromLTRB(24.sp, 12.sp, 24.sp, 32.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle/Marqueur de swipe
                Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 24.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                Text(
                  'Ajouter une photo',
                  style:
                      TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ).sourceSansProBold,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Choisissez la source de votre image',
                  style:
                      TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[500],
                      ).sourceSansProRegular,
                ),
                SizedBox(height: 32.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildSourceOption(
                        context: context,
                        icon: Icons.photo_library_rounded,
                        label: 'Galerie',
                        color: Colors.blue,
                        onTap: () => Navigator.of(context).pop('gallery'),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: _buildSourceOption(
                        context: context,
                        icon: Icons.photo_camera_rounded,
                        label: 'Caméra',
                        color: Colors.teal,
                        onTap: () => Navigator.of(context).pop('camera'),
                      ),
                    ),
                  ],
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

  static Widget _buildSourceOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(12.sp),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28.sp),
              ),
              SizedBox(height: 12.h),
              Text(
                label,
                style:
                    TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ).sourceSansProSemiBold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
