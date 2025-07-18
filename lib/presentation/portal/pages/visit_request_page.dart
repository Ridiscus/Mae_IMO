import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/shared/widgets/index.dart';

class VisitRequestPage extends StatefulWidget {
  static const routeName = 'visitRequest';
  static const routePath = '/visit-request';

  const VisitRequestPage({super.key});

  @override
  State<VisitRequestPage> createState() => _VisitRequestPageState();
}

class _VisitRequestPageState extends State<VisitRequestPage> {
  String selectedDate = 'Date picker';
  String selectedTime = 'Matin';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [_buildHeader(), Expanded(child: _buildVisitForm())],
      ),
      floatingActionButton: _buildRequestButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(left: 16.r, right: 16.r),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircularBackButton(),
            CustomSpacer(),
            Text(
              'Demande de visite',
              style:
                  TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ).sourceSansProBold,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisitForm() {
    return Container(
      width: double.infinity,
      color: Color(0xFFF5F5F5),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPropertySummary(),
              CustomSpacer(space: 2),
              _buildDatePicker(),
              CustomSpacer(),
              _buildTimePicker(),
              CustomSpacer(),
              _buildAdditionalInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPropertySummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Détails de la propriété',
          style:
              TextStyle(
                fontSize: 20.r,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ).sourceSansProBold,
        ),
        CustomSpacer(),
        _buildSummaryItem(
          icon: Icons.home_outlined,
          label: 'Type : Appartement',
        ),
        CustomSpacer(),
        _buildSummaryItem(
          icon: Icons.location_on_outlined,
          label: 'Localisation : Cocody',
        ),
        CustomSpacer(),
        _buildSummaryItem(
          icon: Icons.payments_outlined,
          label: 'Prix : 150 000 FCFA',
        ),
        CustomSpacer(),
        _buildSummaryItem(icon: Icons.hotel_outlined, label: 'Chambres : 2'),
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
          'Date de visite souhaitée',
          style:
              TextStyle(
                fontSize: 18.r,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ).sourceSansProSemiBold,
        ),
        SizedBox(height: 8.h),
        CustomDatePickerFactory.createDatePicker(
          displayText: selectedDate,
          onDateSelected: (DateTime date) {
            setState(() {
              // Format the date as needed
              selectedDate =
                  '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
            });
          },
          hintText: 'Sélectionnez une date',
        ),
      ],
    );
  }

  Widget _buildTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Heure de visite préférée',
          style:
              TextStyle(
                fontSize: 18.r,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ).sourceSansProSemiBold,
        ),
        SizedBox(height: 8.h),
        CustomDropdownFactory.createDropdown<String>(
          value: selectedTime,
          items: <String>['Matin', 'Après-midi', 'Soirée'],
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedTime = newValue;
              });
            }
          },
          itemLabelBuilder: (String value) => value,
          hintText: 'Sélectionnez une plage horaire',
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informations supplémentaires',
          style:
              TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ).sourceSansProSemiBold,
        ),
        SizedBox(height: 8.h),
        CustomInputTextFactory.createTextAreaInput(
          hintText: 'Commentaires ou questions spécifiques...',
        ),
      ],
    );
  }

  Widget _buildRequestButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomButton(
            text: 'Demander une visite',
            onPressed: () {
              // Handle visit request
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Demande envoyée'),
                    content: Text(
                      'Votre demande de visite a été envoyée avec succès. Un agent vous contactera prochainement pour confirmation.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
            showArrow: true,
            iconData: Icons.calendar_month,
          ),
        ],
      ),
    );
  }
}
