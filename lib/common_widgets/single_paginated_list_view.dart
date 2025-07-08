import 'package:flutter/material.dart';

class SinglePaginatedListView<T> extends StatelessWidget {
  final List<T> data;
  final ScrollController controller;
  final bool hasMore;
  final Widget Function(T item, int index) itemBuilder;
  final EdgeInsetsGeometry? padding;
  const SinglePaginatedListView({super.key, required this.controller, required this.data, required this.itemBuilder, required this.hasMore, this.padding});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      padding: padding,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: data.length + 1,
      itemBuilder: (context, index) {
        if (index < data.length) {
          return itemBuilder(data[index], index);
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
