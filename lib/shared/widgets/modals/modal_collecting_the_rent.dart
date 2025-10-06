part of 'index.dart';

class ModalCollectingTheRent extends StatefulWidget {
  /// Function to execute when payment is validated
  final VoidCallback onValidated;

  /// Function to execute when payment is canceled
  final VoidCallback onCancel;

  /// Tenant ID for the payment
  final int tenantId;

  /// Optional: Amount to display in the modal
  final String? amount;

  /// Optional: Description or note for the payment
  final String? description;

  const ModalCollectingTheRent({
    super.key,
    required this.onValidated,
    required this.onCancel,
    required this.tenantId,
    this.amount,
    this.description,
  });

  @override
  State<ModalCollectingTheRent> createState() => _ModalCollectingTheRentState();
}

class _ModalCollectingTheRentState extends State<ModalCollectingTheRent> {
  final _codeController = TextEditingController();
  final _monthsController = TextEditingController(text: '1');
  int _selectedMonths = 1;
  bool _isCodeGenerated = false;

  late PaymentState _paymentState;
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    _monthsController.dispose();
    super.dispose();
  }

  void _generateCode() {
    final request = EncashedRequest(
      locataireId: widget.tenantId,
      nombreMois: _selectedMonths,
    );

    context.read<PaymentBloc>().add(GenerateCashCodeEvent(dto: request));
  }

  void _validateCode() {
    if (_codeController.text.isEmpty) return;

    final request = ValidateEncashedRequest(
      locataireId: widget.tenantId,
      code: _codeController.text,
      nombreMois: _selectedMonths,
    );

    context.read<PaymentBloc>().add(ValidateCashCodeEvent(dto: request));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state.codeGenerated == true) {
          setState(() {
            _isCodeGenerated = true;
          });
        }

        if (state.codeValidated == true) {
          widget.onValidated();
          Navigator.pop(context);
          // Navigation vers HomeAgentPage
          context.goNamed(HomeAgentPage.routeName);
        }
      },
      child: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          _paymentState = state;
          _isLoading = state.isLoading;

          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Container(
              padding: EdgeInsets.all(24.sp),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildModalHeader(),
                    CustomSpacer(),
                    if (!_isCodeGenerated) ...[
                      _buildMonthsSelection(),
                      CustomSpacer(),
                      _buildAmountSection(),
                      CustomSpacer(),
                      _buildGenerateCodeButton(),
                    ] else ...[
                      _buildCodeGeneratedInfo(),
                      CustomSpacer(),
                      _buildCodeInput(),
                      CustomSpacer(),
                      _buildValidateButton(),
                    ],
                    CustomSpacer(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildModalHeader() {
    return Column(
      children: [
        Text(
          _isCodeGenerated
              ? 'Saisir le code de validation'
              : 'Encaissement du loyer',
          style:
              TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ).sourceSansProBold,
        ),
        CustomSpacer(space: 0.5),
        Text(
          _isCodeGenerated
              ? 'Demandez au locataire de saisir le code reçu'
              : 'Saisissez le nombre de mois à encaisser',
          textAlign: TextAlign.center,
          style:
              TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ).sourceSansProRegular,
        ),
      ],
    );
  }

  Widget _buildMonthsSelection() {
    return CustomInputTextFactory.createTextNumberInput(
      controller: _monthsController,
      labelText: 'Nombre de mois',
      hintText: 'Saisissez le nombre de mois (1-12)',
      onChanged: (value) {
        final months = int.tryParse(value) ?? 1;
        if (months >= 1 && months <= 12) {
          setState(() {
            _selectedMonths = months;
          });
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez saisir le nombre de mois';
        }
        final months = int.tryParse(value);
        if (months == null || months < 1 || months > 12) {
          return 'Le nombre de mois doit être entre 1 et 12';
        }
        return null;
      },
    );
  }

  Widget _buildAmountSection() {
    if (widget.amount == null && !_isCodeGenerated)
      return const SizedBox.shrink();

    final displayAmount = widget.amount ?? '0';
    final totalAmount =
        int.tryParse(displayAmount.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final monthlyAmount = totalAmount * _selectedMonths;

    return Column(
      children: [
        Text(
          'Montant total',
          style:
              TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ).sourceSansProRegular,
        ),
        CustomSpacer(space: 0.5),
        Text(
          '${monthlyAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ')} FCFA',
          style:
              TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ).sourceSansProBold,
        ),
        if (_selectedMonths > 1) ...[
          CustomSpacer(space: 0.3),
          Text(
            '$displayAmount FCFA × $_selectedMonths mois',
            style:
                TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[500],
                ).sourceSansProRegular,
          ),
        ],
      ],
    );
  }

  Widget _buildGenerateCodeButton() {
    return CustomButton(
      text: 'Générer le code de paiement',
      onPressed: _isLoading ? null : _generateCode,
      isLoading: _isLoading,
      buttonVariant: ButtonVariant.primary,
      textStyle:
          TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ).sourceSansProBold,
    );
  }

  Widget _buildCodeGeneratedInfo() {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(Icons.check_circle, color: AppColors.primary, size: 48.sp),
          CustomSpacer(space: 0.5),
          Text(
            'Code généré avec succès',
            style:
                TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ).sourceSansProBold,
          ),
          CustomSpacer(space: 0.5),
          Text(
            'Le locataire a reçu un code de validation. Demandez-lui de vous le communiquer pour valider le paiement.',
            textAlign: TextAlign.center,
            style:
                TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ).sourceSansProRegular,
          ),
        ],
      ),
    );
  }

  Widget _buildCodeInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Code de validation',
          style:
              TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ).sourceSansProSemiBold,
        ),
        CustomSpacer(space: 0.5),
        TextFormField(
          controller: _codeController,
          decoration: InputDecoration(
            hintText: 'Saisissez le code reçu par le locataire',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.sp,
              vertical: 16.sp,
            ),
          ),
          style: TextStyle(fontSize: 16.sp).sourceSansProRegular,
          textCapitalization: TextCapitalization.characters,
        ),
      ],
    );
  }

  Widget _buildValidateButton() {
    return CustomButton(
      text: 'Valider le paiement',
      onPressed:
          _isLoading || _codeController.text.isEmpty ? null : _validateCode,
      isLoading: _isLoading,
      buttonVariant: ButtonVariant.primary,
      textStyle:
          TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ).sourceSansProBold,
    );
  }
}
