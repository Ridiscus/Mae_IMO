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

class CreateOwnerPage extends StatefulWidget {
  static const routeName = 'createOwner';
  static const routePath = '/commercial/create-owner';

  const CreateOwnerPage({super.key});

  @override
  State<CreateOwnerPage> createState() => _CreateOwnerPageState();
}

class _CreateOwnerPageState extends State<CreateOwnerPage> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs
  final _nameController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _communeController = TextEditingController();
  final _adresseController = TextEditingController();

  // Fichiers
  File? _profileImage;
  File? _cniFile;

  @override
  void dispose() {
    _nameController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _communeController.dispose();
    _adresseController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<DashboardBloc>().add(
        CreateOwnerEvent(
          name: _nameController.text,
          prenom: _prenomController.text,
          email: _emailController.text,
          contact: _contactController.text,
          commune: _communeController.text,
          adresse: _adresseController.text,
          profileImage: _profileImage,
          cniFile: _cniFile,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state.ownerCreated) {
          SuccessModal.show(
            context: context,
            title: 'Propriétaire Créé',
            message:
                'Le propriétaire ${_nameController.text} ${_prenomController.text} a été créé avec succès.',
            buttonText: 'REVENIR À LA LISTE',
            onConfirm: () {
              context.pop();
            },
          );
        }
      },
      builder: (context, state) {
        return FormWithHeaderLayout(
          headerTitle: 'Nouveau Propriétaire',
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
                                label: 'Photo de profil',
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
                                  (_profileImage != null)
                                      ? Image.file(
                                        _profileImage!,
                                        fit: BoxFit.cover,
                                      )
                                      : Center(
                                        child: Icon(
                                          Icons.person_outline,
                                          size: 40.sp,
                                          color: AppColors.primary,
                                        ),
                                      ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Photo de profil',
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
                    labelText: 'Nom',
                    hintText: 'Ex: Aboua',
                    isRequired: true,
                    prefixIcon: Icons.person_outline,
                    errorText: state.formErrors?['name'],
                  ),
                  CustomSpacer(),
                  CustomInputText(
                    controller: _prenomController,
                    labelText: 'Prénom',
                    hintText: 'Ex: Duval',
                    isRequired: true,
                    prefixIcon: Icons.person_outline,
                    errorText: state.formErrors?['prenom'],
                  ),
                  CustomSpacer(),
                  CustomInputText(
                    controller: _emailController,
                    labelText: 'Email',
                    hintText: 'Ex: ariellaarchelle@gmail.com',
                    isRequired: true,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    errorText: state.formErrors?['email'],
                  ),
                  CustomSpacer(),
                  CustomInputText(
                    controller: _contactController,
                    labelText: 'Contact',
                    hintText: 'Ex: 07XXXXXXXX',
                    isRequired: true,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone_outlined,
                    errorText: state.formErrors?['contact'],
                  ),
                  CustomSpacer(),
                  CustomInputText(
                    controller: _communeController,
                    labelText: 'Commune',
                    hintText: 'Ex: Abobo',
                    isRequired: true,
                    prefixIcon: Icons.location_on_outlined,
                    errorText: state.formErrors?['commune'],
                  ),
                  CustomSpacer(),
                  CustomInputText(
                    controller: _adresseController,
                    labelText: 'Adresse',
                    hintText: 'Ex: Marcory',
                    isRequired: true,
                    prefixIcon: Icons.map_outlined,
                    errorText: state.formErrors?['adresse'],
                  ),
                  SizedBox(height: 24.h),

                  // Photo de profil
                  FilePickerWidget(
                    label: 'Photo de profil (Optionnel)',
                    hint: 'Sélectionner une photo',
                    onFileSelected:
                        (file) => setState(() => _profileImage = file),
                    errorText: state.formErrors?['profil_image'],
                  ),
                  CustomSpacer(),

                  // CNI
                  FilePickerWidget(
                    label: 'Pièce d\'identité (CNI)',
                    hint: 'Sélectionner le fichier CNI',
                    onFileSelected: (file) => setState(() => _cniFile = file),
                    errorText: state.formErrors?['cni'],
                  ),

                  SizedBox(height: 48.h),
                  CustomButton(
                    text: 'ENREGISTRER LE PROPRIÉTAIRE',
                    onPressed: state.isCreatingOwner ? () {} : _submit,
                    isLoading: state.isCreatingOwner,
                    width: double.infinity,
                  ),
                  SizedBox(height: 35.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
