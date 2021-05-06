import 'package:flutter/material.dart';
import 'package:pollaris_app/models/user.dart';
import 'package:pollaris_app/screens/my_page.dart';
import 'package:pollaris_app/screens/poll_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final _pages = [PollPage(), MyPage()];

  int currentPageIndex = 0;

  late PageController pageController;

  late User user;

  @override
  void initState() {
    super.initState();

    user = context.read<User>();
    pageController = PageController();
    pageController.addListener(() {});
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
            child: PageView(
          children: _pages,
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              currentPageIndex = index;
            });
          },
        )),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: currentPageIndex,
          items: [
            BottomNavigationBarItem(
                label: "Home", icon: Icon(Icons.home_rounded)),
            BottomNavigationBarItem(
                label: "My", icon: Icon(Icons.location_history_rounded)),
          ],
          onTap: (index) {
            pageController.animateToPage(index,
                duration: const Duration(milliseconds: 200),
                curve: Curves.ease);
          },
        ),
      );
}
