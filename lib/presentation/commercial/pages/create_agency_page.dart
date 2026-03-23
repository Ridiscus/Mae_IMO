import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/manager/state/dashboard/dashboard_bloc.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import '../widgets/file_picker_widget.dart';
import '../widgets/file_preview_modal.dart';
import '../widgets/success_modal.dart';

class CreateAgencyPage extends StatefulWidget {
  static const routeName = 'createAgency';
  static const routePath = '/commercial/create-agency';
  const CreateAgencyPage({super.key});
  @override
  State<CreateAgencyPage> createState() => _CreateAgencyPageState();
}

class _CreateAgencyPageState extends State<CreateAgencyPage> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _communeController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController();
  final _rccmNumberController = TextEditingController();
  final _dfeNumberController = TextEditingController();

  // Fichiers
  File? _profileImage;
  File? _ribFile;
  File? _rccmFile;
  File? _dfeFile;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _communeController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    _rccmNumberController.dispose();
    _dfeNumberController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<DashboardBloc>().add(
        CreateAgencyEvent(
          name: _nameController.text,
          email: _emailController.text,
          contact: _contactController.text,
          commune: _communeController.text,
          adresse: _addressController.text,
          rccm: _rccmNumberController.text,
          dfe: _dfeNumberController.text,
          rib: _ribFile,
          rccmFile: _rccmFile,
          dfeFile: _dfeFile,
          profileImage: _profileImage,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state.agencyCreated) {
          SuccessModal.show(
            context: context,
            title: 'Agence Créée',
            message:
                'L\'agence ${_nameController.text} a été créée avec succès.',
            buttonText: 'REVENIR À LA LISTE',
            onConfirm: () {
              context.pop();
              context.pop(); // Returns back to agencies list
            },
          );
        }
      },
      builder: (context, state) {
        return FormWithHeaderLayout(
          headerTitle: 'Créer une Agence',
          padding: EdgeInsets.zero,
          content: Padding(
            padding: EdgeInsets.all(20.sp),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_profileImage != null) {
                              FilePreviewModal.show(
                                context,
                                file: _profileImage!,
                                label: 'Image de profil',
                              );
                            } else {
                              // Trigger pick file if empty
                              // Since FilePickerWidget is below, maybe we just do nothing or show hint
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
                                  (_profileImage != null)
                                      ? Image.file(
                                        _profileImage!,
                                        fit: BoxFit.cover,
                                      )
                                      : Center(
                                        child: Icon(
                                          Icons.business_outlined,
                                          size: 40.sp,
                                          color: AppColors.primary,
                                        ),
                                      ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Logo / Image de l\'agence',
                          style:
                              TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey[600],
                              ).sourceSansProRegular,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),

                  CustomInputText(
                    controller: _nameController,
                    labelText: 'Nom de l\'agence',
                    hintText: 'Ex: Maelys Immo Sud',
                    isRequired: true,
                    prefixIcon: Icons.business_outlined,
                    errorText: state.formErrors?['name'],
                  ),
                  CustomSpacer(),
                  CustomInputText(
                    controller: _emailController,
                    labelText: 'Email',
                    hintText: 'agence@exemple.com',
                    isRequired: true,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    errorText: state.formErrors?['email'],
                  ),
                  CustomSpacer(),
                  CustomInputText(
                    controller: _communeController,
                    labelText: 'Commune',
                    hintText: 'Ex: Cocody',
                    isRequired: true,
                    prefixIcon: Icons.location_on_outlined,
                    errorText: state.formErrors?['commune'],
                  ),
                  CustomSpacer(),
                  CustomInputText(
                    controller: _contactController,
                    labelText: 'Contact',
                    hintText: '05XXXXXXXX',
                    isRequired: true,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone_outlined,
                    errorText: state.formErrors?['contact'],
                  ),
                  CustomSpacer(),
                  CustomInputText(
                    controller: _addressController,
                    labelText: 'Adresse',
                    hintText: 'Ex: Riviera 3, Rue de la Paix',
                    isRequired: true,
                    prefixIcon: Icons.map_outlined,
                    errorText: state.formErrors?['adresse'],
                  ),
                  SizedBox(height: 24.h),

                  SizedBox(height: 24.h),

                  // Photos
                  FilePickerWidget(
                    label: 'Image de profil (Optionnel)',
                    hint: 'Sélectionner le logo ou l\'image de l\'agence',
                    onFileSelected:
                        (file) => setState(() => _profileImage = file),
                    errorText: state.formErrors?['profile_image'],
                  ),
                  CustomSpacer(),

                  // RIB
                  FilePickerWidget(
                    label: 'RIB (Pièce jointe)',
                    hint: 'Sélectionner le relevé d\'identité bancaire',
                    onFileSelected: (file) => setState(() => _ribFile = file),
                    errorText: state.formErrors?['rib'],
                  ),
                  CustomSpacer(),

                  // RCCM
                  CustomInputText(
                    controller: _rccmNumberController,
                    labelText: 'N° RCCM',
                    hintText: 'Ex: CI-ABJ-03-2023-B12-XXXX',
                    isRequired: true,
                    prefixIcon: Icons.numbers_outlined,
                    errorText: state.formErrors?['rccm'],
                  ),
                  SizedBox(height: 12.h),
                  FilePickerWidget(
                    label: 'Fiche RCCM (Pièce jointe)',
                    hint: 'Sélectionner la fiche RCCM',
                    isRequired: true,
                    onFileSelected: (file) => setState(() => _rccmFile = file),
                    errorText: state.formErrors?['rccm_file'],
                  ),
                  CustomSpacer(),

                  // DFE
                  CustomInputText(
                    controller: _dfeNumberController,
                    labelText: 'N° DFE',
                    hintText: 'Ex: XXXXXXXXXA',
                    isRequired: true,
                    prefixIcon: Icons.description_outlined,
                    errorText: state.formErrors?['dfe'],
                  ),
                  SizedBox(height: 12.h),
                  FilePickerWidget(
                    label: 'Fiche DFE (Pièce jointe)',
                    hint: 'Sélectionner la fiche DFE',
                    isRequired: true,
                    onFileSelected: (file) => setState(() => _dfeFile = file),
                    errorText: state.formErrors?['dfe_file'],
                  ),

                  SizedBox(height: 40.h),
                  CustomButton(
                    text: 'CRÉER L\'AGENCE',
                    onPressed: state.isCreatingAgency ? () {} : _submit,
                    isLoading: state.isCreatingAgency,
                    width: double.infinity,
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
