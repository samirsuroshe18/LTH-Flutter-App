import 'package:flutter/material.dart';

class GroupedPaginatedListView<T> extends StatelessWidget {
  final Map<String, List<T>> groupedData;
  final ScrollController controller;
  final bool hasMore;
  final Widget Function(String groupKey) groupHeaderBuilder;
  final Widget Function(T item, int index) itemBuilder;
  final EdgeInsetsGeometry? padding;

  const GroupedPaginatedListView({
    super.key,
    required this.groupedData,
    required this.controller,
    required this.hasMore,
    required this.groupHeaderBuilder,
    required this.itemBuilder,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final groupKeys = groupedData.keys.toList();

    return ListView.builder(
      controller: controller,
      padding: padding,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: groupKeys.length + 1,
      itemBuilder: (context, index) {
        if (index < groupKeys.length) {
          final groupKey = groupKeys[index];
          final items = groupedData[groupKey]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              groupHeaderBuilder(groupKey),
              ...items.asMap().entries.map(
                    (entry) => itemBuilder(entry.value, entry.key),
              ),
            ],
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: hasMore
                  ? const CircularProgressIndicator()
                  : const Text("No more data to load"),
            ),
          );
        }
      },
    );
  }
}
