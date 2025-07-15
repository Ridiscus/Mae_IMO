import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/extensions/text_style_ext.dart';

class PortalPage extends StatefulWidget {
  static const String routeName = 'portal';
  static const String routePath = '/portal';

  const PortalPage({super.key});

  @override
  State<PortalPage> createState() => _PortalPageState();
}

class _PortalPageState extends State<PortalPage> {
  final List<String> _categories = [
    'Villa',
    'Villa',
    'Villa',
    'Villa',
    'Villa',
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(statusBarColor: AppColors.primary),
      child: Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: Column(
          children: [
            _buildAppBar(),
            SizedBox(height: 16.r),
            _buildSearchBar(),
            SizedBox(height: 16.r),
            _buildCategoryList(),
            SizedBox(height: 16.r),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.r),
                children: [
                  _buildPropertyCard(),
                  SizedBox(height: 16.r),
                  _buildPropertyCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
      color: AppColors.orange,
      child: SafeArea(
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(
                Icons.person_outline,
                color: Colors.black,
                size: 20.r,
              ),
            ),
            SizedBox(width: 16.r),
            Text(
              'Maelys-imo',
              style:
                  TextStyle(
                    fontSize: 24.r,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ).sourceSansProBold,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48.r,
      margin: EdgeInsets.symmetric(horizontal: 16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.0.r),
            child: Icon(Icons.search, size: 20.r, color: Colors.grey),
          ),
          SizedBox(width: 8.r),
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
          Container(
            margin: EdgeInsets.only(right: 4.r),
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.orange,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(Icons.tune, size: 20.r, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 35.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(left: 8.r),
            padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
            decoration: BoxDecoration(
              color: index == 0 ? AppColors.orange : Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color:
                    index == 0
                        ? Colors.transparent
                        : Colors.grey.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.place_outlined,
                  size: 16.r,
                  color: index == 0 ? Colors.white : Colors.grey,
                ),
                SizedBox(width: 6.r),
                Text(
                  _categories[index],
                  style:
                      TextStyle(
                        fontSize: 14.r,
                        fontWeight: FontWeight.w500,
                        color: index == 0 ? Colors.white : Colors.grey,
                      ).sourceSansProSemiBold,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPropertyCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
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
          // Property image with rounded corners at top
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/temps.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  // Pagination indicators
                  Positioned(
                    bottom: 8.r,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _paginationDot(true),
                        _paginationDot(false),
                        _paginationDot(false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Property details
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Maison à abobo',
                  style:
                      TextStyle(
                        fontSize: 18.r,
                        fontWeight: FontWeight.bold,
                      ).sourceSansProBold,
                ),
                SizedBox(height: 12.r),
                _buildAmenities(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _paginationDot(bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.r),
      width: isActive ? 16.r : 8.r,
      height: 8.r,
      decoration: BoxDecoration(
        color: isActive ? AppColors.orange : Colors.white,
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }

  Widget _buildAmenities() {
    return Wrap(
      spacing: 8.r,
      runSpacing: 8.r,
      children: List.generate(
        8,
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
                      color: Colors.grey,
                    ).sourceSansProRegular,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
