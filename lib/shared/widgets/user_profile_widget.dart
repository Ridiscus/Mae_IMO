part of 'index.dart';

/// Widget polymorphe pour afficher le profil d'un utilisateur
/// Adapte automatiquement l'affichage selon le type d'utilisateur (Tenant ou CollectionAgent)
class UserProfileWidget extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onTap;
  final bool showActions;

  const UserProfileWidget({
    super.key,
    required this.user,
    this.onTap,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 12.h),
              _buildUserInfo(),
              if (showActions) ...[
                SizedBox(height: 16.h),
                _buildActions(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Avatar polymorphe
        CircleAvatar(
          radius: 24.r,
          backgroundColor: _getUserTypeColor(),
          backgroundImage: user.hasProfileImage 
              ? NetworkImage(user.profileImage.toString())
              : null,
          child: !user.hasProfileImage
              ? Icon(
                  _getUserTypeIcon(),
                  color: Colors.white,
                  size: 24.sp,
                )
              : null,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.fullName,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ).sourceSansProBold,
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: _getUserTypeColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      _getUserTypeLabel(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: _getUserTypeColor(),
                        fontWeight: FontWeight.w500,
                      ).sourceSansProRegular,
                    ),
                  ),
                  if (user.codeId != null) ...[
                    SizedBox(width: 8.w),
                    Text(
                      '#${user.codeId}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ).sourceSansProRegular,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return user.when<Widget>(
      onTenant: (tenant) => _buildTenantInfo(tenant),
      onCollectionAgent: (agent) => _buildAgentInfo(agent),
      onCommercial: (commercial) => _buildCommercialInfo(commercial),
      onUnknown: (user) => _buildGenericInfo(user),
    );
  }

  Widget _buildTenantInfo(TenantModel tenant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (tenant.email != null)
          _buildInfoRow(Icons.email, tenant.email!),
        if (tenant.contact != null)
          _buildInfoRow(Icons.phone, tenant.contact!),
        if (tenant.adresse != null)
          _buildInfoRow(Icons.location_on, tenant.adresse!),
        if (tenant.profession != null)
          _buildInfoRow(Icons.work, tenant.profession!),
        if (tenant.status != null)
          _buildStatusRow(tenant.status!),
      ],
    );
  }

  Widget _buildAgentInfo(CollectionAgentModel agent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (agent.email != null)
          _buildInfoRow(Icons.email, agent.email!),
        if (agent.contact != null)
          _buildInfoRow(Icons.phone, agent.contact!),
        if (agent.commune != null)
          _buildInfoRow(Icons.location_city, agent.commune!),
        if (agent.dateNaissance != null)
          _buildInfoRow(
            Icons.cake,
            '${DateTime.now().year - agent.dateNaissance!.year} ans',
          ),
      ],
    );
  }

  Widget _buildCommercialInfo(CommercialModel commercial) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (commercial.email != null)
          _buildInfoRow(Icons.email, commercial.email!),
        if (commercial.contact != null)
          _buildInfoRow(Icons.phone, commercial.contact!),
      ],
    );
  }

  Widget _buildGenericInfo(UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (user.email != null)
          _buildInfoRow(Icons.email, user.email!),
        if (user.contact != null)
          _buildInfoRow(Icons.phone, user.contact!),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16.sp,
            color: Colors.grey[600],
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[700],
              ).sourceSansProRegular,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String status) {
    final color = _getStatusColor(status);
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 16.sp,
            color: color,
          ),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              status.toUpperCase(),
              style: TextStyle(
                fontSize: 12.sp,
                color: color,
                fontWeight: FontWeight.w600,
              ).sourceSansProSemiBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return user.when<Widget>(
      onTenant: (tenant) => _buildTenantActions(tenant),
      onCollectionAgent: (agent) => _buildAgentActions(agent),
      onCommercial: (commercial) => _buildCommercialActions(commercial),
      onUnknown: (user) => _buildGenericActions(user),
    );
  }

  Widget _buildTenantActions(TenantModel tenant) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // Action: Voir les paiements
            },
            icon: Icon(Icons.payment, size: 16.sp),
            label: Text(
              'Paiements',
              style: TextStyle(fontSize: 12.sp).sourceSansProRegular,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 8.h),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // Action: État des lieux
            },
            icon: Icon(Icons.home_outlined, size: 16.sp),
            label: Text(
              'État des lieux',
              style: TextStyle(fontSize: 12.sp).sourceSansProRegular,
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.orange,
              padding: EdgeInsets.symmetric(vertical: 8.h),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgentActions(CollectionAgentModel agent) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // Action: Recouvrements
            },
            icon: Icon(Icons.account_balance_wallet, size: 16.sp),
            label: Text(
              'Recouvrements',
              style: TextStyle(fontSize: 12.sp).sourceSansProRegular,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 8.h),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // Action: Rapports
            },
            icon: Icon(Icons.analytics_outlined, size: 16.sp),
            label: Text(
              'Rapports',
              style: TextStyle(fontSize: 12.sp).sourceSansProRegular,
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.orange,
              padding: EdgeInsets.symmetric(vertical: 8.h),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommercialActions(CommercialModel commercial) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // Action: Voir les agences
            },
            icon: Icon(Icons.business_outlined, size: 16.sp),
            label: Text(
              'Agences',
              style: TextStyle(fontSize: 12.sp).sourceSansProRegular,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 8.h),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // Action: Voir les statistiques
            },
            icon: Icon(Icons.bar_chart_outlined, size: 16.sp),
            label: Text(
              'Stats',
              style: TextStyle(fontSize: 12.sp).sourceSansProRegular,
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(vertical: 8.h),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenericActions(UserModel user) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          // Action générique: Voir le profil
        },
        icon: Icon(Icons.person_outline, size: 16.sp),
        label: Text(
          'Voir le profil',
          style: TextStyle(fontSize: 12.sp).sourceSansProRegular,
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.orange,
          padding: EdgeInsets.symmetric(vertical: 8.h),
        ),
      ),
    );
  }

  // Méthodes utilitaires pour le styling polymorphe
  Color _getUserTypeColor() {
    return user.when<Color>(
      onTenant: (tenant) => Colors.blue,
      onCollectionAgent: (agent) => Colors.green,
      onCommercial: (commercial) => AppColors.primary,
      onUnknown: (user) => Colors.grey,
    );
  }

  IconData _getUserTypeIcon() {
    return user.when<IconData>(
      onTenant: (tenant) => Icons.home,
      onCollectionAgent: (agent) => Icons.work,
      onCommercial: (commercial) => Icons.person_search_outlined,
      onUnknown: (user) => Icons.person,
    );
  }

  String _getUserTypeLabel() {
    return user.when<String>(
      onTenant: (tenant) => 'Locataire',
      onCollectionAgent: (agent) => 'Agent',
      onCommercial: (commercial) => 'Commercial',
      onUnknown: (user) => 'Utilisateur',
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'actif':
        return Colors.green;
      case 'inactive':
      case 'inactif':
        return Colors.red;
      case 'pending':
      case 'en_attente':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
