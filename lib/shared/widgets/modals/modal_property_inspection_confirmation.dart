part of 'index.dart';

class ModalPropertyInspectionConfirmation extends StatefulWidget {
  final VoidCallback onValidated;
  final VoidCallback onCancel;

  const ModalPropertyInspectionConfirmation({
    super.key,
    required this.onValidated,
    required this.onCancel,
  });

  @override
  State<ModalPropertyInspectionConfirmation> createState() =>
      _ModalPropertyInspectionConfirmationState();
}

class _ModalPropertyInspectionConfirmationState
    extends State<ModalPropertyInspectionConfirmation> {
  final _pinController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  // Current verification method (PIN or QR)
  VerificationMethod _verificationMethod = VerificationMethod.pin;

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
      padding: EdgeInsets.symmetric(horizontal: 24.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildModalTitle(),
            CustomSpacer(),
            _buildModalDescription(),
            CustomSpacer(),
            _buildVerificationMethodSelector(),
            CustomSpacer(),
            if (_verificationMethod == VerificationMethod.pin) ...[
              Center(child: _buildPinInput()),
              if (_errorMessage != null) ...[
                CustomSpacer(space: 0.5),
                _buildErrorMessage(),
              ],
            ] else ...[
              _buildQrCodeOption(),
            ],
            CustomSpacer(space: 2),
            _buildActions(context),
            SpacerPlatform(),
          ],
        ),
      ),
    );
  }

  Widget _buildModalTitle() {
    return Row(
      children: [
        Icon(Icons.description_outlined, size: 32.sp, color: AppColors.primary),
        SizedBox(width: 12.sp),
        Text(
          'Confirmation',
          style:
              TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ).sourceSansProBold,
        ),
      ],
    );
  }

  Widget _buildModalDescription() {
    return Text(
      'Vous êtes sur le point de valider l\'état des lieux de cette propriété. Cette action est irréversible.',
      style:
          TextStyle(
            fontSize: 16.sp,
            color: Colors.black87,
          ).sourceSansProRegular,
    );
  }

  Widget _buildVerificationMethodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Méthode de vérification',
          style:
              TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ).sourceSansProSemiBold,
        ),
        CustomSpacer(),
        Row(
          children: [
            Expanded(
              child: _buildMethodButton(
                icon: Icons.pin,
                title: 'Code PIN',
                isSelected: _verificationMethod == VerificationMethod.pin,
                onTap:
                    () => setState(
                      () => _verificationMethod = VerificationMethod.pin,
                    ),
              ),
            ),
            SizedBox(width: 24.sp),
            Expanded(
              child: _buildMethodButton(
                icon: Icons.qr_code_scanner,
                title: 'Scanner QR',
                isSelected: _verificationMethod == VerificationMethod.qrCode,
                onTap:
                    () => setState(
                      () => _verificationMethod = VerificationMethod.qrCode,
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMethodButton({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 8.sp),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color:
                isSelected
                    ? AppColors.primary
                    : Colors.grey.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28.sp,
              color: isSelected ? AppColors.primary : Colors.grey.shade700,
            ),
            SizedBox(height: 8.sp),
            Text(
              title,
              style:
                  TextStyle(
                    fontSize: 14.sp,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    color:
                        isSelected ? AppColors.primary : Colors.grey.shade700,
                  ).sourceSansProSemiBold,
            ),
          ],
        ),
      ),
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

  Widget _buildQrCodeOption() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 250.w,
            height: 250.w,
            child: QrCodeViewer(

              onQrCodeScanned: (String scannedCode) {
                // Vérifie si le code scanné correspond à celui attendu
                // Dans une vraie implémentation, comparez avec un code attendu
                if (scannedCode.isNotEmpty) {
                  widget.onValidated();
                } else {
                  setState(() {
                    _errorMessage = 'Code QR invalide. Veuillez réessayer.';
                  });
                }
              },
            ),
          ),
          if (_errorMessage != null) ...[
            CustomSpacer(space: 0.5),
            _buildErrorMessage(),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Center(
      child: Text(
        _errorMessage!,
        textAlign: TextAlign.center,
        style:
            TextStyle(fontSize: 16.sp, color: Colors.red).sourceSansProRegular,
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    if (_verificationMethod == VerificationMethod.pin) {
      return CustomButton(
        text: 'Valider avec code',
        onPressed: _isLoading ? null : _validatePin,
        isLoading: _isLoading,
        buttonVariant: ButtonVariant.primary,
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

enum VerificationMethod { pin, qrCode }
