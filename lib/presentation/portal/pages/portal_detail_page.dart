import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/presentation/portal/pages/visit_request_page.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:maelys_imo/core/extensions/index.dart';

class PortalDetailPage extends StatefulWidget {
  static const String routeName = 'portalDetail/:id/:type';
  static const String routePath = '/portal-detail/:id/:type';

  final String? id;
  final String? type;

  const PortalDetailPage({super.key, this.id, this.type});

  @override
  State<PortalDetailPage> createState() => _PortalDetailPageState();
}

class _PortalDetailPageState extends State<PortalDetailPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: SingleChildScrollView(
          child: SizedBox(
            width: context.getSize.width,
            height: context.getSize.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageHeader(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitleAndPrice(),
                        SizedBox(height: 20.r),
                        _buildPropertyInfo(),
                        SizedBox(height: 20.r),
                        _buildAmenities(),
                        SizedBox(height: 20.r),
                        _buildDescription(),
                        SizedBox(height: 32.r),
                      ],
                    ),
                  ),
                ),
                if (widget.type?.toLowerCase() == 'prospect') ...[
                  _buildVisitButton(),
                  SpacerPlatform(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageHeader() {
    return SizedBox(
      width: double.infinity,
      height: context.getSize.height * 0.4,
      child: Stack(
        children: [
          // Image
          Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20.r)),
                  child: Image.asset(
                    'assets/images/temps.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              // Pagination indicators
              Positioned(
                bottom: 10.h,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => PaginationDot(isActive: index == 0),
                  ),
                ),
              ),
            ],
          ),

          // Back button
          Positioned(top: 40.r, left: 16.r, child: CircularBackButton()),
        ],
      ),
    );
  }

  Widget _buildTitleAndPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            'Maison à abobo',
            style:
                TextStyle(
                  fontSize: 22.r,
                  fontWeight: FontWeight.bold,
                ).sourceSansProBold,
          ),
        ),
        Text(
          '200 000 FCFA / Mois',
          style:
              TextStyle(
                fontSize: 16.r,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ).sourceSansProBold,
        ),
      ],
    );
  }

  Widget _buildPropertyInfo() {
    return Row(
      children: [
        _buildInfoItem('Type : Villa', Icons.home_outlined),
        SizedBox(width: 8.r),
        Container(
          width: 4.r,
          height: 4.r,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8.r),
        _buildInfoItem('Garage : Oui', Icons.garage_outlined),
        SizedBox(width: 8.r),
        Container(
          width: 4.r,
          height: 4.r,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8.r),
        _buildInfoItem('Superficie : 100m²', Icons.square_foot_outlined),
      ],
    );
  }

  Widget _buildInfoItem(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16.r, color: Colors.grey),
        SizedBox(width: 4.r),
        Text(
          text,
          style:
              TextStyle(
                fontSize: 14.r,
                color: Colors.grey[700],
              ).sourceSansProRegular,
        ),
      ],
    );
  }

  Widget _buildAmenities() {
    return Wrap(
      spacing: 8.r,
      runSpacing: 8.r,
      children: List.generate(
        3,
        (index) => Container(
          padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 4.r),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.shower_outlined, size: 14.r, color: Colors.grey),
              SizedBox(width: 4.r),
              Text(
                '2 douches',
                style:
                    TextStyle(
                      fontSize: 12.r,
                      color: Colors.grey[700],
                    ).sourceSansProRegular,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style:
              TextStyle(
                fontSize: 18.r,
                fontWeight: FontWeight.bold,
              ).sourceSansProBold,
        ),
        SizedBox(height: 8.r),
        Text(
          'Le lorem ipsum est, en imprimerie, une suite de mots sans signification utilisée à titre provisoire Le lorem ipsum est, en imprimerie, une suite de mots sans signification utilisée à titre provisoire',
          style:
              TextStyle(
                fontSize: 14.r,
                color: Colors.grey[800],
                height: 1.5,
              ).sourceSansProRegular,
        ),
      ],
    );
  }

  Widget _buildVisitButton() {
    return Padding(
      padding: EdgeInsets.all(16.sp),
      child: CustomButton(
        text: 'Visiter',
        showArrow: true,
        onPressed: () {
          context.pushNamed(VisitRequestPage.routeName);
        },

        buttonVariant: ButtonVariant.primary,
        textStyle:
            TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ).sourceSansProBold,
      ),
    );
  }
}
