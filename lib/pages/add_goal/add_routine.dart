import 'package:flutter/material.dart';
import 'package:productivity_app/models/goal.dart';
import 'package:productivity_app/widgets/display_activity_type.dart';

class AddRoutine extends StatelessWidget {
  const AddRoutine(
      {super.key,
      required this.onCheckMarkGoalAdd,
      required this.onAmountGoalAdd});

  final Function(CheckmarkGoal) onCheckMarkGoalAdd;
  final Function(AmountGoal) onAmountGoalAdd;

  final List<Category> categories = const [
    Category(
        name: "Sport", child: Icon(Icons.sports_baseball), color: Colors.green),
    Category(
        name: "Kost", child: Icon(Icons.dinner_dining), color: Colors.orange),
    Category(
        name: "Finans", child: Icon(Icons.monetization_on), color: Colors.blue),
    Category(name: "Udendørs", child: Icon(Icons.grass), color: Colors.brown),
    Category(
        name: "Uddannelse", child: Icon(Icons.menu_book), color: Colors.purple),
    Category(name: "Hjem", child: Icon(Icons.home), color: Colors.black),
    Category(name: "Andre", child: Icon(Icons.more_horiz), color: Colors.teal),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vælg kategori"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              childAspectRatio: 4 / 1),
          itemBuilder: (BuildContext context, int index) {
            Category _currentCategory = categories[index];
            return ShowCategoryWidget(category: _currentCategory);
          },
        ),
      ),
    );
  }
}

class ShowCategoryWidget extends StatelessWidget {
  const ShowCategoryWidget({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: category.color.withOpacity(0.3)),
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
    );
  }
}

class Category {
  final String name;
  final Widget child;
  final Color color;

  const Category(
      {required this.name, required this.child, required this.color});
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
