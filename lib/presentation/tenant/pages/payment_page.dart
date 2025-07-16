import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maelys_imo/core/extensions/index.dart';

class PaymentPage extends StatefulWidget {
  static const routeName = 'payment';
  static const routePath = '/payment';

  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedDate = 'Date picker';
  String selectedPaymentMethod = 'Option 1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _buildPaymentForm(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.r,
        left: 16.r,
        right: 16.r,
        bottom: 24.r,
      ),
      width: double.infinity,
      color: Color(0xFF0A2342),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: 30.r,
            ),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
          SizedBox(height: 16.r),
          Text(
            'Payer mon loyer',
            style: TextStyle(
              fontSize: 28.r,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ).sourceSansProBold,
          ),
          SizedBox(height: 8.r),
          Center(
            child: Text(
              '07/2025',
              style: TextStyle(
                fontSize: 16.r,
                color: Colors.white70,
              ).sourceSansProRegular,
            ),
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
              SizedBox(height: 32.r),
              _buildDatePicker(),
              SizedBox(height: 24.r),
              _buildPaymentMethodPicker(),
              Padding(
                padding: EdgeInsets.only(top: 48.r, bottom: 24.r),
                child: _buildPaymentButton(),
              ),
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
          style: TextStyle(
            fontSize: 20.r,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ).sourceSansProBold,
        ),
        SizedBox(height: 16.r),
        _buildSummaryItem(
          icon: Icons.home_outlined,
          label: 'Type : villa',
        ),
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

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24.r,
          color: Colors.black87,
        ),
        SizedBox(width: 12.r),
        Text(
          label,
          style: TextStyle(
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
          style: TextStyle(
            fontSize: 18.r,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ).sourceSansProSemiBold,
        ),
        SizedBox(height: 12.r),
        GestureDetector(
          onTap: () {
            // Show date picker
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate,
                  style: TextStyle(
                    fontSize: 16.r,
                    color: Colors.grey[600],
                  ).sourceSansProRegular,
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey[600],
                  size: 24.r,
                ),
              ],
            ),
          ),
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
          style: TextStyle(
            fontSize: 18.r,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ).sourceSansProSemiBold,
        ),
        SizedBox(height: 12.r),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedPaymentMethod,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedPaymentMethod = newValue;
                  });
                }
              },
              items: <String>['Option 1', 'Option 2', 'Option 3']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 16.r,
                      color: Colors.grey[600],
                    ).sourceSansProRegular,
                  ),
                );
              }).toList(),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey[600],
                size: 24.r,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentButton() {
    return Container(
      width: double.infinity,
      height: 56.r,
      child: ElevatedButton(
        onPressed: () {
          // Process payment
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF0A2342),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Payer mon loyer',
              style: TextStyle(
                fontSize: 18.r,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ).sourceSansProBold,
            ),
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 16.r,
              child: Icon(
                Icons.arrow_forward,
                color: Color(0xFF0A2342),
                size: 20.r,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
