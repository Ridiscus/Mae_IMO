part of 'index.dart';

class PaymentStatusModel {
  final String label;
  final Color color;
  final IconData icon;

  PaymentStatusModel({
    required this.label,
    required this.color,
    required this.icon,
  });

  static PaymentStatusModel fromText(String? status) {
    if (status == null) {
      return PaymentStatusModel(
        label: 'En attente',
        color: AppColors.primary,
        icon: Icons.pending,
      );
    }
    switch (status.toUpperCase()) {
      case 'EN ATTENTE':
        return PaymentStatusModel(
          label: 'En attente',
          color: AppColors.orange,
          icon: Icons.pending,
        );
      case 'PAYÉ':
        return PaymentStatusModel(
          label: 'Payé',
          color: AppColors.success,
          icon: Icons.check_circle,
        );
      case 'ANNULÉ':
        return PaymentStatusModel(
          label: 'Annulé',
          color: AppColors.redColor,
          icon: Icons.error,
        );
      default:
        return PaymentStatusModel(
          label: status,
          color: AppColors.primary,
          icon: Icons.tag,
        );
    }
  }
}
