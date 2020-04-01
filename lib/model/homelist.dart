
import 'package:flutter/widgets.dart';
import 'package:wardslaus/pages/help_screen.dart';

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
  });

  Widget navigateScreen;
  String imagePath;

  static List<HomeList> homeList = [
    HomeList(
      imagePath: 'assets/images/fitness_app.png',
      navigateScreen: HelpScreen(),
    ),
    HomeList(
      imagePath: 'assets/images/fitness_app.png',
      navigateScreen: HelpScreen(),
    ),
    HomeList(
      imagePath: 'assets/images/fitness_app.png',
      navigateScreen: HelpScreen(),
    ),
  ];
}
