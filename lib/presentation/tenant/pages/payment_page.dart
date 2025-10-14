import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:maelys_imo/core/constants/assets.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/core/manager/state/auth/auth_bloc.dart';
import 'package:maelys_imo/core/manager/state/dashboard/dashboard_bloc.dart';
import 'package:maelys_imo/core/manager/state/payment/payment_bloc.dart';
import 'package:maelys_imo/core/utils/index.dart';
import 'package:maelys_imo/core/utils/toast/notification_toast.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/domain/models/index.dart';
import '../../../core/domain/requests/index.dart';

class PaymentPage extends StatefulWidget {
  static const routeName = 'payment';
  static const routePath = '/payment';

  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  String? selectedPaymentMethod;
  final TextEditingController _transactionIdController =
      TextEditingController();
  final TextEditingController _numberMonthControler = TextEditingController();
  File? selectedFile;
  String? selectedFileName;
  FocusNode _focusNode = FocusNode();

  bool isLoading = false;

  TenantDashboardModel? dashboardModel;

  UserModel? userModel;

  @override
  void dispose() {
    _transactionIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dashboardModel = context.select(
      (DashboardBloc bloc) => bloc.state.tenantDashboardModel,
    );
    userModel = context.select((AuthBloc bloc) => bloc.state.userModel);

    return BlocConsumer<PaymentBloc, PaymentState>(
      listener: (context, state) {
        setState(() {
          isLoading = state.isLoading;
        });

        if (state.paymentSuccess == true && state.cinetpayData == null) {
          _resetForm();
        }
        // if(state.cinetpayData != null){
        //   context.pushNamed(CheckoutCinetpayPage.routeName);
        // }

        if (state.cinetpayData != null || state.initPaymentModel != null) {
          CoreHelper.launchLink(state.initPaymentModel?.paymentUrl ?? '', launchMode: LaunchMode.externalApplication);
          // context.pushNamed(CheckoutCinetpayPage.routeName);
        }
      },
      builder: (context, state) {
        return PageWithHeaderLayout(
          headerContent: _buildHeaderContent(),
          bodyContent: Form(key: _formKey, child: _buildPaymentForm()),
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
          'Payer mon loyer',
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

  Widget _buildPaymentForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSummarySection(),
        CustomSpacer(space: 2),
        _buildNumberMonthField(),
        CustomSpacer(),
        _buildPaymentMethodPicker(),
        if (selectedPaymentMethod != null) ...[
          CustomSpacer(),
          _buildConditionalFields(),
        ],
        CustomSpacer(space: 10),
        _buildPaymentButton(),
      ],
    );
  }

  Widget _buildSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Récapitulatif',
          style:
              TextStyle(
                fontSize: 20.r,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ).sourceSansProBold,
        ),
        SizedBox(height: 16.r),
        _buildSummaryItem(
          icon: Icons.home_outlined,
          label: 'Type : ${dashboardModel?.locataire?.estate?.type ?? ''}',
        ),
        SizedBox(height: 12.r),
        _buildSummaryItem(
          icon: Icons.location_on_outlined,
          label:
              'Localisation : ${dashboardModel?.locataire?.estate?.commune ?? ''}',
        ),
        SizedBox(height: 12.r),
        _buildSummaryItem(
          icon: Icons.payments_outlined,
          label:
              'loyer : ${dashboardModel?.locataire?.estate?.prix?.formatCurrency()}',
        ),
      ],
    );
  }

  Widget _buildSummaryItem({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(icon, size: 24.r, color: Colors.black87),
        SizedBox(width: 12.r),
        Text(
          label,
          style:
              TextStyle(
                fontSize: 16.r,
                color: Colors.black87,
              ).sourceSansProRegular,
        ),
      ],
    );
  }

  Widget _buildNumberMonthField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sélectionnez le nombre de mois à payer',
          style:
              TextStyle(
                fontSize: 18.r,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ).sourceSansProSemiBold,
        ),
        SizedBox(height: 12.r),

        CustomInputTextFactory.createTextNumberInput(
          isRequired: true,
          controller: _numberMonthControler,
          focusNode: _focusNode,
          hintText: "Entrez le nombre de mois à payer",
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Le nombre de mois est obligatoire";
            }
            if (int.tryParse(value) == null) {
              return "Le nombre de mois doit être un nombre";
            }
            if (int.tryParse(value) == 0) {
              return "Le nombre de mois doit être supérieur à 0";
            }
            return null;
          },
        ),
        /*InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM yyyy', 'fr_FR').format(selectedDate),
                  style:
                      TextStyle(
                        fontSize: 16.r,
                        color: Colors.black87,
                      ).sourceSansProRegular,
                ),
                Icon(Icons.calendar_today, size: 20.r, color: Colors.grey),
              ],
            ),
          ),
        ),*/
      ],
    );
  }

  Widget _buildPaymentMethodPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choix de la méthode de paiement',
          style:
              TextStyle(
                fontSize: 18.r,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ).sourceSansProSemiBold,
        ),

        SizedBox(height: 8.r),

        CustomDropdownFactory.createDropdown<String?>(
          value: selectedPaymentMethod,
          items: <String>['virement', 'mobile_money'],
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedPaymentMethod = newValue;
                // Réinitialiser les champs conditionnels
                _transactionIdController.clear();
                selectedFile = null;
                selectedFileName = null;
              });
            }
          },
          itemLabelBuilder: (String? value) {
            switch (value) {
              case 'virement':
                return 'Virement bancaire';
              case 'mobile_money':
                return 'Mobile Money';
              default:
                return '';
            }
          },
          hintText: 'Sélectionnez une méthode de paiement',
        ),
      ],
    );
  }

  Widget _buildPaymentButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomButton(
            isLoading: isLoading,
            text: 'Payer mon loyer',
            onPressed: () {
              if (_canSubmitPayment()) {
                _submitPayment(userModel?.id);
              }
            },
            showArrow: !isLoading,
            assetPath: Assets.monney,
          ),
        ],
      ),
    );
  }

  Widget _buildConditionalFields() {
    if (selectedPaymentMethod == 'virement') {
      return _buildFilePickerField();
    }
    // else if (selectedPaymentMethod == 'mobile_money') {
    //   return _buildTransactionIdField();
    // }
    return const SizedBox.shrink();
  }

  Widget _buildTransactionIdField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ID de transaction Mobile Money',
          style:
              TextStyle(
                fontSize: 18.r,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ).sourceSansProSemiBold,
        ),
        SizedBox(height: 12.r),
        CustomInputTextFactory.createTextInput(
          controller: _transactionIdController,
          focusNode: FocusNode(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer l\'ID de transaction';
            }
            if (value.length < 5) {
              return 'L\'ID de transaction doit contenir au moins 5 caractères';
            }
            return null;
          },
          hintText: 'Ex: MM_123456789',
        ),
      ],
    );
  }

  Widget _buildFilePickerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Justificatif de virement',
          style:
              TextStyle(
                fontSize: 18.r,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ).sourceSansProSemiBold,
        ),
        SizedBox(height: 12.r),
        InkWell(
          onTap: _pickFile,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(Icons.attach_file, size: 20.r, color: Colors.grey),
                SizedBox(width: 12.r),
                Expanded(
                  child: Text(
                    selectedFileName ??
                        'Sélectionner un fichier (PDF, JPG, JPEG, PNG)',
                    style:
                        TextStyle(
                          fontSize: 16.r,
                          color:
                              selectedFileName != null
                                  ? Colors.black87
                                  : Colors.grey,
                        ).sourceSansProRegular,
                  ),
                ),
                if (selectedFileName != null)
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedFile = null;
                        selectedFileName = null;
                      });
                    },
                    child: Icon(Icons.close, size: 20.r, color: Colors.red),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8.r),
        Text(
          'Formats acceptés: PDF, JPG, JPEG, PNG (Max 10MB)',
          style:
              TextStyle(
                fontSize: 12.r,
                color: Colors.grey.shade600,
              ).sourceSansProRegular,
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: 30 * 3)),
      lastDate: DateTime.now().add(
        const Duration(days: 365 * DateTime.monthsPerYear),
      ),
      locale: const Locale('fr', 'FR'),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileSize = await file.length();
        final fileName = result.files.single.name;

        // Validation de la taille du fichier (10MB max)
        if (fileSize > 10 * 1024 * 1024) {
          showToast(msg: 'Le fichier ne doit pas dépasser 10MB');
          return;
        }

        // Validation du type de fichier
        final extension = fileName.split('.').last.toLowerCase();
        if (!['pdf', 'jpg', 'jpeg', 'png'].contains(extension)) {
          showToast(
            msg:
                'Type de fichier non supporté. Seuls les fichiers PDF, JPG, JPEG et PNG sont acceptés.',
          );
          return;
        }

        setState(() {
          selectedFile = file;
          selectedFileName = fileName;
        });
      }
    } catch (e) {
      showToast(msg: 'Impossible de sélectionner le fichier');
    }
  }

  bool _canSubmitPayment() {
    if (_numberMonthControler.text.isEmpty) return false;

    if (selectedPaymentMethod == null) return false;

    if (selectedPaymentMethod == 'virement') {
      return selectedFile != null;
    }

    return true;
  }

  Future<void> _submitPayment(int? userId) async {
    if (userId == null) {
      showToast(msg: 'Utilisateur non identifié');
      return;
    }

    // Validation du formulaire
    if (!_formKey.currentState!.validate()) return;

    // Validation de la méthode de paiement
    if (selectedPaymentMethod == null) {
      showToast(msg: 'Veuillez sélectionner une méthode de paiement');
      return;
    }

    // Validation spécifique pour mobile money

    if (_numberMonthControler.text.trim().isEmpty) {
      showToast(msg: 'Veuillez saisir le nombre de mois à payé');
      return;
    }

    // Validation spécifique pour virement
    if (selectedPaymentMethod == 'virement') {
      if (selectedFile == null) {
        showToast(msg: 'Veuillez sélectionner un fichier de preuve');
        return;
      }
    }

    try {
      MultipartFile? proofFile;

      // Créer MultipartFile si un fichier est sélectionné
      if (selectedFile != null && selectedFileName != null) {
        proofFile = await MultipartFile.fromFile(
          selectedFile!.path,
          filename: selectedFileName,
        );
      }

      // Format du mois couvert (YYYY-MM)
      final moisCouvert = DateFormat('yyyy-MM').format(selectedDate);

      // Créer le DTO MakePaymentRequest
      final dto = MakePaymentRequest(
        moisCouvert: moisCouvert,
        methodePaiement: selectedPaymentMethod!,
        proofFile: proofFile,
      );

      context.read<PaymentBloc>().add(
        MakePaymentEvent(tenantId: userId, dto: dto),
      );
    } catch (e) {
      showToast(msg: 'Erreur lors de la préparation du paiement');
    }
  }

  void _resetForm() {
    setState(() {
      selectedDate = DateTime.now();
      selectedPaymentMethod = null;
      _transactionIdController.clear();
      selectedFile = null;
      selectedFileName = null;
    });
    _formKey.currentState?.reset();
    _focusNode.unfocus();
    context.pop();
  }
}
