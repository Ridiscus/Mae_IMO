// Fichier d'exports pour les widgets partagés
// Utilisez 'import 'package:maelys_imo/shared/widgets/index.dart';' 
// pour importer tous les widgets en une seule ligne

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:ios_keyboard_action/ios_keyboard_action.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/presentation/portal/pages/portal_page.dart' show PortalPage;
import 'package:maelys_imo/shared/models/index.dart';

import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../core/constants/app_colors.dart' show AppColors;
import '../../core/domain/models/index.dart';
import '../../core/manager/state/estate/estate_bloc.dart';
import '../../core/utils/index.dart';
import '../../presentation/tenant/pages/contact_agency_page.dart';

// Export QrCodeViewer comme un widget autonome (ne fait pas partie de l'index)
part 'qr_code_viewer.dart';

part 'category_list.dart';
part 'circular_icon.dart';
part 'custom_button.dart';
part 'custom_circle_avatar_user.dart';
part 'custom_date_picker.dart';
part 'custom_drawer.dart';
part 'custom_dropdown.dart';
part 'custom_input_text.dart';
part 'custom_scaffold.dart';
part 'custom_spacer.dart';
part 'custom_tag.dart';
part 'latyout/form_with_header_layout.dart';
part 'latyout/app_header_layout.dart';
part 'latyout/page_with_header_layout.dart';
part 'latyout/profile_page_layout.dart';
part 'back_button.dart';
part 'circular_signout_button.dart';
part 'property_card.dart';
part 'spacer_platform.dart';
part 'scaffold_with_bottom_nav.dart';
part 'pagination_dot.dart';

// Widgets exportés directement (non-part)
part 'illustration_header.dart';
part 'custom_qr_code_view.dart';
part 'info_card_widget.dart';
part 'info_row_widget.dart';
part 'stats_card_widget.dart';
part 'scrollable_body_widget.dart';
part 'icon_button_menu.dart';
part 'custom_navigation_bar.dart';
part 'empty_state_widget.dart';
part 'amenity_chip.dart';


