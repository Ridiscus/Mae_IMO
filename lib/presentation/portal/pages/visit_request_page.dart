import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/domain/models/index.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/core/manager/state/estate/estate_bloc.dart';
import 'package:maelys_imo/presentation/portal/pages/portal_page.dart';
import 'package:maelys_imo/shared/widgets/index.dart';

import '../../../core/domain/requests/index.dart';
import '../../../core/utils/toast/notification_toast.dart';

class VisitRequestPage extends StatefulWidget {
  static const routeName = 'visitRequest';
  static const routePath = '/visit-request';

  const VisitRequestPage({super.key});

  @override
  State<VisitRequestPage> createState() => _VisitRequestPageState();
}

class _VisitRequestPageState extends State<VisitRequestPage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay? selectedTime = TimeOfDay.now();
  String selectedTimeDisplay = CustomTimePickerFactory.formatTimeOfDay(
    TimeOfDay.now(),
  );
  EstateModel? _property;

  final TextEditingController _nameController = TextEditingController(),
      _emailController = TextEditingController(),
      _messageController = TextEditingController(),
      _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = context.select((EstateBloc value) => value.state);
    _property = state.estate;
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildVisitForm()),

            _buildRequestButton(),
            SpacerPlatform(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(left: 16.sp, right: 16.sp, bottom: 16.sp),
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
      color: AppColors.scaffold,
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
          label: 'Type : ${_property?.type ?? ""}',
        ),
        CustomSpacer(),
        _buildSummaryItem(
          icon: Icons.location_on_outlined,
          label: 'Localisation : ${_property?.commune ?? ''}',
        ),
        CustomSpacer(),
        _buildSummaryItem(
          icon: Icons.payments_outlined,
          label: 'Prix : ${'${_property?.prix}'.formatCurrency()}',
        ),
        CustomSpacer(),
        _buildSummaryItem(
          icon: Icons.hotel_outlined,
          label: 'Chambres : ${_property?.nombreChambres ?? '0'}',
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
          displayText: selectedDate.humanWithoutTime(),
          firstDate: DateTime.now(),
          onDateSelected: (DateTime date) {
            setState(() {
              // Format the date as needed
              selectedDate = date;
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
        CustomTimePickerFactory.createTimePicker(
          displayText: selectedTimeDisplay,

          onTimeSelected: (TimeOfDay time) {
            setState(() {
              selectedTime = time;
              selectedTimeDisplay = CustomTimePickerFactory.formatTimeOfDay(
                time,
              );
            });
          },
          initialTime: selectedTime,
          hintText: 'Sélectionnez une heure',
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nom complet',
          style:
              TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ).sourceSansProSemiBold,
        ),
        SizedBox(height: 8.h),
        CustomInputTextFactory.createTextInput(
          hintText: 'Votre nom complet',
          controller: _nameController,
        ),
        CustomSpacer(),
        Text(
          'Email',
          style:
              TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ).sourceSansProSemiBold,
        ),
        SizedBox(height: 8.h),
        CustomInputTextFactory.createEmailInput(
          hintText: 'Votre email',
          controller: _emailController,
        ),
        CustomSpacer(),
        Text(
          'Téléphone',
          style:
              TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ).sourceSansProSemiBold,
        ),
        SizedBox(height: 8.h),
        CustomInputTextFactory.createPhoneInput(
          hintText: 'Votre téléphone',
          controller: _phoneController,
        ),
        CustomSpacer(),
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
          controller: _messageController,
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
          BlocConsumer<EstateBloc, EstateState>(
            listener: (context, state) {
              if (state.isLoading == false && state.messageResult != null) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Demande de envoyé'),
                      content: Text(state.messageResult!),
                      actions: [
                        TextButton(
                          onPressed: () {
                            context.goNamed(PortalPage.routeName);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            builder: (context, state) {
              return CustomButton(
                text: 'Demander une visite',
                isLoading: state.isLoading ?? false,
                onPressed: () {
                  if (_emailController.text.trim().isEmpty) {
                    showToast(msg: "Votre email est invalide");
                    return;
                  }

                  if (_phoneController.text.trim().isEmpty) {
                    showToast(msg: "Votre téléphone est obligatoire");
                    return;
                  }

                  if (_nameController.text.trim().isEmpty) {
                    showToast(msg: "Votre nom est obligatoire");
                    return;
                  }
                  if (_messageController.text.trim().isEmpty) {
                    showToast(msg: "Un message est obligatoire");
                    return;
                  }

                  context.read<EstateBloc>().add(
                    SendVisiteRequestEstateEvent(
                      dto: VisiteEstateRequest(
                        bienId: _property!.id!,
                        message: _messageController.text,
                        dateVisite: selectedDate,
                        heureVisite: selectedTimeDisplay,
                        email: _emailController.text,
                        nom: _nameController.text,
                        telephone: _phoneController.text,
                      ),
                    ),
                  );
                },
                showArrow: true,
                iconData: Icons.calendar_month,
              );
            },
          ),
        ],
      ),
    );
  }
}
