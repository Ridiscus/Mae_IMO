
part of 'index.dart';


class SpacerPlatform extends StatelessWidget {
  const SpacerPlatform({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: MediaQuery.of(context).padding.bottom + 10.h);
  }
}

