import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:pinput/pinput.dart';

import '../../../core/domain/models/index.dart';
import '../../../core/domain/requests/index.dart';
import '../../../core/manager/state/payment/payment_bloc.dart';
import '../../../presentation/agent/pages/home_agent_page.dart';

part 'modal_collecting_the_rent.dart';
part 'modal_payment_info.dart';
// part 'modal_payment_validation.dart';
part 'modal_qr_code.dart';
part 'modal_property_inspection_confirmation.dart';