import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/constants/assets.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/shared/widgets/index.dart';

class PaymentPage extends StatefulWidget {
  static const routeName = 'payment';
  static const routePath = '/payment';

  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  DateTime selectedDate = DateTime.now();
  String selectedPaymentMethod = 'Option 1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [_buildHeader(), Expanded(child: _buildPaymentForm())],
      ),
      floatingActionButton: _buildPaymentButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeader() {
    return AppHeaderLayout(
      padding: EdgeInsets.only(left: 16.sp, right: 16.sp, bottom: 16.sp),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircularBackButton(),
          CustomSpacer(),
          Text(
            'Payer mon loyer',
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ).sourceSansProBold,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentForm() {
    return Container(
      width: double.infinity,
      color: Color(0xFFF5F5F5),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummarySection(),
              CustomSpacer(space: 2),
              _buildDatePicker(),
              CustomSpacer(),
              _buildPaymentMethodPicker(),
            ],
          ),
        ),
      ),
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
        _buildSummaryItem(icon: Icons.home_outlined, label: 'Type : villa'),
        SizedBox(height: 12.r),
        _buildSummaryItem(
          icon: Icons.location_on_outlined,
          label: 'Localisation : Marcory',
        ),
        SizedBox(height: 12.r),
        _buildSummaryItem(
          icon: Icons.payments_outlined,
          label: 'loyer : 200 000 FCFA',
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

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choix de la période',
          style:
              TextStyle(
                fontSize: 18.r,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ).sourceSansProSemiBold,
        ),
        SizedBox(height: 12.r),
        CustomDatePickerFactory.createDatePicker(
          displayText: selectedDate.humanWithoutTime(),
          onDateSelected: (DateTime date) {
            setState(() {
              // Format the date as needed
              selectedDate = date;
            });
          },
          hintText: 'Sélectionnez une période',
        ),
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

        CustomDropdownFactory.createDropdown<String>(
          value: selectedPaymentMethod,
          items: <String>['Option 1', 'Option 2', 'Option 3'],
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedPaymentMethod = newValue;
              });
            }
          },
          itemLabelBuilder: (String value) => value,
          hintText: 'Sélectionnez une option',
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
            text: 'Payer mon loyer',
            onPressed: () {},
            showArrow: true,
            assetPath: Assets.monney,
          ),
        ],
      ),
    );
  }
}
