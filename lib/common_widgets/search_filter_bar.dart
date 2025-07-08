import 'package:flutter/material.dart';

class SearchFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final String hintText;
  final String searchQuery;
  final bool? hasActiveFilters;
  final VoidCallback? onFilterPressed;
  final Function(String) onSearchSubmitted;
  final Function() onClearSearch;
  final bool isFilterButton;

  const SearchFilterBar({
    super.key,
    required this.searchController,
    required this.hintText,
    required this.searchQuery,
    this.hasActiveFilters,
    this.onFilterPressed,
    required this.onSearchSubmitted,
    required this.onClearSearch,
    this.isFilterButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Search field (expanded to take available width)
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                hintText: hintText,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: onClearSearch,
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white
              ),
              onSubmitted: onSearchSubmitted,
            ),
          ),

          // Small gap between search and filter button
          const SizedBox(width: 8),

          // Filter button
          if(isFilterButton)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8.0),
                onTap: onFilterPressed,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.filter_list,
                        color: hasActiveFilters!=null && hasActiveFilters==true
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      if (hasActiveFilters!=null && hasActiveFilters==true)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}