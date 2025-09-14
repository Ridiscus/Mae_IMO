part of 'index.dart';

class UIHelper {
  static cachedNetworkImage(
    String? imageUrl, {
    double height = 100,
    BoxFit? fit,
  }) {
    return CachedNetworkImage(
      imageUrl: imageUrl ?? "",
      repeat: ImageRepeat.noRepeat,
      height: height.h,
      width: height.h,
      fit: fit ?? BoxFit.contain,

      errorWidget:
          (context, url, error) => Icon(Icons.error, color: Colors.red),
      placeholder: (context, url) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              width: 20.sp,
              height: 20.sp,
              child: CircularProgressIndicator.adaptive(
                strokeCap: StrokeCap.round,
              ),
            ),
          ],
        );
      },
    );
  }

  static cachedNetworkImageProvider(
    String? imageUrl, {
    double height = 100,
    BoxFit? fit,
  }) {
    return CachedNetworkImageProvider(imageUrl ?? "");
  }

  static networkImage(String? imageUrl, {double height = 100}) {
    return Image.network(
      imageUrl ?? "",
      repeat: ImageRepeat.noRepeat,
      height: height.h,
      width: height.h,
      fit: BoxFit.contain,
      errorBuilder:
          (context, url, error) => Icon(Icons.error, color: Colors.red),
      loadingBuilder:
          (context, child, loadingProgress) =>
              loadingProgress == null
                  ? child
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 20.sp,
                        height: 20.sp,
                        child: CircularProgressIndicator.adaptive(
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                    ],
                  ),
    );
  }
}
