import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:productivity_app/models/category.dart';
import 'package:productivity_app/models/goal.dart';
import 'package:productivity_app/pages/add_routine/pages/choose_category.dart';
import 'package:productivity_app/pages/add_routine/pages/define_routine.dart';
import 'package:productivity_app/pages/add_routine/pages/evaluate.dart';
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
  bool nextButtonActive = false;

  late List<Widget> _pages = [
    ChooseCategoryPage(
        pageTitle: _pageTitle("Vælg Lategori"),
        categories: categories,
        updateCurrentPageIndex: () {
          _updateCurrentPageIndex(1);
        }),
    Container(
      // TODO change this to be maybe a collumn instead of stack with padding
      padding: const EdgeInsets.only(bottom: 70),
      child: DefineRoutinePage(pageTitle: _pageTitle("Definer rutine")),
    ),
    EvaluatePage(pageTitle: _pageTitle("Evaluering")),
  ];

  @override
  void initState() {
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
    Category(name: "Rengøring", child: Icon(Icons.cleaning_services), color: Colors.black),
    Category(name: "Teknologisk", child: Icon(Icons.code), color: Colors.indigo),
    Category(name: "Andre", child: Icon(Icons.more_horiz), color: Colors.teal),
  ];

  Widget _pageTitle(String text) => Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
            child: Text(
          text,
          style: Theme.of(context).textTheme.titleLarge,
        )),
      );

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
            children: _pages,
          ),
          PageIndicator(
            nextButtonActive: nextButtonActive,
            onCancel: () => Navigator.pop(context),
            tabController: _tabController,
            currentPageIndex: _currentPageIndex,
            onUpdateCurrentPageIndex: _updateCurrentPageIndex,
            listLength: _pages.length,
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
    this.prevButtonActive = true,
    this.nextButtonActive = false,
    this.onCancel,
    required this.listLength,
    this.onFinish,
  });

  final int currentPageIndex;
  final TabController tabController;
  final void Function(int) onUpdateCurrentPageIndex;
  final void Function()? onCancel;
  final void Function()? onFinish;
  final int listLength;

  final bool prevButtonActive;
  final bool nextButtonActive;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Theme.of(context).colorScheme.outline)),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          !prevButtonActive
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
                        currentPageIndex == 0
                            ? SizedBox()
                            : Icon(
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
          !nextButtonActive
              ? Expanded(child: SizedBox())
              : Expanded(
                  child: TextButton(
                    onPressed: () {
                      if (currentPageIndex == listLength - 1) {
                        return onFinish != null ? onFinish!() : null;
                      }
                      onUpdateCurrentPageIndex(currentPageIndex + 1);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(currentPageIndex == listLength - 1
                            ? "Gem og afslut"
                            : "Næste"),
                        currentPageIndex == listLength - 1
                            ? SizedBox()
                            : Icon(
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
