part of 'index.dart';

class ModalVerifyEstateLocationCode extends StatefulWidget {
  /// Tenant ID for verification
  final int tenantId;

  /// Callback when code is verified successfully
  final VoidCallback onVerified;

  const ModalVerifyEstateLocationCode({
    super.key,
    required this.tenantId,
    required this.onVerified,
  });

  @override
  State<ModalVerifyEstateLocationCode> createState() =>
      _ModalVerifyEstateLocationCodeState();
}

class _ModalVerifyEstateLocationCodeState
    extends State<ModalVerifyEstateLocationCode> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _verifyCode(BuildContext context) {
    if (_codeController.text.trim().isEmpty) {
      showToast(
        msg: 'Veuillez saisir le code de vérification',
        type: ToastificationType.error,
      );
      return;
    }

    // Verify code
    context.read<InventoriesBloc>().add(
          VerifyCodeEtatLieuxEvent(
            locataireId: widget.tenantId,
            verificationCode: _codeController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InventoriesBloc, InventoriesState>(
      listener: (context, state) {
        // Handle code verified successfully
        if (state.codeVerified == true) {
          // Close the modal
          Navigator.of(context).pop();
          // Call the callback
          widget.onVerified();
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20.sp,
          right: 20.sp,
          top: 20.sp,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vérification du code OTP',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ).sourceSansProBold,
            ),
            SizedBox(height: 12.sp),
            Text(
              'Un code de vérification a été envoyé au locataire. Veuillez saisir le code communiqué par le locataire.',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black87,
              ).sourceSansProRegular,
            ),
            SizedBox(height: 20.sp),
            CustomInputTextFactory.createTextInput(
              controller: _codeController,
              hintText: 'Code de vérification',
              labelText: 'Code OTP',
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 20.sp),
            SafeArea(
              left: false,
              right: false,
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.sp),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Annuler',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ).sourceSansProSemiBold,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.sp),
                  Expanded(
                    child: BlocBuilder<InventoriesBloc, InventoriesState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: 'Vérifier',
                          onPressed: () => _verifyCode(context),
                          isLoading: state.isLoading ?? false,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.sp),
          ],
        ),
      ),
    );
  }
}
