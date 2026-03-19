import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/core/utils/index.dart';
import 'file_preview_modal.dart';

class FilePickerWidget extends StatefulWidget {
  final String label;
  final String? hint;
  final Function(File?) onFileSelected;
  final File? initialFile;
  final String? serverUrl;
  final VoidCallback? onFileDeleted;
  final bool isRequired;
  final String? errorText;

  const FilePickerWidget({
    super.key,
    required this.label,
    this.hint,
    required this.onFileSelected,
    this.initialFile,
    this.serverUrl,
    this.onFileDeleted,
    this.isRequired = false,
    this.errorText,
  });

  @override
  State<FilePickerWidget> createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
  File? _selectedFile;

  @override
  void initState() {
    super.initState();
    _selectedFile = widget.initialFile;
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _isDeleted = false;
      });
      widget.onFileSelected(_selectedFile);
    }
  }

  bool _isDeleted = false;

  void _clearFile() {
    setState(() {
      _selectedFile = null;
      if (widget.serverUrl != null) {
        _isDeleted = true;
      }
    });
    widget.onFileSelected(null);
    if (widget.onFileDeleted != null) {
      widget.onFileDeleted!();
    }
  }

  void _previewFile() {
    if (_selectedFile != null) {
      FilePreviewModal.show(context, file: _selectedFile!, label: widget.label);
    } else if (widget.serverUrl != null && widget.serverUrl!.isNotEmpty) {
      FilePreviewModal.show(
        context,
        url: widget.serverUrl!,
        label: widget.label,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: widget.label,
            style:
                TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ).sourceSansProSemiBold,
            children: [
              if (widget.isRequired)
                const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        InkWell(
          onTap:
              (_selectedFile != null ||
                      (widget.serverUrl != null && !_isDeleted))
                  ? _previewFile
                  : _pickFile,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color:
                    _selectedFile != null
                        ? AppColors.primary
                        : Colors.grey.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                _buildThumbnail(),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    _selectedFile != null
                        ? _selectedFile!.path.split('/').last
                        : widget.hint ?? 'Sélectionner un fichier',
                    style:
                        TextStyle(
                          fontSize: 14.sp,
                          color:
                              _selectedFile != null
                                  ? Colors.black87
                                  : Colors.grey,
                        ).sourceSansProRegular,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (_selectedFile != null ||
                    (widget.serverUrl != null && !_isDeleted))
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit_outlined,
                          color: AppColors.primary,
                        ),
                        onPressed: _pickFile,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      SizedBox(width: 12.w),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: _clearFile,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  )
                else
                  Icon(Icons.add_circle_outline, color: AppColors.primary),
              ],
            ),
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 6.h, left: 12.w),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red[700], size: 14.sp),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    widget.errorText!,
                    style:
                        TextStyle(
                          color: Colors.red[700],
                          fontSize: 12.sp,
                        ).sourceSansProRegular,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildThumbnail() {
    final hasRemote =
        widget.serverUrl != null && widget.serverUrl!.isNotEmpty && !_isDeleted;
    final hasLocal = _selectedFile != null;

    if (!hasLocal && !hasRemote) {
      return Icon(Icons.cloud_upload_outlined, color: Colors.grey, size: 24.sp);
    }

    return GestureDetector(
      onTap: _previewFile,
      child: Container(
        width: 40.sp,
        height: 40.sp,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child:
                  hasLocal
                      ? (_selectedFile!.path.toLowerCase().endsWith('.pdf')
                          ? Center(
                            child: Icon(
                              Icons.picture_as_pdf,
                              color: Colors.red,
                              size: 24.sp,
                            ),
                          )
                          : Image.file(_selectedFile!, fit: BoxFit.cover))
                      : (widget.serverUrl!.toLowerCase().endsWith('.pdf')
                          ? Center(
                            child: Icon(
                              Icons.picture_as_pdf,
                              color: Colors.red,
                              size: 24.sp,
                            ),
                          )
                          : UIHelper.cachedNetworkImage(
                            widget.serverUrl!,
                            fit: BoxFit.cover,
                            height: 40,
                          )),
            ),
            Container(
              color: Colors.black.withValues(alpha: 0.1),
              child: Center(
                child: Icon(Icons.zoom_in, color: Colors.white, size: 16.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
