import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/constants/assets.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/presentation/auth/pages/login_page.dart';
import 'package:maelys_imo/presentation/portal/pages/portal_detail_page.dart';
import 'package:maelys_imo/shared/models/index.dart';
import 'package:maelys_imo/shared/widgets/index.dart';

class PortalPage extends StatefulWidget {
  static const String routeName = 'portal';
  static const String routePath = '/portal';

  const PortalPage({super.key});

  @override
  State<PortalPage> createState() => _PortalPageState();
}

class _PortalPageState extends State<PortalPage> {
  final List<String> _categories = [
    'Tout',
    'Maisons',
    'Terrains',
    'Bureaux',
    'Magasins',
    'Villas',
    'Appartements',
  ];

  late final List<PropertyModel> _properties = [
    PropertyModel(
      title: 'Maison à abobo',
      imageUrl: 'assets/images/temps.png',
      amenities: List.generate(
        8,
        (index) => AmenityModel(text: '2 douches', iconData: 'shower_outlined'),
      ),
    ),
    PropertyModel(
      title: 'Villa à Cocody',
      imageUrl: 'assets/images/temps.png',
      amenities: List.generate(
        5,
        (index) => AmenityModel(text: '3 chambres', iconData: 'bed_outlined'),
      ),
    ),
    PropertyModel(
      title: 'Villa à Cocody',
      imageUrl: 'assets/images/temps.png',
      amenities: List.generate(
        5,
        (index) => AmenityModel(text: '3 chambres', iconData: 'bed_outlined'),
      ),
    ),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.orange,
        statusBarIconBrightness: Brightness.light,
      ),
      child: PageWithHeaderLayout(
        headerBackgroundColor: AppColors.orange,
        bodyPadding: EdgeInsets.only(top: 16.sp),
        headerContent: _buildHeaderContent(),
        bodyContent: _buildPageContent(),
      ),
    );
  }

  Widget _buildPageContent() {
    return Column(
      children: [
        CategoryList(
          categories: _categories,
          selectedIndex: _selectedIndex,
          onCategorySelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        CustomSpacer(),
        ...List.generate(
          _properties.length,
          (index) => Padding(
            padding: EdgeInsets.only(
              left: 16.sp,
              right: 16.sp,
              bottom: index < _properties.length - 1 ? 16.h : 0,
            ),
            child: PropertyCard(
              property: _properties[index],
              onPressed: () => _navigateToPropertyDetails(_properties[index]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderContent() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircularIcon(
              iconAsset: Assets.user,
              onPressed: () {
                context.pushNamed(LoginPage.routeName);
              },
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                'Maelys-imo',
                textAlign: TextAlign.center,
                style:
                    TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ).sourceSansProBold,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.sp),
        _buildSearchBar(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.sp),
            child: Icon(Icons.search, size: 24.sp, color: Colors.grey),
          ),
          SizedBox(width: 8.sp),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher, Appartement, Villa',
                fillColor: Colors.white,
                hintStyle:
                    TextStyle(
                      fontSize: 14.r,
                      color: Colors.grey,
                    ).sourceSansProRegular,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12.r),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 8.sp),
            child: CircleAvatar(
              backgroundColor: AppColors.orange,
              child: SvgPicture.asset(
                Assets.filter,
                width: 15.sp,
                height: 15.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPropertyDetails(PropertyModel property) {
    context.pushNamed(
      PortalDetailPage.routeName,
      pathParameters: {'id': "1", 'type': 'prospect'},
    );
  }

}
