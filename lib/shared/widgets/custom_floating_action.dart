part of 'index.dart';

class CustomFloatingAction extends StatelessWidget {
  final Function(int) isSelected;
  final Function(String) onNavigate;

  const CustomFloatingAction({
    super.key, 
    required this.isSelected, 
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Positioned.fill(
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 1.5),
                  child: Container(color: AppColors.orange),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButtonMenu(
                  iconData: Icons.picture_as_pdf_outlined,
                  title: "Documents",
                  onPressed: () => onNavigate('documents'),
                  selected: isSelected(0),
                ),
                IconButtonMenu(
                  iconData: Icons.credit_card_outlined,
                  title: "Paiements",
                  selected: isSelected(1),
                  onPressed: () => onNavigate('payments'),
                ),
                IconButtonMenu(
                  iconData: Icons.checklist_outlined,
                  selected: isSelected(2),
                  title: "État des lieux",
                  onPressed: () => onNavigate('inspection'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
