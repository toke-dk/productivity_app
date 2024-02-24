import 'package:flutter/material.dart';
import 'package:productivity_app/models/goal.dart';
import 'package:productivity_app/widgets/display_activity_type.dart';

class AddRoutine extends StatefulWidget {
  const AddRoutine(
      {super.key,
      required this.onCheckMarkGoalAdd,
      required this.onAmountGoalAdd});

  final Function(CheckmarkGoal) onCheckMarkGoalAdd;
  final Function(AmountGoal) onAmountGoalAdd;

  @override
  State<AddRoutine> createState() => _AddRoutineState();
}

class _AddRoutineState extends State<AddRoutine> with TickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabController;
  int _currentPageIndex = 0;

  bool prevButtonDisabled = true;
  bool nextButtonDisabled = false;

  @override
  void initState() {
    prevButtonDisabled = _currentPageIndex == 0 ? true : prevButtonDisabled;
    nextButtonDisabled = _currentPageIndex == 0 ? true : nextButtonDisabled;

    super.initState();
    _pageViewController = PageController();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
  }

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
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: null,
            children: [
              Padding(
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
              Text("page two"),
            ],
          ),
          PageIndicator(
              prevButtonDisabled: prevButtonDisabled,
              nextButtonDisabled: nextButtonDisabled,
              tabController: _tabController,
              currentPageIndex: _currentPageIndex,
              onUpdateCurrentPageIndex: (int newIndex) {},
              isOnDesktopAndWeb: true)
        ],
      ),
    );
  }
}

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.tabController,
    required this.currentPageIndex,
    required this.onUpdateCurrentPageIndex,
    required this.isOnDesktopAndWeb,
    this.prevButtonDisabled = false,
    this.nextButtonDisabled = false,
  });

  final int currentPageIndex;
  final TabController tabController;
  final void Function(int) onUpdateCurrentPageIndex;
  final bool isOnDesktopAndWeb;

  final bool prevButtonDisabled;
  final bool nextButtonDisabled;

  @override
  Widget build(BuildContext context) {
    if (!isOnDesktopAndWeb) {
      return const SizedBox.shrink();
    }
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            splashRadius: 16.0,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (currentPageIndex == 0) {
                return;
              }
              onUpdateCurrentPageIndex(currentPageIndex - 1);
            },
            icon: prevButtonDisabled
                ? SizedBox()
                : TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_left_rounded,
                          size: 32.0,
                        ),
                        Text("Forrige"),
                      ],
                    ),
                  ),
          ),
          TabPageSelector(
            controller: tabController,
            color: colorScheme.background,
            selectedColor: colorScheme.primary,
          ),
          IconButton(
            splashRadius: 16.0,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (currentPageIndex == 2) {
                return;
              }
              onUpdateCurrentPageIndex(currentPageIndex + 1);
            },
            icon: !nextButtonDisabled
                ? TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Text("Næste"),
                        const Icon(
                          Icons.arrow_right_rounded,
                          size: 32.0,
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
          ),
        ],
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
