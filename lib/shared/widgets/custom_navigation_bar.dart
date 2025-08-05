part of 'index.dart';

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onNavigate;

  const CustomNavigationBar({
    super.key, 
    required this.selectedIndex, 
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Barre indicatrice en haut (style violet fin)
          SizedBox(
            height: 2,
            child: Row(
              children: List.generate(4, (index) {
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.sp),
                    decoration: BoxDecoration(
                      color: selectedIndex == index
                          ? AppColors.primary // Violet comme dans la capture
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                );
              }),
            ),
          ),
          // BottomNavigationBar
          BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: onNavigate,

            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.black87,
            unselectedItemColor: Colors.grey[500],
            selectedFontSize: 12.sp,
            unselectedFontSize: 12.sp,
            iconSize: 24.sp,
            elevation: 0,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.grey[500],
            ),

            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.picture_as_pdf_outlined),
                label: 'Documents',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(Icons.credit_card_outlined),
                    /*Positioned(
                      top: -6,
                      right: -6,
                      child: Container(
                        padding: EdgeInsets.all(3.sp),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16.sp,
                          minHeight: 16.sp,
                        ),
                        child: Text(
                          '5',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),*/
                  ],
                ),
                label: 'Paiements',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.checklist_outlined),
                label: 'État des lieux',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
