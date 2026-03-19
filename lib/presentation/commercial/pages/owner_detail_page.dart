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

class OwnerDetailPage extends StatefulWidget {
  static const routeName = 'ownerDetail';
  static const routePath = '/commercial/owner-detail';
  final OwnerModel owner;

  const OwnerDetailPage({super.key, required this.owner});

  @override
  State<OwnerDetailPage> createState() => _OwnerDetailPageState();
}

class _OwnerDetailPageState extends State<OwnerDetailPage> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour l'édition
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _residenceController;
  late TextEditingController _contactController;
  late TextEditingController
  _addressController; // Missing in previous simulated version but maybe needed
  bool _controllersInitialized = false;

  // Fichiers pour l'édition
  File? _newRibFile;
  File? _newIdentityFile;
  File? _newProfileImage;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData([OwnerModel? owner]) {
    final o = owner ?? widget.owner;
    if (!_controllersInitialized) {
      _firstNameController = TextEditingController(text: o.firstName);
      _lastNameController = TextEditingController(text: o.lastName);
      _emailController = TextEditingController(text: o.email);
      _residenceController = TextEditingController(text: o.residence);
      _contactController = TextEditingController(text: o.contact);
      _addressController = TextEditingController(
        text: o.residence,
      ); // Using residence as address placeholder if needed
      _controllersInitialized = true;
    } else {
      _firstNameController.text = o.firstName ?? '';
      _lastNameController.text = o.lastName ?? '';
      _emailController.text = o.email ?? '';
      _residenceController.text = o.residence ?? '';
      _contactController.text = o.contact ?? '';
      _addressController.text = o.residence ?? '';
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _residenceController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _toggleEdit(OwnerModel o) {
    setState(() {
      _isEditing = !_isEditing;
      _initData(o);
      if (!_isEditing) {
        _newRibFile = null;
        _newIdentityFile = null;
        _newProfileImage = null;
      }
    });
  }

  void _saveChanges(OwnerModel o) {
    if (_formKey.currentState!.validate()) {
      context.read<DashboardBloc>().add(
        UpdateOwnerEvent(
          id: o.codeId!,
          name: _lastNameController.text,
          prenom: _firstNameController.text,
          email: _emailController.text,
          contact: _contactController.text,
          commune: _residenceController.text,
          adresse: _addressController.text, // Backend might expect address
          profileImage: _newProfileImage,
          cniFile: _newIdentityFile,
          ribFile: _newRibFile,
        ),
      );
    }
  }

  void _showDeleteDialog(OwnerModel o) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Supprimer ce propriétaire ?'),
            content: const Text(
              'Cette action est irréversible. Toutes les données liées à ce propriétaire (dont ses biens et contrats) seront définitivement supprimées.',
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
                        state.isDeletingOwner
                            ? null
                            : () {
                              Navigator.pop(dialogContext);
                              context.read<DashboardBloc>().add(
                                DeleteOwnerEvent(o.codeId!),
                              );
                            },
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child:
                        state.isDeletingOwner
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state.ownerUpdated) {
          setState(() => _isEditing = false);
          SuccessModal.show(
            context: context,
            title: 'Modification Réussie !',
            message:
                'Les informations du propriétaire ont été mises à jour avec succès.',
            buttonText: 'OK, J\'AI COMPRIS',
          );
        }
        if (state.ownerDeleted) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final o =
            state.owners?.firstWhere(
              (element) => element.id == widget.owner.id,
              orElse: () => widget.owner,
            ) ??
            widget.owner;

        return PageWithHeaderLayout(
          headerHeight: MediaQuery.of(context).size.height * 0.20,
          headerContent: Column(
            children: [
              Row(
                children: [
                  const CircularBackButton(),
                  SizedBox(width: 8.w),
                  Text(
                    _isEditing
                        ? 'Modifier Propriétaire'
                        : 'Détails Propriétaire',
                    style:
                        TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ).sourceSansProBold,
                  ),
                  const Spacer(),
                  if (!_isEditing) ...[
                    _buildHeaderAction(
                      icon: Icons.edit_outlined,
                      onTap: () => _toggleEdit(o),
                    ),
                    SizedBox(width: 8.w),
                    _buildHeaderAction(
                      icon: Icons.delete_outline,
                      color: Colors.red[300],
                      onTap: () => _showDeleteDialog(o),
                    ),
                  ] else ...[
                    _buildHeaderAction(
                      icon: Icons.close,
                      onTap: () => _toggleEdit(o),
                    ),
                    SizedBox(width: 8.w),
                    _buildHeaderAction(
                      icon:
                          state.isUpdatingOwner
                              ? Icons.hourglass_empty
                              : Icons.check,
                      color: AppColors.success,
                      onTap:
                          state.isUpdatingOwner ? null : () => _saveChanges(o),
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
                _buildProfileHeader(o),
                SizedBox(height: 24.h),

                _buildSectionTitle('Informations Générales'),
                _buildInfoCard([
                  _buildEditableInfoRow(
                    'Identifiant',
                    o.codeId ?? 'N/A',
                    isEditable: false,
                    prefixIcon: Icons.badge_outlined,
                  ),
                  _buildEditableInfoRow(
                    'Nom de famille',
                    o.lastName ?? 'N/A',
                    controller: _lastNameController,
                    prefixIcon: Icons.person_outline,
                    errorText: state.formErrors?['name'],
                  ),
                  _buildEditableInfoRow(
                    'Prénoms',
                    o.firstName ?? 'N/A',
                    controller: _firstNameController,
                    prefixIcon: Icons.person_outline,
                    errorText: state.formErrors?['prenom'],
                  ),
                  _buildEditableInfoRow(
                    'Email',
                    o.email ?? 'N/A',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    errorText: state.formErrors?['email'],
                  ),
                  _buildEditableInfoRow(
                    'Contact',
                    o.contact ?? 'N/A',
                    controller: _contactController,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone_outlined,
                    errorText: state.formErrors?['contact'],
                  ),
                ]),
                SizedBox(height: 24.h),

                _buildSectionTitle('Localisation'),
                _buildInfoCard([
                  _buildEditableInfoRow(
                    'Lieu de résidence',
                    o.residence ?? 'N/A',
                    controller: _residenceController,
                    prefixIcon: Icons.location_on_outlined,
                    errorText:
                        state.formErrors?['commune'] ??
                        state.formErrors?['adresse'],
                  ),
                ]),
                SizedBox(height: 24.h),

                _buildSectionTitle('Documents & Gestion'),
                _buildInfoCard([
                  _buildEditableFileRow(
                    'Pièce d\'identité (CNI/Passeport)',
                    o.identityFile,
                    (file) => setState(() => _newIdentityFile = file),
                    serverUrl:
                        o.identityFile != null
                            ? Endpoints.storageUrl(o.identityFile)
                            : null,
                  ),
                  const Divider(),
                  _buildEditableFileRow(
                    'RIB / Coordonnées Bancaires',
                    o.ribFile,
                    (file) => setState(() => _newRibFile = file),
                    serverUrl:
                        o.ribFile != null
                            ? Endpoints.storageUrl(o.ribFile)
                            : null,
                  ),
                  if (_isEditing) ...[
                    const Divider(),
                    _buildEditableFileRow(
                      'Photo de profil',
                      o.profilImage,
                      (file) => setState(() => _newProfileImage = file),
                      serverUrl:
                          o.profilImage != null
                              ? Endpoints.storageUrl(o.profilImage)
                              : null,
                    ),
                  ],
                  const Divider(),
                  _buildInfoRow(
                    'Mode de Gestion',
                    o.hasManagementAgents
                        ? 'Gestion par agence(s)'
                        : 'Gestion directe propriétaire',
                    prefixIcon: Icons.gavel_outlined,
                  ),
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

  Widget _buildProfileHeader(OwnerModel o) {
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
                  (o.profilImage != null && o.profilImage!.isNotEmpty)
                      ? UIHelper.cachedNetworkImage(
                        Endpoints.storageUrl(o.profilImage),
                        height: 100,
                        fit: BoxFit.cover,
                      )
                      : _buildInitialsAvatar(o),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            _isEditing
                ? "${_lastNameController.text} ${_firstNameController.text}"
                : o.fullName,
            style:
                TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ).sourceSansProBold,
          ),
          Text(
            _isEditing ? _emailController.text : (o.email ?? ''),
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

  Widget _buildInitialsAvatar(OwnerModel o) {
    return Center(
      child: Text(
        (o.lastName != null && o.lastName!.isNotEmpty)
            ? o.lastName!.substring(0, 1).toUpperCase()
            : 'P',
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

  Widget _buildInfoRow(String label, String value, {IconData? prefixIcon}) {
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
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style:
                  TextStyle(
                    fontSize: 13.sp,
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
          Expanded(
            child: Text(
              label,
              style:
                  TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ).sourceSansProRegular,
              overflow: TextOverflow.ellipsis,
            ),
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
}
