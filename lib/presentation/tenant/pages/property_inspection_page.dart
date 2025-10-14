import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/domain/models/index.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/core/manager/state/dashboard/dashboard_bloc.dart';
import 'package:maelys_imo/core/manager/state/tenant/tenant_bloc.dart';
import 'package:maelys_imo/presentation/tenant/pages/property_inspection_detail_page.dart';
import 'package:maelys_imo/shared/widgets/index.dart';

class PropertyInspectionPage extends StatefulWidget {
  static const routeName = 'propertyInspectionPage';
  static const routePath = '/property-inspection';

  const PropertyInspectionPage({super.key});

  @override
  State<PropertyInspectionPage> createState() => _PropertyInspectionPageState();
}

class _PropertyInspectionPageState extends State<PropertyInspectionPage> {
  TenantDashboardModel? dashboard;
  EstateLocationResponseModel? propertyInspections;

  @override
  void initState() {
    super.initState();
    // Récupérer les états des lieux au chargement de la page
    context.read<TenantBloc>().add(const FetchPropertyInspectionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    dashboard = context.select(
      (DashboardBloc bloc) => bloc.state.tenantDashboardModel,
    );
    propertyInspections = context.select(
      (TenantBloc bloc) => bloc.state.propertyInspections,
    );

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
      ),
      child: PageWithHeaderLayout(
        headerContent: _buildHeaderContent(),
        bodyContent: _buildInspectionForm(),
      ),
    );
  }

  Widget _buildHeaderContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CircularBackButton(), // Retiré car dans le shell de navigation
        CustomSpacer(),

        Text(
          'État des lieux',
          style:
              TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ).sourceSansProBold,
        ),
      ],
    );
  }

  Widget _buildInspectionForm() {
    return BlocBuilder<TenantBloc, TenantState>(
      builder: (context, state) {
        if (state.isLoading == true) {
          return const Center(child: CircularProgressIndicator());
        }

        // final inspections = state.propertyInspections?.data.availableInspections ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPropertySummary(),
            CustomSpacer(space: 2),

            if (propertyInspections == null || 
                (propertyInspections?.etatEntree == null && propertyInspections?.etatSortie == null))
              EmptyStateWidget(
                title: "Aucun état des lieux disponible",
                icon: Icons.search_off,
              )
            else
              _buildInspectionsList(),
          ],
        );
      },
    );
  }

  Widget _buildPropertySummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${dashboard?.locataire?.estate?.title}',
          style:
              TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ).sourceSansProBold,
        ),
        SizedBox(height: 8.sp),
        _buildSummaryItem(
          icon: Icons.home_outlined,
          label: 'Type: ${dashboard?.locataire?.estate?.type ?? ''}',
        ),
        SizedBox(height: 8.sp),
        _buildSummaryItem(
          icon: Icons.location_on_outlined,
          label: 'Adresse: ${dashboard?.locataire?.estate?.commune ?? ''}',
        ),
      ],
    );
  }

  Widget _buildSummaryItem({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(icon, size: 24.sp, color: Colors.black87),
        SizedBox(width: 12.sp),
        Text(
          label,
          style:
              TextStyle(
                fontSize: 16.sp,
                color: Colors.black87,
              ).sourceSansProRegular,
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getAvailableInspections() {
    final inspections = <Map<String, dynamic>>[];

    if (propertyInspections?.etatEntree != null) {
      inspections.add({
        'type': 'entree',
        'data': propertyInspections!.etatEntree!,
        'label': 'Entrée',
      });
    }

    if (propertyInspections?.etatSortie != null) {
      inspections.add({
        'type': 'sortie',
        'data': propertyInspections!.etatSortie!,
        'label': 'Sortie',
      });
    }

    return inspections;
  }

  Widget _buildInspectionsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'États des lieux disponibles',
          style:
              TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ).sourceSansProSemiBold,
        ),
        CustomSpacer(),
        ..._getAvailableInspections().map(
          (inspection) => _buildInspectionItem(inspection),
        ),
      ],
    );
  }

  Widget _buildInspectionItem(Map<String, dynamic> inspection) {
    final EstateLocationModel data = inspection['data'];
    final String type = inspection['label'];
    final statusColor = AppColors.success; // Les états des lieux récupérés sont généralement terminés

    return Container(
      margin: EdgeInsets.only(bottom: 16.sp),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Navigation vers la page de détail
          _navigateToInspectionDetail(inspection);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'État des lieux - $type',
                  style:
                      TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ).sourceSansProSemiBold,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.sp,
                    vertical: 4.sp,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'Terminé',
                    style:
                        TextStyle(
                          fontSize: 12.sp,
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ).sourceSansProSemiBold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.sp),
            Text(
              'Type: ${data.typeBien ?? dashboard?.locataire?.estate?.type ?? ''}',
              style:
                  TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade600,
                  ).sourceSansProRegular,
            ),
            SizedBox(height: 4.sp),
            Text(
              'Adresse: ${data.communeBien ?? dashboard?.locataire?.estate?.commune ?? ''}',
              style:
                  TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade600,
                  ).sourceSansProRegular,
            ),
            SizedBox(height: 4.sp),
            Text(
              'Date: ${_formatDate(data.createdAt?.toString() ?? '')}',
              style:
                  TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade600,
                  ).sourceSansProRegular,
            ),
            SizedBox(height: 12.sp),
            Row(
              children: [
                Icon(Icons.visibility, size: 16.sp, color: AppColors.primary),
                SizedBox(width: 4.sp),
                Text(
                  'Voir les détails',
                  style:
                      TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ).sourceSansProSemiBold,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _navigateToInspectionDetail(Map<String, dynamic> inspection) {
    final EstateLocationModel data = inspection['data'];
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => PropertyInspectionDetailPage(
              inspectionId: data.id?.toString() ?? '0',
              inspectionData: data,
            ),
      ),
    );
  }
}
