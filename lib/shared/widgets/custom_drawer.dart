part of 'index.dart';

class CustomDrawer extends StatelessWidget {
  final String? profileType;
  final String name;
  final String email;
  final String? profileImage;
  final Function()? onHomeTap;
  final Function()? onPaymentsTap;
  final Function()? onWalletTap;
  final Function()? onTransactionsTap;
  final Function()? onProfileTap;
  final Function()? onCurrentSituationTap;
  final Function()? onDocumentsTap;
  final Function()? onLogoutTap;
  final Function()? onCloseTap;
  final int selectedIndex;

  const CustomDrawer({
    super.key,
    this.profileType,
    required this.name,
    required this.email,
    this.profileImage,
    this.onHomeTap,
    this.onPaymentsTap,
    this.onWalletTap,
    this.onTransactionsTap,
    this.onProfileTap,
    this.onCurrentSituationTap,
    this.onDocumentsTap,
    this.onLogoutTap,
    this.onCloseTap,
    this.selectedIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Drawer(
        backgroundColor: Colors.white,
        width: context.getSize.width / 1.3,
        elevation: 30,
        shadowColor: AppColors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(32.r),
            bottomRight: Radius.circular(32.r),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildProfileSection(context),
              CustomSpacer(space: 3),
              _buildMenuItems(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24.sp, left: 24.sp, right: 24.sp),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomCircleAvatarUser(
                profileImage: profileImage,
                size: 72,
                backgroundColor: AppColors.primary,
              ),
            ],
          ),
          SizedBox(height: 16.sp),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              name,
              style:
              TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ).sourceSansProSemiBold,
            ),
          ),
          SizedBox(height: 2.sp),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              email,
              style:
              TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ).sourceSansProRegular,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    final menuItems = [
      _MenuItem(
        icon: Icons.home_outlined,
        title: 'Accueil',
        onTap: onHomeTap ?? onCloseTap,
      ),

      if (profileType != 'tenant') ...[
        _MenuItem(
          icon: Icons.checklist_outlined,
          title: 'État des lieux',
          onTap: onCurrentSituationTap,
        ),
      ],

      if (profileType == 'tenant') ...[
        _MenuItem(
          icon: Icons.phone,
          title: 'Contacter l\'agence',
          onTap: () {
            context.pushNamed(ContactAgencyPage.routeName);
          },
        ),
      ],
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: menuItems.length,
      separatorBuilder: (context, index) => CustomSpacer(space: .1),
      itemBuilder: (context, index) => menuItems[index],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function()? onTap;
  final bool isSelected;

  const _MenuItem({
    Key? key,
    required this.icon,
    required this.title,
    this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.black, size: 24.sp),
      title: Text(
        title,
        style:
        TextStyle(
          fontSize: 16.sp,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? Colors.black : Colors.black87,
        ).sourceSansProRegular,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 24.sp),
      minLeadingWidth: 24.w,
      dense: true,
      visualDensity: VisualDensity.comfortable,
    );
  }
}
