part of '../index.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;
  const AuthLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            children: [
              Image.asset(
                'assets/images/maelys_imo_logo.png',
                width: context.getSize.width / 2.5,
              ),
              Divider(color: Color.fromRGBO(255, 255, 255, 1), height: 16),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      padding: EdgeInsets.all(25.w),
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .5),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white, width: 3.r),
                      ),
                      child: child
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
