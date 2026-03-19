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
          id: agence.id!,
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
                    'Nom',
                    agence.name ?? 'N/A',
                    controller: _nameController,
                    prefixIcon: Icons.business_outlined,
                    errorText: state.formErrors?['name'],
                  ),
                  _buildEditableInfoRow(
                    'Email',
                    agence.email ?? 'N/A',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    errorText: state.formErrors?['email'],
                  ),
                  _buildEditableInfoRow(
                    'Contact',
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
                    'Adresse Complète',
                    agence.adresse ?? 'N/A',
                    controller: _addressController,
                    prefixIcon: Icons.map_outlined,
                    errorText: state.formErrors?['adresse'],
                  ),
                ]),
                SizedBox(height: 24.h),

                // Documents & Juridique
                _buildSectionTitle('Documents & Juridique'),
                _buildInfoCard([
                  _buildEditableInfoRow(
                    'N° RCCM',
                    agence.rccm ?? 'N/A',
                    controller: _rccmController,
                    prefixIcon: Icons.numbers_outlined,
                    errorText: state.formErrors?['rccm'],
                  ),
                  _buildEditableFileRow(
                    'Fiche RCCM',
                    agence.rccmFile,
                    (file) => setState(() => _newRccmFile = file),
                    serverUrl:
                        agence.rccmFile != null
                            ? Endpoints.storageUrl(agence.rccmFile)
                            : null,
                  ),
                  const Divider(),
                  _buildEditableInfoRow(
                    'N° DFE',
                    agence.dfe ?? 'N/A',
                    controller: _dfeController,
                    prefixIcon: Icons.description_outlined,
                    errorText: state.formErrors?['dfe'],
                  ),
                  _buildEditableFileRow(
                    'Fiche DFE',
                    agence.dfeFile,
                    (file) => setState(() => _newDfeFile = file),
                    serverUrl:
                        agence.dfeFile != null
                            ? Endpoints.storageUrl(agence.dfeFile)
                            : null,
                  ),
                  const Divider(),
                  _buildEditableFileRow(
                    'RIB / Coordonnées Bancaires',
                    agence.rib,
                    (file) => setState(() => _newRibFile = file),
                    serverUrl:
                        agence.rib != null
                            ? Endpoints.storageUrl(agence.rib)
                            : null,
                  ),
                  if (_isEditing) ...[
                    const Divider(),
                    _buildEditableFileRow(
                      'Photo de profil',
                      agence.profileImage,
                      (file) => setState(() => _newProfileImage = file),
                      serverUrl:
                          agence.profileImage != null
                              ? Endpoints.storageUrl(agence.profileImage)
                              : null,
                    ),
                  ],
                ]),
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
          Container(
            width: 100.sp,
            height: 100.sp,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child:
                  (a.profileImage != null && a.profileImage!.isNotEmpty)
                      ? UIHelper.cachedNetworkImage(
                        Endpoints.storageUrl(a.profileImage),
                        height: 100,
                        fit: BoxFit.cover,
                      )
                      : _buildInitialsAvatar(a),
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
                ).sourceSansProRegular,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style:
                TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ).sourceSansProRegular,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style:
                  TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ).sourceSansProSemiBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableFileRow(
    String label,
    String? currentFileName,
    Function(File?) onFileSelected, {
    String? serverUrl,
  }) {
    if (_isEditing) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: FilePickerWidget(
          label: label,
          hint: currentFileName ?? 'Aucun fichier sélectionné',
          onFileSelected: onFileSelected,
          serverUrl: serverUrl,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style:
                TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ).sourceSansProRegular,
          ),
          if (currentFileName != null)
            TextButton.icon(
              onPressed: () {
                FilePreviewModal.show(
                  context,
                  url: Endpoints.storageUrl(currentFileName),
                  label: label,
                );
              },
              icon: Icon(Icons.visibility_outlined, size: 18.sp),
              label: Text(
                'Voir',
                style: TextStyle(fontSize: 13.sp).sourceSansProSemiBold,
              ),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                backgroundColor: AppColors.primary.withValues(alpha: 0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            )
          else
            Text(
              'Non fourni',
              style:
                  TextStyle(
                    fontSize: 14.sp,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[400],
                  ).sourceSansProItalic,
            ),
        ],
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
