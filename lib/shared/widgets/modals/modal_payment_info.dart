part of 'index.dart';

class ModalPaymentInfo extends StatelessWidget {
  /// Le mois du paiement
  final String month;

  /// Le montant du paiement
  final String amount;

  /// La date du paiement
  final String date;

  /// Le statut du paiement
  final PaymentStatusModel status;

  /// Numéro de référence du paiement
  final String? reference;

  /// Méthode de paiement utilisée
  final String? paymentMethod;

  /// Nom du bénéficiaire
  final String? recipientName;

  const ModalPaymentInfo({
    super.key,
    required this.month,
    required this.amount,
    required this.date,
    required this.status,
    this.reference,
    this.paymentMethod,
    this.recipientName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              CustomSpacer(),
              _buildAmountSection(),
              CustomSpacer(),
              _buildDetailsSection(),
              CustomSpacer(),
              _buildCloseButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Text(
            'Détails du paiement',
            style:
                TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ).sourceSansProBold,
          ),
          CustomSpacer(space: 0.5),
          Text(
            'Loyer du mois de $month',
            textAlign: TextAlign.center,
            style:
                TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ).sourceSansProRegular,
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: status.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(status.icon, color: status.color, size: 40.sp),
          ),
        ),
        CustomSpacer(),
        Center(
          child: Column(
            children: [
              Text(
                amount,
                style:
                    TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ).sourceSansProBold,
              ),
              CustomSpacer(space: 0.5),
              CustomTag(label: status.label, color: status.color),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsSection() {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          _buildDetailRow(
            label: 'Date de paiement',
            value: date,
            icon: Icons.calendar_today,
          ),
          if (reference != null) ...[
            Divider(height: 24.sp, color: Colors.grey.withValues(alpha: 0.2)),
            _buildDetailRow(
              label: 'Référence',
              value: reference!,
              icon: Icons.receipt_long,
            ),
          ],
          if (paymentMethod != null) ...[
            Divider(height: 24.sp, color: Colors.grey.withValues(alpha: 0.2)),
            _buildDetailRow(
              label: 'Méthode de paiement',
              value: paymentMethod!,
              icon: Icons.payment,
            ),
          ],
          if (recipientName != null) ...[
            Divider(height: 24.sp, color: Colors.grey.withValues(alpha: 0.2)),
            _buildDetailRow(
              label: 'Bénéficiaire',
              value: recipientName!,
              icon: Icons.person,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          width: 40.sp,
          height: 40.sp,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20.sp),
        ),
        SizedBox(width: 16.sp),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style:
                    TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ).sourceSansProRegular,
              ),
              Text(
                value,
                style:
                    TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ).sourceSansProSemiBold,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Center(
      child: CustomButton(
        text: 'Fermer',
        onPressed: () => Navigator.pop(context),
        buttonVariant: ButtonVariant.primary,
        textStyle:
            TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ).sourceSansProBold,
      ),
    );
  }
}
