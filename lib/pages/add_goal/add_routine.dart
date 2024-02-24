import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: PageViewExample());
  }
}

class PageViewExample extends StatefulWidget {
  const PageViewExample({super.key});

  @override
  State<PageViewExample> createState() => _PageViewExampleState();
}

class _PageViewExampleState extends State<PageViewExample>
    with TickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabController;
  int _currentPageIndex = 0;

  int? _selectedCategoryIndex;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _tabController = TabController(length: 2, vsync: this);
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
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageViewController,
            onPageChanged: _handlePageViewChanged,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(child: Text("Vælg kategori", style: Theme.of(context).textTheme.titleLarge,)),
                    ),
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

                          selected: _selectedCategoryIndex == index,
                          category: _currentCategory,
                          onPressed: () {
                            setState(() {
                              _selectedCategoryIndex = index;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Text("page two"),
            ],
          ),
          PageIndicator(
            onCancel: ()=>Navigator.pop(context),
            tabController: _tabController,
            currentPageIndex: _currentPageIndex,
            onUpdateCurrentPageIndex: _updateCurrentPageIndex,
          ),
        ],
      ),
    );
  }

  void _handlePageViewChanged(int currentPageIndex) {
    _tabController.index = currentPageIndex;
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  void _updateCurrentPageIndex(int index) {
    _tabController.index = index;
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.tabController,
    required this.currentPageIndex,
    required this.onUpdateCurrentPageIndex,
    this.prevButtonDisabled = false,
    this.nextButtonDisabled = false, this.onCancel,
  });

  final int currentPageIndex;
  final TabController tabController;
  final void Function(int) onUpdateCurrentPageIndex;
  final void Function()? onCancel;

  final bool prevButtonDisabled;
  final bool nextButtonDisabled;


  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          prevButtonDisabled
              ? SizedBox()
              : Expanded(
                child: TextButton(
                    onPressed: () {
                      if (currentPageIndex == 0) {
                        return onCancel != null ? onCancel!() : null;
                      }
                      onUpdateCurrentPageIndex(currentPageIndex - 1);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        currentPageIndex == 0 ? SizedBox() : Icon(
                          Icons.arrow_left_rounded,
                          size: 32.0,
                        ),
                        Text(currentPageIndex == 0 ? "Afbryd" : "Forrige"),
                      ],
                    ),
                  ),
              ),
          TabPageSelector(
            controller: tabController,
            color: colorScheme.background,
            selectedColor: colorScheme.primary,
          ),
          prevButtonDisabled
              ? SizedBox()
              : Expanded(
                child: TextButton(
                    onPressed: () {
                      if (currentPageIndex == 2) {
                        return;
                      }
                      onUpdateCurrentPageIndex(currentPageIndex + 1);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Næste"),
                        const Icon(
                          Icons.arrow_right_rounded,
                          size: 32.0,
                        ),
                      ],
                    ),
                  ),
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
                color: selected ? Colors.black.withOpacity(0.7) : Colors.transparent,
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
