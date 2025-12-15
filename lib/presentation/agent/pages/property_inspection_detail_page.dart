import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/presentation/agent/pages/property_inspection_form_page.dart';
import 'package:maelys_imo/presentation/agent/pages/tenant_validation_page.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/domain/models/index.dart';
import '../../../core/manager/state/inventories/inventories_bloc.dart';

class PropertyInspectionDetailPage extends StatefulWidget {
  static const routeName = 'propertyInspectionDetail';
  static const routePath = '/property-inspection-detail/:id';

  final String propertyId;

  const PropertyInspectionDetailPage({super.key, required this.propertyId});

  @override
  State<PropertyInspectionDetailPage> createState() =>
      _PropertyInspectionDetailPageState();
}

class _PropertyInspectionDetailPageState
    extends State<PropertyInspectionDetailPage> {
  // Sample property data - to be replaced with API data
  EstateModel? _propertyData;
  TenantModel? _tenant;

  bool _isLoading = false;
  late InventoriesState _inventoriesState;

  @override
  void initState() {
    context.read<InventoriesBloc>().add(
      FetchOneInventoriesEvent(id: widget.propertyId),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _inventoriesState = context.select((InventoriesBloc bloc) => bloc.state);
    _propertyData = _inventoriesState.inventoryDetail?.bien;
    _tenant = _inventoriesState.inventoryDetail?.locataire;
    _isLoading = _inventoriesState.isLoading ?? false;

    return BlocListener<InventoriesBloc, InventoriesState>(
      listener: (context, state) {
        // 1. Gestion existante du chargement des détails
        if (state.isLoading == false && state.inventoryDetail == null && state.failure == null) {
          context.pop();
        }

        // 2. NOUVEAU : Redirection si le code a été généré avec succès
        // On vérifie "codeGenerated == true" (variable existante dans ton State)
        if (state.codeGenerated == true) {
          // IMPORTANT : On remet le codeGenerated à null ou on s'assure de ne pas boucler
          // Mais comme le bloc le remet à null au début de l'event, c'est bon.

          context.pushNamed(
            TenantValidationPage.routeName,
            pathParameters: {'id': widget.propertyId},
          );
        }
      },
      child: FormWithHeaderLayout(
        headerTitle: 'Détails de l\'état des lieux',
        contentColor: AppColors.scaffold,
        content: Skeletonizer(
          enabled: _isLoading,
          child: _buildDetailContent(),
        ),
      ),
    );
  }

  Widget _buildDetailContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPropertyInfoCard(),
        CustomSpacer(),
        _buildTenantInfoCard(),
        Spacer(),
        _buildStartInspectionButton(context),
        SpacerPlatform(),
      ],
    );
  }

  Widget _buildPropertyInfoCard() {
    return _buildInfoCard(
      title: 'Données du bien',
      child: Column(
        children: [
          _buildInfoRow(
            Icons.location_on_outlined,
            'Adresse: ${_propertyData?.title}',
          ),
          SizedBox(height: 16.sp),
          _buildInfoRow(Icons.house_outlined, 'Type: ${_propertyData?.type}'),
        ],
      ),
    );
  }

  Widget _buildTenantInfoCard() {
    return _buildInfoCard(
      title: 'Données du locataire',
      child: Column(
        children: [
          _buildInfoRow(
            Icons.person_outline,
            'Nom: ${_tenant?.fullName ?? ''}',
          ),
          SizedBox(height: 16.sp),
          _buildInfoRow(
            Icons.pending_actions_outlined,
            'Statut: ${_tenant?.status ?? ''}',
            textColor: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required Widget child}) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
                TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ).sourceSansProBold,
          ),
          CustomSpacer(space: .5),
          Container(
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String text, {
    Color? textColor,
    FontWeight? fontWeight,
  }) {
    return Row(
      children: [
        Icon(icon, size: 24.sp, color: textColor ?? Colors.black87),
        SizedBox(width: 16.sp),
        Expanded(
          child: Text(
            text,
            style:
                TextStyle(
                  fontSize: 16.sp,
                  color: textColor ?? Colors.black87,
                  fontWeight: fontWeight ?? FontWeight.normal,
                ).sourceSansProRegular,
          ),
        ),
      ],
    );
  }








  Widget _buildStartInspectionButton(BuildContext context) {
    // On récupère l'état pour savoir si ça charge (pour le spinner sur le bouton)
    final isLoading = context.select((InventoriesBloc bloc) => bloc.state.isLoading ?? false);

    return CustomButton(
      text: 'Démarrer l\'état des lieux',
      isLoading: isLoading, // Affiche le chargement sur le bouton
      onPressed: () {
        // On vérifie qu'on a bien les infos du locataire
        if (_tenant?.id != null) {
          // ON UTILISE L'EVENT EXISTANT DU BLOC
          context.read<InventoriesBloc>().add(
            GenerateCodeEtatLieuxEvent(locataireId: _tenant!.id!),
          );
        } else {
          // Sécurité si pas de locataire
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Impossible de trouver l'ID du locataire"))
          );
        }
      },
      showArrow: true,
      buttonVariant: ButtonVariant.primary,
    );
  }


}
