import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/constants/assets.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/core/manager/state/dashboard/dashboard_bloc.dart';
import 'package:maelys_imo/core/utils/index.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DocumentsTenantPage extends StatefulWidget {
  static const routeName = 'documentsTenant';
  static const routePath = '/documents-tenant';

  const DocumentsTenantPage({super.key});

  @override
  State<DocumentsTenantPage> createState() => _DocumentsTenantPageState();
}

class _DocumentsTenantPageState extends State<DocumentsTenantPage> {
  @override
  Widget build(BuildContext context) {
    return PageWithHeaderLayout(
      headerContent: _buildHeaderContent(),
      bodyContent: _buildContent(),
      onRefresh: () async {
        final completer = Completer<void>();

        // Écouter les changements d'état pour savoir quand le chargement est terminé
        late StreamSubscription subscription;
        subscription = context.read<DashboardBloc>().stream.listen((state) {
          if (state.isLoading ?? false) {
            subscription.cancel();
            completer.complete();
          }
        });

        // Déclencher le chargement des données
        context.read<DashboardBloc>().add(FetchTenantDashboardEvent());

        // Attendre que le chargement soit terminé
        return completer.future;
      },
    );
  }

  Widget _buildHeaderContent() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CircularBackButton(), // Retiré comme demandé
          CustomSpacer(),
          Text(
            'Mes documents',
            style:
                TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ).sourceSansProBold,
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final state = context.select((DashboardBloc bloc) => bloc.state);
    final tenantDashboardModel = state.tenantDashboardModel;
    final isLoading = state.isLoading ?? false;

    return (tenantDashboardModel?.documents ?? []).isEmpty
        ? SizedBox(
          height: context.getSize.height,
          child: EmptyStateWidget(
            title: "Aucun document trouvé !",
            icon: Icons.search_off,
          ),
        )
        : SizedBox(
          height: context.getSize.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...(tenantDashboardModel?.documents ?? [])
                  .map((document) {
                    return Skeletonizer(
                      enabled: isLoading,
                      child: _buildDocumentItem(
                        label: document.text,
                        onTap: () {
                          CoreHelper.launchLink(document.link);
                        },
                      ),
                    );
                  })
                  .expand((element) => [element, CustomSpacer(space: .5)]),
            ],
          ),
        );
  }

  Widget _buildDocumentItem({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.borderColor),
        ),
        padding: EdgeInsets.all(16.r),
        child: Row(
          children: [
            Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.picture_as_pdf_outlined,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(width: 16.r),
            Expanded(
              child: Text(
                label,
                style:
                    TextStyle(
                      fontSize: 16.r,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ).sourceSansProSemiBold,
              ),
            ),
            SvgPicture.asset(
              Assets.cloudDownload,
              colorFilter: ColorFilter.mode(AppColors.black, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
