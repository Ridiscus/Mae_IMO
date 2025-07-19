part of 'index.dart';

class ModalCollectingTheRent extends StatefulWidget {
  /// Function to execute when payment is validated
  final VoidCallback onValidated;

  /// Function to execute when payment is canceled
  final VoidCallback onCancel;

  /// Optional: Amount to display in the modal
  final String? amount;

  /// Optional: Description or note for the payment
  final String? description;

  const ModalCollectingTheRent({
    super.key,
    required this.onValidated,
    required this.onCancel,
    this.amount,
    this.description,
  });

  @override
  State<ModalCollectingTheRent> createState() => _ModalCollectingTheRentState();
}

class _ModalCollectingTheRentState extends State<ModalCollectingTheRent> {
  final _pinController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  // Expected PIN for demo purposes - in a real app this would be handled by a backend
  final _expectedPin = '1234';

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _validatePin() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate network delay
    Future.delayed(const Duration(seconds: 1), () {
      if (_pinController.text == _expectedPin) {
        widget.onValidated();
        Navigator.pop(context);
      } else {
        setState(() {
          _errorMessage = 'Code incorrect. Veuillez réessayer.';
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildModalHeader(),
            CustomSpacer(),
            _buildAmountSection(),
            CustomSpacer(),
            _buildPinInput(),
            if (_errorMessage != null) ...[
              CustomSpacer(),
              _buildErrorMessage(),
            ],
            CustomSpacer(space: 2),
            _buildButtons(),
            CustomSpacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildModalHeader() {
    return Column(
      children: [
        Text(
          'Validation du paiement',
          style:
              TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ).sourceSansProBold,
        ),
        if (widget.description != null) ...[
          CustomSpacer(space: 0.5),
          Text(
            widget.description!,
            textAlign: TextAlign.center,
            style:
                TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ).sourceSansProRegular,
          ),
        ],
      ],
    );
  }

  Widget _buildAmountSection() {
    if (widget.amount == null) return const SizedBox.shrink();

    return Column(
      children: [
        Text(
          'Montant',
          style:
              TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ).sourceSansProRegular,
        ),
        CustomSpacer(space: 0.5),
        Text(
          '${widget.amount} FCFA',
          style:
              TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ).sourceSansProBold,
        ),
      ],
    );
  }

  Widget _buildPinInput() {
    final defaultPinTheme = PinTheme(
      width: 60.w,
      height: 60.w,
      textStyle:
          TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ).sourceSansProSemiBold,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.primary),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: Colors.red),
      ),
    );

    return Column(
      children: [
        Text(
          'Saisissez le code de validation',
          style:
              TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ).sourceSansProRegular,
        ),
        CustomSpacer(),
        Pinput(
          controller: _pinController,
          length: 4,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          errorPinTheme: errorPinTheme,
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          onCompleted: (_) => _validatePin(),
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Text(
      _errorMessage!,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16.sp, color: Colors.red).sourceSansProRegular,
    );
  }

  Widget _buildButtons() {
    return CustomButton(
      text: 'Valider le paiement',
      onPressed: _isLoading ? null : _validatePin,
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
