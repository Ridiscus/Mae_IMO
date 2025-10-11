import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/domain/models/index.dart';
import 'package:maelys_imo/core/domain/requests/index.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/core/utils/toast/notification_toast.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:maelys_imo/shared/widgets/modals/index.dart';
import 'package:toastification/toastification.dart';

import '../../../core/manager/state/inventories/inventories_bloc.dart';

class PropertyInspectionFormPage extends StatefulWidget {
  static const routeName = 'propertyInspectionForm';
  static const routePath = '/property-inspection-form/:id';

  final String propertyId;

  const PropertyInspectionFormPage({super.key, required this.propertyId});

  @override
  State<PropertyInspectionFormPage> createState() =>
      _PropertyInspectionFormPageState();
}

class _PropertyInspectionFormPageState
    extends State<PropertyInspectionFormPage> {
  // Controllers for parties communes
  final Map<String, bool?> _partiesCommunesStatus = {};
  final Map<String, TextEditingController> _partiesCommunesComments = {};

  // Controllers for chambres
  final Map<String, Map<String, bool?>> _chambresStatus = {};
  final Map<String, Map<String, TextEditingController>> _chambresComments = {};

  TenantModel? _tenant;
  EstateModel? _propertyData;
  EstateLocationModel? _estateLocation;

  @override
  void dispose() {
    // // Dispose all controllers
    // for (var controller in _partiesCommunesComments.values) {
    //   controller.dispose();
    // }
    // for (var map in _chambresComments.values) {
    //   for (var controller in map.values) {
    //     controller.dispose();
    //   }
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InventoriesBloc, InventoriesState>(
      listener: (context, state) {
        // Handle code generated successfully
        if (state.codeGenerated == true) {
          _showVerificationCodeModal(context);
        }

        // Handle estate location saved successfully (only navigate on success)
        if (state.estateLocationSaved == true) {
          context.pop();
        }

        // Don't auto-navigate on errors - let user manually go back to preserve data
      },
      builder: (context, state) {
        _propertyData = state.inventoryDetail?.bien;
        _tenant = state.inventoryDetail?.locataire;
        _estateLocation = state.inventoryDetail?.etatsLieu?.etatEntree;

        return PageWithHeaderLayout(
          headerContent: _buildHeaderContent(),
          bodyContent: _buildInspectionForm(),
        );
      },
    );
  }

  Widget _buildHeaderContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircularBackButton(),
        CustomSpacer(),
        Text(
          'État des lieux',
          style:
              TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ).sourceSansProBold,
        ),
      ],
    );
  }

  Widget _buildInspectionForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPropertySummary(),
        CustomSpacer(space: 2),
        _buildRoomsList(),
        CustomSpacer(),
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildPropertySummary() {
    // Sample property data - replace with actual data
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _propertyData?.title ?? "",
          style:
              TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ).sourceSansProBold,
        ),
        SizedBox(height: 8.sp),
        _buildSummaryItem(
          icon: Icons.home_outlined,
          label: 'Type: ${_propertyData?.type ?? ''}',
        ),
        SizedBox(height: 8.sp),
        _buildSummaryItem(
          icon: Icons.location_on_outlined,
          label: 'Adresse: ${_propertyData?.commune ?? ''}',
        ),
        SizedBox(height: 8.sp),
        _buildSummaryItem(
          icon: Icons.person_outline,
          label: 'Locataire: ${_tenant?.fullName ?? ''}',
        ),
      ],
    );
  }

  Widget _buildSummaryItem({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(icon, size: 24.sp, color: Colors.black87),
        SizedBox(width: 12.sp),
        Text(
          label,
          style:
              TextStyle(
                fontSize: 16.sp,
                color: Colors.black87,
              ).sourceSansProRegular,
        ),
      ],
    );
  }

  // Extrait dynamiquement les champs des parties communes depuis le modèle
  List<Map<String, String>> get _partiesCommunesFields {
    final partiesCommunes = _estateLocation?.partiesCommunesModel;
    if (partiesCommunes == null) return [];

    final fields = <Map<String, String>>[];
    final modelMap = partiesCommunes.toMap();

    // Parcourir les clés du modèle et exclure les observations
    modelMap.forEach((key, value) {
      if (!key.startsWith('observation_')) {
        // Convertir la clé snake_case en label lisible
        final label = _formatLabel(key);
        fields.add({'key': key, 'label': label});
      }
    });

    return fields;
  }

  // Convertit une clé snake_case en label lisible
  String _formatLabel(String key) {
    final labels = {
      'sol': 'Sol',
      'murs': 'Murs',
      'plafond': 'Plafond',
      'douche': 'Douche',
      'lavabo': 'Lavabo',
      'robinet': 'Robinet',
      'porte_entre': 'Porte d\'entrée',
      'interrupteur': 'Interrupteur',
    };

    return labels[key] ??
        key
            .replaceAll('_', ' ')
            .split(' ')
            .map(
              (word) =>
                  word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1),
            )
            .join(' ');
  }

  Widget _buildRoomsList() {
    final partiesCommunes = _estateLocation?.partiesCommunesModel;
    final chambres = _estateLocation?.chambreModels ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Parties Communes Section
        if (partiesCommunes != null) ...[
          Text(
            'Parties Communes',
            style:
                TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ).sourceSansProBold,
          ),
          SizedBox(height: 16.sp),
          ..._partiesCommunesFields.map(
            (field) =>
                _buildPartiesCommunesItem(field['label']!, field['key']!),
          ),
          SizedBox(height: 24.sp),
        ],

        // Chambres Section
        if (chambres.isNotEmpty) ...[
          Text(
            'Chambres',
            style:
                TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ).sourceSansProBold,
          ),
          SizedBox(height: 16.sp),
          ...chambres.map((chambre) => _buildChambreSection(chambre)),
        ],
      ],
    );
  }

  Widget _buildPartiesCommunesItem(String label, String key) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.sp),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style:
                TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ).sourceSansProSemiBold,
          ),
          SizedBox(height: 12.sp),
          Row(
            children: [
              Expanded(
                child: _buildStatusButton(
                  label: 'Bon état',
                  isSelected: _partiesCommunesStatus[key] == true,
                  color: AppColors.success,
                  onTap: () {
                    setState(() {
                      _partiesCommunesStatus[key] = true;
                    });
                  },
                ),
              ),
              SizedBox(width: 12.sp),
              Expanded(
                child: _buildStatusButton(
                  label: 'Mauvais état',
                  isSelected: _partiesCommunesStatus[key] == false,
                  color: AppColors.redColor,
                  onTap: () {
                    setState(() {
                      _partiesCommunesStatus[key] = false;
                      // Initialize comment controller if not exists
                      if (!_partiesCommunesComments.containsKey(key)) {
                        _partiesCommunesComments[key] = TextEditingController();
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          // Show comment field if status is bad
          if (_partiesCommunesStatus[key] == false) ...[
            SizedBox(height: 12.sp),
            CustomInputTextFactory.createTextAreaInput(
              controller: _partiesCommunesComments[key]!,
              hintText: 'Commentaire sur l\'état...',
                textInputAction: TextInputAction.done
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChambreSection(ChambreModel chambre) {
    final chambreKey = chambre.nom ?? 'Chambre';

    // Initialize status map for this chambre if not exists
    if (!_chambresStatus.containsKey(chambreKey)) {
      _chambresStatus[chambreKey] = {};
      _chambresComments[chambreKey] = {};
    }

    return Container(
      margin: EdgeInsets.only(bottom: 24.sp),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            chambreKey,
            style:
                TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ).sourceSansProBold,
          ),
          SizedBox(height: 16.sp),
          _buildChambreElementItem(chambreKey, 'Sol', 'sol'),
          _buildChambreElementItem(chambreKey, 'Murs', 'murs'),
          _buildChambreElementItem(chambreKey, 'Plafond', 'plafond'),
        ],
      ),
    );
  }

  Widget _buildChambreElementItem(
    String chambreKey,
    String label,
    String elementKey,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.sp),
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style:
                TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ).sourceSansProSemiBold,
          ),
          SizedBox(height: 8.sp),
          Row(
            children: [
              Expanded(
                child: _buildStatusButton(
                  label: 'Bon état',
                  isSelected: _chambresStatus[chambreKey]?[elementKey] == true,
                  color: AppColors.success,
                  onTap: () {
                    setState(() {
                      _chambresStatus[chambreKey]![elementKey] = true;
                    });
                  },
                ),
              ),
              SizedBox(width: 12.sp),
              Expanded(
                child: _buildStatusButton(
                  label: 'Mauvais état',
                  isSelected: _chambresStatus[chambreKey]?[elementKey] == false,
                  color: AppColors.redColor,
                  onTap: () {
                    setState(() {
                      _chambresStatus[chambreKey]![elementKey] = false;
                      // Initialize comment controller if not exists
                      if (!_chambresComments[chambreKey]!.containsKey(
                        elementKey,
                      )) {
                        _chambresComments[chambreKey]![elementKey] =
                            TextEditingController();
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          // Show comment field if status is bad
          if (_chambresStatus[chambreKey]?[elementKey] == false) ...[
            SizedBox(height: 8.sp),
            CustomInputTextFactory.createTextAreaInput(
              controller: _chambresComments[chambreKey]![elementKey]!,
              hintText: 'Commentaire sur l\'état...',
              textInputAction: TextInputAction.done
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusButton({
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.sp),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? color.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
          border: Border.all(
            color: isSelected ? color : Colors.grey.withOpacity(0.3),
            width: 1.sp,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Text(
            label,
            style:
                TextStyle(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? color : Colors.grey.shade700,
                ).sourceSansProSemiBold,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return CustomButton(
      text: 'Enregistrer cet état',
      onPressed: _validateAndSave,
      showArrow: true,
      iconData: Icons.save,
    );
  }

  bool _isFormValid() {
    // Check if all parties communes have a status selected (dynamically)
    for (var field in _partiesCommunesFields) {
      final key = field['key']!;
      if (_partiesCommunesStatus[key] == null) {
        return false;
      }
      // Check if comment is required for bad status
      if (_partiesCommunesStatus[key] == false) {
        if (!_partiesCommunesComments.containsKey(key) ||
            _partiesCommunesComments[key]!.text.trim().isEmpty) {
          return false;
        }
      }
    }

    // Check if all chambres elements have a status selected
    final chambres = _estateLocation?.chambreModels ?? [];
    for (var chambre in chambres) {
      final chambreKey = chambre.nom ?? 'Chambre';
      final elementKeys = ['sol', 'murs', 'plafond'];

      for (var elementKey in elementKeys) {
        if (_chambresStatus[chambreKey]?[elementKey] == null) {
          return false;
        }
        // Check if comment is required for bad status
        if (_chambresStatus[chambreKey]?[elementKey] == false) {
          if (!_chambresComments[chambreKey]!.containsKey(elementKey) ||
              _chambresComments[chambreKey]![elementKey]!.text.trim().isEmpty) {
            return false;
          }
        }
      }
    }

    return true;
  }

  void _validateAndSave() {
    if (!_isFormValid()) {
      showToast(
        msg:
            'Veuillez remplir tous les champs requis et ajouter des commentaires pour les éléments en mauvais état',
        type: ToastificationType.error,
      );
      return;
    }

    if (_tenant?.id == null) {
      showToast(
        msg: 'Informations du locataire manquantes',
        type: ToastificationType.error,
      );
      return;
    }

    // Generate OTP code
    context.read<InventoriesBloc>().add(
      GenerateCodeEtatLieuxEvent(locataireId: _tenant!.id!),
    );
  }

  void _showVerificationCodeModal(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (modalContext) => ModalVerifyEstateLocationCode(
        tenantId: _tenant!.id!,
        onVerified: _saveEstateLocation,
      ),
    );
  }

  void _saveEstateLocation() {
    // Prepare parties communes data
    final partiesCommunesData = <String, dynamic>{};
    _partiesCommunesStatus.forEach((key, status) {
      partiesCommunesData[key] = status == true ? 'Bon état' : 'Mauvais état';
      if (status == false && _partiesCommunesComments.containsKey(key)) {
        partiesCommunesData['observation_$key'] =
            _partiesCommunesComments[key]!.text.trim();
      }
    });

    // Prepare chambres data
    final chambresData = <Map<String, dynamic>>[];
    final chambres = _estateLocation?.chambreModels ?? [];

    for (var chambre in chambres) {
      final chambreKey = chambre.nom ?? 'Chambre';
      final chambreData = <String, dynamic>{'nom': chambreKey};
      _chambresStatus[chambreKey]?.forEach((elementKey, status) {
        chambreData[elementKey] = status == true ? 'Bon état' : 'Mauvais état';
        if (status == false &&
            _chambresComments[chambreKey]!.containsKey(elementKey)) {
          chambreData['observation_$elementKey'] =
              _chambresComments[chambreKey]![elementKey]!.text.trim();
        }
      });

      chambresData.add(chambreData);
    }

    // Create request
    final request = SaveEstateLocationRequest(
      locataireId: _tenant!.id!,
      bienId: _propertyData!.id!,
      typeBien: _propertyData!.type ?? '',
      communeBien: _propertyData!.commune ?? '',
      presencePartie: 'oui',
      partiesCommunes: partiesCommunesData,
      chambres: chambresData,
      nombreCle: int.tryParse(_estateLocation?.nombreCle ?? "") ?? 1, // You can make this dynamic if needed
    );

    // Save estate location
    context.read<InventoriesBloc>().add(
      SaveEstateLocationEvent(request: request),
    );
  }
}
