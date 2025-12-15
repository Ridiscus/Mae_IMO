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
import 'package:skeletonizer/skeletonizer.dart';
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
  // Controllers
  final Map<String, bool?> _partiesCommunesStatus = {};
  final Map<String, TextEditingController> _partiesCommunesComments = {};
  final Map<String, Map<String, bool?>> _chambresStatus = {};
  final Map<String, Map<String, TextEditingController>> _chambresComments = {};

  TenantModel? _tenant;
  EstateModel? _propertyData;
  EstateLocationModel? _estateLocation;
  bool _isLoading = true;

  // --- LISTE PAR DÉFAUT SI L'API RENVOIE NULL ---
  final List<String> _defaultPartiesCommunesKeys = [
    'sol', 'murs', 'plafond', 'porte_entre', 'interrupteur',
    'robinet', 'lavabo', 'douche'
  ];

  final List<String> _defaultRooms = ['Pièces 1', 'Pièces 2', 'Pièces 3'];

  @override
  void initState() {
    super.initState();
    context.read<InventoriesBloc>().add(
      FetchOneInventoriesEvent(id: widget.propertyId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InventoriesBloc, InventoriesState>(
      listener: (context, state) {
        if (state.estateLocationSaved == true) {
          context.pop();
        }
      },
      builder: (context, state) {
        _propertyData = state.inventoryDetail?.bien;
        _tenant = state.inventoryDetail?.locataire;
        _estateLocation = state.inventoryDetail?.etatsLieu?.etatEntree;
        _isLoading = state.isLoading ?? false;

        return PageWithHeaderLayout(
          headerContent: _buildHeaderContent(),
          bodyContent: Skeletonizer(
            enabled: _isLoading,
            child: _propertyData == null
                ? const Center(child: Text("Chargement..."))
                : _buildInspectionForm(),
          ),
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
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ).sourceSansProBold,
        ),
      ],
    );
  }

  Widget _buildInspectionForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPropertySummary(),
          CustomSpacer(space: 2),
          _buildRoomsList(), // C'est ici que la magie opère
          CustomSpacer(),
          _buildSaveButton(),
          SizedBox(height: 40.sp),
        ],
      ),
    );
  }

  Widget _buildPropertySummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _propertyData?.title ?? "Bien Immobilier",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black).sourceSansProBold,
        ),
        SizedBox(height: 8.sp),
        _buildSummaryItem(icon: Icons.home_outlined, label: 'Type: ${_propertyData?.type ?? ''}'),
        _buildSummaryItem(icon: Icons.location_on_outlined, label: 'Commune: ${_propertyData?.commune ?? ''}'),
        _buildSummaryItem(icon: Icons.person_outline, label: 'Locataire: ${_tenant?.fullName ?? ''}'),
      ],
    );
  }

  Widget _buildSummaryItem({required IconData icon, required String label}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.sp),
      child: Row(
        children: [
          Icon(icon, size: 24.sp, color: Colors.black87),
          SizedBox(width: 12.sp),
          Text(label, style: TextStyle(fontSize: 16.sp, color: Colors.black87).sourceSansProRegular),
        ],
      ),
    );
  }

  // --- CORRECTION CLÉ : GÉNÉRATION DYNAMIQUE OU PAR DÉFAUT ---
  List<Map<String, String>> get _partiesCommunesFields {
    final fields = <Map<String, String>>[];

    // CAS 1 : On a déjà des données (ex: update ou l'API a envoyé une config)
    if (_estateLocation?.partiesCommunesModel != null) {
      final modelMap = _estateLocation!.partiesCommunesModel!.toMap();
      modelMap.forEach((key, value) {
        if (!key.startsWith('observation_')) {
          fields.add({'key': key, 'label': _formatLabel(key)});
        }
      });
    }
    // CAS 2 (Ton cas actuel) : C'est vide, on génère les champs par défaut
    else {
      for (var key in _defaultPartiesCommunesKeys) {
        fields.add({'key': key, 'label': _formatLabel(key)});
      }
    }
    return fields;
  }

  String _formatLabel(String key) {
    final labels = {
      'sol': 'Sol', 'murs': 'Murs', 'plafond': 'Plafond', 'douche': 'Douche',
      'lavabo': 'Lavabo', 'robinet': 'Robinet', 'porte_entre': 'Porte d\'entrée', 'interrupteur': 'Interrupteur',
    };
    return labels[key] ?? key.replaceAll('_', ' ').split(' ').map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1)).join(' ');
  }






  // --- NOUVELLE VERSION INTELLIGENTE ---
  Widget _buildRoomsList() {
    final chambres = _estateLocation?.chambreModels ?? [];
    List<String> roomNames = [];

    // CAS 1 : On a déjà des données d'état des lieux (Update)
    if (chambres.isNotEmpty) {
      roomNames = chambres.map((c) => c.nom ?? 'Chambre').toList();
    }
    // CAS 2 : C'est nouveau, on utilise le nombre de chambres du Bien
    else {
      // On récupère le nombre envoyé par le backend (ou 1 par défaut si vide)
      int nbChambres = int.tryParse(_propertyData?.nombreChambres ?? "1") ?? 1;

      // On génère les noms : "Chambre 1", "Chambre 2", etc.
      roomNames = List.generate(nbChambres, (index) => "Pièces ${index + 1}");

    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Parties Communes
        Text('Parties Communes', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black).sourceSansProBold),
        SizedBox(height: 16.sp),
        ..._partiesCommunesFields.map((field) => _buildPartiesCommunesItem(field['label']!, field['key']!)),
        SizedBox(height: 24.sp),

        // 2. Pièces Dynamiques
        Text('Pièces', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black).sourceSansProBold),
        SizedBox(height: 16.sp),

        ...roomNames.map((roomName) => _buildChambreSection(roomName)),
      ],
    );
  }





  Widget _buildPartiesCommunesItem(String label, String key) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.sp),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: Offset(0, 2))]),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black).sourceSansProSemiBold),
          SizedBox(height: 12.sp),
          Row(
            children: [
              Expanded(child: _buildStatusButton(label: 'Bon état', isSelected: _partiesCommunesStatus[key] == true, color: AppColors.success, onTap: () => setState(() => _partiesCommunesStatus[key] = true))),
              SizedBox(width: 12.sp),
              Expanded(child: _buildStatusButton(label: 'Mauvais état', isSelected: _partiesCommunesStatus[key] == false, color: AppColors.redColor, onTap: () {
                setState(() {
                  _partiesCommunesStatus[key] = false;
                  if (!_partiesCommunesComments.containsKey(key)) _partiesCommunesComments[key] = TextEditingController();
                });
              })),
            ],
          ),
          if (_partiesCommunesStatus[key] == false) ...[
            SizedBox(height: 12.sp),
            CustomInputTextFactory.createTextAreaInput(controller: _partiesCommunesComments[key]!, hintText: 'Commentaire sur l\'état...', textInputAction: TextInputAction.done),
          ],
        ],
      ),
    );
  }

  // J'ai adapté cette méthode pour prendre juste le NOM de la pièce (String)
  Widget _buildChambreSection(String chambreKey) {
    if (!_chambresStatus.containsKey(chambreKey)) {
      _chambresStatus[chambreKey] = {};
      _chambresComments[chambreKey] = {};
    }
    return Container(
      margin: EdgeInsets.only(bottom: 24.sp),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(chambreKey, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.primary).sourceSansProBold),
          SizedBox(height: 16.sp),
          _buildChambreElementItem(chambreKey, 'Sol', 'sol'),
          _buildChambreElementItem(chambreKey, 'Murs', 'murs'),
          _buildChambreElementItem(chambreKey, 'Plafond', 'plafond'),
        ],
      ),
    );
  }

  Widget _buildChambreElementItem(String chambreKey, String label, String elementKey) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.sp),
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.black).sourceSansProSemiBold),
          SizedBox(height: 8.sp),
          Row(
            children: [
              Expanded(child: _buildStatusButton(label: 'Bon état', isSelected: _chambresStatus[chambreKey]?[elementKey] == true, color: AppColors.success, onTap: () => setState(() => _chambresStatus[chambreKey]![elementKey] = true))),
              SizedBox(width: 12.sp),
              Expanded(child: _buildStatusButton(label: 'Mauvais état', isSelected: _chambresStatus[chambreKey]?[elementKey] == false, color: AppColors.redColor, onTap: () {
                setState(() {
                  _chambresStatus[chambreKey]![elementKey] = false;
                  if (!_chambresComments[chambreKey]!.containsKey(elementKey)) _chambresComments[chambreKey]![elementKey] = TextEditingController();
                });
              })),
            ],
          ),
          if (_chambresStatus[chambreKey]?[elementKey] == false) ...[
            SizedBox(height: 8.sp),
            CustomInputTextFactory.createTextAreaInput(controller: _chambresComments[chambreKey]![elementKey]!, hintText: 'Commentaire sur l\'état...', textInputAction: TextInputAction.done),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusButton({required String label, required bool isSelected, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.sp),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
          border: Border.all(color: isSelected ? color : Colors.grey.withOpacity(0.3), width: 1.sp),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(child: Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal, color: isSelected ? color : Colors.grey.shade700).sourceSansProSemiBold)),
      ),
    );
  }

  Widget _buildSaveButton() {
    final isSaving = _isLoading;

    return CustomButton(
      text: 'Enregistrer cet état',
      onPressed: _validateAndSave,
      showArrow: true,
      isDisabled: !_isFormValid() || isSaving,
      isLoading: isSaving,
      iconData: Icons.save,
    );
  }

  bool _isFormValid() {
    // Si on utilise la liste par défaut, on vérifie que ces champs sont remplis
    if (_partiesCommunesFields.isNotEmpty) {
      for (var field in _partiesCommunesFields) {
        final key = field['key']!;
        if (_partiesCommunesStatus[key] == null) return false;
        if (_partiesCommunesStatus[key] == false) {
          if (!_partiesCommunesComments.containsKey(key) || _partiesCommunesComments[key]!.text.trim().isEmpty) return false;
        }
      }
    }

    // Validation des chambres (basée sur les statuts remplis)
    // On itère sur les clés que nous avons créées nous-mêmes dans _chambresStatus
    for (var chambreKey in _chambresStatus.keys) {
      final elementKeys = ['sol', 'murs', 'plafond'];
      for (var elementKey in elementKeys) {
        if (_chambresStatus[chambreKey]?[elementKey] == null) return false;
        if (_chambresStatus[chambreKey]?[elementKey] == false) {
          if (!_chambresComments[chambreKey]!.containsKey(elementKey) || _chambresComments[chambreKey]![elementKey]!.text.trim().isEmpty) return false;
        }
      }
    }
    return true;
  }

  void _validateAndSave() {
    if (!_isFormValid()) {
      showToast(msg: 'Veuillez remplir tous les champs', type: ToastificationType.error);
      return;
    }

    final partiesCommunesData = <String, dynamic>{};
    _partiesCommunesStatus.forEach((key, status) {
      partiesCommunesData[key] = status == true ? 'Bon état' : 'Mauvais état';
      if (status == false && _partiesCommunesComments.containsKey(key)) {
        partiesCommunesData['observation_$key'] = _partiesCommunesComments[key]!.text.trim();
      }
    });

    final chambresData = <Map<String, dynamic>>[];

    // On itère sur les pièces générées (qu'elles viennent de l'API ou par défaut)
    // Astuce : on utilise les clés de _chambresStatus qui contiennent les noms des pièces
    _chambresStatus.forEach((chambreKey, elements) {
      final chambreData = <String, dynamic>{'nom': chambreKey};
      elements.forEach((elementKey, status) {
        chambreData[elementKey] = status == true ? 'Bon état' : 'Mauvais état';
        if (status == false && _chambresComments[chambreKey]!.containsKey(elementKey)) {
          chambreData['observation_$elementKey'] = _chambresComments[chambreKey]![elementKey]!.text.trim();
        }
      });
      chambresData.add(chambreData);
    });

    final request = SaveEstateLocationRequest(
      locataireId: _tenant!.id!,
      bienId: _propertyData!.id!,
      typeBien: _propertyData!.type ?? '',
      communeBien: _propertyData!.commune ?? '',
      presencePartie: 'oui',
      partiesCommunes: partiesCommunesData,
      chambres: chambresData,
      nombreCle: int.tryParse(_estateLocation?.nombreCle ?? "") ?? 2, // 2 clés par défaut
    );

    context.read<InventoriesBloc>().add(
      SaveEstateLocationEvent(request: request),
    );
  }
}