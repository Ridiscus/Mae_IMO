import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/presentation/agent/pages/property_inspection_form_page.dart';
import 'package:maelys_imo/shared/widgets/index.dart';

import '../../../core/manager/state/inventories/inventories_bloc.dart';

class TenantValidationPage extends StatefulWidget {
  static const routeName = 'tenantValidation';
  static const routePath = '/tenant-validation/:id';

  final String propertyId;

  const TenantValidationPage({super.key, required this.propertyId});

  @override
  State<TenantValidationPage> createState() => _TenantValidationPageState();
}

class _TenantValidationPageState extends State<TenantValidationPage> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  // Fonction unique pour vérifier un code (QR ou OTP manuel)
  void _verifyCode(BuildContext context, String code) {
    // On récupère l'ID du locataire stocké dans le state du Bloc (chargé à la page précédente)
    final locataireId = context.read<InventoriesBloc>().state.inventoryDetail?.locataire?.id;

    if (locataireId != null && code.isNotEmpty) {
      // On lance l'événement de vérification existant
      context.read<InventoriesBloc>().add(
        VerifyCodeEtatLieuxEvent(
          locataireId: locataireId,
          verificationCode: code,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible de récupérer les infos du locataire ou code vide.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // BlocConsumer permet d'écouter les changements (Listener) ET de reconstruire l'UI (Builder)
    return BlocConsumer<InventoriesBloc, InventoriesState>(
      listener: (context, state) {
        // SUCCÈS : Si le code est vérifié, on passe au formulaire
        if (state.codeVerified == true) {
          context.pushReplacementNamed(
            PropertyInspectionFormPage.routeName,
            pathParameters: {'id': widget.propertyId},
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.isLoading ?? false;

        return PageWithHeaderLayout(
          // Header avec bouton retour et titre
          headerContent: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 10.sp),
            child: Row(
              children: [
                InkWell(
                  onTap: () => context.pop(),
                  child: Container(
                    padding: EdgeInsets.all(8.sp),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                ),
                SizedBox(width: 16.sp),
                Text(
                  "Validation Locataire",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ), // .sourceSansProBold si disponible
                ),
              ],
            ),
          ),

          // Corps de la page
          bodyContent: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 24.sp),
            child: Column(

              children: [
                Text(
                  "Veuillez scanner le QR Code du locataire pour confirmer sa présence.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 24.sp),

                // 1. LE SCANNER
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: QrCodeViewer(
                      height: 300.h,
                      width: double.infinity,
                      onQrCodeScanned: (code) {
                        // Dès qu'on scanne, on lance la vérif
                        _verifyCode(context, code);
                      },
                    ),
                  ),
                ),

                SizedBox(height: 32.sp),

                // SEPARATEUR "OU"
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.sp),
                      child: Text(
                        "OU",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),

                SizedBox(height: 32.sp),

                // 2. LE CHAMP OTP
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Entrez le code de validation",
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8.sp),

                CustomInputText(
                  controller: _otpController,
                  hintText: "Ex: 1234",
                  keyboardType: TextInputType.text,
                ),

                SizedBox(height: 24.sp),

                CustomButton(
                  text: "Valider le code",
                  isLoading: isLoading, // Affiche le chargement sur le bouton
                  onPressed: () {
                    // Vérification manuelle
                    _verifyCode(context, _otpController.text);
                  },
                  buttonVariant: ButtonVariant.primary,
                ),

                SizedBox(height: 20.sp),
              ],
            ),
          ),
        );
      },
    );
  }
}