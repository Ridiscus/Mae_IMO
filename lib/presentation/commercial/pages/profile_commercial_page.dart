import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/domain/requests/index.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/core/manager/state/auth/auth_bloc.dart';
import 'package:maelys_imo/presentation/commercial/pages/update_email_commercial_page.dart';
import 'package:maelys_imo/presentation/commercial/pages/update_password_commercial_page.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:maelys_imo/presentation/auth/pages/login_page.dart';
import 'package:maelys_imo/core/api_manager/endpoints.dart';
import 'package:maelys_imo/core/utils/index.dart';

class ProfileCommercialPage extends StatefulWidget {
  static const routeName = 'profileCommercial';
  static const routePath = '/commercial/profile';
  const ProfileCommercialPage({super.key});
  @override
  State<ProfileCommercialPage> createState() => _ProfileCommercialPageState();
}

class _ProfileCommercialPageState extends State<ProfileCommercialPage> {
  File? _pendingImage;
  bool _isUploadingImage = false;

  // ─────────────────────────── PHOTO PICKER ──────────────────────────────────

  Future<void> _handleAvatarTap(
    bool hasImage,
    String? profileImage,
    String initials,
  ) async {
    if (_isUploadingImage) return;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder:
          (ctx) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 12.h),
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 20.h),
                if (hasImage)
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(8.sp),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.visibility_outlined,
                        color: AppColors.primary,
                        size: 20.sp,
                      ),
                    ),
                    title: Text(
                      'Voir la photo de profil',
                      style:
                          TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ).sourceSansProSemiBold,
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      _showImagePreview(profileImage, initials);
                    },
                  ),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8.sp),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.photo_camera_outlined,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                  ),
                  title: Text(
                    'Modifier la photo de profil',
                    style:
                        TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ).sourceSansProSemiBold,
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickAndUploadImage();
                  },
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
    );
  }

  void _showImagePreview(String? profileImage, String initials) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (ctx) => Container(
            height: MediaQuery.of(context).size.height - 50.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                SizedBox(height: 20.h),
                // Header simple sans bordure
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Aperçu du profil',
                        style:
                            TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ).sourceSansProBold,
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close, size: 28),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: UIHelper.cachedNetworkImage(
                        Endpoints.storageUrl(profileImage),
                        fit:
                            BoxFit
                                .contain, // Pour voir toute l'image sans la rogner
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 24.h,
                  ),
                  child: CustomButton(
                    text: 'Fermer',
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
    );
  }

  Future<void> _pickAndUploadImage() async {
    // Proposer galerie ou appareil photo
    final source = await _showImageSourceDialog();
    if (source == null) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    if (picked == null) return;

    final file = File(picked.path);

    // Vérification taille ≤ 2 Mo
    if (file.lengthSync() > 2 * 1024 * 1024) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La photo ne doit pas dépasser 2 Mo')),
        );
      }
      return;
    }

    setState(() {
      _pendingImage = file;
      _isUploadingImage = true;
    });

    final multipart = await MultipartFile.fromFile(file.path);
    if (mounted) {
      context.read<AuthBloc>().add(
        UpdateProfileImagEvent(
          dto: UpdateProfileImageRequest(image: multipart),
        ),
      );
    }
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder:
          (ctx) => SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Changer la photo de profil',
                    style:
                        TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ).sourceSansProBold,
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSourceOption(
                        ctx: ctx,
                        icon: Icons.photo_library_outlined,
                        label: 'Galerie',
                        source: ImageSource.gallery,
                      ),
                      _buildSourceOption(
                        ctx: ctx,
                        icon: Icons.camera_alt_outlined,
                        label: 'Appareil photo',
                        source: ImageSource.camera,
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildSourceOption({
    required BuildContext ctx,
    required IconData icon,
    required String label,
    required ImageSource source,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pop(ctx, source),
      child: Column(
        children: [
          Container(
            width: 64.sp,
            height: 64.sp,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(icon, color: AppColors.primary, size: 28.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style:
                TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black87,
                ).sourceSansProSemiBold,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────── BUILD ─────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen:
          (previous, current) => current.updatedImage != previous.updatedImage,
      listener: (context, state) {
        setState(() => _isUploadingImage = false);
        if (state.userModel == null) {
          context.goNamed(LoginPage.routeName);
          return;
        }
        if (state.updatedImage == true) {
          setState(() => _pendingImage = null);
        } else if (state.updatedImage == false) {
          setState(() => _pendingImage = null);
        }
      },
      builder: (context, state) {
        final user = state.userModel;
        final initials = _getInitials(user?.fullName);
        final fullName = user?.fullName ?? 'Commercial';
        final email = user?.email ?? '---';
        final contact = user?.contact ?? '---';
        final codeId = user?.codeId ?? '---';
        final hasImage =
            user?.profileImage != null &&
            user!.profileImage.toString().isNotEmpty;

        return AnnotatedRegion(
          value: SystemUiOverlayStyle(
            statusBarColor: AppColors.primary,
            statusBarIconBrightness: Brightness.light,
          ),
          child: Scaffold(
            backgroundColor: AppColors.scaffold,
            body: Stack(
              children: [
                // ── Header ────────────────────────────────────────────────
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _buildHeader(context),
                ),
                // ── Content ───────────────────────────────────────────────
                Positioned.fill(
                  top: (MediaQuery.of(context).size.height * .24).sp,
                  child: Container(
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: AppColors.scaffold,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r),
                      ),
                    ),
                    child: ListView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 24.h,
                      ),
                      children: [
                        // Avatar tappable + Nom
                        _buildAvatarSection(
                          hasImage: hasImage,
                          profileImage: user?.profileImage?.toString(),
                          initials: initials,
                          fullName: fullName,
                          codeId: codeId,
                          isLoading: state.isLoading,
                        ),

                        SizedBox(height: 28.h),

                        // Informations du compte
                        _buildSectionLabel('Informations du compte'),
                        SizedBox(height: 10.h),
                        _buildCard([
                          _buildInfoRow(
                            icon: Icons.badge_outlined,
                            label: 'Identifiant',
                            value: codeId,
                          ),
                          _buildDivider(),
                          _buildInfoRow(
                            icon: Icons.email_outlined,
                            label: 'Email',
                            value: email,
                          ),
                          _buildDivider(),
                          _buildInfoRow(
                            icon: Icons.phone_outlined,
                            label: 'Contact',
                            value: contact,
                          ),
                        ]),

                        SizedBox(height: 24.h),

                        // Paramètres du compte
                        _buildSectionLabel('Paramètres du compte'),
                        SizedBox(height: 10.h),
                        _buildCard([
                          _buildMenuRow(
                            icon: Icons.email_outlined,
                            label: 'Modifier mon email',
                            color: AppColors.primary,
                            onTap:
                                () => context.pushNamed(
                                  UpdateEmailCommercialPage.routeName,
                                ),
                          ),
                          _buildDivider(),
                          _buildMenuRow(
                            icon: Icons.lock_outline,
                            label: 'Modifier mon mot de passe',
                            color: AppColors.primary,
                            onTap:
                                () => context.pushNamed(
                                  UpdatePasswordCommercialPage.routeName,
                                ),
                          ),
                        ]),

                        SizedBox(height: 24.h),

                        // Déconnexion
                        _buildLogoutButton(context),

                        SizedBox(
                          height: MediaQuery.of(context).padding.bottom + 24.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────── WIDGETS ───────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      width: double.infinity,
      height: (MediaQuery.of(context).size.height * .28).sp,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Stack(
        children: [
          IllustrationHeader(
            color: Colors.white,
            primaryAlpha: 0.1,
            secondaryAlpha: 0.05,
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircularBackButton(
                      backgroundColor: Colors.white,
                      backgroundOpacity: 0.15,
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  'Mon Profil',
                  style:
                      TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ).sourceSansProBold,
                ),
                Text(
                  'Gérez vos informations personnelles',
                  style:
                      TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white.withValues(alpha: 0.8),
                      ).sourceSansProRegular,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection({
    required bool hasImage,
    required String? profileImage,
    required String initials,
    required String fullName,
    required String codeId,
    required bool isLoading,
  }) {
    return Center(
      child: Column(
        children: [
          // Avatar tappable avec badge appareil photo
          GestureDetector(
            onTap: () => _handleAvatarTap(hasImage, profileImage, initials),
            child: Stack(
              children: [
                Container(
                  width: 90.sp,
                  height: 90.sp,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.12),
                    border: Border.all(color: AppColors.primary, width: 2.5),
                  ),
                  child: ClipOval(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // 1. L'image (soit la nouvelle en attente, soit l'actuelle, soit les initiales)
                        Positioned.fill(
                          child:
                              _pendingImage != null
                                  ? Image.file(
                                    _pendingImage!,
                                    fit: BoxFit.cover,
                                  )
                                  : hasImage
                                  ? UIHelper.cachedNetworkImage(
                                    Endpoints.storageUrl(profileImage),
                                    fit: BoxFit.cover,
                                  )
                                  : Center(
                                    child: Text(
                                      initials,
                                      style:
                                          TextStyle(
                                            fontSize: 34.sp,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ).sourceSansProBold,
                                    ),
                                  ),
                        ),

                        // 2. Overlay de chargement (si en cours d'upload)
                        if (_isUploadingImage || isLoading)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withValues(alpha: 0.4),
                              child: Center(
                                child: SizedBox(
                                  width: 24.sp,
                                  height: 24.sp,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Badge caméra
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(6.sp),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 14.h),
          Text(
            fullName,
            style:
                TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ).sourceSansProBold,
          ),
          SizedBox(height: 4.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              'Commercial • $codeId',
              style:
                  TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ).sourceSansProSemiBold,
            ),
          ),

          // Hint tap pour changer
          if (!_isUploadingImage) ...[
            SizedBox(height: 6.h),
            Text(
              'Appuyer sur la photo pour la modifier',
              style:
                  TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey[400],
                  ).sourceSansProRegular,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label.toUpperCase(),
      style:
          TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey[500],
            letterSpacing: 1.2,
          ).sourceSansProBold,
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 18.sp, color: AppColors.primary),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style:
                      TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey[500],
                      ).sourceSansProRegular,
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style:
                      TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ).sourceSansProSemiBold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuRow({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.sp),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, size: 18.sp, color: color),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Text(
                  label,
                  style:
                      TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ).sourceSansProSemiBold,
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20.sp,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: () => _showLogoutDialog(context),
        borderRadius: BorderRadius.circular(16.r),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, color: Colors.white, size: 20.sp),
              SizedBox(width: 10.w),
              Text(
                'Se déconnecter',
                style:
                    TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ).sourceSansProBold,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            title: Text(
              'Déconnexion',
              style:
                  TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ).sourceSansProBold,
            ),
            content: Text(
              'Êtes-vous sûr de vouloir vous déconnecter ?',
              style:
                  TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ).sourceSansProRegular,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  'ANNULER',
                  style: TextStyle(color: Colors.grey[600]).sourceSansProBold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  context.read<AuthBloc>().add(const LogoutEvent());
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text(
                  'SE DÉCONNECTER',
                  style:
                      const TextStyle(
                        fontWeight: FontWeight.bold,
                      ).sourceSansProBold,
                ),
              ),
            ],
          ),
    );
  }

  // ─────────────────────────── UTILS ─────────────────────────────────────────

  Widget _buildCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 52.w,
      endIndent: 16.w,
      color: Colors.grey.withValues(alpha: 0.1),
    );
  }

  String _getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return 'C';
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
