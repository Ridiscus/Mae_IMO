part of 'index.dart';

class CustomSearchableDropdown<T> extends StatefulWidget {
  final String labelText;
  final String hintText;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabelBuilder;
  final void Function(T?) onChanged;
  final String? errorText;
  final bool isLoading;
  final String? searchHint;
  final bool showSearch;

  const CustomSearchableDropdown({
    super.key,
    required this.labelText,
    required this.hintText,
    this.value,
    required this.items,
    required this.itemLabelBuilder,
    required this.onChanged,
    this.errorText,
    this.isLoading = false,
    this.searchHint = "Rechercher...",
    this.showSearch = true,
  });

  @override
  State<CustomSearchableDropdown<T>> createState() =>
      _CustomSearchableDropdownState<T>();
}

class _CustomSearchableDropdownState<T>
    extends State<CustomSearchableDropdown<T>> {
  final _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  final _searchController = TextEditingController();
  late List<T> _filteredItems;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _showDropdown();
    }
  }

  void _showDropdown() {
    setState(() {
      _isOpen = true;
      _filteredItems = widget.items;
      _searchController.clear();
    });

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = _createOverlayEntry(size);
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeDropdown() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    if (mounted) {
      setState(() {
        _isOpen = false;
      });
    }
  }

  OverlayEntry _createOverlayEntry(Size size) {
    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Background to catch taps outside
            Positioned.fill(
              child: GestureDetector(
                onTap: _closeDropdown,
                behavior: HitTestBehavior.opaque,
                child: Container(color: Colors.transparent),
              ),
            ),
            // Floating menu
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 5.h),
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(15.r),
                color: Colors.white,
                clipBehavior: Clip.antiAlias,
                child: Container(
                  width: size.width,
                  constraints: BoxConstraints(maxHeight: 350.h),
                  child: StatefulBuilder(
                    builder: (context, setModalState) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Search Box (Optional)
                          if (widget.showSearch) ...[
                            Padding(
                              padding: EdgeInsets.all(12.sp),
                              child: TextField(
                                controller: _searchController,
                                autofocus: true,
                                style:
                                    TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.black87,
                                    ).sourceSansProRegular,
                                decoration: InputDecoration(
                                  hintText: widget.searchHint,
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14.sp,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    size: 18.sp,
                                    color: Colors.grey[600],
                                  ),
                                  suffixIcon:
                                      _searchController.text.isNotEmpty
                                          ? IconButton(
                                            icon: Icon(
                                              Icons.close,
                                              size: 18.sp,
                                              color: Colors.grey[400],
                                            ),
                                            onPressed: () {
                                              _searchController.clear();
                                              setModalState(() {
                                                _filteredItems = widget.items;
                                              });
                                            },
                                          )
                                          : null,
                                  isDense: true,
                                  fillColor: Colors.grey[50],
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: BorderSide(
                                      color: Colors.grey[200]!,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: BorderSide(
                                      color: Colors.grey[100]!,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: BorderSide(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                onChanged: (val) {
                                  setModalState(() {
                                    _filteredItems =
                                        widget.items
                                            .where(
                                              (item) => widget
                                                  .itemLabelBuilder(item)
                                                  .toLowerCase()
                                                  .contains(val.toLowerCase()),
                                            )
                                            .toList();
                                  });
                                },
                              ),
                            ),
                            const Divider(height: 1),
                          ],
                          // List of Items
                          Flexible(
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(vertical: 4.h),
                              shrinkWrap: true,
                              itemCount: _filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = _filteredItems[index];
                                final label = widget.itemLabelBuilder(item);
                                final isSelected = widget.value == item;

                                return InkWell(
                                  onTap: () {
                                    widget.onChanged(item);
                                    _closeDropdown();
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 12.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          isSelected
                                              ? AppColors.primary.withValues(
                                                alpha: 0.05,
                                              )
                                              : null,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            label,
                                            style:
                                                TextStyle(
                                                  fontSize: 15.sp,
                                                  fontWeight:
                                                      isSelected
                                                          ? FontWeight.w600
                                                          : FontWeight.w400,
                                                  color:
                                                      isSelected
                                                          ? AppColors.primary
                                                          : Colors.black87,
                                                ).sourceSansProRegular,
                                          ),
                                        ),
                                        if (isSelected)
                                          Icon(
                                            Icons.check,
                                            size: 18.sp,
                                            color: AppColors.primary,
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          if (_filteredItems.isEmpty)
                            Padding(
                              padding: EdgeInsets.all(30.sp),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 40.sp,
                                    color: Colors.grey[200],
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    "Aucun résultat trouvé",
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: widget.isLoading ? null : _toggleDropdown,
        child: AbsorbPointer(
          child: CustomInputText(
            controller: TextEditingController(
              text:
                  widget.value != null
                      ? widget.itemLabelBuilder(widget.value as T)
                      : "",
            ),
            labelText: widget.labelText,
            hintText: widget.hintText,
            readOnly: true,
            suffixWidget:
                widget.isLoading
                    ? SizedBox(
                      width: 20.r,
                      height: 20.r,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                    : Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: Icon(
                        _isOpen
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: _isOpen ? AppColors.primary : Colors.grey[600],
                        size: 24.sp,
                      ),
                    ),
            errorText: widget.errorText,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_isOpen) _closeDropdown();
    _searchController.dispose();
    super.dispose();
  }
}
