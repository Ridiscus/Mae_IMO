import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/domain/models/index.dart';
import 'package:maelys_imo/core/manager/state/dashboard/dashboard_bloc.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/core/api_manager/endpoints.dart';
import 'package:maelys_imo/core/utils/index.dart';
import '../widgets/file_picker_widget.dart';
import '../widgets/file_preview_modal.dart';
import '../widgets/success_modal.dart';

class AgencyDetailPage extends StatefulWidget {
  static const routeName = 'agencyDetail';
  static const routePath = '/commercial/agency-detail';
  final AgencyModel agency;
  const AgencyDetailPage({super.key, required this.agency});
  @override
  State<AgencyDetailPage> createState() => _AgencyDetailPageState();
}

class _AgencyDetailPageState extends State<AgencyDetailPage> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour l'édition
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _communeController;
  late TextEditingController _contactController;
  late TextEditingController _addressController;
  late TextEditingController _rccmController;
  late TextEditingController _dfeController;
  bool _controllersInitialized = false;

  // Fichiers pour l'édition
  File? _newRibFile;
  File? _newRccmFile;
  File? _newDfeFile;
  File? _newProfileImage;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers([AgencyModel? agency]) {
    final a = agency ?? widget.agency;
    if (!_controllersInitialized) {
      _nameController = TextEditingController(text: a.name);
      _emailController = TextEditingController(text: a.email);
      _communeController = TextEditingController(text: a.commune);
      _contactController = TextEditingController(text: a.contact);
      _addressController = TextEditingController(text: a.adresse);
      _rccmController = TextEditingController(text: a.rccm);
      _dfeController = TextEditingController(text: a.dfe);
      _controllersInitialized = true;
    } else {
      _nameController.text = a.name ?? '';
      _emailController.text = a.email ?? '';
      _communeController.text = a.commune ?? '';
      _contactController.text = a.contact ?? '';
      _addressController.text = a.adresse ?? '';
      _rccmController.text = a.rccm ?? '';
      _dfeController.text = a.dfe ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _communeController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    _rccmController.dispose();
    _dfeController.dispose();
    super.dispose();
  }

  void _toggleEdit(AgencyModel agence) {
    setState(() {
      _isEditing = !_isEditing;
      _initControllers(agence);
      if (!_isEditing) {
        _newRibFile = null;
        _newRccmFile = null;
        _newDfeFile = null;
        _newProfileImage = null;
      }
    });
  }

  void _saveChanges(AgencyModel agence) {
    if (_formKey.currentState!.validate()) {
      context.read<DashboardBloc>().add(
        UpdateAgencyEvent(
          id: agence.codeId!,
          name: _nameController.text,
          email: _emailController.text,
          contact: _contactController.text,
          commune: _communeController.text,
          adresse: _addressController.text,
          rccm: _rccmController.text,
          dfe: _dfeController.text,
          rib: _newRibFile,
          rccmFile: _newRccmFile,
          dfeFile: _newDfeFile,
          profileImage: _newProfileImage,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state.agencyUpdated) {
          setState(() => _isEditing = false);
          SuccessModal.show(
            context: context,
            title: 'Modification Réussie !',
            message:
                'Les informations de l\'agence ont été mises à jour avec succès.',
            buttonText: 'OK, J\'AI COMPRIS',
          );
        }
        if (state.agencyDeleted) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final agence =
            state.agencies?.firstWhere(
              (element) => element.id == widget.agency.id,
              orElse: () => widget.agency,
            ) ??
            widget.agency;

        return PageWithHeaderLayout(
          headerHeight: MediaQuery.of(context).size.height * 0.20,
          headerContent: Column(
            children: [
              Row(
                children: [
                  const CircularBackButton(),
                  SizedBox(width: 8.w),
                  Text(
                    _isEditing ? 'Modifier l\'agence' : 'Détails de l\'agence',
                    style:
                        TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ).sourceSansProBold,
                  ),
                  const Spacer(),
                  if (!_isEditing) ...[
                    _buildHeaderAction(
                      icon: Icons.edit_outlined,
                      onTap: () => _toggleEdit(agence),
                    ),
                    SizedBox(width: 8.w),
                    _buildHeaderAction(
                      icon: Icons.delete_outline,
                      color: Colors.red[300],
                      onTap: () => _showDeleteDialog(context, agence),
                    ),
                  ] else ...[
                    _buildHeaderAction(
                      icon: Icons.close,
                      onTap: () => _toggleEdit(agence),
                    ),
                    SizedBox(width: 8.w),
                    _buildHeaderAction(
                      icon:
                          state.isUpdatingAgency
                              ? Icons.hourglass_empty
                              : Icons.check,
                      color: AppColors.success,
                      onTap:
                          state.isUpdatingAgency
                              ? null
                              : () => _saveChanges(agence),
                    ),
                  ],
                ],
              ),
            ],
          ),
          bodyContent: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Info (Initials & Name)
                _buildProfileHeader(agence),
                SizedBox(height: 24.h),

                // Informations générales
                _buildSectionTitle('Informations Générales'),
                _buildInfoCard([
                  _buildEditableInfoRow(
                    'ID Agence',
                    agence.codeId ?? 'N/A',
                    isEditable: false,
                    prefixIcon: Icons.badge_outlined,
                  ),
                  _buildEditableInfoRow(
                    'Nom de l\'agence',
                    agence.name ?? 'N/A',
                    controller: _nameController,
                    prefixIcon: Icons.business_outlined,
                    errorText: state.formErrors?['name'],
                  ),
                  _buildEditableInfoRow(
                    'Email professionnel',
                    agence.email ?? 'N/A',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    errorText: state.formErrors?['email'],
                  ),
                  _buildEditableInfoRow(
                    'Contact téléphonique',
                    agence.contact ?? 'N/A',
                    controller: _contactController,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone_outlined,
                    errorText: state.formErrors?['contact'],
                  ),
                ]),
                SizedBox(height: 24.h),

                // Localisation
                _buildSectionTitle('Localisation'),
                _buildInfoCard([
                  _buildEditableInfoRow(
                    'Commune',
                    agence.commune ?? 'N/A',
                    controller: _communeController,
                    prefixIcon: Icons.location_on_outlined,
                    errorText: state.formErrors?['commune'],
                  ),
                  _buildEditableInfoRow(
                    'Adresse complète',
                    agence.adresse ?? 'N/A',
                    controller: _addressController,
                    prefixIcon: Icons.map_outlined,
                    errorText: state.formErrors?['adresse'],
                  ),
                ]),
                SizedBox(height: 24.h),

                // Documents & Juridique
                _buildSectionTitle('Documents & Juridique'),
                if (_isEditing)
                  _buildInfoCard([
                    _buildEditableInfoRow(
                      'N° RCCM',
                      agence.rccm ?? 'N/A',
                      controller: _rccmController,
                      prefixIcon: Icons.numbers_outlined,
                      errorText: state.formErrors?['rccm'],
                    ),
                    _buildFilePickerSection(
                      'Fiche RCCM',
                      agence.rccmFile,
                      (file) => setState(() => _newRccmFile = file),
                      serverUrl:
                          agence.rccmFile != null
                              ? Endpoints.storageUrl(agence.rccmFile)
                              : null,
                    ),
                    const Divider(height: 32),
                    _buildEditableInfoRow(
                      'N° DFE',
                      agence.dfe ?? 'N/A',
                      controller: _dfeController,
                      prefixIcon: Icons.description_outlined,
                      errorText: state.formErrors?['dfe'],
                    ),
                    _buildFilePickerSection(
                      'Fiche DFE',
                      agence.dfeFile,
                      (file) => setState(() => _newDfeFile = file),
                      serverUrl:
                          agence.dfeFile != null
                              ? Endpoints.storageUrl(agence.dfeFile)
                              : null,
                    ),
                    const Divider(height: 32),
                    _buildFilePickerSection(
                      'RIB / Coordonnées Bancaires',
                      agence.rib,
                      (file) => setState(() => _newRibFile = file),
                      serverUrl:
                          agence.rib != null
                              ? Endpoints.storageUrl(agence.rib)
                              : null,
                    ),
                    const Divider(height: 32),
                    _buildFilePickerSection(
                      'Photo de profil',
                      agence.profileImage,
                      (file) => setState(() => _newProfileImage = file),
                      serverUrl:
                          agence.profileImage != null
                              ? Endpoints.storageUrl(agence.profileImage)
                              : null,
                    ),
                  ])
                else
                  Column(
                    children: [
                      _buildInfoCard([
                        _buildEditableInfoRow(
                          'N° RCCM',
                          agence.rccm ?? 'N/A',
                          isEditable: false,
                          prefixIcon: Icons.numbers_outlined,
                        ),
                        SizedBox(height: 8.h),
                        _buildFilePreviewCard(
                          'Fiche RCCM',
                          agence.rccmFile,
                          agence.rccmFile != null
                              ? Endpoints.storageUrl(agence.rccmFile)
                              : null,
                        ),
                        const Divider(height: 32),
                        _buildEditableInfoRow(
                          'N° DFE',
                          agence.dfe ?? 'N/A',
                          isEditable: false,
                          prefixIcon: Icons.description_outlined,
                        ),
                        SizedBox(height: 8.h),
                        _buildFilePreviewCard(
                          'Fiche DFE',
                          agence.dfeFile,
                          agence.dfeFile != null
                              ? Endpoints.storageUrl(agence.dfeFile)
                              : null,
                        ),
                        const Divider(height: 32),
                        _buildFilePreviewCard(
                          'Relevé d\'Identité Bancaire (RIB)',
                          agence.rib,
                          agence.rib != null
                              ? Endpoints.storageUrl(agence.rib)
                              : null,
                        ),
                      ]),
                    ],
                  ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderAction({
    required IconData icon,
    required VoidCallback? onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.sp),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color ?? Colors.white, size: 20.sp),
      ),
    );
  }

  Widget _buildProfileHeader(AgencyModel a) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (_isEditing && _newProfileImage != null) {
                FilePreviewModal.show(
                  context,
                  file: _newProfileImage!,
                  label: 'Nouvelle Photo de Profil',
                );
              } else if (a.profileImage != null && a.profileImage!.isNotEmpty) {
                FilePreviewModal.show(
                  context,
                  url: Endpoints.storageUrl(a.profileImage),
                  label: 'Photo de Profil',
                );
              }
            },
            child: Container(
              width: 100.sp,
              height: 100.sp,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child:
                    (_isEditing && _newProfileImage != null)
                        ? Image.file(_newProfileImage!, fit: BoxFit.cover)
                        : (a.profileImage != null && a.profileImage!.isNotEmpty)
                        ? UIHelper.cachedNetworkImage(
                          Endpoints.storageUrl(a.profileImage),
                          height: 100,
                          fit: BoxFit.cover,
                        )
                        : _buildInitialsAvatar(a),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            _isEditing ? _nameController.text : (a.name ?? ''),
            style:
                TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ).sourceSansProBold,
          ),
          Text(
            _isEditing ? _emailController.text : (a.email ?? ''),
            style:
                TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ).sourceSansProSemiBold,
          ),
        ],
      ),
    );
  }

  Widget _buildInitialsAvatar(AgencyModel a) {
    return Center(
      child: Text(
        (a.name != null && a.name!.isNotEmpty)
            ? a.name!.substring(0, 1).toUpperCase()
            : 'A',
        style:
            TextStyle(
              fontSize: 40.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ).sourceSansProBold,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
      child: Text(
        title.toUpperCase(),
        style:
            TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
              letterSpacing: 1.2,
            ).sourceSansProBold,
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildEditableInfoRow(
    String label,
    String value, {
    bool isEditable = true,
    TextEditingController? controller,
    TextInputType? keyboardType,
    IconData? prefixIcon,
    String? errorText,
  }) {
    if (_isEditing && isEditable && controller != null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: CustomInputText(
          controller: controller,
          labelText: label,
          hintText: 'Entrez $label',
          keyboardType: keyboardType,
          prefixIcon: prefixIcon,
          isRequired: true,
          errorText: errorText,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              prefixIcon ?? Icons.info_outline,
              color: AppColors.primary,
              size: 18.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style:
                      TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ).sourceSansProRegular,
                ),
                Text(
                  value,
                  style:
                      TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ).sourceSansProBold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilePreviewCard(
    String label,
    String? fileName,
    String? serverUrl,
  ) {
    if (fileName == null || fileName.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
              size: 18.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              '$label non fourni',
              style:
                  TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                  ).sourceSansProItalic,
            ),
          ],
        ),
      );
    }

    final isPdf = fileName.toLowerCase().endsWith('.pdf');

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.sp),
            decoration: BoxDecoration(
              color:
                  isPdf
                      ? Colors.red.withValues(alpha: 0.1)
                      : Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              isPdf
                  ? Icons.picture_as_pdf_rounded
                  : Icons.insert_drive_file_rounded,
              color: isPdf ? Colors.red[700] : Colors.blue[700],
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style:
                      TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary.withValues(alpha: 0.7),
                        letterSpacing: 0.5,
                      ).sourceSansProSemiBold,
                ),
                Text(
                  fileName.split('/').last,
                  style:
                      TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ).sourceSansProBold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                FilePreviewModal.show(context, url: serverUrl, label: label);
              },
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                padding: EdgeInsets.all(8.sp),
                child: Icon(
                  Icons.visibility_outlined,
                  color: AppColors.primary,
                  size: 22.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilePickerSection(
    String label,
    String? currentFileName,
    Function(File?) onFileSelected, {
    String? serverUrl,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: FilePickerWidget(
        label: label,
        hint: currentFileName ?? 'Sélectionner un fichier',
        onFileSelected: onFileSelected,
        serverUrl: serverUrl,
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, AgencyModel agence) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Supprimer l\'agence ?'),
            content: const Text(
              'Cette action est irréversible. Toutes les données liées à cette agence seront définitivement supprimées.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('ANNULER'),
              ),
              BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  return TextButton(
                    onPressed:
                        state.isDeletingAgency
                            ? null
                            : () {
                              Navigator.pop(dialogContext);
                              context.read<DashboardBloc>().add(
                                DeleteAgencyEvent(agence.codeId!),
                              );
                            },
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child:
                        state.isDeletingAgency
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.red,
                              ),
                            )
                            : const Text('SUPPRIMER'),
                  );
                },
              ),
            ],
          ),
    );
  }
}
