import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/manager/state/dashboard/dashboard_bloc.dart';
import 'package:maelys_imo/core/domain/models/index.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import '../widgets/file_picker_widget.dart';
import '../widgets/success_modal.dart';

class CreateOwnerPropertyPage extends StatefulWidget {
  static const routeName = 'createOwnerProperty';
  static const routePath = '/commercial/create-owner-property';

  const CreateOwnerPropertyPage({super.key});

  @override
  State<CreateOwnerPropertyPage> createState() =>
      _CreateOwnerPropertyPageState();
}

class _CreateOwnerPropertyPageState extends State<CreateOwnerPropertyPage> {
  final _formKey = GlobalKey<FormState>();

  // --- Information du bien ---
  OwnerModel? _selectedOwner;
  String? _selectedPropertyType;
  final _superficieController = TextEditingController();
  String? _selectedCommune;
  final _nbPiecesController = TextEditingController();
  final _nbToilettesController = TextEditingController();
  bool _hasGarage = false;
  String? _utilizationType;
  final _customUtilizationController = TextEditingController();
  String? _selectedDisponibilite;

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
  String? _ownerError;
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
    'En construction',
  ];

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(const FetchCommercialOwnersEvent());
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
      _ownerError = null;
      _mainPhotoError = null;
      _suppPhotosError = null;
    });

    if (_formKey.currentState!.validate()) {
      bool hasError = false;

      if (_selectedOwner == null) {
        setState(() => _ownerError = "Veuillez sélectionner un propriétaire");
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
        CreateOwnerPropertyEvent(
          ownerId: _selectedOwner!.codeId!,
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
                'Le bien a été rattaché avec succès au propriétaire ${_selectedOwner?.lastName ?? ""} ${_selectedOwner?.firstName ?? ""}.',
            buttonText: 'RETOURNER AU DASHBOARD',
            onConfirm:
                () => Navigator.of(context).popUntil((route) => route.isFirst),
          );
        }
      },
      builder: (context, state) {
        return FormWithHeaderLayout(
          headerTitle: 'Bien pour Propriétaire',
          content: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 20.sp),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Information du bien'),
                  SizedBox(height: 16.h),

                  CustomSearchableDropdown<OwnerModel?>(
                    labelText: 'Sélectionnez le propriétaire',
                    hintText: 'Choisir un propriétaire',
                    value: _selectedOwner,
                    items: state.owners?.cast<OwnerModel?>() ?? [],
                    isLoading: state.isLoading ?? false,
                    errorText:
                        _ownerError ?? state.formErrors?['proprietaire_id'],
                    onChanged: (val) {
                      setState(() {
                        _selectedOwner = val;
                        _ownerError = null;
                      });
                    },
                    itemLabelBuilder: (val) => val?.fullName ?? "",
                  ),
                  CustomSpacer(),

                  CustomSearchableDropdown<String?>(
                    labelText: 'Type de bien',
                    hintText: 'Choisir le type',
                    value: _selectedPropertyType,
                    items: _propertyTypes,
                    showSearch: false,
                    errorText: state.formErrors?['type'],
                    onChanged:
                        (val) => setState(() => _selectedPropertyType = val),
                    itemLabelBuilder: (val) => val ?? '',
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
                    errorText: state.formErrors?['commune'],
                    onChanged: (val) => setState(() => _selectedCommune = val),
                    itemLabelBuilder: (val) => val ?? '',
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
                    labelText: 'Disponibilité',
                    hintText: 'Disponibilité du bien',
                    value: _selectedDisponibilite,
                    items: _disponibilites,
                    showSearch: false,
                    errorText: state.formErrors?['disponibilite'],
                    onChanged:
                        (val) => setState(() => _selectedDisponibilite = val),
                    itemLabelBuilder: (val) => val ?? '',
                  ),
                  CustomSpacer(),

                  CustomSearchableDropdown<String?>(
                    labelText: 'Type d\'utilisation',
                    hintText: 'Choisir l\'utilisation',
                    value: _utilizationType,
                    items: _utilizationTypes,
                    showSearch: false,
                    errorText: state.formErrors?['utilisation'],
                    onChanged: (val) => setState(() => _utilizationType = val),
                    itemLabelBuilder: (val) => val ?? '',
                  ),
                  if (_utilizationType == 'Autre') ...[
                    CustomSpacer(),
                    CustomInputText(
                      controller: _customUtilizationController,
                      labelText: 'Précisez l\'utilisation',
                      isRequired: true,
                    ),
                  ],

                  SizedBox(height: 32.h),
                  _buildSectionTitle('Condition financière'),
                  SizedBox(height: 16.h),

                  CustomInputText(
                    controller: _loyerController,
                    labelText: 'Loyer (FCFA)',
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.payments_outlined,
                    errorText: state.formErrors?['prix'],
                    onChanged: (_) => _calculateTotal(),
                  ),
                  CustomSpacer(),

                  Row(
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
                    label: 'Photo principale *',
                    hint: 'Sélectionner l\'image de couverture',
                    errorText:
                        _mainPhotoError ?? state.formErrors?['main_image'],
                    onFileSelected: (file) {
                      setState(() {
                        _mainPhoto = file;
                        _mainPhotoError = null;
                      });
                    },
                  ),
                  CustomSpacer(),

                  ...List.generate(5, (index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: FilePickerWidget(
                        label:
                            'Photo suppl. ${index + 1} ${index == 0 ? "*" : ""}',
                        hint: 'Ajouter une photo supplémentaire',
                        errorText:
                            index == 0
                                ? (_suppPhotosError ??
                                    state.formErrors?['additional_images1'])
                                : state
                                    .formErrors?['additional_images${index + 1}'],
                        onFileSelected: (file) {
                          setState(() {
                            _suppPhotos[index] = file;
                            _suppPhotosError = null;
                          });
                        },
                      ),
                    );
                  }),

                  CustomSpacer(),
                  CustomInputText(
                    controller: _videoUrlController,
                    labelText: 'Vidéo 3D / visite virtuelle (lien ou iframe)',
                    maxLines: 2,
                    hintText: 'Collez le lien ou le code iframe ici',
                    errorText: state.formErrors?['video_3d'],
                  ),
                  CustomSpacer(),
                  CustomInputText(
                    controller: _descriptionController,
                    labelText: 'Description détaillée',
                    maxLines: 4,
                    hintText: 'Décrivez les atouts du bien...',
                    errorText: state.formErrors?['description'],
                  ),

                  SizedBox(height: 48.h),
                  CustomButton(
                    text:
                        state.isCreatingProperty
                            ? 'ENVOI EN COURS...'
                            : 'ENREGISTRER LE BIEN',
                    onPressed: state.isCreatingProperty ? null : _submit,
                    width: double.infinity,
                  ),
                  SizedBox(height: 20.h),
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
        color: AppColors.orange.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.orange.withValues(alpha: 0.1)),
      ),
      child: Text(
        title.toUpperCase(),
        style:
            TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.orange,
              letterSpacing: 1.1,
            ).sourceSansProBold,
      ),
    );
  }
}
