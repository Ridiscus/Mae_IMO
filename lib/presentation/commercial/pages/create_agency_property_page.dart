import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/manager/state/dashboard/dashboard_bloc.dart';
import 'package:maelys_imo/core/domain/models/index.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import '../widgets/file_picker_widget.dart';
import '../widgets/success_modal.dart';

class CreateAgencyPropertyPage extends StatefulWidget {
  static const routeName = 'createAgencyProperty';
  static const routePath = '/commercial/create-agency-property';
  const CreateAgencyPropertyPage({super.key});
  @override
  State<CreateAgencyPropertyPage> createState() =>
      _CreateAgencyPropertyPageState();
}

class _CreateAgencyPropertyPageState extends State<CreateAgencyPropertyPage> {
  final _formKey = GlobalKey<FormState>();

  // --- Information du bien ---
  AgencyModel? _selectedAgency;
  String? _selectedPropertyType;
  final _superficieController = TextEditingController();
  String? _selectedCommune;
  final _nbPiecesController = TextEditingController();
  final _nbToilettesController = TextEditingController();
  bool _hasGarage = false;
  String? _utilizationType;
  final _customUtilizationController = TextEditingController();
  String? _selectedDisponibilite = 'Immédiate';

  // --- Condition financière ---
  final _loyerController = TextEditingController();
  final _avanceController = TextEditingController();
  final _cautionController = TextEditingController();
  final _fraisController = TextEditingController();
  final _totalAtEntryController = TextEditingController();
  final _paymentDayController = TextEditingController();

  // --- Photos & Media ---
  File? _mainPhoto;
  final List<File?> _suppPhotos = List.generate(5, (_) => null);
  final _videoUrlController = TextEditingController();
  final _descriptionController = TextEditingController();

  // --- Erreurs locales de validation ---
  String? _agencyError;
  String? _mainPhotoError;
  String? _suppPhotosError;

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
    'Dans 3 mois',
  ];

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(const FetchCommercialAgencesEvent());
  }

  @override
  void dispose() {
    _superficieController.dispose();
    _nbPiecesController.dispose();
    _nbToilettesController.dispose();
    _customUtilizationController.dispose();
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

  void _calculateTotal() {
    final loyer = double.tryParse(_loyerController.text) ?? 0;
    final avance = int.tryParse(_avanceController.text) ?? 0;
    final caution = int.tryParse(_cautionController.text) ?? 0;
    final frais = int.tryParse(_fraisController.text) ?? 0;

    final total = loyer * (avance + caution + frais);
    _totalAtEntryController.text = total.toStringAsFixed(0);
  }

  void _submit() {
    setState(() {
      _agencyError = null;
      _mainPhotoError = null;
      _suppPhotosError = null;
    });

    if (_formKey.currentState!.validate()) {
      bool hasError = false;

      if (_selectedAgency == null) {
        setState(() => _agencyError = "Veuillez sélectionner une agence");
        hasError = true;
      }

      if (_mainPhoto == null) {
        setState(() => _mainPhotoError = "La photo principale est obligatoire");
        hasError = true;
      } else if (_mainPhoto!.lengthSync() > 2048 * 1024) {
        setState(() => _mainPhotoError = "La photo principale dépasse 2 Mo");
        hasError = true;
      }

      if (_suppPhotos[0] == null) {
        setState(
          () =>
              _suppPhotosError =
                  "Au moins une photo supplémentaire est requise",
        );
        hasError = true;
      }

      for (int i = 0; i < _suppPhotos.length; i++) {
        final photo = _suppPhotos[i];
        if (photo != null && photo.lengthSync() > 2048 * 1024) {
          setState(
            () =>
                _suppPhotosError =
                    "La photo supplémentaire ${i + 1} dépasse 2 Mo",
          );
          hasError = true;
          break;
        }
      }

      if (hasError) return;

      context.read<DashboardBloc>().add(
        CreateAgencyPropertyEvent(
          agenceId: _selectedAgency!.codeId!,
          type: _selectedPropertyType ?? '',
          utilisation:
              _utilizationType == 'Autre'
                  ? _customUtilizationController.text
                  : (_utilizationType ?? ''),
          description: _descriptionController.text,
          superficie: double.tryParse(_superficieController.text) ?? 0,
          avance: int.tryParse(_avanceController.text) ?? 0,
          caution: int.tryParse(_cautionController.text) ?? 0,
          prix: double.tryParse(_loyerController.text) ?? 0,
          commune: _selectedCommune ?? '',
          disponibilite: _selectedDisponibilite ?? 'Immédiate',
          nombreDeChambres: int.tryParse(_nbPiecesController.text) ?? 0,
          nombreDeToilettes: int.tryParse(_nbToilettesController.text) ?? 0,
          garage: _hasGarage,
          frais: int.tryParse(_fraisController.text) ?? 0,
          video3d: _videoUrlController.text,
          mainImage: _mainPhoto,
          additionalImages: _suppPhotos,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state.propertyCreated) {
          SuccessModal.show(
            context: context,
            title: 'Bien Enregistré !',
            message:
                'Le bien a été rattaché avec succès à l\'agence ${_selectedAgency?.name}.',
            buttonText: 'RETOURNER AU DASHBOARD',
            onConfirm: () => context.pop(),
          );
        }
      },
      builder: (context, state) {
        final agencies = state.agencies ?? [];
        return FormWithHeaderLayout(
          headerTitle: 'Bien pour Agence',
          padding: EdgeInsets.zero,
          content: SingleChildScrollView(
            padding: EdgeInsets.all(20.sp),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Information du bien'),
                  SizedBox(height: 16.h),

                  CustomSearchableDropdown<AgencyModel?>(
                    labelText: 'Sélectionnez l\'agence',
                    hintText: 'Choisir une agence',
                    value: _selectedAgency,
                    items: agencies,
                    showSearch: true,
                    onChanged: (val) {
                      setState(() {
                        _selectedAgency = val;
                        _agencyError = null;
                      });
                    },
                    itemLabelBuilder: (val) => val?.name ?? '',
                    errorText: _agencyError ?? state.formErrors?['agence_id'],
                  ),
                  CustomSpacer(),

                  CustomSearchableDropdown<String?>(
                    labelText: 'Type de bien',
                    hintText: 'Choisir le type',
                    value: _selectedPropertyType,
                    items: _propertyTypes,
                    showSearch: false,
                    onChanged:
                        (val) => setState(() => _selectedPropertyType = val),
                    itemLabelBuilder: (val) => val ?? '',
                    errorText: state.formErrors?['type'],
                  ),
                  CustomSpacer(),

                  CustomInputText(
                    controller: _superficieController,
                    labelText: 'Superficie (m2)',
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.square_foot_outlined,
                    errorText: state.formErrors?['superficie'],
                  ),
                  CustomSpacer(),

                  CustomSearchableDropdown<String?>(
                    labelText: 'Commune',
                    hintText: 'Choisir la commune',
                    value: _selectedCommune,
                    items: _communesAbidjan,
                    showSearch: true,
                    onChanged: (val) => setState(() => _selectedCommune = val),
                    itemLabelBuilder: (val) => val ?? '',
                    errorText: state.formErrors?['commune'],
                  ),
                  CustomSpacer(),

                  Row(
                    children: [
                      Expanded(
                        child: CustomInputText(
                          controller: _nbPiecesController,
                          labelText: 'Nombre de pièces',
                          keyboardType: TextInputType.number,
                          errorText: state.formErrors?['nombre_de_chambres'],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: CustomInputText(
                          controller: _nbToilettesController,
                          labelText: 'Nombre de toilettes',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  CustomSpacer(),

                  CustomSearchableDropdown<bool>(
                    labelText: 'Garage',
                    hintText: 'Possède un garage ?',
                    value: _hasGarage,
                    items: const [false, true],
                    showSearch: false,
                    onChanged:
                        (val) => setState(() => _hasGarage = val ?? false),
                    itemLabelBuilder: (val) => val ? 'Oui' : 'Non',
                  ),
                  CustomSpacer(),

                  CustomSearchableDropdown<String?>(
                    labelText: 'Type d\'utilisation',
                    hintText: 'Choisir l\'utilisation',
                    value: _utilizationType,
                    items: _utilizationTypes,
                    showSearch: false,
                    onChanged: (val) => setState(() => _utilizationType = val),
                    itemLabelBuilder: (val) => val ?? '',
                    errorText: state.formErrors?['utilisation'],
                  ),
                  if (_utilizationType == 'Autre') ...[
                    CustomSpacer(),
                    CustomInputText(
                      controller: _customUtilizationController,
                      labelText: 'Précisez l\'utilisation',
                      isRequired: true,
                    ),
                  ],
                  CustomSpacer(),

                  CustomSearchableDropdown<String?>(
                    labelText: 'Disponibilité',
                    hintText: 'Choisir la disponibilité',
                    value: _selectedDisponibilite,
                    items: _disponibilites,
                    showSearch: false,
                    onChanged:
                        (val) => setState(() => _selectedDisponibilite = val),
                    itemLabelBuilder: (val) => val ?? '',
                    errorText: state.formErrors?['disponibilite'],
                  ),

                  SizedBox(height: 32.h),
                  _buildSectionTitle('Condition financière'),
                  SizedBox(height: 16.h),

                  CustomInputText(
                    controller: _loyerController,
                    labelText: 'Loyer (FCFA)',
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.payments_outlined,
                    onChanged: (_) => _calculateTotal(),
                    errorText: state.formErrors?['prix'],
                  ),
                  CustomSpacer(),

                  Row(
                    children: [
                      Expanded(
                        child: CustomInputText(
                          controller: _avanceController,
                          labelText: 'Avance (Mois)',
                          keyboardType: TextInputType.number,
                          onChanged: (_) => _calculateTotal(),
                          errorText: state.formErrors?['avance'],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: CustomInputText(
                          controller: _cautionController,
                          labelText: 'Caution (Mois)',
                          keyboardType: TextInputType.number,
                          onChanged: (_) => _calculateTotal(),
                          errorText: state.formErrors?['caution'],
                        ),
                      ),
                    ],
                  ),
                  CustomSpacer(),

                  Row(
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
                  CustomSpacer(),

                  CustomInputText(
                    controller: _totalAtEntryController,
                    labelText: 'Total à l\'entrée',
                    readOnly: true,
                    prefixIcon: Icons.calculate_outlined,
                  ),

                  SizedBox(height: 32.h),
                  _buildSectionTitle('Photos du bien'),
                  SizedBox(height: 16.h),

                  FilePickerWidget(
                    label: 'Photo principale',
                    hint: 'Sélectionner l\'image de couverture',
                    onFileSelected: (file) {
                      setState(() {
                        _mainPhoto = file;
                        _mainPhotoError = null;
                      });
                    },
                    errorText:
                        _mainPhotoError ?? state.formErrors?['main_image'],
                  ),
                  CustomSpacer(),

                  ...List.generate(5, (index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: FilePickerWidget(
                        label: 'Photo suppl. ${index + 1}',
                        hint: 'Ajouter une photo supplémentaire',
                        onFileSelected: (file) {
                          setState(() {
                            _suppPhotos[index] = file;
                            _suppPhotosError = null;
                          });
                        },
                        errorText:
                            index == 0
                                ? (_suppPhotosError ??
                                    state.formErrors?['additional_images1'])
                                : state
                                    .formErrors?['additional_images${index + 1}'],
                      ),
                    );
                  }),

                  CustomSpacer(),
                  CustomInputText(
                    controller: _videoUrlController,
                    labelText: 'Vidéo 3D / visite virtuelle (lien ou iframe)',
                    maxLines: 3,
                    hintText: 'Collez le lien ou le code iframe ici',
                    errorText: state.formErrors?['video_3d'],
                  ),
                  CustomSpacer(),
                  CustomInputText(
                    controller: _descriptionController,
                    labelText: 'Description détaillée',
                    maxLines: 5,
                    hintText: 'Décrivez les atouts du bien...',
                    errorText: state.formErrors?['description'],
                  ),

                  SizedBox(height: 48.h),
                  CustomButton(
                    text: 'ENREGISTRER LE BIEN',
                    onPressed: state.isCreatingProperty ? () {} : _submit,
                    isLoading: state.isCreatingProperty,
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

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Text(
        title.toUpperCase(),
        style:
            TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              letterSpacing: 1.1,
            ).sourceSansProBold,
      ),
    );
  }
}
