import 'package:flutter/material.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';

class CustomDropdown<T> extends StatefulWidget {
  final String? label;
  final String? hint;
  final T? value;
  final List<DropdownMenuItem<T>>? items;
  final Future<List<DropdownMenuItem<T>>>? asyncItems;
  final Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final Widget? prefixIcon;
  final bool isLoading;
  final double borderRadius;
  final bool searchable;
  final String searchHint;
  final Widget? emptyResultWidget;
  final Function(String)? onSearch;

  const CustomDropdown({
    Key? key,
    this.label,
    this.hint,
    this.value,
    this.items,
    this.asyncItems,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.isLoading = false,
    this.borderRadius = 25.0,
    this.searchable = false,
    this.searchHint = 'Search...',
    this.emptyResultWidget,
    this.onSearch,
  }) : assert(items != null || asyncItems != null, 'Either items or asyncItems must be provided'),
        super(key: key);

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  late bool _isLoading;
  List<DropdownMenuItem<T>>? _items;
  String _searchQuery = '';
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isLoading = widget.isLoading;
    _loadItems();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _removeOverlay();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading != widget.isLoading) {
      setState(() {
        _isLoading = widget.isLoading;
      });
    }
    if (oldWidget.items != widget.items || oldWidget.asyncItems != widget.asyncItems) {
      _loadItems();
    }
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && widget.searchable) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.asyncItems != null) {
        final items = await widget.asyncItems!;
        setState(() {
          _items = items;
          _isLoading = false;
        });
      } else {
        setState(() {
          _items = widget.items;
          _isLoading = widget.isLoading;
        });
      }
    } catch (e) {
      setState(() {
        _items = [];
        _isLoading = false;
      });
    }
  }

  List<DropdownMenuItem<T>> _getFilteredItems() {
    if (_items == null) return [];
    if (_searchQuery.isEmpty) return _items!;

    return _items!.where((item) {
      if (item.child is Text) {
        final text = (item.child as Text).data?.toLowerCase() ?? '';
        return text.contains(_searchQuery.toLowerCase());
      }
      return true;
    }).toList();
  }

  void _showOverlay() {
    _removeOverlay();

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 5),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: widget.searchHint,
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(widget.borderRadius),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                          if (widget.onSearch != null) {
                            widget.onSearch!(value);
                          }
                        });
                        _overlayEntry?.markNeedsBuild();
                      },
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: _getFilteredItems().length,
                      itemBuilder: (context, index) {
                        final item = _getFilteredItems()[index];
                        return InkWell(
                          onTap: () {
                            if (widget.onChanged != null) {
                              widget.onChanged!(item.value);
                            }
                            _searchController.clear();
                            _searchQuery = '';
                            _removeOverlay();
                            _focusNode.unfocus();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: item.child,
                          ),
                        );
                      },
                    ),
                  ),
                  if (_getFilteredItems().isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: widget.emptyResultWidget ?? Text('No results found'.tr(context)),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isOpen = true;
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      _isOpen = false;
    }
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _removeOverlay();
    } else {
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: CompositedTransformTarget(
        link: _layerLink,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: _focusNode.hasFocus
                ? Border.all(color: Theme.of(context).primaryColor, width: 1.5)
                : Border.all(color: Colors.transparent),
          ),
          child: widget.searchable
              ? _buildSearchableField()
              : _buildStandardDropdown(),
        ),
      ),
    );
  }

  Widget _buildStandardDropdown() {
    return DropdownButtonFormField<T>(
      value: widget.value,
      items: _isLoading ? [] : _items,
      onChanged: _isLoading ? null : widget.onChanged,
      validator: widget.validator,
      focusNode: _focusNode,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      icon: _isLoading
          ? const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2.0),
      )
          : const Icon(Icons.arrow_drop_down),
      dropdownColor: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(widget.borderRadius),
      isExpanded: true,
    );
  }

  Widget _buildSearchableField() {
    String displayText = '';
    if (widget.value != null) {
      final selectedItem = _items?.firstWhere(
            (item) => item.value == widget.value,
        orElse: () => DropdownMenuItem<T>(
          value: widget.value,
          child: Text(widget.value.toString()),
        ),
      );

      if (selectedItem?.child is Text) {
        displayText = (selectedItem!.child as Text).data ?? '';
      } else {
        displayText = widget.value.toString();
      }
    }

    return InkWell(
      onTap: _toggleDropdown,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          prefixIcon: widget.prefixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide.none,
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          suffixIcon: _isLoading
              ? const SizedBox(
            height: 20,
            width: 20,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: CircularProgressIndicator(strokeWidth: 2.0),
            ),
          )
              : const Icon(Icons.arrow_drop_down),
        ),
        isEmpty: widget.value == null,
        isFocused: _focusNode.hasFocus,
        child: Text(displayText),
      ),
    );
  }
}