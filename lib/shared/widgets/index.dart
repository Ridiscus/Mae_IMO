// Fichier d'exports pour les widgets partagés
// Utilisez 'import 'package:maelys_imo/shared/widgets/index.dart';' 
// pour importer tous les widgets en une seule ligne

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:maelys_imo/core/constants/assets.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/presentation/portal/pages/portal_page.dart' show PortalPage;
import 'package:maelys_imo/shared/models/index.dart';

import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../core/constants/app_colors.dart' show AppColors;
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


