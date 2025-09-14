part of 'index.dart';
class ModalQrCode extends StatelessWidget {
  const ModalQrCode({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.getSize.width,
      height: context.getSize.height / 1.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300.w,
            height: 300.w,
            margin: EdgeInsets.all(16.sp),
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .1),
                  blurRadius: 10.r,
                  offset: Offset(0, 0),
                ),
              ],
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: CustomQrCodeView(
              padding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
            ),
          ),
          CustomSpacer(),
          Text(
            'Mon code QR',
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ).sourceSansProSemiBold,
          ),
        ],
      ),
    );
  }
}
