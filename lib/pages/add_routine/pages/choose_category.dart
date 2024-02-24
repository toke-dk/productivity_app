import 'package:flutter/material.dart';

import '../add_routine.dart';

class EvaluatePage extends StatelessWidget {
  const EvaluatePage({super.key, required this.pageTitle, required this.categories, required this.updateCurrentPageIndex});
  final Widget pageTitle;
  final List<Category> categories;
  final Function() updateCurrentPageIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          pageTitle,
          GridView.builder(
            shrinkWrap: true,
            itemCount: categories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                childAspectRatio: 4 / 1),
            itemBuilder: (BuildContext context, int index) {
              Category _currentCategory = categories[index];
              return ShowCategoryWidget(
                category: _currentCategory,
                onPressed: updateCurrentPageIndex,
              );
            },
          ),
        ],
      ),
    );
  }
}
