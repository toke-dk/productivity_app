import 'package:flutter/material.dart';
import 'package:productivity_app/models/category.dart';

class ChooseCategoryPage extends StatelessWidget {
  const ChooseCategoryPage(
      {super.key,
      required this.pageTitle,
      required this.categories,
      required this.updateCurrentPageIndex});

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

class ShowCategoryWidget extends StatelessWidget {
  const ShowCategoryWidget(
      {super.key,
      required this.category,
      this.onPressed,
      this.selected = false});

  final Category category;
  final Function()? onPressed;
  final bool selected;

  Color get backgroundColor => category.color.withOpacity(0.3);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed != null ? () => onPressed!() : null,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(
                color: selected
                    ? Colors.black.withOpacity(0.7)
                    : Colors.transparent,
                width: 2),
            borderRadius: BorderRadius.circular(10),
            color: backgroundColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(category.name),
            CircleAvatar(
              backgroundColor: category.color.withOpacity(0.8),
              radius: 13,
              child: ClipOval(
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: FittedBox(
                      child: ColorFiltered(
                          colorFilter:
                              ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          child: category.child)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DisplayCategory extends StatelessWidget {
  const DisplayCategory(
      {super.key,
      required this.category,
      this.axisDirection = Axis.horizontal,
      this.dense = false,
      this.mainAxisAlignment = MainAxisAlignment.center});

  final Category category;
  final Axis axisDirection;
  final bool dense;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    List<Widget> childrenToDisplay = [
      CircleAvatar(
        radius: 20,
        child: ClipOval(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: category.child,
        )),
      ),
      SizedBox(
        width: axisDirection == Axis.horizontal ? 10 : 0,
        height: axisDirection == Axis.vertical ? 10 : 0,
      ),
      FittedBox(fit: BoxFit.fitWidth, child: Text(category.name))
    ];

    return axisDirection == Axis.horizontal
        ? Transform.scale(
            scale: dense ? 0.8 : 1,
            child: Row(
                mainAxisAlignment: mainAxisAlignment,
                children: childrenToDisplay),
          )
        : Transform.scale(
            scale: dense ? 0.8 : 1,
            child: Column(
              mainAxisAlignment: mainAxisAlignment,
              children: childrenToDisplay,
            ),
          );
  }
}
