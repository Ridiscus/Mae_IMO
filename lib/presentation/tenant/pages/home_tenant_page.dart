import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/presentation/tenant/pages/payment_page.dart'; // Added import
import 'package:maelys_imo/presentation/tenant/pages/contact_agency_page.dart';
import 'package:maelys_imo/presentation/tenant/pages/profile_tenant_page.dart'; // Added import

class HomeTenantPage extends StatefulWidget {
  static const routeName = 'homeTenant';
  static const routePath = '/home-tenant';

  const HomeTenantPage({super.key});

  @override
  State<HomeTenantPage> createState() => _HomeTenantPageState();
}

class _HomeTenantPageState extends State<HomeTenantPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
      bottomNavigationBar: _buildContactButton(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.r,
        left: 16.r,
        right: 16.r,
        bottom: 24.r,
      ),
      width: double.infinity,
      color: Color(0xFF0A2342),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 30.r,
                ),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
              Row(
                children: [
                  Text(
                    'Juillet 2025',
                    style: TextStyle(
                      fontSize: 20.r,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ).sourceSansProBold,
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                    size: 24.r,
                  ),
                ],
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 16.r,
                child: GestureDetector(
                  onTap: () {
                    context.goNamed(ProfileTenantPage.routeName);
                  },
                  child: Icon(
                    Icons.person,
                    color: Color(0xFF0A2342),
                    size: 20.r,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.r),
          _buildRentInfo(),
          SizedBox(height: 16.r),
          _buildPayRentButton(),
        ],
      ),
    );
  }

  Widget _buildRentInfo() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Loyer du mois',
              style: TextStyle(
                fontSize: 16.r,
                color: Colors.white,
              ).sourceSansProRegular,
            ),
            SizedBox(width: 8.r),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 2.r),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                'impayé',
                style: TextStyle(
                  fontSize: 12.r,
                  color: Colors.white,
                ).sourceSansProSemiBold,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.r),
        Text(
          '200 000 FCFA',
          style: TextStyle(
            fontSize: 32.r,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ).sourceSansProBold,
        ),
      ],
    );
  }

  Widget _buildPayRentButton() {
    return Container(
      width: double.infinity,
      height: 56.r,
      child: ElevatedButton(
        onPressed: () {
          // Navigate to payment page
          context.goNamed(PaymentPage.routeName);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Payer mon loyer',
              style: TextStyle(
                fontSize: 18.r,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ).sourceSansProBold,
            ),
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 16.r,
              child: Icon(
                Icons.arrow_forward,
                color: Colors.orange,
                size: 20.r,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      width: double.infinity,
      color: Color(0xFFF5F5F5),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Historique des paiements',
                style: TextStyle(
                  fontSize: 18.r,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ).sourceSansProBold,
              ),
              SizedBox(height: 16.r),
              _buildPaymentHistoryItem(
                month: 'juin',
                amount: '200 000 FCFA',
                date: '06 juin 2025',
                isPaid: true,
              ),
              SizedBox(height: 12.r),
              _buildPaymentHistoryItem(
                month: 'mai',
                amount: '200 000 FCFA',
                date: '06 juin 2025',
                isPaid: true,
              ),
              SizedBox(height: 12.r),
              _buildPaymentHistoryItem(
                month: 'avril',
                amount: '150 000 FCFA',
                date: '06 juin 2025',
                isPaid: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentHistoryItem({
    required String month,
    required String amount,
    required String date,
    required bool isPaid,
  }) {
    return Container(
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
              Icons.image,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(width: 16.r),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Loyer du mois de $month',
                  style: TextStyle(
                    fontSize: 16.r,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ).sourceSansProSemiBold,
                ),
                SizedBox(height: 4.r),
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 18.r,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ).sourceSansProBold,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 4.r),
                decoration: BoxDecoration(
                  color: isPaid ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  isPaid ? 'Payé' : 'Impayé',
                  style: TextStyle(
                    fontSize: 12.r,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ).sourceSansProSemiBold,
                ),
              ),
              SizedBox(height: 4.r),
              Text(
                date,
                style: TextStyle(
                  fontSize: 12.r,
                  color: Colors.grey[600],
                ).sourceSansProRegular,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          height: 56.r,
          child: ElevatedButton(
            onPressed: () {
              // Navigate to contact agency page
              context.goNamed(ContactAgencyPage.routeName);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF0A2342),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Contacter l\'agence',
                  style: TextStyle(
                    fontSize: 18.r,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ).sourceSansProBold,
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 16.r,
                  child: Icon(
                    Icons.phone,
                    color: Color(0xFF0A2342),
                    size: 20.r,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
