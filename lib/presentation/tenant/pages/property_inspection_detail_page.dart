import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/domain/models/index.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/shared/widgets/index.dart';

class PropertyInspectionDetailPage extends StatefulWidget {
  static const routeName = 'propertyInspectionDetail';
  static const routePath = '/property-inspection-detail/:id';

  final String inspectionId;
  final EstateLocationModel inspectionData;

  const PropertyInspectionDetailPage({
    super.key,
    required this.inspectionId,
    required this.inspectionData,
  });

  @override
  State<PropertyInspectionDetailPage> createState() =>
      _PropertyInspectionDetailPageState();
}

class _PropertyInspectionDetailPageState
    extends State<PropertyInspectionDetailPage> {
  @override
  Widget build(BuildContext context) {
    return PageWithHeaderLayout(
      headerContent: _buildHeaderContent(),
      bodyContent: _buildInspectionDetail(),
    );
  }

  Widget _buildHeaderContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircularBackButton(),
        CustomSpacer(),
        Text(
          'État des lieux - Détail',
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ).sourceSansProBold,
        ),
      ],
    );
  }

  Widget _buildInspectionDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPropertySummary(),
        CustomSpacer(space: 2),
        _buildInspectionInfo(),
        CustomSpacer(space: 2),
        _buildRoomsList(),
        CustomSpacer(),
      ],
    );
  }

  Widget _buildPropertySummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informations du bien',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ).sourceSansProBold,
        ),
        SizedBox(height: 8.sp),
        _buildSummaryItem(
          icon: Icons.home_outlined,
          label: 'Type: ${widget.inspectionData.typeBien ?? ''}',
        ),
        SizedBox(height: 8.sp),
        _buildSummaryItem(
          icon: Icons.location_on_outlined,
          label: 'Adresse: ${widget.inspectionData.communeBien ?? ''}',
        ),
        SizedBox(height: 8.sp),
        _buildSummaryItem(
          icon: Icons.key_outlined,
          label: 'Nombre de clés: ${widget.inspectionData.nombreCle ?? ''}',
        ),
      ],
    );
  }

  Widget _buildInspectionInfo() {
    final statusColor = AppColors.success; // Les états des lieux récupérés sont généralement terminés

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Statut de l\'inspection',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ).sourceSansProSemiBold,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 6.sp),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'Terminé',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ).sourceSansProSemiBold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.sp),
          Text(
            'Date: ${_formatDate(widget.inspectionData.createdAt?.toString() ?? '')}',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade600,
            ).sourceSansProRegular,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(icon, size: 24.sp, color: Colors.black87),
        SizedBox(width: 12.sp),
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black87,
          ).sourceSansProRegular,
        ),
      ],
    );
  }

  Widget _buildRoomsList() {
    final partiesCommunes = widget.inspectionData.partiesCommunesModel?.toMap() ?? {};
    final chambres = widget.inspectionData.chambreModels ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Parties Communes Section
        if (partiesCommunes.isNotEmpty) ...[
          Text(
            'Parties Communes',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ).sourceSansProBold,
          ),
          SizedBox(height: 16.sp),
          ..._buildPartiesCommunesItems(partiesCommunes),
          SizedBox(height: 24.sp),
        ],

        // Chambres Section
        if (chambres.isNotEmpty) ...[
          Text(
            'Chambres',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ).sourceSansProBold,
          ),
          SizedBox(height: 16.sp),
          ...chambres.map((chambre) => _buildChambreSection(chambre)),
        ],
      ],
    );
  }

  List<Widget> _buildPartiesCommunesItems(Map<String, dynamic> partiesCommunes) {
    final items = <Widget>[];
    
    partiesCommunes.forEach((key, value) {
      if (!key.startsWith('observation_')) {
        final label = _formatLabel(key);
        final observation = partiesCommunes['observation_$key'];
        items.add(_buildPartiesCommunesItem(label, value.toString(), observation));
      }
    });
    
    return items;
  }

  Widget _buildPartiesCommunesItem(String label, String status, String? observation) {
    final isGoodCondition = status.toLowerCase().contains('bon') || 
                           status.toLowerCase().contains('propre') || 
                           status.toLowerCase().contains('fonctionnel');
    final statusColor = isGoodCondition ? AppColors.success : AppColors.redColor;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ).sourceSansProSemiBold,
          ),
          SizedBox(height: 12.sp),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 16.sp),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              border: Border.all(
                color: statusColor,
                width: 1.sp,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ).sourceSansProSemiBold,
            ),
          ),
          if (observation != null && observation.isNotEmpty) ...[
            SizedBox(height: 12.sp),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.sp),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Observation:',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ).sourceSansProSemiBold,
                  ),
                  SizedBox(height: 4.sp),
                  Text(
                    observation,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade800,
                    ).sourceSansProRegular,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChambreSection(ChambreModel chambre) {
    return Container(
      width: context.getSize.width,
      margin: EdgeInsets.only(bottom: 24.sp),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            chambre.nom ?? 'Chambre',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ).sourceSansProBold,
          ),
          SizedBox(height: 16.sp),
          _buildChambreElementItem('Sol', chambre.sol ?? '', chambre.observationSol),
          _buildChambreElementItem('Murs', chambre.murs ?? '', chambre.observationMurs),
          _buildChambreElementItem('Plafond', chambre.plafond ?? '', chambre.observationPlafond),
        ],
      ),
    );
  }

  Widget _buildChambreElementItem(String label, String status, String? observation) {
    final isGoodCondition = status.toLowerCase().contains('bon') || 
                           status.toLowerCase().contains('propre');
    final statusColor = isGoodCondition ? AppColors.success : AppColors.redColor;

    return Container(
      margin: EdgeInsets.only(bottom: 12.sp),
      width: context.getSize.width,
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ).sourceSansProSemiBold,
          ),
          SizedBox(height: 8.sp),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 12.sp),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              border: Border.all(
                color: statusColor,
                width: 1.sp,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ).sourceSansProSemiBold,
            ),
          ),
          if (observation != null && observation.isNotEmpty && observation != 'RAS') ...[
            SizedBox(height: 8.sp),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Observation:',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ).sourceSansProSemiBold,
                  ),
                  SizedBox(height: 2.sp),
                  Text(
                    observation,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade800,
                    ).sourceSansProRegular,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatLabel(String key) {
    final labels = {
      'sol': 'Sol',
      'murs': 'Murs',
      'plafond': 'Plafond',
      'douche': 'Douche',
      'lavabo': 'Lavabo',
      'robinet': 'Robinet',
      'porte_entre': 'Porte d\'entrée',
      'interrupteur': 'Interrupteur',
    };

    return labels[key] ??
        key
            .replaceAll('_', ' ')
            .split(' ')
            .map(
              (word) =>
                  word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1),
            )
            .join(' ');
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} à ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }
}
