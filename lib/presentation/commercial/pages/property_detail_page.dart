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
import '../widgets/file_picker_widget.dart';
import '../widgets/success_modal.dart';

class PropertyDetailPage extends StatefulWidget {
  static const routeName = 'propertyDetailCommercial';
  static const routePath = '/commercial/property-detail';
  final PropertyModel property;

  const PropertyDetailPage({super.key, required this.property});

  @override
  State<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // --- Editing state ---
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();

  // --- Contrôleurs pour l'édition ---
  late TextEditingController _superficieController;
  late TextEditingController _nbPiecesController;
  late TextEditingController _nbToilettesController;
  late TextEditingController _loyerController;
  late TextEditingController _avanceController;
  late TextEditingController _cautionController;
  late TextEditingController _fraisController;
  late TextEditingController _totalAtEntryController;
  late TextEditingController _paymentDayController;
  late TextEditingController _videoUrlController;
  late TextEditingController _descriptionController;
  bool _controllersInitialized = false;

  // --- Dropdowns ---
  String? _selectedPropertyType;
  String? _selectedCommune;
  String? _selectedUtilizationType;
  String? _selectedDisponibilite;
  bool _hasGarage = false;

  // --- Nouvelles photos ---
  File? _newMainPhoto;
  final List<File?> _newSuppPhotos = List.generate(5, (_) => null);

  // --- Options ---
  final List<String> _propertyTypes = [
    'Appartement',
    'Maison',
    'Bureau',
    'Studio',
    'Magasin',
  ];
  final List<String> _communesAbidjan = [
    'Abobo',
    'Adjamé',
    'Anyama',
    'Attécoubé',
    'Bingerville',
    'Cocody',
    'Koumassi',
    'Marcory',
    'Plateau',
    'Port-Bouët',
    'Songon',
    'Treichville',
    'Yopougon',
  ];
  final List<String> _utilizationTypes = [
    'Habitation',
    'Bureau',
    'Commercial',
    'Autre',
  ];
  final List<String> _disponibilites = [
    'Immédiate',
    'Dans 1 mois',
    'Dans 2 mois',
    'En construction',
  ];

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers([PropertyModel? property]) {
    final p = property ?? widget.property;

    if (!mounted) return;

    // Si les contrôleurs ne sont pas encore initialisés (premier appel dans initState)
    if (!_controllersInitialized) {
      _superficieController = TextEditingController(
        text: p.superfice?.toStringAsFixed(0) ?? '',
      );
      _nbPiecesController = TextEditingController(
        text: p.nbPieces?.toString() ?? '',
      );
      _nbToilettesController = TextEditingController(
        text: p.nbToilettes?.toString() ?? '',
      );
      _loyerController = TextEditingController(
        text: p.price?.toStringAsFixed(0) ?? '',
      );
      _avanceController = TextEditingController(
        text: p.nbMonthsAdvance?.toString() ?? '',
      );
      _cautionController = TextEditingController(
        text: p.nbMonthsCaution?.toString() ?? '',
      );
      _fraisController = TextEditingController(
        text: p.nbMonthsFrais?.toString() ?? '',
      );
      _totalAtEntryController = TextEditingController(
        text: p.totalAtEntry?.toStringAsFixed(0) ?? '',
      );
      _paymentDayController = TextEditingController(text: p.paymentDay ?? '');
      _videoUrlController = TextEditingController(text: p.videoUrl ?? '');
      _descriptionController = TextEditingController(text: p.description ?? '');
      _controllersInitialized = true;
    } else {
      // Sinon, on met juste à jour le texte
      _superficieController.text = p.superfice?.toStringAsFixed(0) ?? '';
      _nbPiecesController.text = p.nbPieces?.toString() ?? '';
      _nbToilettesController.text = p.nbToilettes?.toString() ?? '';
      _loyerController.text = p.price?.toStringAsFixed(0) ?? '';
      _avanceController.text = p.nbMonthsAdvance?.toString() ?? '';
      _cautionController.text = p.nbMonthsCaution?.toString() ?? '';
      _fraisController.text = p.nbMonthsFrais?.toString() ?? '';
      _totalAtEntryController.text = p.totalAtEntry?.toStringAsFixed(0) ?? '';
      _paymentDayController.text = p.paymentDay ?? '';
      _videoUrlController.text = p.videoUrl ?? '';
      _descriptionController.text = p.description ?? '';
    }

    _selectedPropertyType = p.type;
    _selectedCommune = p.commune;
    _selectedUtilizationType = p.utilizationType;
    _hasGarage = p.hasGarage;
    _selectedDisponibilite = p.isAvailable ? 'Immédiate' : 'En construction';
  }

  @override
  void dispose() {
    _pageController.dispose();
    _superficieController.dispose();
    _nbPiecesController.dispose();
    _nbToilettesController.dispose();
    _loyerController.dispose();
    _avanceController.dispose();
    _cautionController.dispose();
    _fraisController.dispose();
    _totalAtEntryController.dispose();
    _paymentDayController.dispose();
    _videoUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _toggleEdit(PropertyModel p) {
    setState(() {
      _isEditing = !_isEditing;
      // On réinitialise toujours avec la version la plus fraîche pour l'édition ou l'abandon
      _initControllers(p);
      if (!_isEditing) {
        _newMainPhoto = null;
        for (int i = 0; i < _newSuppPhotos.length; i++) {
          _newSuppPhotos[i] = null;
        }
      }
    });
  }

  void _calculateTotal() {
    final loyer = double.tryParse(_loyerController.text) ?? 0;
    final avance = int.tryParse(_avanceController.text) ?? 0;
    final caution = int.tryParse(_cautionController.text) ?? 0;
    final frais = int.tryParse(_fraisController.text) ?? 0;
    final total = loyer * (avance + caution + frais);
    _totalAtEntryController.text = total.toStringAsFixed(0);
  }

  void _saveChanges(BuildContext context, PropertyModel p) {
    if (_formKey.currentState!.validate()) {
      if (p.id == null) return;
      context.read<DashboardBloc>().add(
        UpdatePropertyEvent(
          propertyId: p.id!,
          type: _selectedPropertyType ?? p.type ?? '',
          utilisation: _selectedUtilizationType ?? p.utilizationType ?? '',
          description: _descriptionController.text,
          superficie: double.tryParse(_superficieController.text) ?? 0,
          avance: int.tryParse(_avanceController.text) ?? 0,
          caution: int.tryParse(_cautionController.text) ?? 0,
          prix: double.tryParse(_loyerController.text) ?? 0,
          commune: _selectedCommune ?? p.commune ?? '',
          disponibilite: _selectedDisponibilite ?? 'Immédiate',
          nombreDeChambres: int.tryParse(_nbPiecesController.text) ?? 0,
          nombreDeToilettes: int.tryParse(_nbToilettesController.text) ?? 0,
          garage: _hasGarage,
          frais: int.tryParse(_fraisController.text) ?? 0,
          video3d: _videoUrlController.text,
          paymentDay: _paymentDayController.text,
          mainImage: _newMainPhoto,
          additionalImages: _newSuppPhotos,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state.propertyUpdated) {
          setState(() => _isEditing = false);
          SuccessModal.show(
            context: context,
            title: 'Modification Réussie !',
            message:
                'Les informations du bien ont été mises à jour avec succès.',
            buttonText: 'OK, J\'AI COMPRIS',
          );
        }
        if (state.propertyDeleted) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        // On récupère la version la plus fraîche du bien depuis le state
        final p =
            state.properties?.firstWhere(
              (item) => item.id == widget.property.id,
              orElse: () => widget.property,
            ) ??
            widget.property;

        final bool isAgency = p.owner?.gestion?.toLowerCase() == "agence";
        return PageWithHeaderLayout(
          headerHeight: MediaQuery.of(context).size.height * 0.20,
          headerContent: Row(
            children: [
              const CircularBackButton(),
              SizedBox(width: 8.w),
              Text(
                _isEditing ? 'Modifier le bien' : 'Détails du Bien',
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
                  onTap: () => _toggleEdit(p),
                ),
                SizedBox(width: 8.w),
                _buildHeaderAction(
                  icon: Icons.delete_outline,
                  color: Colors.red[300],
                  onTap: () => _showDeleteDialog(context, p),
                ),
              ] else ...[
                _buildHeaderAction(
                  icon: Icons.close,
                  onTap: () => _toggleEdit(p),
                ),
                SizedBox(width: 8.w),
                _buildHeaderAction(
                  icon:
                      state.isUpdatingProperty
                          ? Icons.hourglass_top
                          : Icons.check,
                  color: AppColors.success,
                  onTap:
                      state.isUpdatingProperty
                          ? null
                          : () => _saveChanges(context, p),
                ),
              ],
            ],
          ),
          bodyContent: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Carrousel hero (lecture seule) ---
                if (!_isEditing) ...[
                  _buildPropertyHero(p),
                  SizedBox(height: 24.h),
                ],

                // =========================================================
                // MODE LECTURE
                // =========================================================
                if (!_isEditing) ...[
                  _buildDetailSection('Information du bien', [
                    _buildDetailRow(
                      'Détenteur',
                      isAgency ? 'Agence' : 'Propriétaire',
                    ),
                    if (p.owner != null) ...[
                      _buildDetailRow(
                        'Nom',
                        p.owner!.fullName.isNotEmpty
                            ? p.owner!.fullName
                            : '---',
                      ),
                      _buildDetailRow('Contact', p.owner!.contact ?? '---'),
                      if (p.owner!.email != null && p.owner!.email!.isNotEmpty)
                        _buildDetailRow('Email', p.owner!.email!),
                    ],
                    _buildDetailRow('Type de bien', p.type ?? '---'),
                    _buildDetailRow(
                      'Superficie',
                      '${p.superfice?.toStringAsFixed(0) ?? "---"} m2',
                    ),
                    _buildDetailRow('Commune', p.commune ?? '---'),
                    _buildDetailRow('Pièces', p.nbPieces?.toString() ?? '---'),
                    _buildDetailRow(
                      'Toilettes',
                      p.nbToilettes?.toString() ?? '---',
                    ),
                    _buildDetailRow('Garage', p.hasGarage ? 'Oui' : 'Non'),
                    _buildDetailRow('Utilisation', p.utilizationType ?? '---'),
                  ]),

                  SizedBox(height: 16.h),
                  _buildDetailSection('Condition financière', [
                    _buildDetailRow(
                      'Loyer',
                      p.formattedPrice,
                      valueColor: AppColors.primary,
                    ),
                    _buildDetailRow(
                      'Avance',
                      '${p.nbMonthsAdvance?.toStringAsFixed(0) ?? "---"} Mois',
                    ),
                    _buildDetailRow(
                      'Caution',
                      '${p.nbMonthsCaution?.toStringAsFixed(0) ?? "---"} Mois',
                    ),
                    _buildDetailRow(
                      'Frais',
                      '${p.nbMonthsFrais?.toStringAsFixed(0) ?? "---"} Mois',
                    ),
                    _buildDetailRow(
                      'Total à l\'entrée',
                      '${p.totalAtEntry?.toStringAsFixed(0) ?? "---"} FCFA',
                      valueColor: AppColors.primary,
                    ),
                    _buildDetailRow('Jour de paiement', p.paymentDay ?? 'N/A'),
                  ]),

                  SizedBox(height: 16.h),
                  _buildDetailSection('Photos & Description', [
                    Text(
                      'Photo principale :',
                      style:
                          TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ).sourceSansProBold,
                    ),
                    SizedBox(height: 8.h),
                    if (p.mainImageUrl != null && p.mainImageUrl!.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          final List<String> allImages = [
                            p.mainImageUrl!,
                            ...p.supplementaryImages,
                          ];
                          _showFullScreenGallery(
                            context,
                            allImages,
                            initialPage: 0,
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            Endpoints.storageUrl(p.mainImageUrl!),
                            width: double.infinity,
                            height: 150.h,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, _, __) => Container(
                                  width: double.infinity,
                                  height: 150.h,
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                    size: 40,
                                  ),
                                ),
                          ),
                        ),
                      )
                    else
                      Text(
                        'Aucune photo principale disponible.',
                        style:
                            TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black87,
                            ).sourceSansProRegular,
                      ),

                    SizedBox(height: 16.h),
                    Text(
                      'Photos suppl. :',
                      style:
                          TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ).sourceSansProBold,
                    ),
                    SizedBox(height: 8.h),
                    if (p.supplementaryImages.isNotEmpty) ...[
                      SizedBox(
                        height: 80.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: p.supplementaryImages.length,
                          separatorBuilder:
                              (context, index) => SizedBox(width: 8.w),
                          itemBuilder: (context, index) {
                            final img = p.supplementaryImages[index];
                            return GestureDetector(
                              onTap: () {
                                final List<String> allImages = [
                                  if (p.mainImageUrl != null &&
                                      p.mainImageUrl!.isNotEmpty)
                                    p.mainImageUrl!,
                                  ...p.supplementaryImages,
                                ];
                                final int initialPage =
                                    (p.mainImageUrl != null &&
                                            p.mainImageUrl!.isNotEmpty)
                                        ? index + 1
                                        : index;
                                _showFullScreenGallery(
                                  context,
                                  allImages,
                                  initialPage: initialPage,
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child:
                                    (img.startsWith('assets/'))
                                        ? Image.asset(
                                          img,
                                          width: 80.w,
                                          height: 80.h,
                                          fit: BoxFit.cover,
                                        )
                                        : Image.network(
                                          Endpoints.storageUrl(img),
                                          width: 80.w,
                                          height: 80.h,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, _, __) => Container(
                                                width: 80.w,
                                                height: 80.h,
                                                color: Colors.grey[200],
                                                child: const Icon(
                                                  Icons.broken_image,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                        ),
                              ),
                            );
                          },
                        ),
                      ),
                    ] else
                      Text(
                        'Aucune photo supplémentaire.',
                        style:
                            TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black87,
                            ).sourceSansProRegular,
                      ),

                    SizedBox(height: 12.h),
                    Text(
                      'Description :',
                      style:
                          TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ).sourceSansProBold,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      p.description ?? 'Aucune description fournie.',
                      style:
                          TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black87,
                          ).sourceSansProRegular,
                    ),
                    if (p.videoUrl != null && p.videoUrl!.isNotEmpty) ...[
                      SizedBox(height: 12.h),
                      Text(
                        'Lien Vidéo/3D :',
                        style:
                            TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ).sourceSansProBold,
                      ),
                      Text(
                        p.videoUrl!,
                        style:
                            TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.primary,
                              decoration: TextDecoration.underline,
                            ).sourceSansProRegular,
                      ),
                    ],
                  ]),

                  SizedBox(height: 30.h),
                ],

                // =========================================================
                // MODE ÉDITION
                // =========================================================
                if (_isEditing) ...[
                  _buildSectionTitle('Information du bien'),
                  _buildInfoCard([
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: CustomDropdown<String?>(
                        labelText: 'Type de bien',
                        hintText: 'Choisir le type',
                        value: _selectedPropertyType,
                        items: _propertyTypes,
                        onChanged:
                            (val) =>
                                setState(() => _selectedPropertyType = val),
                        itemLabelBuilder: (val) => val ?? '',
                        errorText: state.formErrors?['type'],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: CustomInputText(
                        controller: _superficieController,
                        labelText: 'Superficie (m²)',
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.square_foot_outlined,
                        errorText: state.formErrors?['superficie'],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: CustomDropdown<String?>(
                        labelText: 'Commune',
                        hintText: 'Choisir la commune',
                        value: _selectedCommune,
                        items: _communesAbidjan,
                        onChanged:
                            (val) => setState(() => _selectedCommune = val),
                        itemLabelBuilder: (val) => val ?? '',
                        errorText: state.formErrors?['commune'],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomInputText(
                              controller: _nbPiecesController,
                              labelText: 'Pièces',
                              keyboardType: TextInputType.number,
                              errorText:
                                  state.formErrors?['nombre_de_chambres'],
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: CustomInputText(
                              controller: _nbToilettesController,
                              labelText: 'Toilettes',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: CustomDropdown<bool>(
                        labelText: 'Garage',
                        value: _hasGarage,
                        items: const [false, true],
                        onChanged:
                            (val) => setState(() => _hasGarage = val ?? false),
                        itemLabelBuilder: (val) => val ? 'Oui' : 'Non',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: CustomDropdown<String?>(
                        labelText: 'Type d\'utilisation',
                        hintText: 'Choisir l\'utilisation',
                        value: _selectedUtilizationType,
                        items: _utilizationTypes,
                        onChanged:
                            (val) =>
                                setState(() => _selectedUtilizationType = val),
                        itemLabelBuilder: (val) => val ?? '',
                        errorText: state.formErrors?['utilisation'],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: CustomDropdown<String?>(
                        labelText: 'Disponibilité',
                        hintText: 'Disponibilité du bien',
                        value: _selectedDisponibilite,
                        items: _disponibilites,
                        onChanged:
                            (val) =>
                                setState(() => _selectedDisponibilite = val),
                        itemLabelBuilder: (val) => val ?? '',
                        errorText: state.formErrors?['disponibilite'],
                      ),
                    ),
                  ]),

                  SizedBox(height: 24.h),
                  _buildSectionTitle('Condition financière'),
                  _buildInfoCard([
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: CustomInputText(
                        controller: _loyerController,
                        labelText: 'Loyer (FCFA)',
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.payments_outlined,
                        errorText: state.formErrors?['prix'],
                        onChanged: (_) => _calculateTotal(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomInputText(
                              controller: _avanceController,
                              labelText: 'Avance (Mois)',
                              keyboardType: TextInputType.number,
                              errorText: state.formErrors?['avance'],
                              onChanged: (_) => _calculateTotal(),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: CustomInputText(
                              controller: _cautionController,
                              labelText: 'Caution (Mois)',
                              keyboardType: TextInputType.number,
                              errorText: state.formErrors?['caution'],
                              onChanged: (_) => _calculateTotal(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomInputText(
                              controller: _fraisController,
                              labelText: 'Frais (Mois)',
                              keyboardType: TextInputType.number,
                              onChanged: (_) => _calculateTotal(),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: CustomInputText(
                              controller: _paymentDayController,
                              labelText: 'Jour de paiement',
                              hintText: 'ex: 05 du mois',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: CustomInputText(
                        controller: _totalAtEntryController,
                        labelText: 'Total à l\'entrée',
                        readOnly: true,
                        prefixIcon: Icons.calculate_outlined,
                      ),
                    ),
                  ]),

                  SizedBox(height: 24.h),
                  _buildSectionTitle('Photos & Médias'),
                  _buildInfoCard([
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: FilePickerWidget(
                        label: 'Photo principale',
                        hint: p.mainImageUrl ?? 'Sélectionner une photo',
                        serverUrl:
                            p.mainImageUrl != null
                                ? Endpoints.storageUrl(p.mainImageUrl!)
                                : null,
                        errorText: state.formErrors?['main_image'],
                        onFileSelected:
                            (file) => setState(() => _newMainPhoto = file),
                      ),
                    ),
                    ...List.generate(5, (index) {
                      final existingImage =
                          p.supplementaryImages.length > index
                              ? p.supplementaryImages[index]
                              : null;
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: FilePickerWidget(
                          label: 'Photo suppl. ${index + 1}',
                          hint: existingImage ?? 'Ajouter une photo',
                          serverUrl:
                              existingImage != null
                                  ? Endpoints.storageUrl(existingImage)
                                  : null,
                          errorText:
                              state
                                  .formErrors?['additional_images${index + 1}'],
                          onFileSelected:
                              (file) =>
                                  setState(() => _newSuppPhotos[index] = file),
                        ),
                      );
                    }),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: CustomInputText(
                        controller: _videoUrlController,
                        labelText: 'Vidéo 3D / visite virtuelle',
                        maxLines: 2,
                        hintText: 'Collez le lien ou le code iframe',
                        errorText: state.formErrors?['video_3d'],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: CustomInputText(
                        controller: _descriptionController,
                        labelText: 'Description',
                        maxLines: 4,
                        hintText: 'Décrivez les atouts du bien...',
                        errorText: state.formErrors?['description'],
                      ),
                    ),
                  ]),

                  SizedBox(height: 24.h),
                  if (state.isUpdatingProperty)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: const CircularProgressIndicator(),
                      ),
                    )
                  else
                    CustomButton(
                      text: 'ENREGISTRER LES MODIFICATIONS',
                      onPressed: () => _saveChanges(context, p),
                      width: double.infinity,
                    ),
                  SizedBox(height: 30.h),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  // -------------------------------------------------------------------------
  // Widgets helpers
  // -------------------------------------------------------------------------

  Widget _buildHeaderAction({
    required IconData icon,
    VoidCallback? onTap,
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

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
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
                    fontWeight: FontWeight.bold,
                    color: valueColor ?? Colors.black87,
                  ).sourceSansProBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyHero(PropertyModel p) {
    final bool isAgency = p.owner?.gestion?.toLowerCase() == "agence";

    final List<String> images = [
      if (p.mainImageUrl != null && p.mainImageUrl!.isNotEmpty)
        p.mainImageUrl!
      else
        'assets/images/property_default_1.png',
      ...p.supplementaryImages,
    ];

    return Column(
      children: [
        Container(
          height: 250.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Stack(
              children: [
                GestureDetector(
                  onTap:
                      () => _showFullScreenGallery(
                        context,
                        images,
                        initialPage: _currentPage,
                      ),
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged:
                        (index) => setState(() => _currentPage = index),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      final img = images[index];
                      return Hero(
                        tag: 'property_img_$index',
                        child:
                            (img.startsWith('assets/'))
                                ? Image.asset(img, fit: BoxFit.cover)
                                : Image.network(
                                  Endpoints.storageUrl(img),
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, _, __) => Container(
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons.broken_image,
                                          color: Colors.grey,
                                        ),
                                      ),
                                ),
                      );
                    },
                  ),
                ),
                if (images.length > 1)
                  Positioned(
                    bottom: 16.h,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(images.length, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          height: 8.h,
                          width: _currentPage == index ? 24.w : 8.w,
                          decoration: BoxDecoration(
                            color:
                                _currentPage == index
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        );
                      }),
                    ),
                  ),
                Positioned(
                  top: 16.h,
                  right: 16.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: (isAgency ? AppColors.primary : AppColors.orange)
                          .withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      isAgency ? 'AGENCE' : 'PROPRIÉTAIRE',
                      style:
                          TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ).sourceSansProBold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Column(
            children: [
              Text(
                p.title ?? 'Détails du bien',
                textAlign: TextAlign.center,
                style:
                    TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ).sourceSansProBold,
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16.sp,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    p.location ?? 'Abidjan, Côte d\'Ivoire',
                    style:
                        TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ).sourceSansProRegular,
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                p.formattedPrice,
                style:
                    TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ).sourceSansProBold,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showFullScreenGallery(
    BuildContext context,
    List<String> images, {
    int initialPage = 0,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 1,
            minChildSize: 1,
            maxChildSize: 1,
            builder:
                (context, scrollController) => Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.r),
                      topRight: Radius.circular(25.r),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Center(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 12.h),
                              width: 40.w,
                              height: 4.h,
                              decoration: BoxDecoration(
                                color: Colors.white30,
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 2.h,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Galerie d\'images',
                                    style:
                                        TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ).sourceSansProBold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          ),
                          const Divider(color: Colors.white10),
                          Expanded(
                            child: PageView.builder(
                              controller: PageController(
                                initialPage: initialPage,
                              ),
                              itemCount: images.length,
                              itemBuilder: (context, index) {
                                final img = images[index];
                                return InteractiveViewer(
                                  minScale: 0.5,
                                  maxScale: 4.0,
                                  child: Center(
                                    child:
                                        (img.startsWith('assets/'))
                                            ? Image.asset(
                                              img,
                                              fit: BoxFit.contain,
                                            )
                                            : Image.network(
                                              Endpoints.storageUrl(img),
                                              fit: BoxFit.contain,
                                            ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 24.sp, top: 12.sp),
                            child: Text(
                              'Faites glisser pour faire défiler',
                              style:
                                  TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.white60,
                                  ).sourceSansProRegular,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

  void _showDeleteDialog(BuildContext context, PropertyModel p) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Supprimer ce bien ?'),
            content: const Text(
              'Cette action est irréversible. Toutes les données liées à ce bien seront définitivement supprimées.',
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
                        state.isDeletingProperty
                            ? null
                            : () {
                              Navigator.pop(dialogContext);
                              context.read<DashboardBloc>().add(
                                DeletePropertyEvent(p.id!),
                              );
                            },
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child:
                        state.isDeletingProperty
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
