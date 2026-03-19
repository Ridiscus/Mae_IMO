import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pdfrx/pdfrx.dart';

class FilePreviewModal extends StatefulWidget {
  final File? localFile;
  final String? remoteUrl;
  final String label;

  const FilePreviewModal({
    super.key,
    this.localFile,
    this.remoteUrl,
    required this.label,
  });

  static void show(
    BuildContext context, {
    File? file,
    String? url,
    required String label,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 1,
            minChildSize: 1,
            maxChildSize: 1,
            builder:
                (context, scrollController) => Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.r),
                      topRight: Radius.circular(25.r),
                    ),
                  ),
                  child: FilePreviewModal(
                    localFile: file,
                    remoteUrl: url,
                    label: label,
                  ),
                ),
          ),
    );
  }

  @override
  State<FilePreviewModal> createState() => _FilePreviewModalState();
}

class _FilePreviewModalState extends State<FilePreviewModal> {
  bool _isLoading = false;

  Future<void> _shareFile() async {
    try {
      if (widget.localFile != null) {
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(widget.localFile!.path)],
            subject: widget.label,
          ),
        );
      } else if (widget.remoteUrl != null) {
        setState(() => _isLoading = true);
        final tempDir = await getTemporaryDirectory();
        final fileName = widget.remoteUrl!.split('/').last;
        final savePath = '${tempDir.path}/$fileName';

        await Dio().download(widget.remoteUrl!, savePath);
        await SharePlus.instance.share(
          ShareParams(files: [XFile(savePath)], subject: widget.label),
        );
      }
    } catch (e) {
      _showError('Erreur lors du partage : $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _downloadFile() async {
    try {
      setState(() => _isLoading = true);

      File? fileToSave = widget.localFile;

      if (widget.remoteUrl != null) {
        final tempDir = await getTemporaryDirectory();
        final fileName = widget.remoteUrl!.split('/').last;
        final savePath = '${tempDir.path}/$fileName';
        await Dio().download(widget.remoteUrl!, savePath);
        fileToSave = File(savePath);
      }

      if (fileToSave != null) {
        // Sur mobile, on simule ou on utilise share pour "sauvegarder" si pas de dossier spécifique
        // Mais on peut essayer de copier dans le dossier Downloads sur Android
        if (Platform.isAndroid) {
          final directory = Directory('/storage/emulated/0/Download');
          if (await directory.exists()) {
            final fileName = fileToSave.path.split('/').last;
            await fileToSave.copy('${directory.path}/$fileName');
            _showSuccess('Fichier enregistré dans le dossier Téléchargements');
          } else {
            await SharePlus.instance.share(
              ShareParams(files: [XFile(fileToSave.path)]),
            );
          }
        } else {
          // iOS ou autre, le partage est la méthode standard pour sauvegarder
          await SharePlus.instance.share(
            ShareParams(files: [XFile(fileToSave.path)]),
          );
        }
      }
    } catch (e) {
      _showError('Erreur lors du téléchargement : $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.success),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fileName =
        widget.localFile?.path.split('/').last ??
        widget.remoteUrl?.split('/').last ??
        'document.pdf';
    final isPdf = fileName.toLowerCase().endsWith('.pdf');
    final fileSize =
        widget.localFile != null
            ? _getFileSize(widget.localFile!)
            : 'Fichier existant';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Column(
            children: [
              // Handle for DraggableScrollableSheet
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 12.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.label,
                            style:
                                TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ).sourceSansProBold,
                          ),
                          Text(
                            '$fileName • $fileSize',
                            style:
                                TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white70,
                                ).sourceSansProRegular,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white10),

              // Body
              Expanded(
                child: Center(
                  child: isPdf ? _buildPdfPreview() : _buildImagePreview(),
                ),
              ),

              // Footer Actions
              SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24.sp, 8.h, 24.sp, 24.sp),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _shareFile,
                          icon: const Icon(Icons.share_outlined),
                          label: const Text('Partager'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white10,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _downloadFile,
                          icon: const Icon(Icons.download_outlined),
                          label: const Text('Télécharger'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4.0,
      child:
          widget.localFile != null
              ? Image.file(widget.localFile!, fit: BoxFit.contain)
              : widget.remoteUrl != null
              ? CachedNetworkImage(
                imageUrl: widget.remoteUrl!,
                fit: BoxFit.contain,
                placeholder:
                    (context, url) => const Center(
                      child: CircularProgressIndicator.adaptive(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                errorWidget:
                    (context, url, error) => _buildPlaceholderIcon(
                      Icons.image_not_supported_outlined,
                    ),
              )
              : _buildPlaceholderIcon(Icons.image_outlined),
    );
  }

  Widget _buildPlaceholderIcon(IconData icon) {
    return Container(
      color: Colors.white12,
      child: Center(child: Icon(icon, size: 100.sp, color: Colors.white30)),
    );
  }

  Widget _buildPdfPreview() {
    if (widget.remoteUrl != null) {
      return PdfViewer.uri(Uri.parse(widget.remoteUrl!));
    } else if (widget.localFile != null) {
      return PdfViewer.file(widget.localFile!.path);
    }

    return Container(
      padding: EdgeInsets.all(40.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(30.sp),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.picture_as_pdf_rounded,
              size: 100.sp,
              color: Colors.red[400],
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Document Indisponible',
            style:
                TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ).sourceSansProBold,
          ),
          SizedBox(height: 8.h),
          Text(
            'L\'aperçu de ce PDF ne peut pas être généré.',
            textAlign: TextAlign.center,
            style:
                TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white60,
                ).sourceSansProRegular,
          ),
        ],
      ),
    );
  }

  String _getFileSize(File file) {
    try {
      final bytes = file.lengthSync();
      if (bytes < 1024) return '$bytes B';
      if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } catch (_) {
      return '--';
    }
  }
}
