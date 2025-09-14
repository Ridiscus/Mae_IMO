part of 'index.dart';

class UpdateProfileImageRequest extends Dto {
  final MultipartFile image;

  UpdateProfileImageRequest({required this.image});

  @override
  Map<String, dynamic> toJson() => {"profile_image": image.clone()};

  FormData toMultipart() {
    return FormData.fromMap(toJson());
  }
}
